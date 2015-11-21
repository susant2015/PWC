//
//  PWCiPhoneScheduleDateViewController.m
//  PWC
//
//  Created by Samiul Hoque on 5/20/13.
//  Copyright (c) 2013 Premium Web Cart. All rights reserved.
//

#import "PWCiPhoneScheduleDateViewController.h"
#import "PWCGlobal.h"
#import "AFNetworking.h"
#import "PWCiPhoneScheduleBookedCustomersViewController.h"
#import "PWCiPhoneScheduleBookViewController.h"
#import "PWCiPhoneScheduleEditViewController.h"
#import "PWCServices.h"
#import "PWCCustomers.h"


@interface PWCiPhoneScheduleDateViewController ()

@end

@implementation PWCiPhoneScheduleDateViewController

@synthesize theDate;
@synthesize bookingData;
@synthesize availableData;
@synthesize unavailableData;
@synthesize timeSlots;
@synthesize forCustomerList;
@synthesize bookingStartTime;
@synthesize togglingTime;

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

    //self.navigationController.toolbarHidden = YES;
    NSLog(@"Schedule Booking");
    self.bookingData = [[NSMutableArray alloc] init];
    self.availableData = [[NSMutableArray alloc] init];
    self.unavailableData = [[NSMutableArray alloc] init];
    
    self.timeSlots = [NSArray arrayWithObjects:@"0.00", @"0.30", @"1.00", @"1.30", @"2.00", @"2.30",
                      @"3.00", @"3.30", @"4.00", @"4.30", @"5.00", @"5.30",
                      @"6.00", @"6.30", @"7.00", @"7.30", @"8.00", @"8.30",
                      @"9.00", @"9.30", @"10.00", @"10.30", @"11.00", @"11.30",
                      @"12.00", @"12.30", @"13.00", @"13.30", @"14.00", @"14.30",
                      @"15.00", @"15.30", @"16.00", @"16.30", @"17.00", @"17.30",
                      @"18.00", @"18.30", @"19.00", @"19.30", @"20.00", @"20.30",
                      @"21.00", @"21.30", @"22.00", @"22.30", @"23.00", @"23.30", nil];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateStyle:NSDateFormatterMediumStyle];
    
    self.navigationItem.title = [df stringFromDate:self.theDate];
    
    [self monthData:self.theDate];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self monthData:self.theDate];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
