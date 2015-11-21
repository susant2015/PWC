//
//  PWCiPhoneScheduleEditViewController.m
//  PWC
//
//  Created by Samiul Hoque on 7/30/13.
//  Copyright (c) 2013 Premium Web Cart. All rights reserved.
//

#import "PWCiPhoneScheduleEditViewController.h"
#import "PWCGlobal.h"
#import "AFNetworking.h"
#import "PWCiPhoneScheduleEditBookingViewController.h"

@interface PWCiPhoneScheduleEditViewController ()

@end

@implementation PWCiPhoneScheduleEditViewController

@synthesize list;
@synthesize options;
@synthesize theDate;
@synthesize selectedOption;
@synthesize startTime;
@synthesize unavailable;
@synthesize selectedRow;

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
    
    self.options = [[NSArray alloc] initWithObjects:@"Delete all bookings in this series",
                    @"Delete this booking and all following bookings", @"Delete only this booking and all other will remain", nil];
    
    NSLog(@"LIST: %@", self.list);
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.list count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"editBookingCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    NSInteger row = indexPath.row;
    NSDictionary *d = [self.list objectAtIndex:row];
    
    UILabel *name = (UILabel *)[cell viewWithTag:251];
    name.text = [NSString stringWithFormat:@"%@ %@", [d objectForKey:@"first_name"], [d objectForKey:@"last_name"]];
    
    return cell;
}


- (IBAction)deleteBooking:(id)sender {
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    self.selectedRow = indexPath.row;
    
    UIActionSheet *sheet = [[UIActionSheet alloc]
                            initWithTitle:@"What to delete?"
                            delegate:self
                            cancelButtonTitle:nil
                            destructiveButtonTitle:nil
                            otherButtonTitles:nil];
    
    for (NSString *item in self.options) {
        [sheet addButtonWithTitle:item];
    }
    
    [sheet addButtonWithTitle:@"Cancel"];
	// Set cancel button index to the one we just added so that we know which one it is in delegate call
	// NB - This also causes this button to be shown with a black background
	sheet.cancelButtonIndex = sheet.numberOfButtons - 1;
    
	[sheet showInView:[self.view superview]];
}

- (IBAction)editBooking:(id)sender {
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    self.selectedRow = indexPath.row;
    //NSLog(@"%d",sec);
    //NSInteger bookIndex = [self.availableData indexOfObject:[self.timeSlots objectAtIndex:sec]];
    
    [self performSegueWithIdentifier:@"editABookingSegue" sender:self];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == actionSheet.cancelButtonIndex) { return; }
    
    if (buttonIndex == 0) {
        self.selectedOption = @"0";
    } else if (buttonIndex == 1) {
        self.selectedOption = @"1";
    } else if (buttonIndex == 2) {
        self.selectedOption = @"2";
    }
    
    [SVProgressHUD showWithStatus:@"Updating ..." maskType:SVProgressHUDMaskTypeBlack];
    
    SEL backSel = @selector(doUpdateBooking);
    [self performSelectorInBackground:backSel withObject:self];
}

- (void)doUpdateBooking
{
    // Call API and Get Data
    NSURL *url = [NSURL URLWithString:@"http://www.secureinfossl.com"];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [httpClient setDefaultHeader:@"Accept" value:@"application/json"];
    
    NSString *path = [NSString stringWithFormat:@"/scheduleapi/deleteBooking/%@/%@/%@/%@",
                      [[self.list objectAtIndex:self.selectedRow] objectForKey:@"id"],
                      self.selectedOption,
                      [[self.list objectAtIndex:self.selectedRow] objectForKey:@"isRepeating"],
                      self.theDate];
    
    NSLog(@"PATH: %@", path);
    
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET" path:path parameters:nil];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                                            NSLog(@"Success");
                                                                                            //NSLog(@"DATA: %@", JSON);
                                                                                            
                                                                                            int resultCode = [[JSON objectForKey:@"result"] intValue];
                                                                                            
                                                                                            if (resultCode == 1) {
                                                                                                if ([[JSON objectForKey:@"errorcode"] length] > 1) {
                                                                                                    [SVProgressHUD dismissWithError:[JSON objectForKey:@"message"] afterDelay:1.5];
                                                                                                } else {
                                                                                                    [SVProgressHUD showSuccessWithStatus:@"Successfully deleted."];
                                                                                                    [self.navigationController popViewControllerAnimated:YES];
                                                                                                }
                                                                                            } else {
                                                                                                [SVProgressHUD dismissWithError:@"Cannot delete at this moment." afterDelay:1.5];
                                                                                            }
                                                                                            
                                                                                        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                                            NSLog(@"Failure");
                                                                                            //NSLog(@"Error: %@", error);
                                                                                            //NSLog(@"JSON: %@", JSON);
                                                                                            
                                                                                            [SVProgressHUD dismissWithError:@"Cannot delete at this moment." afterDelay:1.5];
                                                                                        }];
    [operation start];
    [operation waitUntilFinished];
}

#pragma mark SEGUE

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"editABookingSegue"]) {
        PWCiPhoneScheduleEditBookingViewController *dest = segue.destinationViewController;
        NSDictionary *d = [self.list objectAtIndex:self.selectedRow];
        dest.bookingId = [d objectForKey:@"id"];
        dest.coachRowId = [d objectForKey:@"coach_row_id"];
        dest.serviceId = [d objectForKey:@"service_row_id"];
        dest.customerId = [d objectForKey:@"customer_id"];
        dest.startTime = self.startTime;
        dest.unavailable = self.unavailable;
        dest.theDate = self.theDate;
        
        NSLog(@"Start Time: %@", self.startTime);
    }
}

@end
