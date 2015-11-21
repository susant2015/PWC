//
//  PWCOrdersViewController.m
//  PWC
//
//  Created by Samiul Hoque on 2/19/13.
//  Copyright (c) 2013 Premium Web Cart. All rights reserved.
//

#import "PWCOrdersViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "PWCGlobal.h"
#import "PWCOrderList.h"
#import "PWCOrders.h"
#import "PWCOrderDetailsViewController.h"
#import "SBJson.h"

@interface PWCOrdersViewController ()

@end

@implementation PWCOrdersViewController

@synthesize data;
@synthesize listTitle;
@synthesize total;
@synthesize currency;

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
        NSLog(@"Failed to open database!");
    } else {
        
    }
    
    //NSLog(@"%@",data);
    
    if ([listTitle isEqualToString:@"Today's"]) {
        self.navigationItem.title = @"Today's Orders";
        self.data = [PWCOrderList database].pwcOrdersTodays;
        
        
        //self.data = [PWCGlobal getTheGlobal].temp1Orders;
        int seven = [[PWCGlobal getTheGlobal].orders7Days intValue] - [[PWCGlobal getTheGlobal].ordersToday intValue];
        [PWCGlobal getTheGlobal].orders7Days = [NSString stringWithFormat:@"%d",seven];
        [PWCGlobal getTheGlobal].ordersToday = @"";
    } else {
        self.navigationItem.title = @"7 Days Order Details";
        self.data = [PWCOrderList database].pwcOrders7days;
        
        //self.data = [PWCGlobal getTheGlobal].temp7Orders;
        [PWCGlobal getTheGlobal].orders7Days = @"";
        [PWCGlobal getTheGlobal].ordersToday = @"";
    }
    
    self.total = 0.0;
    
    self.currency = [PWCGlobal getTheGlobal].currencySymbol;
    //self.currency = @"$";
    
    for (PWCOrders *ord in self.data) {
        if ([ord.orderStatus isEqualToString:@"accepted"]) {
            self.total += [[ord.orderAmount substringFromIndex:1] floatValue];
        }
    }
    
    /*
    for (NSDictionary *dic in self.data) {
        if ([[dic objectForKey:@"OrderStatus"] isEqualToString:@"accepted"]) {
            NSString *newStr = [[dic objectForKey:@"OrderAmount"] substringFromIndex:1];
            self.total += [newStr floatValue];
        }
    }
    */
    
    [self updateData:self.data];
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
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if ([listTitle isEqualToString:@"Today's"]) {
        return [NSString stringWithFormat:@"Today's Sales: %@ %.2f", self.currency, self.total];
    } else {
        return [NSString stringWithFormat:@"7 Day Sales: %@ %.2f", self.currency, self.total];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    //NSLog(@"Total: %d", [self.data count])
    NSInteger count = 0;
    if ([self.data count] > 0) {
        count = [self.data count];
    } else {
        count = 1;
    }
    
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.data count] > 0) {
        return 98.0;
    } else {
        return 200.0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.data count] > 0) {
        static NSString *CellIdentifier = @"orderCell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        //NSDictionary *d = [self.data objectAtIndex:indexPath.row];
        
        PWCOrders *d = [self.data objectAtIndex:indexPath.row];
        
        UIView *datetime = (UIView *)[cell viewWithTag:100];
        UILabel *date = (UILabel *)[cell viewWithTag:101];
        UILabel *time = (UILabel *)[cell viewWithTag:102];
        UILabel *product = (UILabel *)[cell viewWithTag:103];
        UILabel *customer = (UILabel *)[cell viewWithTag:104];
        UILabel *affiliate = (UILabel *)[cell viewWithTag:105];
        UILabel *price = (UILabel *)[cell viewWithTag:106];
        UIImageView *status = (UIImageView *)[cell viewWithTag:107];
        UIImageView *types = (UIImageView *)[cell viewWithTag:108];
        
        // Configure the cell...
        /*
        NSString *tempDate = [NSString stringWithFormat:@"%@ -05:00", d.orderDate];
        NSArray *tArr = [tempDate componentsSeparatedByString:@" "];
        NSString *tempD = [NSString stringWithFormat:@"%@ %@ %@", [tArr objectAtIndex:0], [tArr objectAtIndex:1], [[tArr objectAtIndex:2] stringByReplacingOccurrencesOfString:@":" withString:@""]];
         */
        
        NSArray *tArr = [d.orderDate componentsSeparatedByString:@" "];
        NSString *tempD = @"";
        if ([tArr count] > 2) {
            tempD = [NSString stringWithFormat:@"%@ %@ %@", [tArr objectAtIndex:0], [tArr objectAtIndex:1], [[tArr objectAtIndex:2] stringByReplacingOccurrencesOfString:@":" withString:@""]];
        } else {
            tempD = [NSString stringWithFormat:@"%@ %@ -0500", [tArr objectAtIndex:0], [tArr objectAtIndex:1]];
        }
        
        NSDateFormatter *dFormatter = [[NSDateFormatter alloc] init];
        [dFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss ZZZ"];
        NSDate *dateValue = [dFormatter dateFromString:tempD];
        
        //NSLog(@"%@ | %@ | %@ | %@",d.orderDate, tempD, dateValue, [dateValue descriptionWithLocale:[NSLocale systemLocale]]);
        
        [dFormatter setDateFormat:@"dd MMM yyyy"];
        date.text = [dFormatter stringFromDate:dateValue];
        [dFormatter setDateFormat:@"hh:mm a"];
        time.text = [dFormatter stringFromDate:dateValue];
        product.text = d.product;
        customer.text = d.customer;
        
        if ([d.affiliate length] > 0) {
            affiliate.text = [NSString stringWithFormat:@"Aff: %@", d.affiliate];
        } else {
            affiliate.text = d.affiliate;
        }
        
        price.text = [NSString stringWithFormat:@"%@", d.orderAmount];
        status.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",d.orderStatus]];
        types.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@Order.png",d.orderTypes]];
        
        /*
         NSDateFormatter *dFormatter = [[NSDateFormatter alloc] init];
         [dFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
         NSDate *dateValue = [dFormatter dateFromString:[d objectForKey:@"OrderDateTime"]];
         
         [dFormatter setDateFormat:@"dd MMM yyyy"];
         date.text = [dFormatter stringFromDate:dateValue];
         [dFormatter setDateFormat:@"hh:mm a"];
         time.text = [dFormatter stringFromDate:dateValue];
         product.text = [d objectForKey:@"ProductName"];
         customer.text = [d objectForKey:@"CustomerName"];
         affiliate.text = [d objectForKey:@"AffiliatesName"];
         price.text = [NSString stringWithFormat:@"%@", [d objectForKey:@"OrderAmount"]];
         status.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",[d objectForKey:@"OrderStatus"]]];
         //NSLog(@"%@",[d objectForKey:@"OrderStatus"]);
         */
        datetime.layer.cornerRadius = 5.0;
        datetime.layer.borderWidth = 1.5;
        datetime.layer.borderColor = [UIColor grayColor].CGColor;
        //datetime.layer.backgroundColor = [UIColor whiteColor].CGColor;
        datetime.layer.shadowPath = [UIBezierPath bezierPathWithRect:datetime.bounds].CGPath;
        datetime.layer.masksToBounds = NO;
        //datetime.layer.shadowOffset = CGSizeMake(5, 10);
        //datetime.layer.shadowRadius = 5.0;
        //datetime.layer.shadowOpacity = 0.5;
        datetime.clipsToBounds = YES;
        
        // NSLog(@"%@", d);
        
        return cell;
    } else {
        static NSString *CellIdentifier = @"noOrderCell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        return cell;
    }
}

