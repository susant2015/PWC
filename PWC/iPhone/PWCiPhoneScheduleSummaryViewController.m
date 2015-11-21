//
//  PWCiPhoneScheduleSummaryViewController.m
//  PWC
//
//  Created by Samiul Hoque on 5/20/13.
//  Copyright (c) 2013 Premium Web Cart. All rights reserved.
//

#import "PWCiPhoneScheduleSummaryViewController.h"
#import "PWCGlobal.h"
#import "AFNetworking.h"

@interface PWCiPhoneScheduleSummaryViewController ()

@end

@implementation PWCiPhoneScheduleSummaryViewController

@synthesize theDate;
@synthesize bookingData;

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

    //self.navigationController.toolbarHidden = NO;
    NSLog(@"SUMMARY");
    self.bookingData = [[NSMutableArray alloc] init];
    
    [self monthData:self.theDate];
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
    NSInteger count = [self.bookingData count];
    if ([self.bookingData count] < 1) {
        count = 1;
    }
    return count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if ([self.bookingData count] < 1) {
        return 1;
    } else {
        NSDictionary *d = [self.bookingData objectAtIndex:section];
        NSArray *a = [d objectForKey:@"details"];
        return [a count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"summaryCell";
    if ([self.bookingData count] < 1) {
        CellIdentifier = @"noSummaryCell";
    }

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    //if (cell == nil) {
    //    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    //}
    
    if ([self.bookingData count] > 0) {
        NSInteger sec = indexPath.section;
        NSInteger row = indexPath.row;
        
        NSDictionary *dic = [self.bookingData objectAtIndex:sec];
        NSArray *a = [dic objectForKey:@"details"];
        NSDictionary *d = [a objectAtIndex:row];
        
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", [d objectForKey:@"first_name"], [d objectForKey:@"last_name"]];
        cell.detailTextLabel.text = [d objectForKey:@"service_name"];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([self.bookingData count] < 1) {
        return 0.0;
    } else {
        return 36.0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.bookingData count] < 1) {
        return 100.0;
    } else {
        return 56.0;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if ([self.bookingData count] < 1) {
        return @"";
    } else {
        NSString *ampm = @"AM";
        NSString *time = [[self.bookingData objectAtIndex:section] objectForKey:@"bookingtime"];
        if (([time floatValue] - 12.00) >= 0) {
            ampm = @"PM";
            if (([time floatValue] - 12.00) >= 1) {
                time = [NSString stringWithFormat:@"%.2f", [time floatValue] - 12.00];
            }
        }
        return [NSString stringWithFormat:@"Time: %@ %@", [time stringByReplacingOccurrencesOfString:@"." withString:@":"], ampm];
    }
}

- (void)monthData:(NSDate *)date
{
    [SVProgressHUD showWithStatus:@"Loading bookings ..." maskType:SVProgressHUDMaskTypeBlack];
    
    SEL calendarSel = @selector(getBookingSummary);
    
    [self performSelectorInBackground:calendarSel withObject:self];
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
    
    NSLog(@"PATH: %@", path);
    
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET" path:path parameters:nil];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                                            NSLog(@"Success");
                                                                                            //NSLog(@"DATA: %@", JSON);
                                                                                            
                                                                                            int resultCode = [[JSON objectForKey:@"result"] intValue];
                                                                                            
                                                                                            if (resultCode == 1) {
                                                                                                [self.bookingData removeAllObjects];
                                                                                                NSArray *data = [JSON objectForKey:@"bookingdates"];
                                                                                                for (NSDictionary *d in data) {
                                                                                                    [self.bookingData addObject:d];
                                                                                                }
                                                                                            }
                                                                                            
                                                                                            NSLog(@"ARRAY: %@", self.bookingData);
                                                                                            
                                                                                            [SVProgressHUD showSuccessWithStatus:@"Bookings Loaded."];
                                                                                            
                                                                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                                                                [self.tableView reloadData];
                                                                                            });
                                                                                            
                                                                                        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                                            NSLog(@"Failure");
                                                                                            NSLog(@"Error: %@", error);
                                                                                            [SVProgressHUD dismissWithError:@"Calendar update failed. Try again later." afterDelay:1.0];
                                                                                        }];
    [operation start];
    [operation waitUntilFinished];
}

@end
