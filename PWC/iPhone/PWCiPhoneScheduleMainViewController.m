//
//  PWCiPhoneScheduleMainViewController.m
//  PWC
//
//  Created by Samiul Hoque on 5/14/13.
//  Copyright (c) 2013 Premium Web Cart. All rights reserved.
//

#import "PWCiPhoneScheduleMainViewController.h"
#import "PWCGlobal.h"
#import "AFNetworking.h"
#import "PWCCustomers.h"
#import "PWCServices.h"
#import "SBJSON.h"

@interface PWCiPhoneScheduleMainViewController ()

@end

@implementation PWCiPhoneScheduleMainViewController

@synthesize custEmpty;
@synthesize servEmpty;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    custEmpty = NO;
    servEmpty = NO;
    
    if (sqlite3_open([[PWCGlobal getTheGlobal].getDBPath UTF8String], &pwcDB) != SQLITE_OK) {
        // NSLog(@"Failed to open db");
    } else {
        // NSLog(@"DB openned.");
    }
    
    [SVProgressHUD dismiss];
    
    // Customers
    if ([PWCCustomers customers].pwcCustomers == nil || [PWCCustomers customers].lastCustomerId == nil) {
        custEmpty = YES;
    } else {
        [PWCGlobal getTheGlobal].customers = [PWCCustomers customers].pwcCustomers;
    }
    
    // Services
    if ([PWCServices services].pwcServices == nil || [PWCServices services].lastServiceId == nil) {
        servEmpty = YES;
    } else {
        [PWCGlobal getTheGlobal].services = [PWCServices services].pwcServices;
    }
    
    if (custEmpty) {
        [self updateCustomers];
    } else if (servEmpty) {
        [self updateServices];
    } else {
        //NSLog(@"Last salespathID : %@", [self lastSalesPathId]);
        [self populateFunnelsAndTags];
    }
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)updateScheduleData:(id)sender {
    [self updateCustomers];
}

- (void)updateCustomers
{
    [SVProgressHUD showWithStatus:@"Loading customers ..." maskType:SVProgressHUDMaskTypeBlack];
    
    SEL customerSel = @selector(doGetCustomers);
    
    [self performSelectorInBackground:customerSel withObject:self];
}

- (void)updateServices
{
    [SVProgressHUD showWithStatus:@"Loading services ..." maskType:SVProgressHUDMaskTypeBlack];
    
    SEL servicesSel = @selector(doGetServices);
    
    [self performSelectorInBackground:servicesSel withObject:self];
}

- (void)doGetCustomers
{
    NSURL *url = [NSURL URLWithString:@"https://www.pwccrm.com"];
    NSString *path = [NSString stringWithFormat:@"/beta/api2/api/customerlist/%@/%@", [PWCGlobal getTheGlobal].merchantId, [PWCGlobal getTheGlobal].userHash];
    //}
    
    // Call API and Get Data
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [httpClient setDefaultHeader:@"Accept" value:@"application/json"];
    
    if (([PWCCustomers customers].lastCustomerId != nil) && ([[PWCCustomers customers].lastCustomerId length] > 0)) {
        path = [NSString stringWithFormat:@"%@/%@", path, [PWCCustomers customers].lastCustomerId];
    }
    
    NSLog(@"PATH: %@", path);
    
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET" path:path parameters:nil];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                                            //NSLog(@"Success");
                                                                                            //NSLog(@"DATA: %@", JSON);
                                                                                            
                                                                                            int resultCode = [[JSON objectForKey:@"result"] intValue];
                                                                                            
                                                                                            if (resultCode == 1) {
                                                                                                NSArray *customerArray = [JSON objectForKey:@"customers"];
                                                                                                [self saveCustomerData:customerArray];
                                                                                            }
                                                                                            
                                                                                            [PWCGlobal getTheGlobal].customers = [PWCCustomers customers].pwcCustomers;
                                                                                            
                                                                                            [SVProgressHUD showSuccessWithStatus:@"Customers Synced."];
                                                                                            
                                                                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                                                                [self updateServices];
                                                                                            });
                                                                                            
                                                                                        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                                            //NSLog(@"Failure");
                                                                                            
                                                                                            [SVProgressHUD dismissWithError:@"Syncing failed. Try again later." afterDelay:1.0];
                                                                                            [PWCGlobal getTheGlobal].customers = [PWCCustomers customers].pwcCustomers;
                                                                                            
                                                                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                                                                [self updateServices];
                                                                                            });
                                                                                        }];
    [operation start];
    [operation waitUntilFinished];
}

