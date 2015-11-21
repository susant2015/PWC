//
//  PWCDashboardViewController.m
//  PWC
//
//  Created by Samiul Hoque on 2/15/13.
//  Copyright (c) 2013 Premium Web Cart. All rights reserved.
//

#import "PWCDashboardViewController.h"
#import "PWCDashboardCell.h"
#import <QuartzCore/QuartzCore.h>
#import "PWCGlobal.h"
#import "PWCOrderList.h"
#import "PWCOrders.h"
#import "AFNetworking.h"
#import "SBJson.h"
#import "PWCWebViewController.h"
#import "PWCiPhoneScheduleSummaryViewController.h"
#import "PWCiPhoneScheduleMainViewController.h"
#import "PWCOrdersMainViewController.h"

@interface PWCDashboardViewController ()

@end

@implementation PWCDashboardViewController

@synthesize dashboardItems;

@synthesize webTitle;
@synthesize webUrl;

//==============================================================================================================
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

//==============================================================================================================
-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    self.navigationController.navigationBar.hidden = YES;
}

//==============================================================================================================
- (void)viewDidLoad
{
    [super viewDidLoad];

    [m_scrollView setContentSize: CGSizeMake(m_scrollView.contentSize.width, 420)];
    
    if (sqlite3_open([[PWCGlobal getTheGlobal].getDBPath UTF8String], &pwcDB) != SQLITE_OK) {
        NSLog(@"Failed to open database!");
    } else {
        NSLog(@"Database openned!");
    }
    
    NSLog(@"DASHBOARD VIEW LOADED");
    
    self.dashboardItems = [[NSMutableArray alloc] init];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"dashboardList" ofType:@"plist"];
    NSDictionary *dashboardInfo = [NSDictionary dictionaryWithContentsOfFile:path];
    NSArray *dashItems = [dashboardInfo objectForKey:@"dashboardItems"];
    
    [self.dashboardItems addObject:[dashItems objectAtIndex:0]];
    [self.dashboardItems addObject:[dashItems objectAtIndex:1]];
    [self.dashboardItems addObject:[dashItems objectAtIndex:2]];
    [self.dashboardItems addObject:[dashItems objectAtIndex:3]];
    [self.dashboardItems addObject:[dashItems objectAtIndex:4]];
    [self.dashboardItems addObject:[dashItems objectAtIndex:5]];
    [self.dashboardItems addObject:[dashItems objectAtIndex:6]];
    [self.dashboardItems addObject:[dashItems objectAtIndex:7]];
    
    if ([[PWCGlobal getTheGlobal].notificationType length] == 0) {
        [self performSelector:@selector(loadNotifications) withObject:nil afterDelay:2.0];
    }
    
    [self performSelector:@selector(sendDeviceTokenInBackground) withObject:nil afterDelay:2.0];
}

//==============================================================================================================
- (void)viewDidAppear:(BOOL)animated
{
    NSLog(@"DASHBOARD VIEW CONTROLLER APPEARED");
    self.navigationController.toolbarHidden = YES;
    if (![PWCGlobal getTheGlobal].isAuthenticated)
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
        UIViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"loginScreen"];
        
        //NSLog(@"login push: %@", loginViewController);
        [self presentViewController:loginViewController animated:YES completion:nil];
        //NSLog(@"done push");
    } else {
        [self loadNotifications];
        [self performSelector:@selector(sendDeviceTokenInBackground) withObject:nil afterDelay:1.0];
    }
}
//==============================================================================================================
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma -
#pragma Collection View Data

//==============================================================================================================
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.dashboardItems count];
}
//==============================================================================================================
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"dashboardCell";
    
    PWCDashboardCell *cvc = (PWCDashboardCell *)[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    NSInteger item = [indexPath row];
    NSDictionary *dict = [self.dashboardItems objectAtIndex:item];
    
    cvc.name.text = [dict objectForKey:@"name"];
    cvc.image.image = [UIImage imageNamed:[dict objectForKey:@"image"]];
    cvc.image.highlightedImage = [UIImage imageNamed:[dict objectForKey:@"imagehover"]];
    
    // NOTIFICATION
    UILabel *label = cvc.notification;
    NSString *notiNum = [[PWCGlobal getTheGlobal].dashboardNotifications objectAtIndex:item];
    
    if ([notiNum intValue] > 0) {
        
        label.hidden = NO;
        label.text = notiNum;
        label.layer.cornerRadius = 10.0;
        label.layer.borderWidth = 2.0;
        label.layer.borderColor = [UIColor colorWithRed:101.0/255.0 green:101.0/255.0 blue:101.0/255.0 alpha:1.0].CGColor;
        label.layer.shadowPath = [UIBezierPath bezierPathWithRect:label.bounds].CGPath;
        label.layer.masksToBounds = NO;
        label.layer.shadowOffset = CGSizeMake(5, 10);
        label.layer.shadowRadius = 10.0;
        label.layer.shadowOpacity = 0.5;
        label.clipsToBounds = YES;
    } else {
        label.hidden = YES;
    }
    return cvc;
}

