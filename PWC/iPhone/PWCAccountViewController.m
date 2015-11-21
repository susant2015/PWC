//
//  PWCAccountViewController.m
//  PWC
//
//  Created by Samiul Hoque on 3/5/13.
//  Copyright (c) 2013 Premium Web Cart. All rights reserved.
//

#import "PWCAccountViewController.h"
#import "PWCGlobal.h"
#import "PWCWebViewController.h"
#import "AFNetworking.h"
#import "PWCProducts.h"
#import "PWCOrderList.h"
#import "SBJson.h"
#import "PWCCustomers.h"
#import "PWCServices.h"
#import "DataManager.h"
#import "ASIFormDataRequest.h"
#import "JSON.h"

@interface PWCAccountViewController ()

@end

@implementation PWCAccountViewController
@synthesize m_strSelectedProject;

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
    
    [self updateDefaultRate];
    
    if (sqlite3_open([[PWCGlobal getTheGlobal].getDBPath UTF8String], &pwcDB) != SQLITE_OK) {
        NSLog(@"Failed to open DB! - Account View Controller");
    } else {
        NSLog(@"DB open! - Account View Controller");
    }
    
    [SVProgressHUD dismiss];
}

- (void)viewDidAppear:(BOOL)animated
{
    self.navigationController.toolbarHidden = YES;
}

- (void)updateDefaultRate
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *taxRate = [defaults objectForKey:kTaxRate];
    if (taxRate == nil) {
        taxRate = @"0.00";
    }
    self.defaultTaxRate.detailTextLabel.text = taxRate;
    [PWCGlobal getTheGlobal].defaultTaxRate = taxRate;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSString *requestURL = @"http://www.secureinfossl.com/app/getAccess";
    
    if ([[segue identifier] isEqualToString:@"webSeg1"]) {
        PWCWebViewController *destination = segue.destinationViewController;

        NSString *urlString = [NSString stringWithFormat:@"%@/%@/change-password/%@",
                         requestURL,[PWCGlobal getTheGlobal].merchantId,[PWCGlobal getTheGlobal].hashKey];

        destination.webViewTitle = @"Change Password";
        destination.webViewUrl = [NSURL URLWithString:urlString];
    } else if ([[segue identifier] isEqualToString:@"webSeg2"]) {
        PWCWebViewController *destination = segue.destinationViewController;
        
        NSString *urlString = [NSString stringWithFormat:@"%@/%@/change-package/%@",
                               requestURL,[PWCGlobal getTheGlobal].merchantId,[PWCGlobal getTheGlobal].hashKey];
        
        destination.webViewTitle = @"Change Package";
        destination.webViewUrl = [NSURL URLWithString:urlString];
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if ([cell.textLabel.text isEqualToString:@"Update Billing Info"]) {
        NSURL *url = [NSURL URLWithString:@"https://www.secureinfossl.com/merchant/editAccountBillingInfo.html"];
        
        if (![[UIApplication sharedApplication] openURL:url]) {
            NSString *msg = @"Cannot load the site now! Please try later!";
            [self showAlertWithTitle:nil andMessage:msg];
        }
    } else if ([cell.textLabel.text isEqualToString:@"Default Tax Rate"]) {
        
        [self showTexfieldAlert];
        cell.selected = NO;
    } else if ([cell.textLabel.text isEqualToString:@"Re-Sync Existing Products"]) {
        [SVProgressHUD showWithStatus:@"Loading ..." maskType:SVProgressHUDMaskTypeBlack];
        SEL newOrderSel = @selector(doGetProductsForNewOrder);
        [self performSelectorInBackground:newOrderSel withObject:self];
        cell.selected = NO;
    } else if ([cell.textLabel.text isEqualToString:@"Re-Sync All Orders"]) {
        [SVProgressHUD showWithStatus:@"Loading ..." maskType:SVProgressHUDMaskTypeBlack];
        SEL orderSel = @selector(doOrderProcess);
        [self performSelectorInBackground:orderSel withObject:self];
        cell.selected = NO;
    } else if ([cell.textLabel.text isEqualToString:@"Re-Sync All Customers"]) {
        [SVProgressHUD showWithStatus:@"Loading ..." maskType:SVProgressHUDMaskTypeBlack];
        SEL customerSel = @selector(doGetCustomers);
        [self performSelectorInBackground:customerSel withObject:self];
        cell.selected = NO;
    } else if ([cell.textLabel.text isEqualToString:@"Re-Sync All Services"]) {
        [SVProgressHUD showWithStatus:@"Loading ..." maskType:SVProgressHUDMaskTypeBlack];
        SEL serviceSel = @selector(doGetServices);
        [self performSelectorInBackground:serviceSel withObject:self];
        cell.selected = NO;
    } else if ([cell.textLabel.text isEqualToString:@"Re-Sync All Funnels"]) {
        [SVProgressHUD showWithStatus:@"Loading ..." maskType:SVProgressHUDMaskTypeBlack];
        SEL funnelSel = @selector(doGetFunnels);
        [self performSelectorInBackground:funnelSel withObject:self];
        cell.selected = NO;
    } else if ([cell.textLabel.text isEqualToString:@"Re-Sync All Tags"]) {
        [SVProgressHUD showWithStatus:@"Loading ..." maskType:SVProgressHUDMaskTypeBlack];
        SEL tagSel = @selector(doGetTags);
        [self performSelectorInBackground:tagSel withObject:self];
        cell.selected = NO;
    }
    else if ([cell.textLabel.text isEqualToString:@"Re-Sync All Projects"])
    {
        [self getProjectList];
        cell.selected = NO;
    }
    else if ([cell.textLabel.text isEqualToString:@"Re-Sync All Messages"])
    {
        [self syncMessageList];
        cell.selected = NO;
    }
    else if ([cell.textLabel.text isEqualToString:@"Re-Sync All Users"])
    {
        [self syncUserList];
        cell.selected = NO;
    }
    
}