- (void)saveCustomerData:(NSArray *)customers
{
    int ok = 0, notok = 0;
    
    for (NSDictionary *d in customers) {
        if ([self insertCustomerData:d]) {
            ok++;
        } else {
            notok++;
        }
    }
    NSLog(@"OK: %d, NOT OK: %d", ok, notok);
}

- (BOOL)insertCustomerData:(NSDictionary *)customer
{
    BOOL done = NO;
    sqlite3_stmt *statement;
    // NSLog(@"%@", product);
    
    NSString *section = @"#";
    
    if ([[customer objectForKey:@"first_name"] length] > 0) {
        section = [[[customer objectForKey:@"first_name"] substringToIndex:1] uppercaseString];
    }
    
    NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO customers (customerId, customerCrmId, firstName, lastName, homePhone, workPhone, email, address, city, state, zipCode, country, fax, companyName, balance, notes, section, crm_customer) VALUES ('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",
                           [customer objectForKey:@"customer_id"],
                           [customer objectForKey:@"customer_crm_id"],
                           [customer objectForKey:@"first_name"],
                           [customer objectForKey:@"last_name"],
                           
                           [customer objectForKey:@"home_phone_number"],
                           [customer objectForKey:@"work_phone_number"],
                           [customer objectForKey:@"customer_email"],
                           [NSString stringWithFormat:@"%@, %@", [customer objectForKey:@"address_line1"],[customer objectForKey:@"address_line2"]],
                           
                           [customer objectForKey:@"customer_city"],
                           [customer objectForKey:@"customer_state"],
                           [customer objectForKey:@"customer_zip"],
                           [customer objectForKey:@"country"],
                           
                           [customer objectForKey:@"fax"],
                           [customer objectForKey:@"company_name"],
                           [customer objectForKey:@"balance"],
                           @"",
                           section,
                           [customer objectForKey:@"crm_customer"]];
    
    const char *insert_stmt = [insertSQL UTF8String];
    // NSLog(@"%@", orderDetail);
    sqlite3_prepare_v2(pwcDB, insert_stmt, -1, &statement, NULL);
    if (sqlite3_step(statement) == SQLITE_DONE) {
        done = YES;
    } else {
        done = NO;
    }
    
    sqlite3_finalize(statement);
    
    return done;
}

- (void)doGetServices
{
    NSURL *url = [NSURL URLWithString:@"http://www.secureinfossl.com"];
    NSString *path = [NSString stringWithFormat:@"/scheduleapi/manageservicelist/%@", [PWCGlobal getTheGlobal].coachRowId];
    
    // Call API and Get Data
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [httpClient setDefaultHeader:@"Accept" value:@"application/json"];
    
    if (([PWCServices services].lastServiceId != nil) && ([[PWCServices services].lastServiceId length] > 0)) {
        path = [NSString stringWithFormat:@"%@/%@", path, [PWCServices services].lastServiceId];
    }
    
    NSLog(@"PATH: %@", path);
    
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET" path:path parameters:nil];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                                            NSLog(@"Success");
                                                                                            //NSLog(@"DATA: %@", JSON);
                                                                                            
                                                                                            int resultCode = [[JSON objectForKey:@"result"] intValue];
                                                                                            
                                                                                            if (resultCode == 1) {
                                                                                                NSArray *serviceArray = [JSON objectForKey:@"services"];
                                                                                                [self saveServiceData:serviceArray];
                                                                                            }
                                                                                            
                                                                                            [PWCGlobal getTheGlobal].services = [PWCServices services].pwcServices;
                                                                                            
                                                                                            [SVProgressHUD showSuccessWithStatus:@"Services Synced."];
                                                                                            
                                                                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                                                                [self updateFunnels];
                                                                                            });
                                                                                            
                                                                                        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                                            NSLog(@"Failure");
                                                                                            
                                                                                            [SVProgressHUD dismissWithError:@"Syncing failed. Try again later." afterDelay:1.0];
                                                                                            [PWCGlobal getTheGlobal].services = [PWCServices services].pwcServices;
                                                                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                                                                [self updateFunnels];
                                                                                            });
                                                                                        }];
    [operation start];
    [operation waitUntilFinished];
}

