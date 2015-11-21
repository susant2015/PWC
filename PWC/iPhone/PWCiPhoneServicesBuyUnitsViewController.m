//
//  PWCiPhoneServicesBuyUnitsViewController.m
//  PWC
//
//  Created by Samiul Hoque on 7/24/13.
//  Copyright (c) 2013 Premium Web Cart. All rights reserved.
//

#import "PWCiPhoneServicesBuyUnitsViewController.h"
#import "PWCiPhoneScheduleCheckoutViewController.h"

@interface PWCiPhoneServicesBuyUnitsViewController ()

@end

@implementation PWCiPhoneServicesBuyUnitsViewController

@synthesize customerInfo;

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
    
    //NSLog(@"%@", self.customerInfo);
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.tableView addGestureRecognizer:gestureRecognizer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self hideKeyboard];
}

- (void)hideKeyboard
{
    [self.quantity resignFirstResponder];
    [self updateCalculation];
}

- (void)updateCalculation
{
    float total = [self.quantity.text floatValue] * 10.00;
    self.totalAmount.text = [NSString stringWithFormat:@"%.2f", total];
}

- (IBAction)toCheckout:(id)sender {
    [self updateCalculation];
    
    if ([self.totalAmount.text floatValue] > 0.00) {
        [self performSegueWithIdentifier:@"unitsToCheckout" sender:sender];
    } else {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Quantity"
                                                     message:@"Quantity must be 1 or more"
                                                    delegate:self
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles:nil];
        [av show];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    PWCiPhoneScheduleCheckoutViewController *dest = segue.destinationViewController;
    
    dest.custInfo = self.customerInfo;
    
    NSDictionary *d = [NSDictionary dictionaryWithObjectsAndKeys:@"Unit Product", @"productName", @"10.00", @"unitPrice", @"100", @"productId",
                       self.quantity.text, @"quantity", self.totalAmount.text, @"totalAmount", nil];
    dest.prodInfo = d;
}

@end