- (IBAction)logoutFromApp:(id)sender {
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@""
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:@"Logout"
                                                    otherButtonTitles:nil];
    [actionSheet showInView:super.view];
    //[actionSheet showFromTabBar:self.tabBarController.tabBar];
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != [actionSheet cancelButtonIndex]) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setValue:@"" forKey:kEmailKey];
        [defaults setValue:@"" forKey:kPasswordKey];
        
        [PWCGlobal getTheGlobal].isAuthenticated = NO;
        [PWCGlobal getTheGlobal].firstName = nil;
        
        // REMOVE ALL DATA
        [self deleteProductData];
        [self deleteOrderData];
        [self deleteCustomerData];
        [self deleteServiceData];
        [self deleteLocalData];
        
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (BOOL)deleteStatement:(NSString *)sql
{
    BOOL done = NO;
    sqlite3_stmt *statement;
    
    NSString *updateSQL = sql;
    
    const char *update_stmt = [updateSQL UTF8String];
    
    sqlite3_prepare_v2(pwcDB, update_stmt, -1, &statement, NULL);
    if (sqlite3_step(statement) == SQLITE_DONE)
    {
        done = YES;
    } else {
        done = NO;
    }
    
    sqlite3_finalize(statement);
    return done;
}

#pragma mark - 
#pragma mark RE-SYNC PRODUCT DATA

- (void)deleteProductData
{
    if ([self deleteStatement:@"DELETE FROM products"]) {
        if ([self deleteStatement:@"DELETE FROM sqlite_sequence WHERE name = 'products'"]) {
            //NSLog(@"DELETE DONE");
        }
    }
}

- (void)doGetProductsForNewOrder
{
    // TRUNCATE TABLE
    [self deleteProductData];
    
    // Call API and Get Data
    NSURL *url = [NSURL URLWithString:@"https://secureinfossl.com"];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [httpClient setDefaultHeader:@"Accept" value:@"application/json"];
    
    NSString *path = [NSString stringWithFormat:@"/app/getAccess/%@/productlistwithprices/%@", [PWCGlobal getTheGlobal].merchantId, [PWCGlobal getTheGlobal].hashKey];
    /*
    if (([PWCProducts products].lastProductId != nil) && ([[PWCProducts products].lastProductId length] > 0)) {
        path = [NSString stringWithFormat:@"%@/%@", path, [PWCProducts products].lastProductId];
    }
    */
    //NSLog(@"PATH: %@", path);
    
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET" path:path parameters:nil];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                                            //NSLog(@"Success");
                                                                                            //NSLog(@"DATA: %@", JSON);
                                                                                            
                                                                                            int resultCode = [[JSON objectForKey:@"result"] intValue];
                                                                                            
                                                                                            if (resultCode == 1) {
                                                                                                NSArray *productArray = [JSON objectForKey:@"productlist"];
                                                                                                [self saveProductData:productArray];
                                                                                            }
                                                                                            
                                                                                            [PWCGlobal getTheGlobal].products = [PWCProducts products].pwcProducts;
                                                                                            
                                                                                            [SVProgressHUD showSuccessWithStatus:@"Syncing successful."];
                                                                                            
                                                                                        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                                            //NSLog(@"Failure");
                                                                                            
                                                                                            [SVProgressHUD dismissWithError:@"Syncing failed. Try again later." afterDelay:1.0];
                                                                                            [PWCGlobal getTheGlobal].products = [PWCProducts products].pwcProducts;
                                                                                            
                                                                                        }];
    [operation start];
    [operation waitUntilFinished];
}