- (void)saveServiceData:(NSArray *)services
{
    int ok = 0, notok = 0;
    
    for (NSDictionary *d in services) {
        if ([self insertServiceData:d]) {
            ok++;
        } else {
            notok++;
        }
    }
    NSLog(@"OK: %d, NOT OK: %d", ok, notok);
}

- (BOOL)insertServiceData:(NSDictionary *)service
{
    BOOL done = NO;
    sqlite3_stmt *statement;
    // NSLog(@"%@", product);
    
    NSString *section = @"#";
    
    if ([[service objectForKey:@"service_name"] length] > 0) {
        section = [[[service objectForKey:@"service_name"] substringToIndex:1] uppercaseString];
    }
    
    NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO services (serviceRowId, serviceType, serviceName, description, requiredUnit, maxParticipants, minDuration, chargePerUnit, editRuleDay, editRuleHour, cancelRuleDay, cancelRuleHour, termsAndConditions, removedFunnels, assignedFunnels, removedTags, assignedTags, notes, section) VALUES ('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",
                           [service objectForKey:@"service_row_id"],
                           [service objectForKey:@"service_type"],
                           [service objectForKey:@"service_name"],
                           [service objectForKey:@"description"],
                           
                           [service objectForKey:@"required_unit"],
                           [service objectForKey:@"maximum_participants"],
                           [service objectForKey:@"minimum_duration"],
                           [service objectForKey:@"charge_per_unit"],
                           
                           [service objectForKey:@"edit_rule_day"],
                           [service objectForKey:@"edit_rule_hour"],
                           [service objectForKey:@"cancel_rule_day"],
                           [service objectForKey:@"cancel_rule_hour"],
                           
                           [service objectForKey:@"terms_condition"],
                           
                           [service objectForKey:@"removedfunnels"],
                           [service objectForKey:@"assignedsalespath"],
                           [service objectForKey:@"removedtags"],
                           [service objectForKey:@"assignedtags"],
                           
                           @"",
                           section];
    
    const char *insert_stmt = [insertSQL UTF8String];
    // NSLog(@"%@", orderDetail);
    sqlite3_prepare_v2(pwcDB, insert_stmt, -1, &statement, NULL);
    if (sqlite3_step(statement) == SQLITE_DONE) {
        done = YES;
    } else {
        done = NO;
    }
    
    sqlite3_finalize(statement);
    
    return done;
}

- (void)updateFunnels
{
    [SVProgressHUD showWithStatus:@"Loading funnels ..." maskType:SVProgressHUDMaskTypeBlack];
    
    SEL funnelsSel = @selector(doGetFunnels);
    
    [self performSelectorInBackground:funnelsSel withObject:self];
}

#pragma mark -
#pragma mark RE-SYNC ALL FUNNELS

- (void)doGetFunnels
{
    NSURL *url = [NSURL URLWithString:@"http://www.secureinfossl.com"];
    NSString *path = [NSString stringWithFormat:@"/scheduleapi/getFunnelList/%@", [PWCGlobal getTheGlobal].coachRowId];
    
    // Call API and Get Data
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [httpClient setDefaultHeader:@"Accept" value:@"application/json"];
    
    //NSLog(@"PATH: %@", path);
    
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET" path:path parameters:nil];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                                            //NSLog(@"Success");
                                                                                            //NSLog(@"DATA: %@", JSON);
                                                                                            
                                                                                            int resultCode = [[JSON objectForKey:@"result"] intValue];
                                                                                            
                                                                                            if (resultCode == 1) {
                                                                                                NSArray *funnelArray = [JSON objectForKey:@"funnelswithsalespathlist"];
                                                                                                SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
                                                                                                NSString *funnelsString = [jsonWriter stringWithObject:JSON];
                                                                                                [self saveFunnelData:funnelArray funnelString:funnelsString];
                                                                                                [PWCGlobal getTheGlobal].funnels = funnelArray;
                                                                                            }
                                                                                            
                                                                                            [SVProgressHUD showSuccessWithStatus:@"Funnels Synced."];
                                                                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                                                                [self updateTags];
                                                                                            });
                                                                                        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                                            //NSLog(@"Failure");
                                                                                            
                                                                                            [SVProgressHUD dismissWithError:@"Syncing failed. Try again later." afterDelay:1.0];
                                                                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                                                                [self updateTags];
                                                                                            });
                                                                                        }];
    [operation start];
    [operation waitUntilFinished];
}

