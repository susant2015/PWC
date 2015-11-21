//
//  PWCiPhoneScheduleBookingsViewController.m
//  BackUpFiles
//
//  Created by Samiul Hoque on 6/13/13.
//  Copyright (c) 2013 Premium Web Cart. All rights reserved.
//

#import "PWCiPhoneScheduleBookingsViewController.h"
#import "NSDate+Reporting.h"
#import "PWCGlobal.h"
#import "AFNetworking.h"
#import "PWCiPhoneScheduleSummaryViewController.h"
#import "PWCiPhoneScheduleDateViewController.h"

@interface PWCiPhoneScheduleBookingsViewController ()

@end

@implementation PWCiPhoneScheduleBookingsViewController

@synthesize calendar = _calendar;
@synthesize showedDate;
@synthesize showedMonth;
@synthesize showedYear;
@synthesize bookingData;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.bookingData = [[NSMutableArray alloc] init];
    
    _calendar = [[TKCalendarMonthView alloc] init];
    _calendar.delegate = self;
    _calendar.dataSource = self;
    _calendar.frame = CGRectMake(0, 60, _calendar.frame.size.width, _calendar.frame.size.height);
    
    [self.view addSubview:_calendar];
    
    NSDate *d = [NSDate date];
    
    [self monthData:d];
    
    [self setCurrentDate:d];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setCurrentDate:(NSDate *)d
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateStyle:NSDateFormatterFullStyle];
    
    self.selectedDate.text = [df stringFromDate:d];
    self.showedDate = d;
}

#pragma mark -
#pragma mark TKCalendarMonthViewDelegate methods

- (void)calendarMonthView:(TKCalendarMonthView *)monthView didSelectDate:(NSDate *)d {
	//NSLog(@"calendarMonthView didSelectDate");
    [self setCurrentDate:d];
}

- (void)calendarMonthView:(TKCalendarMonthView *)monthView monthDidChange:(NSDate *)d animated:(BOOL)animated {
	NSLog(@"MONTH: %@", d);
    [self monthData:d];
}

#pragma mark -
#pragma mark TKCalendarMonthViewDataSource methods

- (NSArray*)calendarMonthView:(TKCalendarMonthView *)monthView marksFromDate:(NSDate *)startDate toDate:(NSDate *)lastDate {
	NSLog(@"calendarMonthView marksFromDate toDate");
	//NSLog(@"Make sure to update 'data' variable to pull from CoreData, website, User Defaults, or some other source.");
	// When testing initially you will have to update the dates in this array so they are visible at the
	// time frame you are testing the code.
	NSArray *data = self.bookingData;
    //NSLog(@"MONTH DATA: %@", data);
    
	// Initialise empty marks array, this will be populated with TRUE/FALSE in order for each day a marker should be placed on.
	NSMutableArray *marks = [NSMutableArray array];
	
	// Initialise calendar to current type and set the timezone to never have daylight saving
	NSCalendar *cal = [NSCalendar currentCalendar];
	[cal setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
	
	// Construct DateComponents based on startDate so the iterating date can be created.
	// Its massively important to do this assigning via the NSCalendar and NSDateComponents because of daylight saving has been removed
	// with the timezone that was set above. If you just used "startDate" directly (ie, NSDate *date = startDate;) as the first
	// iterating date then times would go up and down based on daylight savings.
	NSDateComponents *comp = [cal components:(NSMonthCalendarUnit | NSMinuteCalendarUnit | NSYearCalendarUnit |
                                              NSDayCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit | NSSecondCalendarUnit)
                                    fromDate:startDate];
	//NSDateComponents *comp = [cal components:(NSMonthCalendarUnit | NSMinuteCalendarUnit | NSYearCalendarUnit | NSDayCalendarUnit)
    //                                fromDate:startDate];
	NSDate *d = [cal dateFromComponents:comp];
	
	// Init offset components to increment days in the loop by one each time
	NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
	[offsetComponents setDay:1];
	
    
	// for each date between start date and end date check if they exist in the data array
	while (YES) {
		// Is the date beyond the last date? If so, exit the loop.
		// NSOrderedDescending = the left value is greater than the right
        
        //NSLog(@"%@", [d description]);
        
		if ([d compare:lastDate] == NSOrderedDescending) {
			break;
		}
		
		// If the date is in the data array, add it to the marks array, else don't
        NSDateFormatter *dFormatter = [[NSDateFormatter alloc] init];
        [dFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *theDate = [dFormatter stringFromDate:d];
        
		if ([data containsObject:theDate]) {
			[marks addObject:[NSNumber numberWithBool:YES]];
		} else {
			[marks addObject:[NSNumber numberWithBool:NO]];
		}
		
		// Increment day using offset components (ie, 1 day in this instance)
		d = [cal dateByAddingComponents:offsetComponents toDate:d options:0];
	}
    //NSLog(@"MARKS: %@", marks);
	
	//[offsetComponents release];
	
	return [NSArray arrayWithArray:marks];
}

- (IBAction)gotoTodaysDate:(id)sender {
    NSDate *date = [NSDate date];
    [_calendar selectDate:date];
}

- (void)monthData:(NSDate *)date
{
    [SVProgressHUD showWithStatus:@"Updating Calendar ..." maskType:SVProgressHUDMaskTypeBlack];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"MM"];
    self.showedMonth = [df stringFromDate:date];
    [df setDateFormat:@"yyyy"];
    self.showedYear = [df stringFromDate:date];
    
    SEL calendarSel = @selector(getMonthData);
    
    [self performSelectorInBackground:calendarSel withObject:self];
}

- (void)getMonthData
{
    NSURL *url = [NSURL URLWithString:@"http://www.secureinfossl.com"];
    NSString *path = [NSString stringWithFormat:@"/scheduleapi/getBookingDateForMonth/%@/%@/%@", [PWCGlobal getTheGlobal].coachRowId, self.showedMonth, self.showedYear];
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
                                                                                                    NSDateFormatter *dFormatter = [[NSDateFormatter alloc] init];
                                                                                                    [dFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss ZZZ"];
                                                                                                    NSDate *dateValue = [dFormatter dateFromString:[d objectForKey:@"bookingdate"]];
                                                                                                    [dFormatter setDateFormat:@"yyyy-MM-dd"];
                                                                                                    
                                                                                                    [self.bookingData addObject:[dFormatter stringFromDate:dateValue]];
                                                                                                }
                                                                                            }
                                                                                            
                                                                                            [SVProgressHUD showSuccessWithStatus:@"Calendar Updated."];
                                                                                            
                                                                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                                                                [_calendar reloadData];
                                                                                            });
                                                                                            
                                                                                        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                                            NSLog(@"Failure");
                                                                                            
                                                                                            [SVProgressHUD dismissWithError:@"Calendar update failed. Try again later." afterDelay:1.0];
                                                                                        }];
    [operation start];
    [operation waitUntilFinished];
}

#pragma mark -
#pragma mark SEGUE

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"bookingSummarySegue"]) {
        PWCiPhoneScheduleSummaryViewController *dest = segue.destinationViewController;
        //NSLog(@"Date Selected: %@", self.showedDate);
        dest.theDate = self.showedDate;
    } else if ([segue.identifier isEqualToString:@"scheduleBookingSegue"]) {
        PWCiPhoneScheduleDateViewController *dest = segue.destinationViewController;
        //NSLog(@"Date Selected: %@", self.showedDate);
        dest.theDate = self.showedDate;
    }
}

@end