- (void)saveProductData:(NSArray *)products
{
    int ok = 0, notok = 0;
    
    for (NSDictionary *d in products) {
        NSString *key = [[d allKeys] objectAtIndex:0];
        NSArray *val = [d allValues];
        
        for (NSDictionary *dp in [val objectAtIndex:0]) {
            if ([self insertProductData:dp key:key]) {
                ok++;
            } else {
                notok++;
            }
        }
        ok = 0; notok = 0;
    }
}

- (BOOL)insertProductData:(NSDictionary *)product key:(NSString *)section
{
    BOOL done = NO;
    sqlite3_stmt *statement;
    // NSLog(@"%@", product);
    
    NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO products (productId, attributeId, productName, productPrice, section) VALUES ('%@','%@','%@','%@','%@')",
                           [product objectForKey:@"pid"],
                           [product objectForKey:@"aid"],
                           [product objectForKey:@"name"],
                           [product objectForKey:@"price"],
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

#pragma mark -
#pragma mark RE-SYNC ALL ORDERS

- (void)deleteOrderData
{
    if ([self deleteStatement:@"DELETE FROM order_table"]) {
        if ([self deleteStatement:@"DELETE FROM sqlite_sequence WHERE name = 'order_table'"]) {
            //NSLog(@"DELETE DONE");
        }
    }
}

- (void)doOrderProcess
{
    // TRUNCATE TABLE
    [self deleteOrderData];
    
    // Call API and Get Data
    NSURL *url = [NSURL URLWithString:@"https://secureinfossl.com"];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [httpClient setDefaultHeader:@"Accept" value:@"application/json"];
    
    NSString *path = [NSString stringWithFormat:@"/app/getAccess/%@/mobile7daysorder/%@", [PWCGlobal getTheGlobal].merchantId, [PWCGlobal getTheGlobal].hashKey];
    
    /*
    if (([PWCOrderList database].lasOrderRowId != nil) && ([[PWCOrderList database].lasOrderRowId length] > 0)) {
        path = [NSString stringWithFormat:@"%@/%@", path, [PWCOrderList database].lasOrderRowId];
    } else {
        [self deleteOrderData];
    }
    */
    //NSLog(@"PATH: %@", path);
    
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET" path:path parameters:nil];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                                            //NSLog(@"Success");
                                                                                            //NSLog(@"DATA: %@", JSON);
                                                                                            
                                                                                            int resultCode = [[JSON objectForKey:@"resultcode"] intValue];
                                                                                            
                                                                                            if (resultCode == 1) {
                                                                                                NSArray *sevenArray = [JSON objectForKey:@"OrderDetails"];
                                                                                                
                                                                                                [self saveData:sevenArray];
                                                                                                [PWCGlobal getTheGlobal].ordersToday = [PWCOrderList database].pwcTodaysUnread;
                                                                                                [PWCGlobal getTheGlobal].orders7Days = [PWCOrderList database].pwc7DaysUnread;
                                                                                            }
                                                                                            
                                                                                            [SVProgressHUD showSuccessWithStatus:@"Syncing successful."];
                                                                                        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                                            //NSLog(@"Failure");
                                                                                            //NSLog(@"Request: %@",JSON);
                                                                                            [SVProgressHUD dismissWithError:@"Syncing failed. Try again later." afterDelay:1.0];
                                                                                        }];
    [operation start];
    [operation waitUntilFinished];
    
}

- (void)saveData:(NSArray *)orders
{
    int ok = 0, notok = 0;
    
    for (NSDictionary *d in orders) {
        if ([self insertOrderData:d]) {
            ok++;
        } else {
            notok++;
        }
    }
    
    //NSLog(@"OK: %d, NOT OK: %d", ok, notok);
}

