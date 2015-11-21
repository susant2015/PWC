//
//  PWCiPhoneScheduleRemoveTagsViewController.m
//  PWC
//
//  Created by Samiul Hoque on 9/5/13.
//  Copyright (c) 2013 Premium Web Cart. All rights reserved.
//

#import "PWCiPhoneScheduleRemoveTagsViewController.h"
#import "PWCSelectedServiceData.h"
#import "PWCGlobal.h"
#import "AFNetworking.h"
#import "PWCServices.h"

@interface PWCiPhoneScheduleRemoveTagsViewController ()

@end

@implementation PWCiPhoneScheduleRemoveTagsViewController

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
    
    if (sqlite3_open([[PWCGlobal getTheGlobal].getDBPath UTF8String], &pwcDB) != SQLITE_OK) {
        // NSLog(@"Failed to open db");
    } else {
        // NSLog(@"DB openned.");
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [[PWCGlobal getTheGlobal].tags count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSDictionary *d = [[PWCGlobal getTheGlobal].tags objectAtIndex:section];
    NSArray *a = [d objectForKey:@"tagslist"];
    return [a count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"removeTagCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSDictionary *dd = [[PWCGlobal getTheGlobal].tags objectAtIndex:indexPath.section];
    NSArray *a = [dd objectForKey:@"tagslist"];
    NSDictionary *d = [a objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [d objectForKey:@"tag_name"];
    
    if ([self valueFound:[d objectForKey:@"tag_id"]]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [[[PWCGlobal getTheGlobal].tags objectAtIndex:section] objectForKey:@"category_name"];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dd = [[PWCGlobal getTheGlobal].tags objectAtIndex:indexPath.section];
    NSArray *a = [dd objectForKey:@"tagslist"];
    NSDictionary *d = [a objectAtIndex:indexPath.row];
    
    if ([self checkValue:[d objectForKey:@"tag_id"]]) {
        [self.tableView reloadData];
    } else {
        [[PWCSelectedServiceData selectedService].removedTags addObject:[d objectForKey:@"tag_id"]];
        [self.tableView reloadData];
    }
    NSLog(@"%@", [PWCSelectedServiceData selectedService].removedTags);
}

- (BOOL)valueFound:(NSString *)value
{
    for (NSString *s in [PWCSelectedServiceData selectedService].removedTags) {
        if ([s isEqualToString:value]) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)checkValue:(NSString *)val
{
    BOOL found = NO;
    int i = 0;
    
    for (i = 0; i < [[PWCSelectedServiceData selectedService].removedTags count]; i++) {
        NSString *s = [[PWCSelectedServiceData selectedService].removedTags objectAtIndex:i];
        if ([s isEqualToString:val]) {
            found = YES;
            break;
        }
    }
    
    if (found == YES && i < [[PWCSelectedServiceData selectedService].removedTags count]) {
        [[PWCSelectedServiceData selectedService].removedTags removeObjectAtIndex:i];
    }
    
    return found;
}

- (IBAction)saveService:(id)sender {
    [SVProgressHUD showWithStatus:@"Saving ..." maskType:SVProgressHUDMaskTypeBlack];
    
    SEL saveSel = @selector(doSaveService);
    
    [self performSelectorInBackground:saveSel withObject:self];
}

- (void)doSaveService
{
    // Call API and Get Data
    NSURL *url = [NSURL URLWithString:@"https://secureinfossl.com"];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [httpClient setDefaultHeader:@"Accept" value:@"application/json"];
    
    NSMutableDictionary *parDic = [[NSMutableDictionary alloc] init];
    
    // SERVICE INFO
    [parDic addEntriesFromDictionary:[NSDictionary dictionaryWithObject:[PWCSelectedServiceData selectedService].serviceRowId forKey:@"serviceRowId"]];
    [parDic addEntriesFromDictionary:[NSDictionary dictionaryWithObject:[PWCSelectedServiceData selectedService].serviceName forKey:@"serviceName"]];
    [parDic addEntriesFromDictionary:[NSDictionary dictionaryWithObject:[PWCSelectedServiceData selectedService].reqUnitDecimal forKey:@"requiredUnitDecimal"]];
    [parDic addEntriesFromDictionary:[NSDictionary dictionaryWithObject:[PWCSelectedServiceData selectedService].reqUnitFraction forKey:@"requiredUnitFraction"]];
    [parDic addEntriesFromDictionary:[NSDictionary dictionaryWithObject:[PWCSelectedServiceData selectedService].maxParticipants forKey:@"maximumParticipants"]];
    [parDic addEntriesFromDictionary:[NSDictionary dictionaryWithObject:[PWCSelectedServiceData selectedService].minDurationDecimal forKey:@"minimumDurationDecimal"]];
    [parDic addEntriesFromDictionary:[NSDictionary dictionaryWithObject:[PWCSelectedServiceData selectedService].minDurationFraction forKey:@"minimumDurationFraction"]];
    [parDic addEntriesFromDictionary:[NSDictionary dictionaryWithObject:[PWCSelectedServiceData selectedService].serviceType forKey:@"serviceType"]];
    [parDic addEntriesFromDictionary:[NSDictionary dictionaryWithObject:[PWCSelectedServiceData selectedService].description forKey:@"description"]];
    
    // CANCELLATION INFO
    [parDic addEntriesFromDictionary:[NSDictionary dictionaryWithObject:[PWCSelectedServiceData selectedService].editRuleDay forKey:@"editRuleDay"]];
    [parDic addEntriesFromDictionary:[NSDictionary dictionaryWithObject:[PWCSelectedServiceData selectedService].editRuleHour forKey:@"editRuleHour"]];
    [parDic addEntriesFromDictionary:[NSDictionary dictionaryWithObject:[PWCSelectedServiceData selectedService].cancelRuleDay forKey:@"cancelRuleDay"]];
    [parDic addEntriesFromDictionary:[NSDictionary dictionaryWithObject:[PWCSelectedServiceData selectedService].cancelRuleHour forKey:@"cancelRuleHour"]];
    [parDic addEntriesFromDictionary:[NSDictionary dictionaryWithObject:[PWCSelectedServiceData selectedService].termsAndConditions forKey:@"termsAndConditions"]];
    
    // ASSIGNED FUNNELS
    NSString *temp = [[PWCSelectedServiceData selectedService].assignedFunnels componentsJoinedByString:@","];
    [parDic addEntriesFromDictionary:[NSDictionary dictionaryWithObject:temp forKey:@"assignedFunnelsWithSalesPath"]];
    
    // REMOVED FUNNELS
    temp = [[PWCSelectedServiceData selectedService].removedFunnels componentsJoinedByString:@","];
    [parDic addEntriesFromDictionary:[NSDictionary dictionaryWithObject:temp forKey:@"removedFunnels"]];
    
    // ASSIGNED TAGS
    temp = [[PWCSelectedServiceData selectedService].assignedTags componentsJoinedByString:@","];
    [parDic addEntriesFromDictionary:[NSDictionary dictionaryWithObject:temp forKey:@"assignedTags"]];
    
    // REMOVED TAGS
    temp = [[PWCSelectedServiceData selectedService].removedTags componentsJoinedByString:@","];
    [parDic addEntriesFromDictionary:[NSDictionary dictionaryWithObject:temp forKey:@"removedTags"]];
    
    NSString *path = [NSString stringWithFormat:@"/scheduleapi/addServices/%@", [PWCGlobal getTheGlobal].coachRowId];
    //NSString *path = [NSString stringWithFormat:@"/api/swipeSale.html"];
    //NSLog(@"PATH: %@", path);
    
    NSLog(@"PARAMETERS: %@", parDic);
    
    //[SVProgressHUD dismiss];
    
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST" path:path parameters:parDic];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                                            NSLog(@"Success");
                                                                                            //NSLog(@"DATA: %@", JSON);
                                                                                            
                                                                                            int result = [[JSON objectForKey:@"result"] intValue];
                                                                                            
                                                                                            if (result == 1) {
                                                                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                                                                    if ([[PWCSelectedServiceData selectedService].serviceRowId isEqualToString:@"0"]) {
                                                                                                        [self addServiceData];
                                                                                                    } else {
                                                                                                        [self updateServiceData];
                                                                                                    }
                                                                                                });
                                                                                            } else {
                                                                                                [SVProgressHUD dismissWithError:@"Cannot save service right now." afterDelay:1.5];
                                                                                            }
                                                                                            
                                                                                        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                                            NSLog(@"Failure");
                                                                                            //NSLog(@"Request: %@", JSON);
                                                                                            //NSLog(@"Error: %@", error);
                                                                                            
                                                                                            [SVProgressHUD dismissWithError:@"Cannot save service right now." afterDelay:1.5];
                                                                                        }];
    [operation start];
    [operation waitUntilFinished];
}

- (void)updateServiceData
{
    [SVProgressHUD showWithStatus:@"Updating services ..." maskType:SVProgressHUDMaskTypeBlack];
    
    SEL updateSel = @selector(doUpdateService);
    
    [self performSelectorInBackground:updateSel withObject:self];
}

- (void)doUpdateService
{
    NSURL *url = [NSURL URLWithString:@"http://www.secureinfossl.com"];
    NSString *path = [NSString stringWithFormat:@"/scheduleapi/getSingleServiceDetail/%@/%@", [PWCGlobal getTheGlobal].coachRowId, [PWCSelectedServiceData selectedService].serviceRowId];
    
    // Call API and Get Data
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [httpClient setDefaultHeader:@"Accept" value:@"application/json"];

    NSLog(@"PATH: %@", path);
    
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET" path:path parameters:nil];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                                            NSLog(@"Success");
                                                                                            //NSLog(@"DATA: %@", JSON);
                                                                                            
                                                                                            int resultCode = [[JSON objectForKey:@"result"] intValue];
                                                                                            
                                                                                            if (resultCode == 1) {
                                                                                                NSArray *serviceArray = [JSON objectForKey:@"services"];
                                                                                                [self updateServiceData:serviceArray];
                                                                                            }
                                                                                            
                                                                                            [PWCGlobal getTheGlobal].services = [PWCServices services].pwcServices;
                                                                                            [SVProgressHUD dismiss];
                                                                                            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:2] animated:YES];
                                                                                            
                                                                                        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                                            NSLog(@"Failure");
                                                                                            
                                                                                            [PWCGlobal getTheGlobal].services = [PWCServices services].pwcServices;
                                                                                            [SVProgressHUD dismiss];
                                                                                            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:2] animated:YES];
                                                                                        }];
    [operation start];
    [operation waitUntilFinished];
}

