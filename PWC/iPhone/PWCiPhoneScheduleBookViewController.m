//
//  PWCiPhoneScheduleBookViewController.m
//  PWC
//
//  Created by Samiul Hoque on 7/26/13.
//  Copyright (c) 2013 Premium Web Cart. All rights reserved.
//

#import "PWCiPhoneScheduleBookViewController.h"
#import "PWCGlobal.h"
#import "PWCServices.h"
#import "PWCCustomers.h"
#import "AFNetworking.h"

@interface PWCiPhoneScheduleBookViewController ()

@end

@implementation PWCiPhoneScheduleBookViewController

@synthesize startTime;
@synthesize unavailable;
@synthesize allTimes;
@synthesize endTimes;
@synthesize repeatItems;
@synthesize selectedServiceId;
@synthesize selectedCustomerId;
@synthesize theDate;
@synthesize endTime;
@synthesize repeat;

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
    
    // INITIALIZING VARIABLES
    CGFloat height = [UIScreen mainScreen].currentMode.size.height;
    if (height == 1136) {
        self.screenHeight = height / 2;
    } else {
        self.screenHeight = 480;
    }
    
    self.allTimes = [NSArray arrayWithObjects:@"0.00", @"0.30", @"1.00", @"1.30", @"2.00", @"2.30",
                                    @"3.00", @"3.30", @"4.00", @"4.30", @"5.00", @"5.30",
                                    @"6.00", @"6.30", @"7.00", @"7.30", @"8.00", @"8.30",
                                    @"9.00", @"9.30", @"10.00", @"10.30", @"11.00", @"11.30",
                                    @"12.00", @"12.30", @"13.00", @"13.30", @"14.00", @"14.30",
                                    @"15.00", @"15.30", @"16.00", @"16.30", @"17.00", @"17.30",
                                    @"18.00", @"18.30", @"19.00", @"19.30", @"20.00", @"20.30",
                                    @"21.00", @"21.30", @"22.00", @"22.30", @"23.00", @"23.30", nil];
    self.endTimes = [[NSMutableArray alloc] init];
    [self initializeEndTimes];
    //self.repeatItems = [[NSArray alloc] initWithObjects:@"None", @"Daily", @"Weekly", nil];
    self.repeatItems = [[NSArray alloc] initWithObjects:@"Reassign", @"Reschedule", @"Reassign and Reschedule", @"Completed", @"Closed", nil];
    
    // INITIALIZING UI ELEMENTS
    self.startTimeLabel.text = [self formatTime:self.startTime];
    
    [self.selectRepeatBtn setTitle:[self.repeatItems objectAtIndex:0] forState:UIControlStateNormal];
    self.repeat = @"0";
    self.repeatEndsCell.hidden = YES;
    
    [self formatService:0];
    [self formatCustomer:0];
    
    [self.selectServiceBtn setTitle:@"Select Service" forState:UIControlStateNormal];
    self.selectedServiceId = @"";
    
    [self.selectCustomerBtn setTitle:@"Select Customer" forState:UIControlStateNormal];
    self.selectedCustomerId = @"";
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.tableView addGestureRecognizer:gestureRecognizer];
    
    // DATE PICKER
    self.yourDatePickerView = [[UIDatePicker alloc] init];
    self.yourDatePickerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    self.yourDatePickerView.datePickerMode = UIDatePickerModeDate;

}

- (void)hideKeyboard
{
    [self.repeatEndsAfterTextfield resignFirstResponder];
    [self hideView];
}