- (BOOL)insertOrderData:(NSDictionary *)orders
{
    BOOL done = NO;
    sqlite3_stmt *statement;
    
    NSString *orderDetail = [[[SBJsonWriter alloc] init] stringWithObject:[orders objectForKey:@"OrderDetails"]];
    
    NSString *insertSQL = [NSString stringWithFormat: @"INSERT INTO order_table (OrderRowId,OrderId,OrderChargeStatus,OrderStatus,OrderDate,ProductName,OrderAmount,CustomerName,AffiliateName,OrderReadStatus,OrderDetails,OrderTypes) VALUES ('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",
                           [orders objectForKey:@"OrderRowId"],
                           [orders objectForKey:@"OrderId"],
                           [orders objectForKey:@"OrderChargeStatus"],
                           [orders objectForKey:@"OrderStatus"],
                           [orders objectForKey:@"OrderDateTime"],
                           [orders objectForKey:@"ProductName"],
                           [orders objectForKey:@"OrderAmount"],
                           [orders objectForKey:@"CustomerName"],
                           [orders objectForKey:@"AffiliatesName"],
                           @"Unread",
                           orderDetail,
                           [orders objectForKey:@"OrderType"]
                           //[self escape:[[orders objectForKey:@"OrderDetails"] objectAtIndex:0]]
                           ];
    
    const char *insert_stmt = [insertSQL UTF8String];
    //NSLog(@"%@", orderDetail);
    sqlite3_prepare_v2(pwcDB, insert_stmt, -1, &statement, NULL);
    if (sqlite3_step(statement) == SQLITE_DONE)
    {
        done = YES;
        //NSLog(@"%@ - YES", [orders objectForKey:@"OrderRowId"]);
    } else {
        done = NO;
        //NSLog(@"%@ - NO", [orders objectForKey:@"OrderRowId"]);
    }
    sqlite3_finalize(statement);
    
    return done;
}

#pragma mark -
#pragma mark RE-SYNC ALL CUSTOMERS

- (void)deleteCustomerData
{
    if ([self deleteStatement:@"DELETE FROM customers"]) {
        if ([self deleteStatement:@"DELETE FROM sqlite_sequence WHERE name = 'customers'"]) {
            //NSLog(@"DELETE DONE");
        }
    }
}

