//
//  PWCiPhoneScheduleAvailabilityDayViewController.m
//  PWC
//
//  Created by Samiul Hoque on 8/19/13.
//  Copyright (c) 2013 Premium Web Cart. All rights reserved.
//

#import "PWCiPhoneScheduleAvailabilityDayViewController.h"
#import "PWCGlobal.h"
#import "AFNetworking.h"

@interface PWCiPhoneScheduleAvailabilityDayViewController ()

@end

@implementation PWCiPhoneScheduleAvailabilityDayViewController

@synthesize dayName;
@synthesize daySerial;
@synthesize timeSlots;
@synthesize slotStatus;

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
    
    self.navigationItem.title = self.dayName;
    
    self.timeSlots = [NSArray arrayWithObjects:@"0.00", @"0.30", @"1.00", @"1.30", @"2.00", @"2.30",
                      @"3.00", @"3.30", @"4.00", @"4.30", @"5.00", @"5.30",
                      @"6.00", @"6.30", @"7.00", @"7.30", @"8.00", @"8.30",
                      @"9.00", @"9.30", @"10.00", @"10.30", @"11.00", @"11.30",
                      @"12.00", @"12.30", @"13.00", @"13.30", @"14.00", @"14.30",
                      @"15.00", @"15.30", @"16.00", @"16.30", @"17.00", @"17.30",
                      @"18.00", @"18.30", @"19.00", @"19.30", @"20.00", @"20.30",
                      @"21.00", @"21.30", @"22.00", @"22.30", @"23.00", @"23.30", nil];
    
    self.slotStatus = [[NSMutableArray alloc] init];
    for (int i = 0; i < [self.timeSlots count]; i++) {
        [self.slotStatus addObject:@"0"];
    }
    
    [self.saveButton setEnabled:NO];
    
    [self availabilityData];
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
    //NSLog(@"Sections: %d", [self.timeSlots count]);
    return [self.timeSlots count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    //NSLog(@"Rows: %d", 1);
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"rangeNotAvailableCell";
    //NSLog(@"Identifier: %@, Section: %d", CellIdentifier, [indexPath section]);
    
    if ([[self.slotStatus objectAtIndex:indexPath.section] isEqualToString:@"1"]) {
        CellIdentifier = @"rangeAvailableCell";
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    
    return cell;
}

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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    
}

- (IBAction)toggleAvailability:(id)sender {
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    NSInteger sec = indexPath.section;
    //NSLog(@"%d",sec);
    NSString *val = [self.slotStatus objectAtIndex:sec];
    
    if ([val isEqualToString:@"0"]) {
        val = @"1";
    } else {
        val = @"0";
    }
    
    [self.slotStatus replaceObjectAtIndex:sec withObject:val];
    
    [self.saveButton setEnabled:YES];
    
    [self.tableView reloadData];
}

- (IBAction)submitAvailabilityTime:(id)sender {
    [SVProgressHUD showWithStatus:@"Saving availability ..." maskType:SVProgressHUDMaskTypeBlack];
    
    SEL calendarSel = @selector(setAvailability);
    
    [self performSelectorInBackground:calendarSel withObject:self];
}

- (void)setAvailability
{
    NSURL *url = [NSURL URLWithString:@"https://www.secureinfossl.com"];
    NSString *path = [NSString stringWithFormat:@"/scheduleapi/setAvailabilityTime"];
    //}
    
    // Call API and Get Data
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [httpClient setDefaultHeader:@"Accept" value:@"application/json"];
    
    //NSLog(@"AVAILABILITY TIME PATH: %@", path);
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    
    // 1. Slots
    [param addEntriesFromDictionary:[NSDictionary dictionaryWithObject:[self.slotStatus componentsJoinedByString:@","] forKey:@"slotvalues"]];
    
    // 2. coach_row_id
    [param addEntriesFromDictionary:[NSDictionary dictionaryWithObject:[PWCGlobal getTheGlobal].coachRowId forKey:@"coach_row_id"]];
    
    // 3. dayname
    [param addEntriesFromDictionary:[NSDictionary dictionaryWithObject:[self.dayName lowercaseString] forKey:@"dayname"]];
    
    //NSLog(@"PARAM: %@", param);
    
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST" path:path parameters:param];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                                            NSLog(@"Success");
                                                                                            //NSLog(@"DATA: %@", JSON);
                                                                                            
                                                                                            int resultCode = [[JSON objectForKey:@"result"] intValue];
                                                                                            
                                                                                            if (resultCode == 1) {
                                                                                                [SVProgressHUD showSuccessWithStatus:@"Saved successfully."];
                                                                                                [self.navigationController popViewControllerAnimated:YES];
                                                                                            } else {
                                                                                                [SVProgressHUD dismissWithError:@"Cannot save right now. Try again later." afterDelay:1.0];
                                                                                            }
                                                                                            
                                                                                        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                                            NSLog(@"Failure");
                                                                                            [SVProgressHUD dismissWithError:@"There is an error in network connection. Try again later." afterDelay:1.0];
                                                                                        }];
    [operation start];
    [operation waitUntilFinished];
}

- (void)availabilityData
{
    [SVProgressHUD showWithStatus:@"Loading availability ..." maskType:SVProgressHUDMaskTypeBlack];
    
    SEL calendarSel = @selector(getAvailability);
    
    [self performSelectorInBackground:calendarSel withObject:self];
}

- (void)getAvailability
{
    NSURL *url = [NSURL URLWithString:@"https://www.secureinfossl.com"];
    NSString *path = [NSString stringWithFormat:@"/scheduleapi/getAvailabilityTime/%@/%@", [PWCGlobal getTheGlobal].coachRowId, [self.dayName lowercaseString]];
    //}
    
    // Call API and Get Data
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [httpClient setDefaultHeader:@"Accept" value:@"application/json"];
    
    //NSLog(@"AVAILABILITY TIME PATH: %@", path);
    
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET" path:path parameters:nil];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                                            NSLog(@"Success");
                                                                                            //NSLog(@"DATA: %@", JSON);
                                                                                            
                                                                                            int resultCode = [[JSON objectForKey:@"result"] intValue];
                                                                                            
                                                                                            if (resultCode == 1) {
                                                                                                NSArray *data = [JSON objectForKey:@"availabletime"];
                                                                                                
                                                                                                for (int i = 0; i < [data count]; i++) {
                                                                                                    NSDictionary *d = [data objectAtIndex:i];
                                                                                                    [self.slotStatus replaceObjectAtIndex:i withObject:[d objectForKey:@"val"]];
                                                                                                }
                                                                                            }
                                                                                            
                                                                                            [SVProgressHUD showSuccessWithStatus:@"List updated."];
                                                                                            
                                                                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                                                                [self.tableView reloadData];
                                                                                            });
                                                                                            
                                                                                        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                                            NSLog(@"Failure");
                                                                                            [SVProgressHUD dismissWithError:@"Update failed. Try again later." afterDelay:1.0];
                                                                                        }];
    [operation start];
    [operation waitUntilFinished];
}

@end