- (void)formatService:(NSInteger)number
{
    NSLog(@"Service Number = %d", number);
        NSDictionary *d = [[[PWCServices services] pwcServiceList] objectAtIndex:number];
        [self.selectServiceBtn setTitle:[d objectForKey:@"serviceName"] forState:UIControlStateNormal];
        self.selectedServiceId = [d objectForKey:@"serviceRowId"];
        
        if ([[d objectForKey:@"serviceType"] isEqualToString:@"2"]) {
            // Fixed
            NSString *end = [NSString stringWithFormat:@"%.2f", [self.startTime floatValue] + [[d objectForKey:@"minDuration"] floatValue]];
            NSArray *tArr = [end componentsSeparatedByString:@"."];
            //NSLog(@"tArr = %@", tArr);
            if ([[tArr objectAtIndex:1] isEqualToString:@"60"]) {
                end = [NSString stringWithFormat:@"%.2f", ([end floatValue] + 0.40)];
            }
            
            [self.endTimes removeAllObjects];
            [self.endTimes addObject:end];
            self.endTime = end;
            [self.selectEndTimeBtn setTitle:[self formatTime:[self.endTimes objectAtIndex:0]] forState:UIControlStateNormal];
            /*NSLog(@"Fixed");
            NSLog(@"End times: %@", self.endTimes);
            NSLog(@"End time: %@", self.endTime);
            NSLog(@"End Text: %@", self.selectEndTimeBtn.titleLabel.text);*/
        } else {
            // Variable
            [self initializeEndTimes];
            NSMutableArray *temp = [self.endTimes copy];
            [self.endTimes removeAllObjects];
            for (NSString *time in temp) {
                if ([time floatValue] >= [self.startTime floatValue] + [[d objectForKey:@"minDuration"] floatValue]) {
                    [self.endTimes addObject:time];
                }
            }
            self.endTime = [self.endTimes objectAtIndex:0];
            [self.selectEndTimeBtn setTitle:[self formatTime:[self.endTimes objectAtIndex:0]] forState:UIControlStateNormal];
            /*NSLog(@"Variable");
            NSLog(@"End times: %@", self.endTimes);
            NSLog(@"End time: %@", self.endTime);
            NSLog(@"End Text: %@", self.selectEndTimeBtn.titleLabel.text);*/
        }
}

- (void)formatCustomer:(NSInteger)number
{
    NSLog(@"Customer Number = %d", number);
        NSDictionary *d = [[[PWCCustomers customers] pwcCustomerList] objectAtIndex:number];
        [self.selectCustomerBtn setTitle:[NSString stringWithFormat:@"%@ %@", [d objectForKey:@"firstName"], [d objectForKey:@"lastName"]] forState:UIControlStateNormal];
        self.selectedCustomerId = [d objectForKey:@"customerId"];
}

- (void)initializeEndTimes
{
    [self.endTimes removeAllObjects];
    
    for (NSString *time in self.allTimes) {
        if ([self.unavailable containsObject:time]) {
            // do nothing
        } else {
            if ([time floatValue] > [self.startTime floatValue]) {
                [self.endTimes addObject:time];
            }
        }
    }
}