//==============================================================================================================
-(IBAction) actionSchedule:(id)sender
{
    self.navigationController.navigationBar.hidden = NO;
    UIStoryboard *mystoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
    PWCiPhoneScheduleMainViewController* nextView = [mystoryboard instantiateViewControllerWithIdentifier:@"schedule_main_view"];
    [self.navigationController pushViewController: nextView animated: YES];
}

//==============================================================================================================
-(IBAction) actionOrders:(id)sender
{
    if ([[PWCGlobal getTheGlobal].userLevel isEqualToString:@"user"] || [[PWCGlobal getTheGlobal].userLevel isEqualToString:@"coach"])
    {
        self.navigationController.navigationBar.hidden = NO;
        UIStoryboard *mystoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
        PWCOrdersMainViewController* nextView = [mystoryboard instantiateViewControllerWithIdentifier:@"no_permission_view"];
        [self.navigationController pushViewController: nextView animated: YES];
    }
    else
    {
        SEL orderSel = @selector(doOrderProcess);
        [self performSelectorInBackground:orderSel withObject:self];
    }
}

//==============================================================================================================
-(void) actionGotoOrders
{
    self.navigationController.navigationBar.hidden = NO;
    UIStoryboard *mystoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
    PWCOrdersMainViewController* nextView = [mystoryboard instantiateViewControllerWithIdentifier:@"orders_main_view"];
    [self.navigationController pushViewController: nextView animated: YES];
}

//==============================================================================================================
-(IBAction) actionCRM:(id)sender
{
    self.navigationController.navigationBar.hidden = NO;
    UIStoryboard *mystoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
    id nextView = [mystoryboard instantiateViewControllerWithIdentifier:@"crm_main_view"];
    [self.navigationController pushViewController: nextView animated: YES];
}

//==============================================================================================================
-(IBAction) actionProjectMgr:(id)sender
{
    self.navigationController.navigationBar.hidden = NO;
    UIStoryboard *mystoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
    id nextView = [mystoryboard instantiateViewControllerWithIdentifier:@"project_manager_main_view"];
    [self.navigationController pushViewController: nextView animated: YES];
}

//==============================================================================================================
-(IBAction) actionProduct:(id)sender
{
    self.navigationController.navigationBar.hidden = NO;
    UIStoryboard *mystoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
    id nextView = [mystoryboard instantiateViewControllerWithIdentifier:@"product_main_view"];
    [self.navigationController pushViewController: nextView animated: YES];
}

//==============================================================================================================
-(IBAction) actionAffiliates:(id)sender
{
    self.navigationController.navigationBar.hidden = NO;
    UIStoryboard *mystoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
    if ([[PWCGlobal getTheGlobal].userLevel isEqualToString:@"coach"])
    {
        id nextView = [mystoryboard instantiateViewControllerWithIdentifier:@"no_permission_view"];
        [self.navigationController pushViewController: nextView animated: YES];
    }
    else
    {
        id nextView = [mystoryboard instantiateViewControllerWithIdentifier:@"affiliate_main_view"];
        [self.navigationController pushViewController: nextView animated: YES];
    }
}

//==============================================================================================================
-(IBAction) actionAccount:(id)sender
{
    self.navigationController.navigationBar.hidden = NO;
    UIStoryboard *mystoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
    id nextView = [mystoryboard instantiateViewControllerWithIdentifier:@"account_main_view"];
    [self.navigationController pushViewController: nextView animated: YES];
}