/*
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath row] == 1) {
        cell.backgroundColor = [UIColor colorWithRed:230.0/255.0 green:135.0/255.0 blue:115.0/255.0 alpha:1.0];
    }
    //cell.backgroundColor = [UIColor redColor];
}
*/
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [self.timeSlots count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // scheduleBookingCell, scheduleUnavailableCell,
    // scheduleSingleBookingCell, scheduleManyBookingCell
    // scheduleSingleFullCell, scheduleManyFullCell
    
    NSString *CellIdentifier = @"scheduleBookingCell";
    NSInteger sec = indexPath.section;
    NSInteger row = indexPath.row;
    
    if ([self.unavailableData containsObject:[self.timeSlots objectAtIndex:sec]]) {
        // UNAVAILABLE
        CellIdentifier = @"scheduleUnavailableCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        return cell;
        
    } else if ([self.availableData containsObject:[self.timeSlots objectAtIndex:sec]]) {
        
        NSInteger bookIndex = [self.availableData indexOfObject:[self.timeSlots objectAtIndex:sec]];
        
        NSDictionary *dic = [self.bookingData objectAtIndex:bookIndex];
        NSArray *a = [dic objectForKey:@"details"];
        NSDictionary *d = [a objectAtIndex:row];
        
        if ([[d objectForKey:@"max_participants"] intValue] == 0 || [[d objectForKey:@"max_participants"] intValue] > 1) {
            // SERVICE IS MULTI BOOKING
            NSString *participants = [NSString stringWithFormat:@"(%d)", [a count]];
            
            if ([[d objectForKey:@"max_participants"] intValue] == 0 || [[d objectForKey:@"max_participants"] intValue] > [a count]) {
                // MULTI BOOKING
                CellIdentifier = @"scheduleManyBookingCell";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                
                UILabel *countLabel = (UILabel *)[cell viewWithTag:16002];
                UILabel *serviceName = (UILabel *)[cell viewWithTag:16003];
                countLabel.text = participants;
                serviceName.text = [d objectForKey:@"service_name"];
                
                return cell;
                
            } else {
                // MULTI FULL
                CellIdentifier = @"scheduleManyFullCell";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                
                UILabel *countLabel = (UILabel *)[cell viewWithTag:16005];
                UILabel *serviceName = (UILabel *)[cell viewWithTag:16006];
                countLabel.text = participants;
                serviceName.text = [d objectForKey:@"service_name"];
                
                return cell;
            }
        } else {
            // SERVICE IS SINGLE BOOKING
            if ([[d objectForKey:@"max_participants"] intValue] == 0 || [[d objectForKey:@"max_participants"] intValue] > [a count]) {
                // SINGLE BOOKING
                CellIdentifier = @"scheduleSingleBookingCell";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                
                UILabel *serviceName = (UILabel *)[cell viewWithTag:16001];
                serviceName.text = [d objectForKey:@"service_name"];
                
                return cell;
                
            } else {
                // SINGLE FULL
                CellIdentifier = @"scheduleSingleFullCell";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                
                UILabel *serviceName = (UILabel *)[cell viewWithTag:16004];
                serviceName.text = [d objectForKey:@"service_name"];
                
                return cell;
            }
        }
        
        /*
        if ([a count] > 1) {
            
            NSString *participants = [NSString stringWithFormat:@"(%d)", [a count]];
            
            if ([[d objectForKey:@"max_participants"] intValue] == 0 || [[d objectForKey:@"max_participants"] intValue] > [a count]) {
                // MULTI BOOKING
                CellIdentifier = @"scheduleManyBookingCell";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                
                UILabel *countLabel = (UILabel *)[cell viewWithTag:16002];
                UILabel *serviceName = (UILabel *)[cell viewWithTag:16003];
                countLabel.text = participants;
                serviceName.text = [d objectForKey:@"service_name"];
                
                return cell;
                
            } else {
                // MULTI FULL
                CellIdentifier = @"scheduleManyFullCell";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                
                UILabel *countLabel = (UILabel *)[cell viewWithTag:16005];
                UILabel *serviceName = (UILabel *)[cell viewWithTag:16006];
                countLabel.text = participants;
                serviceName.text = [d objectForKey:@"service_name"];
                
                return cell;
            }
        } else {
            if ([[d objectForKey:@"max_participants"] intValue] == 0 || [[d objectForKey:@"max_participants"] intValue] > [a count]) {
                // SINGLE BOOKING
                CellIdentifier = @"scheduleSingleBookingCell";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                
                UILabel *serviceName = (UILabel *)[cell viewWithTag:16001];
                serviceName.text = [d objectForKey:@"service_name"];
                
                return cell;
                
            } else {
                // SINGLE FULL
                CellIdentifier = @"scheduleSingleFullCell";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                
                UILabel *serviceName = (UILabel *)[cell viewWithTag:16004];
                serviceName.text = [d objectForKey:@"service_name"];
                
                return cell;
            }
        }
         */
    } else {
        // NORMAL
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        return cell;
        
    }
}
/*
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 36.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 56.0;
}
*/
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *ampm = @"AM";
    NSString *time = [self.timeSlots objectAtIndex:section];
    if (([time floatValue] - 12.00) >= 0) {
        ampm = @"PM";
        if (([time floatValue] - 12.00) >= 1) {
            time = [NSString stringWithFormat:@"%.2f", [time floatValue] - 12.00];
        }
    }
    return [NSString stringWithFormat:@"Time: %@ %@", [time stringByReplacingOccurrencesOfString:@"." withString:@":"], ampm];
}

- (void)monthData:(NSDate *)date
{
    [SVProgressHUD showWithStatus:@"Loading bookings ..." maskType:SVProgressHUDMaskTypeBlack];
    
    SEL calendarSel = @selector(getUnavailability);
    
    [self performSelectorInBackground:calendarSel withObject:self];
}

- (void)getUnavailability
{
    NSURL *url = [NSURL URLWithString:@"http://www.secureinfossl.com"];
    //NSString *path = @"";
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"dd"];
    NSString *showedDay = [df stringFromDate:self.theDate];
    [df setDateFormat:@"MM"];
    NSString *showedMonth = [df stringFromDate:self.theDate];
    [df setDateFormat:@"yyyy"];
    NSString *showedYear = [df stringFromDate:self.theDate];
    
    NSString *path  = [NSString stringWithFormat:@"/scheduleapi/getCoachUnAvailableTime/%@/%@/%@/%@", [PWCGlobal getTheGlobal].coachRowId, showedDay, showedMonth, showedYear];
    
    // Call API and Get Data
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [httpClient setDefaultHeader:@"Accept" value:@"application/json"];
    
    NSLog(@"UNAVAILABILITY PATH: %@", path);
    
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET" path:path parameters:nil];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                                            NSLog(@"Success");
                                                                                            //NSLog(@"DATA: %@", JSON);
                                                                                            
                                                                                            int resultCode = [[JSON objectForKey:@"result"] intValue];
                                                                                            
                                                                                            if (resultCode == 1) {
                                                                                                [self.unavailableData removeAllObjects];
                                                                                                
                                                                                                NSArray *data = [JSON objectForKey:@"availabletime"];
                                                                                                
                                                                                                for (NSDictionary *d in data) {
                                                                                                    [self.unavailableData addObject:[d objectForKey:@"time"]];
                                                                                                }
                                                                                                //[self.unavailableData addObject:@"15.00"];
                                                                                            }
                                                                                            
                                                                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                                                                SEL bookingSel = @selector(getBookingSummary);
                                                                                                [self performSelectorInBackground:bookingSel withObject:self];
                                                                                            });
                                                                                            
                                                                                        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                                            NSLog(@"Failure");
                                                                                            
                                                                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                                                                SEL bookingSel = @selector(getBookingSummary);
                                                                                                [self performSelectorInBackground:bookingSel withObject:self];
                                                                                            });
                                                                                        }];
    [operation start];
    [operation waitUntilFinished];
}