- (void)intializeRepeatEndsElements
{
    [self.repeatEndsNeverSwitch setOn:YES animated:YES];
    [self repeatEndsNeverSwitchValue:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)formatTime:(NSString *)any24hTimeWithDot
{
    NSString *ampm = @"AM";
    if (([any24hTimeWithDot floatValue] - 12.00) >= 0) {
        ampm = @"PM";
        if (([any24hTimeWithDot floatValue] - 12.00) >= 1) {
            any24hTimeWithDot = [NSString stringWithFormat:@"%.2f", [any24hTimeWithDot floatValue] - 12.00];
        }
    }
    
    return [NSString stringWithFormat:@"%@ %@", [any24hTimeWithDot stringByReplacingOccurrencesOfString:@"." withString:@":"], ampm];
}

// Dropdowns
- (IBAction)selectService:(id)sender {
    UIActionSheet *sheet = [[UIActionSheet alloc]
                            initWithTitle:@"Select Service"
                            delegate:self
                            cancelButtonTitle:nil
                            destructiveButtonTitle:nil
                            otherButtonTitles:nil];
    
    for (NSDictionary *item in [[PWCServices services] pwcServiceList]) {
        [sheet addButtonWithTitle:[item objectForKey:@"serviceName"]];
    }
    
    [sheet addButtonWithTitle:@"Cancel"];
	// Set cancel button index to the one we just added so that we know which one it is in delegate call
	// NB - This also causes this button to be shown with a black background
	sheet.cancelButtonIndex = sheet.numberOfButtons - 1;
    self.clickedButton = 191;
    
	[sheet showInView:[self.view superview]];
}

- (IBAction)selectCustomer:(id)sender {
    UIActionSheet *sheet = [[UIActionSheet alloc]
                            initWithTitle:@"Select Customer"
                            delegate:self
                            cancelButtonTitle:nil
                            destructiveButtonTitle:nil
                            otherButtonTitles:nil];
    
    for (NSDictionary *item in [[PWCCustomers customers] pwcCustomerList]) {
        [sheet addButtonWithTitle:[NSString stringWithFormat:@"%@ %@", [item objectForKey:@"firstName"], [item objectForKey:@"lastName"]]];
    }
    
    [sheet addButtonWithTitle:@"Cancel"];
	// Set cancel button index to the one we just added so that we know which one it is in delegate call
	// NB - This also causes this button to be shown with a black background
	sheet.cancelButtonIndex = sheet.numberOfButtons - 1;
    self.clickedButton = 192;
    
	[sheet showInView:[self.view superview]];
}

- (IBAction)selectEndTime:(id)sender {
    UIActionSheet *sheet = [[UIActionSheet alloc]
                            initWithTitle:@"Select End Time"
                            delegate:self
                            cancelButtonTitle:nil
                            destructiveButtonTitle:nil
                            otherButtonTitles:nil];
    
    for (NSString *item in self.endTimes) {
        [sheet addButtonWithTitle:[self formatTime:item]];
    }
    
    [sheet addButtonWithTitle:@"Cancel"];
	// Set cancel button index to the one we just added so that we know which one it is in delegate call
	// NB - This also causes this button to be shown with a black background
	sheet.cancelButtonIndex = sheet.numberOfButtons - 1;
    self.clickedButton = 193;
    
	[sheet showInView:[self.view superview]];
}

- (IBAction)selectRepeat:(id)sender {
    UIActionSheet *sheet = [[UIActionSheet alloc]
                            initWithTitle:@"Select End Time"
                            delegate:self
                            cancelButtonTitle:nil
                            destructiveButtonTitle:nil
                            otherButtonTitles:nil];
    
    for (NSString *item in self.repeatItems) {
        [sheet addButtonWithTitle:item];
    }
    
    [sheet addButtonWithTitle:@"Cancel"];
	// Set cancel button index to the one we just added so that we know which one it is in delegate call
	// NB - This also causes this button to be shown with a black background
	sheet.cancelButtonIndex = sheet.numberOfButtons - 1;
    self.clickedButton = 194;
    
	[sheet showInView:[self.view superview]]; 
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == actionSheet.cancelButtonIndex) { return; }
	
    UIButton *clickedButton = (UIButton *)[self.view viewWithTag:self.clickedButton];

    if (self.clickedButton == 191) {
        // SERVICE
        [self formatService:buttonIndex];
    } else if (self.clickedButton == 192) {
        // CUSTOMER
        [self formatCustomer:buttonIndex];
    } else if (self.clickedButton == 193) {
        // END TIME
        self.endTime = [self.endTimes objectAtIndex:buttonIndex];
        [self.selectEndTimeBtn setTitle:[self formatTime:[self.endTimes objectAtIndex:buttonIndex]] forState:UIControlStateNormal];
    } else {
        // Repeat - 194
        [clickedButton setTitle:[self.repeatItems objectAtIndex:buttonIndex] forState:UIControlStateNormal];
        self.repeat = [NSString stringWithFormat:@"%d", buttonIndex];
        if (buttonIndex > 0) {
            self.repeatEndsCell.hidden = NO;
            [self intializeRepeatEndsElements];
        } else {
            self.repeatEndsCell.hidden = YES;
        }
    }
}

// -----------------------------------------------------------------------------------------------
// Save BOOKING
- (IBAction)saveBooking:(id)sender {
    
    if ([self.selectedCustomerId length] > 0 && [self.selectedServiceId length] > 0) {
        [SVProgressHUD showWithStatus:@"Saving ..." maskType:SVProgressHUDMaskTypeBlack];
        
        SEL backSel = @selector(doSavingBooking);
        [self performSelectorInBackground:backSel withObject:self];
    } else if ([self.selectedServiceId length] == 0) {
        [SVProgressHUD showErrorWithStatus:@"You have to select a service."];
    } else if ([self.selectedCustomerId length] == 0) {
        [SVProgressHUD showErrorWithStatus:@"You have to select a customer."];
    }
}