- (void)updateServiceData:(NSArray *)services
{
    int ok = 0, notok = 0;
    
    for (NSDictionary *d in services) {
        if ([self updateService:d]) {
            ok++;
        } else {
            notok++;
        }
    }
    NSLog(@"OK: %d, NOT OK: %d", ok, notok);
}

- (BOOL)updateService:(NSDictionary *)service
{
    BOOL done = NO;
    sqlite3_stmt *statement;
    // NSLog(@"%@", product);
    
    NSString *section = @"#";
    
    if ([[service objectForKey:@"service_name"] length] > 0) {
        section = [[[service objectForKey:@"service_name"] substringToIndex:1] uppercaseString];
    }
    
    NSString *insertSQL = [NSString stringWithFormat:@"UPDATE services SET serviceType = '%@', serviceName = '%@', description = '%@', requiredUnit = '%@', maxParticipants = '%@', minDuration = '%@', chargePerUnit = '%@', editRuleDay = '%@', editRuleHour = '%@', cancelRuleDay = '%@', cancelRuleHour = '%@', termsAndConditions = '%@', removedFunnels = '%@', assignedFunnels = '%@', removedTags = '%@', assignedTags = '%@', notes = '%@', section = '%@' WHERE serviceRowId = '%@'",
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
                           section,
                           
                           [service objectForKey:@"service_row_id"]];
    
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

- (void)addServiceData
{
    [SVProgressHUD showWithStatus:@"Updating services ..." maskType:SVProgressHUDMaskTypeBlack];
    
    SEL insertSel = @selector(doGetServices);
    
    [self performSelectorInBackground:insertSel withObject:self];
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
    
    //NSLog(@"PATH: %@", path);
    
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
                                                                                            [SVProgressHUD dismiss];
                                                                                            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:2] animated:YES];
                                                                                            
                                                                                        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                                            NSLog(@"Failure");
                                                                                            
                                                                                            [PWCGlobal getTheGlobal].services = [PWCServices services].pwcServices;
                                                                                            [SVProgressHUD dismiss];
                                                                                            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:2] animated:YES];
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

@end