//==============================================================================================================
-(IBAction) actionNewOrder:(id)sender
{
    self.navigationController.navigationBar.hidden = NO;
    UIStoryboard *mystoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
    id nextView = [mystoryboard instantiateViewControllerWithIdentifier:@"new_order_main_view"];
    [self.navigationController pushViewController: nextView animated: YES];
}

#pragma -
#pragma Collection View actions
//==============================================================================================================
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = [indexPath row];
    NSDictionary *dict = [self.dashboardItems objectAtIndex:row];
    NSString *identifier = [dict objectForKey:@"segue"];
    
     if ([identifier isEqualToString:@"accountSegue"]) {
        [self performSegueWithIdentifier:identifier sender:self];
    } else if ([identifier isEqualToString:@"webSegue"]) {
        NSString *item = [dict objectForKey:@"name"];
        self.webTitle = item;
        
        //if ([item isEqualToString:@"New Order"]) {
        //    self.webUrl = [NSString stringWithFormat:@"http://www.secureinfossl.com/app/getAccess/%@/comingsoonnewoorder/%@",[PWCGlobal getTheGlobal].merchantId,[PWCGlobal getTheGlobal].hashKey];
        //} else
        
        if ([item isEqualToString:@"CRM"]) {
            self.webUrl = [NSString stringWithFormat:@"http://pwccrm.com/mobileapp.php?hashkey=%@&mid=%@", [PWCGlobal getTheGlobal].hashKey, [PWCGlobal getTheGlobal].merchantId];
        } else if ([item isEqualToString:@"Products"]) {
            self.webUrl = [NSString stringWithFormat:@"http://www.secureinfossl.com/app/getAccess/%@/product/%@",[PWCGlobal getTheGlobal].merchantId,[PWCGlobal getTheGlobal].hashKey];
        } else if ([item isEqualToString:@"Schedule"]) {
            self.webUrl = [NSString stringWithFormat:@"http://www.secureinfossl.com/app/getAccess/%@/comingsoonnewschedule/%@",[PWCGlobal getTheGlobal].merchantId,[PWCGlobal getTheGlobal].hashKey];
        }
        
        [self performSegueWithIdentifier:@"webSegue" sender:self];
    }
}

//==============================================================================================================
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"webSegue"]) {
        PWCWebViewController *web = segue.destinationViewController;
        
        web.webViewTitle = self.webTitle;
        web.webViewUrl = [NSURL URLWithString:self.webUrl];
    } else if ([segue.identifier isEqualToString:@"pushBookingSegue"]) {
        PWCiPhoneScheduleSummaryViewController *dest = segue.destinationViewController;
        
        NSDateFormatter *dFormatter = [[NSDateFormatter alloc] init];
        [dFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss ZZZ"];
        NSDate *dateValue = [dFormatter dateFromString:[PWCGlobal getTheGlobal].notificationParam];
        NSLog(@"Param: %@", [PWCGlobal getTheGlobal].notificationParam);
        NSLog(@"Date: %@", dateValue);
        dest.theDate = dateValue;
    }  
}

//==============================================================================================================
- (void)doOrderProcessForPush
{
    // Call API and Get Data
    NSURL *url = [NSURL URLWithString:@"https://secureinfossl.com"];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [httpClient setDefaultHeader:@"Accept" value:@"application/json"];
    
    NSString *path = [NSString stringWithFormat:@"/app/getAccess/%@/mobile7daysorder/%@", [PWCGlobal getTheGlobal].merchantId, [PWCGlobal getTheGlobal].hashKey];
    
    if (([PWCOrderList database].lasOrderRowId != nil) && ([[PWCOrderList database].lasOrderRowId length] > 0)) {
        path = [NSString stringWithFormat:@"%@/%@", path, [PWCOrderList database].lasOrderRowId];
    } else {
        [self deleteOrderData];
    }
    
    //NSLog(@"PATH: %@", path);
    
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET" path:path parameters:nil];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                                            //NSLog(@"Success");
                                                                                            //NSLog(@"DATA: %@", JSON);
                                                                                            //NSLog(@"Performing Operation inside block");
                                                                                            
                                                                                            int resultCode = [[JSON objectForKey:@"resultcode"] intValue];
                                                                                            
                                                                                            if (resultCode == 1) {
                                                                                                NSArray *sevenArray = [JSON objectForKey:@"OrderDetails"];
                                                                                                
                                                                                                [self saveData:sevenArray];
                                                                                            }
                                                                                            
                                                                                            //NSLog(@"%@",[PWCOrderList database].pwcOrderForPush);
                                                                                            
                                                                                            for (PWCOrders *o in [PWCOrderList database].pwcOrderForPush) {
                                                                                                [PWCGlobal getTheGlobal].pushOrderData = [[[SBJsonParser alloc] init] objectWithString:o.orderDetails];
                                                                                                [PWCGlobal getTheGlobal].pushOrderTotal = o.orderAmount;
                                                                                                //NSLog(@"ORDER ID: %@", o.orderId);
                                                                                            }
                                                                                            
                                                                                            //[PWCGlobal getTheGlobal].notificationParam = @"";
                                                                                            //[PWCGlobal getTheGlobal].notificationType = @"";
                                                                                            
                                                                                            [self performSegueWithIdentifier:@"pushOrderSegue" sender:self];
                                                                                        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                                            //NSLog(@"Failure");
                                                                                            //NSLog(@"Request: %@",JSON);
                                                                                            //[self performSegueWithIdentifier:@"ordersSegue" sender:self];
                                                                                        }];
    //[operation setShouldExecuteAsBackgroundTaskWithExpirationHandler:nil];
    [operation start];
    [operation waitUntilFinished];
}