- (void)doSavingBooking
{
    // Call API and Get Data
    NSURL *url = [NSURL URLWithString:@"http://www.secureinfossl.com"];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [httpClient setDefaultHeader:@"Accept" value:@"application/json"];
    
    NSString *path = [NSString stringWithFormat:@"/scheduleapi/setABooking/%@/%@/%@/%@/%@/%@/%@",
                      [PWCGlobal getTheGlobal].coachRowId,
                      self.selectedServiceId,
                      self.selectedCustomerId,
                      self.theDate,
                      self.startTime,
                      self.endTime,
                      self.repeat];
    
    if ([self.repeat intValue] == 1) {
        NSString *t = @"1";
        if ([self.repeatEndsAfterTextfield.text length] > 0) {
            t = self.repeatEndsAfterTextfield.text;
        }
        path = [NSString stringWithFormat:@"%@/1/%@", path, t];
    } else if ([self.repeat intValue] == 2) {
        NSString *t = @"";
        if ([self.repeatEndsAfterTextfield.text length] > 0) {
            t = self.repeatEndsAfterTextfield.text;
        } else {
            NSDate *d = [NSDate date];
            NSDateFormatter *df = [[NSDateFormatter alloc] init];
            df.dateStyle = NSDateFormatterMediumStyle;
            
            NSCalendar *calendar = [NSCalendar currentCalendar];
            int year = [[calendar components:NSYearCalendarUnit fromDate:d] year];
            int month = [[calendar components:NSMonthCalendarUnit fromDate:d] month];
            int day = [[calendar components:NSDayCalendarUnit fromDate:d] day];
            
            t = [NSString stringWithFormat:@"%d-%d-%d",month, day, year];
        }
        path = [NSString stringWithFormat:@"%@/2/%@", path, t];
    }
    
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
                                                                                                    [SVProgressHUD showSuccessWithStatus:@"Successfully booked."];
                                                                                                    [self.navigationController popViewControllerAnimated:YES];
                                                                                                }
                                                                                            } else {
                                                                                                [SVProgressHUD dismissWithError:@"Can't book at this moment." afterDelay:1.5];
                                                                                            }
                                                                                            
                                                                                        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                                            NSLog(@"Failure");
                                                                                            //NSLog(@"Error: %@", error);
                                                                                            //NSLog(@"JSON: %@", JSON);
                                                                                            
                                                                                            [SVProgressHUD dismissWithError:@"Can't book at this moment." afterDelay:1.5];
                                                                                        }];
    [operation start];
    [operation waitUntilFinished];
}

// -----------------------------------------------------------------------------------------------

// Repeat Ends Never
- (IBAction)repeatEndsNeverSwitchValue:(id)sender {
    if (self.repeatEndsNeverSwitch.isOn) {
        [self.repeatEndsOnSwitch setOn:NO animated:YES];
        [self changeTextFieldState:self.repeatEndsAfterTextfield enable:NO];
        self.repeatEndsAfterTextfield.text = @"";
        
        [self.repeatEndsAfterSwitch setOn:NO animated:YES];
        [self changeTextFieldState:self.repeatEndsOnTextField enable:NO];
        self.repeatEndsOnTextField.text = @"";
    } else {
        [self.repeatEndsOnSwitch setOn:NO animated:YES];
        [self changeTextFieldState:self.repeatEndsOnTextField enable:NO];
        self.repeatEndsOnTextField.text = @"";
        
        [self.repeatEndsAfterSwitch setOn:YES animated:YES];
        [self changeTextFieldState:self.repeatEndsAfterTextfield enable:YES];
        self.repeatEndsAfterTextfield.text = @"";
    }
}