- (void)saveFunnelData:(NSArray *)funnels funnelString:(NSString *)funnelString
{
    int maxSalesPathId = 0;
    
    for (NSDictionary *d in funnels) {
        NSArray *salesPaths = [d objectForKey:@"salespathlist"];
        
        for (NSDictionary *ds in salesPaths) {
            if ([[ds objectForKey:@"sales_path_id"] intValue] > maxSalesPathId) {
                maxSalesPathId = [[ds objectForKey:@"sales_path_id"] intValue];
            }
        }
    }
    
    if ([self insertFunnelData:funnels maxSalesPath:[NSString stringWithFormat:@"%d", maxSalesPathId] funnelString:funnelString]) {
        NSLog(@"Funnel Update: OK");
    } else {
        NSLog(@"Funnel Update: NOT OK");
    }
    //NSLog(@"OK: %d, NOT OK: %d", ok, notok);
}

- (BOOL)insertFunnelData:(NSArray *)funnels maxSalesPath:(NSString *)maxSalesPathId funnelString:(NSString *)funnelString
{
    BOOL done = NO;
    sqlite3_stmt *statement;
    // NSLog(@"%@", product);
    
    //NSData *d = [NSKeyedArchiver archivedDataWithRootObject:funnels];
    //NSString *data = [[NSString alloc] initWithData:d encoding:NSUTF8StringEncoding];
    
    NSString *updateSQL = [NSString stringWithFormat:@"UPDATE suppData SET lastId = '%@', data = '%@' WHERE type = 'salespaths'", maxSalesPathId, funnelString];
    //NSLog(@"%@", funnelString);
    
    const char *insert_stmt = [updateSQL UTF8String];
    // NSLog(@"%@", orderDetail);
    sqlite3_prepare_v2(pwcDB, insert_stmt, -1, &statement, NULL);
    if (sqlite3_step(statement) == SQLITE_DONE) {
        done = YES;
    } else {
        done = NO;
    }
    
    sqlite3_finalize(statement);
    
    return done;
}

- (void)updateTags
{
    [SVProgressHUD showWithStatus:@"Loading tags ..." maskType:SVProgressHUDMaskTypeBlack];
    
    SEL tagsSel = @selector(doGetTags);
    
    [self performSelectorInBackground:tagsSel withObject:self];
}

#pragma mark -
#pragma mark RE-SYNC ALL TAGS

- (void)doGetTags
{
    NSURL *url = [NSURL URLWithString:@"http://www.secureinfossl.com"];
    NSString *path = [NSString stringWithFormat:@"/scheduleapi/getTagsList/%@", [PWCGlobal getTheGlobal].coachRowId];
    
    // Call API and Get Data
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [httpClient setDefaultHeader:@"Accept" value:@"application/json"];
    
    //NSLog(@"PATH: %@", path);
    
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET" path:path parameters:nil];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                                            //NSLog(@"Success");
                                                                                            //NSLog(@"DATA: %@", JSON);
                                                                                            
                                                                                            int resultCode = [[JSON objectForKey:@"result"] intValue];
                                                                                            
                                                                                            if (resultCode == 1) {
                                                                                                NSArray *tagsArray = [JSON objectForKey:@"tags"];
                                                                                                SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
                                                                                                NSString *tagsString = [jsonWriter stringWithObject:JSON];
                                                                                                [self saveTagsData:tagsArray tagString:tagsString];
                                                                                                [PWCGlobal getTheGlobal].tags = tagsArray;
                                                                                            }
                                                                                            
                                                                                            [SVProgressHUD showSuccessWithStatus:@"Tags Synced."];
                                                                                            
                                                                                        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                                            //NSLog(@"Failure");
                                                                                            
                                                                                            [SVProgressHUD dismissWithError:@"Syncing failed. Try again later." afterDelay:1.0];
                                                                                        }];
    [operation start];
    [operation waitUntilFinished];
}

- (void)saveTagsData:(NSArray *)allTags tagString:(NSString *)tagString
{
    int maxTagId = 0;
    
    for (NSDictionary *d in allTags) {
        NSArray *tags = [d objectForKey:@"tagslist"];
        
        for (NSDictionary *ds in tags) {
            if ([[ds objectForKey:@"tag_id"] intValue] > maxTagId) {
                maxTagId = [[ds objectForKey:@"tag_id"] intValue];
            }
        }
    }
    
    if ([self insertTagData:allTags maxTag:[NSString stringWithFormat:@"%d", maxTagId] tagString:tagString]) {
        NSLog(@"Tags Update: OK");
    } else {
        NSLog(@"Tags Update: NOT OK");
    }
    //NSLog(@"OK: %d, NOT OK: %d", ok, notok);
}

