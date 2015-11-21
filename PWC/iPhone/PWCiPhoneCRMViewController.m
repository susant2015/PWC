//
//  PWCiPhoneCRMViewController.m
//  PWC
//
//  Created by Samiul Hoque on 7/9/13.
//  Copyright (c) 2013 Premium Web Cart. All rights reserved.
//

#import "PWCiPhoneCRMViewController.h"
#import "PWCGlobal.h"
#import "AFNetworking.h"
#import "PWCCustomers.h"

@interface PWCiPhoneCRMViewController ()

@end

@implementation PWCiPhoneCRMViewController

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

    [PWCGlobal getTheGlobal].m_gCRMViewController = self;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    if (sqlite3_open([[PWCGlobal getTheGlobal].getDBPath UTF8String], &pwcDB) != SQLITE_OK) {
        // NSLog(@"Failed to open db");
    } else {
        // NSLog(@"DB openned.");
    }
    
    [SVProgressHUD dismiss];
    
    if ([PWCCustomers customers].pwcCustomers == nil || [PWCCustomers customers].lastCustomerId == nil) {
        [self updateCRMdata:self];
    } else {
        [PWCGlobal getTheGlobal].customers = [PWCCustomers customers].pwcCustomers;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)updateCRMdata:(id)sender {
    [SVProgressHUD showWithStatus:@"Loading customers ..." maskType:SVProgressHUDMaskTypeBlack];
    
    SEL customerSel = @selector(doGetCustomers);
    
    [self performSelectorInBackground:customerSel withObject:self];
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
                                                                                            NSLog(@"Success");
                                                                                            //NSLog(@"DATA: %@", JSON);
                                                                                            
                                                                                            int resultCode = [[JSON objectForKey:@"result"] intValue];
                                                                                            
                                                                                            if (resultCode == 1) {
                                                                                                NSArray *customerArray = [JSON objectForKey:@"customers"];
                                                                                                [self saveCustomerData:customerArray];
                                                                                            }
                                                                                            
                                                                                            [PWCGlobal getTheGlobal].customers = [PWCCustomers customers].pwcCustomers;
                                                                                            
                                                                                            [SVProgressHUD showSuccessWithStatus:@"Syncing successful."];
                                                                                            
                                                                                        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                                            NSLog(@"Failure");
                                                                                            
                                                                                            [SVProgressHUD dismissWithError:@"Syncing failed. Try again later." afterDelay:1.0];
                                                                                            [PWCGlobal getTheGlobal].customers = [PWCCustomers customers].pwcCustomers;
                                                                                            
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



@end