- (void)getBookingSummary
{
    NSURL *url = [NSURL URLWithString:@"http://www.secureinfossl.com"];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"dd"];
    NSString *showedDay = [df stringFromDate:self.theDate];
    [df setDateFormat:@"MM"];
    NSString *showedMonth = [df stringFromDate:self.theDate];
    [df setDateFormat:@"yyyy"];
    NSString *showedYear = [df stringFromDate:self.theDate];

    NSString *path = [NSString stringWithFormat:@"/scheduleapi/getBookingDetailsForADay/%@/%@/%@/%@", [PWCGlobal getTheGlobal].coachRowId, showedDay, showedMonth, showedYear];
    //}
    
    // Call API and Get Data
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [httpClient setDefaultHeader:@"Accept" value:@"application/json"];
    
    NSLog(@"BOOKING DATA PATH: %@", path);
    
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET" path:path parameters:nil];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                                            NSLog(@"Success");
                                                                                            NSLog(@"DATA: %@", JSON);
                                                                                            
                                                                                            int resultCode = [[JSON objectForKey:@"result"] intValue];
                                                                                            
                                                                                            if (resultCode == 1) {
                                                                                                [self.bookingData removeAllObjects];
                                                                                                [self.availableData removeAllObjects];
                                                                                                NSArray *data = [JSON objectForKey:@"bookingdates"];
                                                                                                for (NSDictionary *d in data) {
                                                                                                    [self.bookingData addObject:d];
                                                                                                    [self.availableData addObject:[d objectForKey:@"bookingtime"]];
                                                                                                }
                                                                                            }
                                                                                            
                                                                                            //NSLog(@"ARRAY: %@", self.bookingData);
                                                                                            
                                                                                            [SVProgressHUD showSuccessWithStatus:@"Bookings Loaded."];
                                                                                            
                                                                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                                                                [self.tableView reloadData];
                                                                                            });
                                                                                            
                                                                                            
                                                                                            
                                                                                        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                                            NSLog(@"Failure");
                                                                                            [SVProgressHUD dismissWithError:@"Calendar update failed. Try again later." afterDelay:1.0];
                                                                                            
                                                                                        }];
    [operation start];
    [operation waitUntilFinished];
}

- (void)toogleAvailability
{
    NSURL *url = [NSURL URLWithString:@"http://www.secureinfossl.com"];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"dd"];
    NSString *showedDay = [df stringFromDate:self.theDate];
    [df setDateFormat:@"MM"];
    NSString *showedMonth = [df stringFromDate:self.theDate];
    [df setDateFormat:@"yyyy"];
    NSString *showedYear = [df stringFromDate:self.theDate];

    NSString *path = [NSString stringWithFormat:@"/scheduleapi/setAvailUnavail/%@/%@/%@/%@/%@", [PWCGlobal getTheGlobal].coachRowId, self.togglingTime, showedDay, showedMonth, showedYear];
    //}
    
    // Call API and Get Data
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [httpClient setDefaultHeader:@"Accept" value:@"application/json"];
    
    NSLog(@"TOGGLING DATA PATH: %@", path);
    
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET" path:path parameters:nil];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                                            NSLog(@"Success");
                                                                                            //NSLog(@"DATA: %@", JSON);
                                                                                            
                                                                                            int resultCode = [[JSON objectForKey:@"result"] intValue];
                                                                                            
                                                                                            if (resultCode == 1) {
                                                                                                
                                                                                            }
                                                                                            
                                                                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                                                                SEL bookingSel = @selector(getUnavailability);
                                                                                                [self performSelectorInBackground:bookingSel withObject:self];
                                                                                            });
                                                                                            
                                                                                        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                                            NSLog(@"Failure");
                                                                                            
                                                                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                                                                SEL bookingSel = @selector(getUnavailability);
                                                                                                [self performSelectorInBackground:bookingSel withObject:self];
                                                                                            });
                                                                                        }];
    [operation start];
    [operation waitUntilFinished];
}