- (BOOL)insertTagData:(NSArray *)allTags maxTag:(NSString *)maxTagId tagString:(NSString *)tagString
{
    BOOL done = NO;
    sqlite3_stmt *statement;
    // NSLog(@"%@", product);
    
    //NSData *d = [NSKeyedArchiver archivedDataWithRootObject:allTags];
    //NSString *data = [[NSString alloc] initWithData:d encoding:NSUTF8StringEncoding];
    
    NSString *updateSQL = [NSString stringWithFormat:@"UPDATE suppData SET lastId = '%@', data = '%@' WHERE type = 'tags'", maxTagId, tagString];
    
    const char *insert_stmt = [updateSQL UTF8String];
    // NSLog(@"%@", orderDetail);
    sqlite3_prepare_v2(pwcDB, insert_stmt, -1, &statement, NULL);
    if (sqlite3_step(statement) == SQLITE_DONE) {
        done = YES;
    } else {
        done = NO;
    }
    
    sqlite3_finalize(statement);
    
    return done;
}

- (NSString *)lastSalesPathId
{
    NSString *last = nil;
    
    NSString *query = @"SELECT lastId FROM suppData WHERE type = 'salespaths'";
    
    sqlite3_stmt *statement;
    
    if (sqlite3_prepare_v2(pwcDB, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            char *csalesPathId = (char *) sqlite3_column_text(statement, 0);
            
            NSString *salesPathId = [[NSString alloc] initWithUTF8String:csalesPathId];
            
            if (last == nil) {
                last = salesPathId;
            } else if ([last intValue] < [salesPathId intValue]) {
                last = salesPathId;
            }
        }
        sqlite3_finalize(statement);
    }
    
    return last;
}

- (NSString *)lastTagId
{
    NSString *last = nil;
    
    NSString *query = @"SELECT lastId FROM suppData WHERE type = 'tags'";
    
    sqlite3_stmt *statement;
    
    if (sqlite3_prepare_v2(pwcDB, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            char *ctagId = (char *) sqlite3_column_text(statement, 0);
            
            NSString *tagId = [[NSString alloc] initWithUTF8String:ctagId];
            
            if (last == nil) {
                last = tagId;
            } else if ([last intValue] < [tagId intValue]) {
                last = tagId;
            }
        }
        sqlite3_finalize(statement);
    }
    
    return last;
}

- (void)populateFunnelsAndTags
{
    NSString *query = @"SELECT data FROM suppData WHERE type = 'salespaths'";
    //NSLog(@"Query=%@",query);
    sqlite3_stmt *statement;
    
    if (sqlite3_prepare_v2(pwcDB, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            char *csalespath = (char *) sqlite3_column_text(statement, 0);
            NSString *salespath = [[NSString alloc] initWithUTF8String:csalespath];
            
            //NSLog(@"SalesPath: %@", salespath);
            //NSData *data = [salespath dataUsingEncoding:NSUTF8StringEncoding];
            //[PWCGlobal getTheGlobal].funnels = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            
            SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
            NSDictionary *dic = [jsonParser objectWithString:salespath];
            [PWCGlobal getTheGlobal].funnels = [dic objectForKey:@"funnelswithsalespathlist"];
            //NSLog(@"SalesPath Array: %@", [PWCGlobal getTheGlobal].funnels);
        }
        sqlite3_finalize(statement);
    }
    
    query = @"SELECT data FROM suppData WHERE type = 'tags'";
    //NSLog(@"Query=%@",query);
    if (sqlite3_prepare_v2(pwcDB, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            char *ctags = (char *) sqlite3_column_text(statement, 0);
            NSString *tags = [[NSString alloc] initWithUTF8String:ctags];
            
            //NSLog(@"TAGS: %@", tags);
            //NSData *data = [tags dataUsingEncoding:NSUTF8StringEncoding];
            //[PWCGlobal getTheGlobal].tags = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            
            SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
            NSDictionary *dic = [jsonParser objectWithString:tags];
            [PWCGlobal getTheGlobal].tags = [dic objectForKey:@"tags"];
            //NSLog(@"Tags Array: %@", [PWCGlobal getTheGlobal].tags);
        }
        sqlite3_finalize(statement);
    }
}

- (IBAction)viewCalendar:(id)sender {
    
}

@end