- (void)updateData:(NSArray *)orders
{
    int ok = 0, notok = 0;
    
    for (PWCOrders *d in orders) {
        NSString *orderRowID = d.orderRowId;
        if ([self updateOrderData:orderRowID]) {
            ok++;
        } else {
            notok++;
        }
    }
    
    //NSLog(@"UPDATE OK: %d, UPDATE NOT OK: %d", ok, notok);
}

- (BOOL)updateOrderData:(NSString *)orderRowID
{
    BOOL done = NO;
    sqlite3_stmt *statement;
    
    NSString *updateSQL = [NSString stringWithFormat: @"UPDATE order_table SET OrderReadStatus = \"Read\" WHERE  OrderRowId = \"%@\"",orderRowID];
    
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    PWCOrderDetailsViewController *detail = segue.destinationViewController;
     
    NSIndexPath *path = [self.tableView indexPathForSelectedRow];
    NSInteger row = path.row;
        
    PWCOrders *ord = [self.data objectAtIndex:row];
    //NSLog(@"%@", ord.orderDetails);
    detail.jsonObj = [[[SBJsonParser alloc] init] objectWithString:ord.orderDetails];
    detail.grandTotal = ord.orderAmount;
    //NSLog(@"ORDER ID: %@", ord.orderId);
    //detail.detailsJson = @"HELLO";
}

@end