//==============================================================================================================
- (void)doBookingSummaryPush
{
    [self performSegueWithIdentifier:@"pushBookingSegue" sender:self];
}

//==============================================================================================================
- (void)doOrderProcess
{
    // Call API and Get Data
    NSURL *url = [NSURL URLWithString:@"https://secureinfossl.com"];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [httpClient setDefaultHeader:@"Accept" value:@"application/json"];
    
    NSString *path = [NSString stringWithFormat:@"/app/getAccess/%@/mobile7daysorder/%@", [PWCGlobal getTheGlobal].merchantId, [PWCGlobal getTheGlobal].hashKey];
    
    if (([PWCOrderList database].lasOrderRowId != nil) && ([[PWCOrderList database].lasOrderRowId length] > 0)) {
        path = [NSString stringWithFormat:@"%@/%@", path, [PWCOrderList database].lasOrderRowId];
    } else {
        [self deleteOrderData];
    }
    
    //NSLog(@"PATH: %@", path);
    
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET" path:path parameters:nil];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                                            //NSLog(@"Success");
                                                                                            //NSLog(@"DATA: %@", JSON);
                                                                                            
                                                                                            int resultCode = [[JSON objectForKey:@"resultcode"] intValue];
                                                                                            
                                                                                            if (resultCode == 1) {
                                                                                                
                                                                                                //NSString *cs = [[[JSON objectForKey:@"Settings"] objectAtIndex:0] objectForKey:@"CurrencySymbol"];
                                                                                                
                                                                                                //[PWCGlobal getTheGlobal].currencySymbol = cs;
                                                                                                
                                                                                                //NSLog(@"%@",[PWCGlobal getTheGlobal].currencySymbol);
                                                                                                
                                                                                                NSArray *sevenArray = [JSON objectForKey:@"OrderDetails"];
                                                                                                
                                                                                                [self saveData:sevenArray];
                                                                                                [PWCGlobal getTheGlobal].ordersToday = [PWCOrderList database].pwcTodaysUnread;
                                                                                                [PWCGlobal getTheGlobal].orders7Days = [PWCOrderList database].pwc7DaysUnread;
                                                                                            }
                                                                                            
//                                                                                            [self performSegueWithIdentifier:@"ordersSegue" sender:self];
                                                                                            [self actionGotoOrders];
                                                                                        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                                            //NSLog(@"Failure");
                                                                                            //NSLog(@"Request: %@",JSON);
//                                                                                            [self performSegueWithIdentifier:@"ordersSegue" sender:self];
                                                                                            [self actionGotoOrders];
                                                                                        }];
    [operation start];
    [operation waitUntilFinished];

}

//==============================================================================================================
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

//==============================================================================================================
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

//==============================================================================================================
- (BOOL)deleteOrderData
{
    BOOL done = NO;
    sqlite3_stmt *statement;
    
    NSString *updateSQL = [NSString stringWithFormat: @"DELETE FROM order_table"];
    
    const char *update_stmt = [updateSQL UTF8String];
    
    sqlite3_prepare_v2(pwcDB, update_stmt, -1, &statement, NULL);
    if (sqlite3_step(statement) == SQLITE_DONE)
    {
        done = YES;
        //NSLog(@"Delete DONE");
    } else {
        done = NO;
    }
    sqlite3_finalize(statement);
    
    return done;
}