- (void)doGetCustomers
{
    // TRUNCATE TABLE
    [self deleteCustomerData];
    
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
    
    //NSLog(@"PATH: %@", path);
    
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET" path:path parameters:nil];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                                            //NSLog(@"Success");
                                                                                            NSLog(@"CUSTOMER DATA: %@", JSON);
                                                                                            
                                                                                            int resultCode = [[JSON objectForKey:@"result"] intValue];
                                                                                            
                                                                                            if (resultCode == 1) {
                                                                                                NSArray *customerArray = [JSON objectForKey:@"customers"];
                                                                                                [self saveCustomerData:customerArray];
                                                                                            }
                                                                                            
                                                                                            [PWCGlobal getTheGlobal].customers = [PWCCustomers customers].pwcCustomers;
                                                                                            
                                                                                            [SVProgressHUD showSuccessWithStatus:@"Customers Synced."];
                                                                                        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                                            //NSLog(@"Failure");
                                                                                            
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
    NSLog(@"%@", customer);
    
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

#pragma mark -
#pragma mark RE-SYNC ALL SERVICES

-(void) deleteLocalData
{
    [[DataManager sharedScoreManager] deleteAllAssignedUser];
    [[DataManager sharedScoreManager] deleteAllEmailProfiles];
    [[DataManager sharedScoreManager] deleteAllEmailContents];
    [[DataManager sharedScoreManager] deleteAllSMSContents];
    [[DataManager sharedScoreManager] deleteTaskList];
    [[DataManager sharedScoreManager] deleteAllTasks];
    [[DataManager sharedScoreManager] deleteAllFunnels];
    [[DataManager sharedScoreManager] deleteSalesPath];
    [[DataManager sharedScoreManager] deleteAllRoleUsers];
    [[DataManager sharedScoreManager] deleteAllCategoy];
    [[DataManager sharedScoreManager] deleteAllTag];
    [[DataManager sharedScoreManager] deleteAllAssignedUser];
    [[DataManager sharedScoreManager] deleteAllLeadRole];
    [[DataManager sharedScoreManager] deleteAllProductCategory];
    [[DataManager sharedScoreManager] deleteAllTask2];        
}

- (void)deleteServiceData
{
    if ([self deleteStatement:@"DELETE FROM services"]) {
        if ([self deleteStatement:@"DELETE FROM sqlite_sequence WHERE name = 'services'"]) {
            //NSLog(@"DELETE DONE");
        }
    }
}

- (void)doGetServices
{
    // TRUNCATE TABLE
    [self deleteServiceData];
    
    NSURL *url = [NSURL URLWithString:@"http://www.secureinfossl.com"];
    NSString *path = [NSString stringWithFormat:@"/scheduleapi/manageservicelist/%@", [PWCGlobal getTheGlobal].coachRowId];
    //} else {
        // MERCHANT OR OTHER
    //    url = [NSURL URLWithString:@"https://www.pwccrm.com"];
    //    path = [NSString stringWithFormat:@"/beta/api2/api/customerlist/%@/%@", [PWCGlobal getTheGlobal].merchantId, [PWCGlobal getTheGlobal].userHash];
    //}
    
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
                                                                                            //NSLog(@"Success");
                                                                                            //NSLog(@"DATA: %@", JSON);
                                                                                            
                                                                                            int resultCode = [[JSON objectForKey:@"result"] intValue];
                                                                                            
                                                                                            if (resultCode == 1) {
                                                                                                NSArray *serviceArray = [JSON objectForKey:@"services"];
                                                                                                [self saveServiceData:serviceArray];
                                                                                            }
                                                                                            
                                                                                            [PWCGlobal getTheGlobal].services = [PWCServices services].pwcServices;
                                                                                            
                                                                                            [SVProgressHUD showSuccessWithStatus:@"Services Synced."];
                                                                                            
                                                                                        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                                            //NSLog(@"Failure");
                                                                                            
                                                                                            [SVProgressHUD dismissWithError:@"Syncing failed. Try again later." afterDelay:1.0];
                                                                                            [PWCGlobal getTheGlobal].services = [PWCServices services].pwcServices;
                                                                                            
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
    //NSLog(@"OK: %d, NOT OK: %d", ok, notok);
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

#pragma mark
#pragma mark Custome Alert
#pragma mark

-(void)showAlertWithTitle:(NSString*)strtitle andMessage:(NSString*)strmessage{
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:strtitle
                                  message:strmessage
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:@"ok"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action)
                                {
                                    //Handel your yes please button action here
                                    [alert dismissViewControllerAnimated:YES completion:nil];
                                    
                                }];
    
    [alert addAction:yesButton];
    
    [self presentViewController:alert animated:YES completion:nil];
}
-(void)showTexfieldAlert{
    UIAlertController * controller=   [UIAlertController
                                  alertControllerWithTitle:@"Tax Rate"
                                  message:@"Enter tax rate:"
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    [controller addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Enter default tax rate";
        textField.keyboardType = UIKeyboardTypeDecimalPad;

    }];
    UIAlertAction* cancelButton = [UIAlertAction
                                actionWithTitle:@"Cancel"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action)
                                {
                                    //Handel your yes please button action here
                                    [controller dismissViewControllerAnimated:YES completion:nil];
                                    
                                }];
    
    [controller addAction:cancelButton];
    
    UIAlertAction* changeButton = [UIAlertAction
                                   actionWithTitle:@"Change"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action)
                                   {
                                       //Handel your yes please button action here
                                       UITextField *txtRate = controller.textFields.firstObject;
                                       if ([[txtRate text] floatValue] >= 0.0) {
                                           NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                                           [defaults setValue:[NSString stringWithFormat:@"%.2f",[[txtRate text] floatValue]] forKey:kTaxRate];
                                       }

                                       [controller dismissViewControllerAnimated:YES completion:nil];
                                       
                                   }];
    
    [controller addAction:cancelButton];
    [controller addAction:changeButton];

    
}



#pragma mark -
#pragma mark RE-SYNC ALL FUNNELS

