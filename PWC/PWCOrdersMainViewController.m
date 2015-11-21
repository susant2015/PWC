//
//  PWCOrdersMainViewController.m
//  PWC
//
//  Created by Samiul Hoque on 2/20/13.
//  Copyright (c) 2013 Premium Web Cart. All rights reserved.
//

#import "PWCOrdersMainViewController.h"
#import "PWCOrdersViewController.h"
#import "PWCReportViewController.h"
#import "PWCOrderList.h"
#import "PWCOrders.h"
#import "PWCGlobal.h"
#import "PWCReportFormData.h"
#import "SBJson.h"
#import "PWCGraphViewController.h"
#import "PWCGraphData.h"
#import "PWCWebViewController.h"

@interface PWCOrdersMainViewController ()

@end

@implementation PWCOrdersMainViewController

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
    [SVProgressHUD dismiss];

}

- (void)viewDidAppear:(BOOL)animated
{
    self.todaysCell.detailTextLabel.text = [PWCGlobal getTheGlobal].ordersToday;
    self.sevenDaysCell.detailTextLabel.text = [PWCGlobal getTheGlobal].orders7Days;
    self.navigationController.toolbarHidden = YES;
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *path = [self.tableView indexPathForSelectedRow];
    NSInteger section = path.section;
    NSInteger row = path.row;
    
    //NSLog(@"PrepareForSegue - %d", section);
    if (section == 0) {
        if (row == 0) {
            PWCOrdersViewController *list = segue.destinationViewController;
            list.listTitle = @"Today's";
        } else {
            //PWCOrderReportViewController *report = segue.destinationViewController;
            //report.formTitle = @"Todays Sales Order Report";
            //PWCReportViewController *report = segue.destinationViewController;
            //report.reportDays = @"today";
            //[self gatherFormData];
            
            PWCGraphViewController *graph = segue.destinationViewController;
            graph.graphViewTitle = @"Today's Sales Report";
            [self gatherFormData:@"today"];
        }
        
    } else if (section == 1) {
        if (row == 0) {
            PWCOrdersViewController *list = segue.destinationViewController;
            list.listTitle = @"7 Days";
        } else {
            //PWCOrderReportViewController *report = segue.destinationViewController;
            //report.formTitle = @"7 Days Sales Order Report";
            //PWCReportViewController *report = segue.destinationViewController;
            //report.reportDays = @"7days";
            //[self gatherFormData];
            
            PWCGraphViewController *graph = segue.destinationViewController;
            graph.graphViewTitle = @"7 Days Sales Report";
            [self gatherFormData:@"7days"];
        }
    } else {
        PWCWebViewController *web = segue.destinationViewController;
        
        NSString *urlString = [NSString stringWithFormat:@"http://www.secureinfossl.com/app/getAccess/%@/order-types/%@", [PWCGlobal getTheGlobal].merchantId,[PWCGlobal getTheGlobal].hashKey];
        
        web.webViewTitle = @"All Orders";
        web.webViewUrl = [NSURL URLWithString:urlString];
    }
}

- (void)gatherFormData:(NSString *)days
{
    NSArray *temp = nil;
    
    if ([days isEqualToString:@"today"]) {
        temp = [PWCOrderList database].pwcOrdersTodays;
    } else {
        temp = [PWCOrderList database].pwcOrders7days;
    }
    
    float total = 0, product = 0, discount = 0, shipment = 0, tax = 0;
    
    if (temp != nil && [temp count] > 0) {
        for (PWCOrders *ord in temp) {
            total += [[ord.orderAmount substringFromIndex:1] floatValue];
            
            NSArray *jsonObj = [[[SBJsonParser alloc] init] objectWithString:ord.orderDetails];
            
            NSArray *products = [[jsonObj objectAtIndex:0] objectForKey:@"ProductsOrdered"];
            NSDictionary *invoice = [[[jsonObj objectAtIndex:0] objectForKey:@"InvoiceProperties"] objectAtIndex:0];
            
            for (NSDictionary *prd in products) {
                product += [[prd objectForKey:@"TOTPRICE"] floatValue];
            }
            
            if ([[invoice objectForKey:@"StateTax"] floatValue] > 0) {
                tax += [[invoice objectForKey:@"StateTax"] floatValue];
            }
            
            if ([[invoice objectForKey:@"CountryTax"] floatValue] > 0) {
                tax += [[invoice objectForKey:@"CountryTax"] floatValue];
            }
            
            if ([[invoice objectForKey:@"ShippingAmount"] floatValue] > 0) {
                shipment += [[invoice objectForKey:@"ShippingAmount"] floatValue];
            }
            
            if ([[invoice objectForKey:@"QuantityDiscount"] floatValue] > 0) {
                discount -= [[invoice objectForKey:@"QuantityDiscount"] floatValue];
            }
            
            if ([[invoice objectForKey:@"CouponDiscount"] floatValue] > 0) {
                discount -= [[invoice objectForKey:@"CouponDiscount"] floatValue];
            }
            
            if ([[invoice objectForKey:@"GiftCertificateAmount"] floatValue] > 0) {
                discount -= [[invoice objectForKey:@"GiftCertificateAmount"] floatValue];
            }
            
            if ([[invoice objectForKey:@"OrderDiscount"] floatValue] > 0) {
                discount -= [[invoice objectForKey:@"OrderDiscount"] floatValue];
            }
        }
    }
    
    [PWCGraphData getGraphData].totalVal = total;
    
    [PWCGraphData getGraphData].xValues = [NSArray arrayWithObjects:
                                           @"Products", @"Discounts", @"Shipping",
                                           @"Taxes", nil];
    [PWCGraphData getGraphData].yValues = [NSArray arrayWithObjects:
                                           [NSNumber numberWithFloat:product],
                                           [NSNumber numberWithFloat:discount],
                                           [NSNumber numberWithFloat:shipment],
                                           [NSNumber numberWithFloat:tax], nil];
    
}

- (IBAction)updateOrderData:(id)sender {
}
@end