//==============================================================================================================
- (NSString *)escape:(NSObject *)value
{
    if (value == nil)
        return nil;
    NSString *escapedValue = nil;
    if ([value isKindOfClass:[NSString class]] || [value isKindOfClass:[NSMutableString class]]) {
        NSString *valueString = (NSString *) value;
        char *theEscapedValue = sqlite3_mprintf("'%q'", [valueString UTF8String]);
        escapedValue = [NSString stringWithUTF8String:(const char *)theEscapedValue];
        sqlite3_free(theEscapedValue);
    } else
        escapedValue = [NSString stringWithFormat:@"%@", value];
    return escapedValue;
}

//==============================================================================================================
- (void)loadNotifications
{
    NSURL *url = [NSURL URLWithString:@"https://secureinfossl.com"];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [httpClient setDefaultHeader:@"Accept" value:@"application/json"];
    
    NSString *path = [NSString stringWithFormat:@"/app/getAccess/%@/mobile7daysorderno/%@", [PWCGlobal getTheGlobal].merchantId, [PWCGlobal getTheGlobal].hashKey];
    
    if (([PWCOrderList database].lasOrderRowId != nil) && ([[PWCOrderList database].lasOrderRowId length] > 0)) {
        path = [NSString stringWithFormat:@"%@/%@", path, [PWCOrderList database].lasOrderRowId];
    }
    
    //NSLog(@"Notification PATH: %@", path);

    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET" path:path parameters:nil];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                                            //NSLog(@"Success Noti");
                                                                                            NSLog(@"DATA: %@", JSON);
                                                                                            
                                                                                            int resultCode = [[JSON objectForKey:@"result"] intValue];
                                                                                            
                                                                                            if (resultCode == 1) {
                                                                                                
                                                                                                int unread = [[PWCOrderList database].pwc7DaysUnread intValue] + [[JSON objectForKey:@"total7daysorders"] intValue];
                                                                                                
                                                                                                NSString *orderVal = [NSString stringWithFormat:@"%d", unread];
                                                                                                
                                                                                                [[PWCGlobal getTheGlobal].dashboardNotifications replaceObjectAtIndex:1 withObject:orderVal];
                                                                                                
                                                                                                [PWCGlobal getTheGlobal].currencySymbol = [JSON objectForKey:@"currencysymbol"];
                                                                                            }
//                                         [self.collectionView reloadData];
                                                                                        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                                            //NSLog(@"Failure Noti");
                                                                                            //NSLog(@"Request: %@",JSON);
                                                                                            
                                                                                        }];
    [operation start];
    //[operation waitUntilFinished];

}

//==============================================================================================================
- (IBAction)refreshButtonClicked:(id)sender
{
    [self loadNotifications];
}

//==============================================================================================================
- (void)sendDeviceTokenInBackground
{
    // SEND TO SERVER
    NSURL *url = [NSURL URLWithString:@"http://www.secureinfossl.com"];
    NSString *path = [NSString stringWithFormat:@"/scheduleapi/updatedevicetoken/%@/%@/%@", [PWCGlobal getTheGlobal].coachRowId, [PWCGlobal getTheGlobal].userHash, [PWCGlobal getTheGlobal].deviceToken];
   
/*} else {
        //MERCHANT
        path = [NSString stringWithFormat:@"%@/%@/%@/%@", path, [PWCGlobal getTheGlobal].merchantId, [PWCGlobal getTheGlobal].userHash, [PWCGlobal getTheGlobal].deviceToken];
    }*/
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [httpClient setDefaultHeader:@"Accept" value:@"application/json"];
    
    NSLog(@"Send DevToken PATH: %@", path);
    
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET" path:path parameters:nil];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                                            NSLog(@"Success Send DevToken");
                                                                                            
                                                                                        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                                            NSLog(@"Failure Send DevToken");
                                                                                            NSLog(@"Request: %@",JSON);
                                                                                            
                                                                                        }];
    [operation start];
    [operation waitUntilFinished];
}

//==============================================================================================================
@end