- (void)doGetFunnels
{
    /*
    
    NSURL *url = [NSURL URLWithString:@"http://www.secureinfossl.com"];
    NSString *path = [NSString stringWithFormat:@"/scheduleapi/getFunnelList/%@", [PWCGlobal getTheGlobal].coachRowId];
     
    */
    
    NSURL *url = [NSURL URLWithString:@"https://pwccrm.com/beta/api2/api"];
    NSString *path = [NSString stringWithFormat:@"%@/funnellist/%@/%@", url, [PWCGlobal getTheGlobal].merchantId, [PWCGlobal getTheGlobal].userHash];
    
    
    NSLog(@"Account Funnels List = %@", path);

    
    
    // Call API and Get Data
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [httpClient setDefaultHeader:@"Accept" value:@"application/json"];
    
    //NSLog(@"PATH: %@", path);
    
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET" path:path parameters:nil];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                                            //NSLog(@"Success");
                                                                                            NSLog(@"DATA: %@", JSON);
                                                                                            
                                                                                            int resultCode = [[JSON objectForKey:@"result"] intValue];
                                                                                            
                                                                                            if (resultCode == 1) {
                                                                                                NSArray *funnelArray = [JSON objectForKey:@"funnelswithsalespathlist"];
                                                                                                SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
                                                                                                NSString *funnelsString = [jsonWriter stringWithObject:JSON];
                                                                                                [self saveFunnelData:funnelArray funnelString:funnelsString];
                                                                                                [PWCGlobal getTheGlobal].funnels = funnelArray;
                                                                                            }
                                                                                            
                                                                                            [SVProgressHUD showSuccessWithStatus:@"Funnels Synced."];
                                                                                            
                                                                                        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                                            //NSLog(@"Failure");
                                                                                            
                                                                                            [SVProgressHUD dismissWithError:@"Syncing failed. Try again later." afterDelay:1.0];
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

#pragma mark -
#pragma mark RE-SYNC ALL TAGS

- (void)doGetTags
{

    /*
    NSURL *url = [NSURL URLWithString:@"http://www.secureinfossl.com"];
    NSString *path = [NSString stringWithFormat:@"/scheduleapi/getTagsList/%@", [PWCGlobal getTheGlobal].coachRowId];
    */
    
    NSURL *url = [NSURL URLWithString:@"https://pwccrm.com/beta/api2/api"];
    NSString *path = [NSString stringWithFormat:@"%@/tags/%@/%@", url, [PWCGlobal getTheGlobal].merchantId, [PWCGlobal getTheGlobal].userHash];
    
    
    NSLog(@"New Account Tags List = %@", url);
    
    // Call API and Get Data
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [httpClient setDefaultHeader:@"Accept" value:@"application/json"];
    
    NSLog(@"PATH: %@", path);
    
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET" path:path parameters:nil];
    NSLog(@"REQUEST: %@", request);

    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                                            //NSLog(@"Success");
                                                                                            NSLog(@"DATA: %@", JSON);
                                                                                            
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

#pragma mark -
#pragma mark Project Sync.
//==============================================================================================================
-(void) getProjectList
{
    [SVProgressHUD showWithStatus:@"Loading ..." maskType:SVProgressHUDMaskTypeBlack];
    NSString* strURL = [@"https://pwcproject.com/v2/mobilepm/api/projectlist" stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    
    NSLog(@"account_id = %@", [PWCGlobal getTheGlobal].account_id);
    NSLog(@"userhash = %@", [PWCGlobal getTheGlobal].hashKey);
    
    ASIFormDataRequest* request = [ASIFormDataRequest requestWithURL: [NSURL URLWithString: strURL]];
    [request setDelegate: self];
    [request setTimeOutSeconds: REQUEST_TIME_OUT];
    [request setPostValue: [PWCGlobal getTheGlobal].account_id forKey: @"account_id"];
    [request setPostValue: [PWCGlobal getTheGlobal].hashKey forKey: @"userhash"];
    
    [request setDidFinishSelector: @selector(finishedGetProjectList:)];
    [request setDidFailSelector: @selector(failedSync:)];
    [request startAsynchronous];
}

//==============================================================================================================
-(void) finishedGetProjectList: (ASIFormDataRequest*) theRequest
{
    [SVProgressHUD showSuccessWithStatus:@"Syncing Successful."];
    NSString* strResponse = [theRequest responseString];
    NSArray* arrList = [strResponse JSONValue];
    
    [[DataManager sharedScoreManager] deleteAllProjectLists];
    
    for(int i = 0; i < [arrList count]; i++)
    {
        NSDictionary* dicRecord = [arrList objectAtIndex: i];
        
        [[DataManager sharedScoreManager] insertProjectList: [dicRecord valueForKey: @"Id"]
                                                   ProjName: [dicRecord valueForKey: @"ProjName"]];
    }
}

#pragma mark - 
#pragma mark Message List.

//==============================================================================================================
-(void) syncMessageList
{
    NSArray* arrProjectList = [[DataManager sharedScoreManager] getAllProjectLists];
    if(arrProjectList == nil || [arrProjectList count] <= 0) return;

    m_nCurProjectIndex = 0;
    m_nTotalProjectCount = [arrProjectList count];
    
    NSDictionary* dicRecord = [arrProjectList objectAtIndex: m_nCurProjectIndex];
    NSString* strProjectID = [dicRecord valueForKey: @"Id"];
    
    [self getMessageList: strProjectID];
}

//==============================================================================================================
-(void) getMessageList: (NSString*) project_id
{
    self.m_strSelectedProject = project_id;
    
    [SVProgressHUD showWithStatus:@"Loading ..." maskType:SVProgressHUDMaskTypeBlack];
    NSString* strURL = [@"https://pwcproject.com/v2/mobilepm/api/messages" stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    
    NSLog(@"account_id = %@", [PWCGlobal getTheGlobal].account_id);
    NSLog(@"userhash = %@", [PWCGlobal getTheGlobal].hashKey);
    NSLog(@"project_id = %@", project_id);
    
    ASIFormDataRequest* request = [ASIFormDataRequest requestWithURL: [NSURL URLWithString: strURL]];
    [request setDelegate: self];
    [request setTimeOutSeconds: REQUEST_TIME_OUT];
    [request setPostValue: [PWCGlobal getTheGlobal].account_id forKey: @"account_id"];
    [request setPostValue: [PWCGlobal getTheGlobal].hashKey forKey: @"userhash"];
    [request setPostValue: project_id forKey: @"project_id"];
    
    [request setDidFinishSelector: @selector(finishedGetMessageList:)];
    [request setDidFailSelector: @selector(failedSync:)];
    [request startAsynchronous];
}

//==============================================================================================================
-(void) finishedGetMessageList: (ASIFormDataRequest*) theRequest
{
    [SVProgressHUD showSuccessWithStatus:@"Syncing Successful."];
    NSString* strResponse = [theRequest responseString];
    NSDictionary* dicList = [strResponse JSONValue];
    
    [[DataManager sharedScoreManager] deleteAllPMMessageListByProjectID: self.m_strSelectedProject];
    
    NSArray* arrList = [dicList allValues];
    if(arrList != nil && [arrList count] > 0)
    {
        for(int i = 0; i < [arrList count]; i++)
        {
            NSDictionary* dicRecord = [arrList objectAtIndex: i];
            [[DataManager sharedScoreManager] insertPMMessageList: [dicRecord valueForKey: @"Id"]
                                                             Date: [dicRecord valueForKey: @"Date"]
                                                      MessageType: [dicRecord valueForKey: @"MessageType"]
                                                         PostedBy: [dicRecord valueForKey: @"PostedBy"]
                                                          Subject: [dicRecord valueForKey: @"Subject"]
                                                       project_id: self.m_strSelectedProject];
        }
    }
    
    m_nCurProjectIndex ++;
    if(m_nCurProjectIndex < m_nTotalProjectCount)
    {
        NSArray* arrProjectList = [[DataManager sharedScoreManager] getAllProjectLists];
        if(arrProjectList == nil || [arrProjectList count] <= 0) return;
        NSDictionary* dicRecord = [arrProjectList objectAtIndex: m_nCurProjectIndex];
        NSString* strProjectID = [dicRecord valueForKey: @"Id"];
        
        [self getMessageList: strProjectID];
    }
}

//==============================================================================================================
-(void) syncUserList
{
    NSArray* arrProjectList = [[DataManager sharedScoreManager] getAllProjectLists];
    if(arrProjectList == nil || [arrProjectList count] <= 0) return;
    
    m_nCurProjectIndex = 0;
    m_nTotalProjectCount = [arrProjectList count];
    
    NSDictionary* dicRecord = [arrProjectList objectAtIndex: m_nCurProjectIndex];
    NSString* strProjectID = [dicRecord valueForKey: @"Id"];
    
    [self getUserList: strProjectID];
}

//==============================================================================================================
-(void) getUserList: (NSString*) project_id
{
    self.m_strSelectedProject = project_id;
    
    [SVProgressHUD showWithStatus:@"Loading ..." maskType:SVProgressHUDMaskTypeBlack];
    NSString* strURL = [@"https://pwcproject.com/v2/mobilepm/api/userlist" stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    
    NSLog(@"account_id = %@", [PWCGlobal getTheGlobal].account_id);
    NSLog(@"userhash = %@", [PWCGlobal getTheGlobal].hashKey);
    NSLog(@"project_id = %@", self.m_strSelectedProject);
    
    ASIFormDataRequest* request = [ASIFormDataRequest requestWithURL: [NSURL URLWithString: strURL]];
    [request setDelegate: self];
    [request setTimeOutSeconds: REQUEST_TIME_OUT];
    [request setPostValue: [PWCGlobal getTheGlobal].account_id forKey: @"account_id"];
    [request setPostValue: [PWCGlobal getTheGlobal].hashKey forKey: @"userhash"];
    [request setPostValue: self.m_strSelectedProject forKey: @"project_id"];
    
    [request setDidFinishSelector: @selector(finishedGetUserList:)];
    [request setDidFailSelector: @selector(failedSync:)];
    [request startAsynchronous];
}

//==============================================================================================================
-(void) finishedGetUserList: (ASIFormDataRequest*) theRequest
{
    [SVProgressHUD showSuccessWithStatus:@"Syncing Successful."];
    NSString* strResponse = [theRequest responseString];
    NSDictionary* dicList = [strResponse JSONValue];
    NSLog(@"dicList = %@", dicList);
    
    NSArray* arrList = [dicList allValues];
    NSString* people = @"";
    
    
    [[DataManager sharedScoreManager] deleteAllPMTaskUserListByProjectID: self.m_strSelectedProject];
    if(arrList != nil && [arrList count] > 0)
    {
        for(int i = 0; i < [arrList count]; i++)
        {
            people = @"";
            
            NSDictionary* dicUser = [arrList objectAtIndex: i];
            if([[dicUser valueForKey: @"people"] isKindOfClass: [NSArray class]])
            {
                NSArray* arrPeople = [dicUser valueForKey: @"people"];
                if(arrPeople != nil && [arrPeople count] > 0)
                {
                    for(int j = 0; j < [arrPeople count]; j++)
                    {
                        NSDictionary* dicPeople = [arrPeople objectAtIndex: j];
                        NSArray* arrTemp = [dicPeople allValues];
                        NSLog(@"arrTemp = %@", arrTemp);
                        NSDictionary* dicTemp = [arrTemp objectAtIndex: 0];
                        [[DataManager sharedScoreManager] insertPMTaskPeople: [dicTemp valueForKey: @"tc_companyname"]
                                                                       tc_id: [dicTemp valueForKey: @"tc_id"]
                                                                 tc_ismaster: [dicTemp valueForKey: @"tc_ismaster"]
                                                                     tc_type: [dicTemp valueForKey: @"tc_type"]
                                                                tp_firstname: [dicTemp valueForKey: @"tp_firstname"]
                                                                       tp_id: [dicTemp valueForKey: @"tp_id"]
                                                                 tp_lastname: [dicTemp valueForKey: @"tp_lastname"]
                                                                    selected: @"0"];
                        
                        if(people == nil || [people length] <=0 )
                        {
                            people = [dicTemp valueForKey: @"tp_id"];
                        }
                        else
                        {
                            people = [people stringByAppendingString: [NSString stringWithFormat: @",%@", [dicTemp valueForKey: @"tp_id"]]];
                        }
                    }
                }
            }
            else
            {
                NSDictionary* dicPeople = [dicUser valueForKey: @"people"];
                NSArray* arrTemp = [dicPeople allValues];
                NSDictionary* dicTemp = [arrTemp objectAtIndex: 0];
                [[DataManager sharedScoreManager] insertPMTaskPeople: [dicTemp valueForKey: @"tc_companyname"]
                                                               tc_id: [dicTemp valueForKey: @"tc_id"]
                                                         tc_ismaster: [dicTemp valueForKey: @"tc_ismaster"]
                                                             tc_type: [dicTemp valueForKey: @"tc_type"]
                                                        tp_firstname: [dicTemp valueForKey: @"tp_firstname"]
                                                               tp_id: [dicTemp valueForKey: @"tp_id"]
                                                         tp_lastname: [dicTemp valueForKey: @"tp_lastname"]
                                                            selected: @"0"];
                
                if(people == nil || [people length] <=0 )
                {
                    people = [dicTemp valueForKey: @"tp_id"];
                }
                else
                {
                    people = [people stringByAppendingString: [NSString stringWithFormat: @",%@", [dicTemp valueForKey: @"tp_id"]]];
                }
            }
            
            [[DataManager sharedScoreManager] insertPMTaskUserList: [dicUser valueForKey: @"tc_comapnyid"]
                                                    tc_companyname: [dicUser valueForKey: @"tc_companyname"]
                                                       tc_ismaster: [dicUser valueForKey: @"tc_ismaster"]
                                                           tc_type: [dicUser valueForKey: @"tc_type"]
                                                            people: people
                                                        project_id: self.m_strSelectedProject];
        }
    }
    
    m_nCurProjectIndex ++;
    if(m_nCurProjectIndex < m_nTotalProjectCount)
    {
        NSArray* arrProjectList = [[DataManager sharedScoreManager] getAllProjectLists];
        if(arrProjectList == nil || [arrProjectList count] <= 0) return;
        
        NSDictionary* dicRecord = [arrProjectList objectAtIndex: m_nCurProjectIndex];
        NSString* strProjectID = [dicRecord valueForKey: @"Id"];
        [self getUserList: strProjectID];
    }
}

//==============================================================================================================
-(void) failedSync: (ASIFormDataRequest*) theRequest
{
    [SVProgressHUD showSuccessWithStatus:@"Syncing Failed."];
}
//==============================================================================================================
@end