- (IBAction)makeTimeUnavailable:(id)sender {
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    NSInteger sec = indexPath.section;
    NSLog(@"%d",sec);
    self.togglingTime = [self.timeSlots objectAtIndex:sec];
    
    [SVProgressHUD showWithStatus:@"Loading ..." maskType:SVProgressHUDMaskTypeBlack];
    
    SEL calendarSel = @selector(toogleAvailability);
    
    [self performSelectorInBackground:calendarSel withObject:self];
}

- (IBAction)makeTimeAvailable:(id)sender {
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    NSInteger sec = indexPath.section;
    NSLog(@"%d",sec);
    self.togglingTime = [self.timeSlots objectAtIndex:sec];
    
    [SVProgressHUD showWithStatus:@"Loading ..." maskType:SVProgressHUDMaskTypeBlack];
    
    SEL calendarSel = @selector(toogleAvailability);
    
    [self performSelectorInBackground:calendarSel withObject:self];
}

- (IBAction)scheduleBooking:(id)sender {
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    NSInteger sec = indexPath.section;
    NSLog(@"%d",sec);
    self.bookingStartTime = [self.timeSlots objectAtIndex:sec];
    
    if ([[[PWCServices services] pwcServiceList] count] == 0) {
        [SVProgressHUD showErrorWithStatus:@"No services found. Add any service first to schedule."];
    } else if ([[[PWCCustomers customers] pwcCustomerList] count] == 0) {
        [SVProgressHUD showErrorWithStatus:@"No customer found. Add any customer first to schedule."];
    } else {
        [self performSegueWithIdentifier:@"bookingToScheduleSegue" sender:self];
    }
}

- (IBAction)showCustomerList:(id)sender {
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    NSInteger sec = indexPath.section;
    NSLog(@"%d",sec);
    NSInteger bookIndex = [self.availableData indexOfObject:[self.timeSlots objectAtIndex:sec]];
    
    NSDictionary *dic = [self.bookingData objectAtIndex:bookIndex];
    self.forCustomerList = [[NSArray alloc] init];
    self.forCustomerList = [dic objectForKey:@"details"];

    [self performSegueWithIdentifier:@"bookingToCustomerListSegue" sender:self];
}

- (IBAction)editBooking:(id)sender {
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    NSInteger sec = indexPath.section;
    NSLog(@"%d",sec);
    NSInteger bookIndex = [self.availableData indexOfObject:[self.timeSlots objectAtIndex:sec]];
    
    NSDictionary *dic = [self.bookingData objectAtIndex:bookIndex];
    self.forCustomerList = [[NSArray alloc] init];
    self.forCustomerList = [dic objectForKey:@"details"];
    self.bookingStartTime = [self.timeSlots objectAtIndex:sec];
    
    [self performSegueWithIdentifier:@"bookingToEditSegue" sender:self];
}

//----- SEGUE

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"bookingToCustomerListSegue"]) {
        PWCiPhoneScheduleBookedCustomersViewController *dest = segue.destinationViewController;
        dest.list = self.forCustomerList;
    } else if ([segue.identifier isEqualToString:@"bookingToScheduleSegue"]) {
        PWCiPhoneScheduleBookViewController *dest = segue.destinationViewController;
        dest.startTime = self.bookingStartTime;
        dest.unavailable = self.unavailableData;
        
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"dd"];
        NSString *showedDay = [df stringFromDate:self.theDate];
        [df setDateFormat:@"MM"];
        NSString *showedMonth = [df stringFromDate:self.theDate];
        [df setDateFormat:@"yyyy"];
        NSString *showedYear = [df stringFromDate:self.theDate];
        
        dest.theDate = [NSString stringWithFormat:@"%@/%@/%@", showedDay, showedMonth, showedYear];
    } else if ([segue.identifier isEqualToString:@"bookingToEditSegue"]) {
        PWCiPhoneScheduleEditViewController *dest = segue.destinationViewController;
        dest.list = self.forCustomerList;
        dest.startTime = self.bookingStartTime;
        dest.unavailable = self.unavailableData;
        
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"dd"];
        NSString *showedDay = [df stringFromDate:self.theDate];
        [df setDateFormat:@"MM"];
        NSString *showedMonth = [df stringFromDate:self.theDate];
        [df setDateFormat:@"yyyy"];
        NSString *showedYear = [df stringFromDate:self.theDate];
        
        dest.theDate = [NSString stringWithFormat:@"%@/%@/%@", showedDay, showedMonth, showedYear];
    }
}


@end