// Repeat Ends After ... Occurrences
- (IBAction)repeatEndsAfterSwitchValue:(id)sender {
    if (self.repeatEndsAfterSwitch.isOn) {
        [self.repeatEndsNeverSwitch setOn:NO animated:YES];
        [self.repeatEndsOnSwitch setOn:NO animated:YES];
        
        [self changeTextFieldState:self.repeatEndsAfterTextfield enable:YES];
        self.repeatEndsAfterTextfield.text = @"";
        [self changeTextFieldState:self.repeatEndsOnTextField enable:NO];
        self.repeatEndsOnTextField.text = @"";
    } else {
        [self.repeatEndsNeverSwitch setOn:YES animated:YES];
        [self.repeatEndsOnSwitch setOn:NO animated:YES];
        [self changeTextFieldState:self.repeatEndsAfterTextfield enable:NO];
        self.repeatEndsAfterTextfield.text = @"";
        [self changeTextFieldState:self.repeatEndsOnTextField enable:NO];
        self.repeatEndsOnTextField.text = @"";
    }
}

// Repeat Ends On .........
- (IBAction)repeatEndsOnSwitchValue:(id)sender {
    if (self.repeatEndsOnSwitch.isOn) {
        [self.repeatEndsNeverSwitch setOn:NO animated:YES];
        [self.repeatEndsAfterSwitch setOn:NO animated:YES];
        
        [self changeTextFieldState:self.repeatEndsOnTextField enable:YES];
        self.repeatEndsOnTextField.text = @"";
        [self changeTextFieldState:self.repeatEndsAfterTextfield enable:NO];
        self.repeatEndsAfterTextfield.text = @"";
    } else {
        [self.repeatEndsNeverSwitch setOn:YES animated:YES];
        [self.repeatEndsAfterSwitch setOn:NO animated:YES];
        [self changeTextFieldState:self.repeatEndsAfterTextfield enable:NO];
        self.repeatEndsAfterTextfield.text = @"";
        [self changeTextFieldState:self.repeatEndsOnTextField enable:NO];
        self.repeatEndsOnTextField.text = @"";
    }
}

- (IBAction)repeatEndsOnBeginEditing:(id)sender {
    [self.repeatEndsOnTextField resignFirstResponder];
    [self showView];
}

- (void)changeTextFieldState:(UITextField *)textField enable:(BOOL)yesNo
{
    if (yesNo) {
        textField.backgroundColor = [UIColor whiteColor];
        textField.textColor = [UIColor blackColor];
        textField.enabled = YES;
    } else {
        textField.backgroundColor = [UIColor darkGrayColor];
        textField.textColor = [UIColor lightTextColor];
        textField.enabled = NO;
    }
}

- (void) showView
{
    [self.view addSubview:self.yourDatePickerView];
    self.yourDatePickerView.frame = CGRectMake(0, self.screenHeight+self.yourDatePickerView.frame.size.height, 320, 0);
    [UIView animateWithDuration:1.0
                     animations:^{
                         self.yourDatePickerView.frame = CGRectMake(0, self.screenHeight-self.yourDatePickerView.frame.size.height, 320, self.yourDatePickerView.frame.size.height+10);
                     }];
}

- (void) hideView
{
    [UIView animateWithDuration:0.5
                     animations:^{
                         self.yourDatePickerView.frame = CGRectMake(0, self.screenHeight+250, 320, 0);
                     } completion:^(BOOL finished) {
                         [self.yourDatePickerView removeFromSuperview];
                         NSDateFormatter *df = [[NSDateFormatter alloc] init];
                         df.dateStyle = NSDateFormatterMediumStyle;
                         
                         NSCalendar *calendar = [NSCalendar currentCalendar];
                         int year = [[calendar components:NSYearCalendarUnit fromDate:[self.yourDatePickerView date]] year];
                         int month = [[calendar components:NSMonthCalendarUnit fromDate:[self.yourDatePickerView date]] month];
                         int day = [[calendar components:NSDayCalendarUnit fromDate:[self.yourDatePickerView date]] day];
                         
                         NSString *date = [NSString stringWithFormat:@"%d-%d-%d",month, day, year];
                         self.repeatEndsOnTextField.text = date;
                     }];
}

@end
