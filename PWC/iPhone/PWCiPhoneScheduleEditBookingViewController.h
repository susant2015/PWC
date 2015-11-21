//
//  PWCiPhoneScheduleEditBookingViewController.h
//  PWC
//
//  Created by Samiul Hoque on 7/26/13.
//  Copyright (c) 2013 Premium Web Cart. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PWCiPhoneScheduleEditBookingViewController : UITableViewController <UIActionSheetDelegate>

@property (strong, nonatomic) NSString *bookingId;
@property (strong, nonatomic) NSString *coachRowId;
@property (strong, nonatomic) NSString *serviceId;
@property (strong, nonatomic) NSString *customerId;



@property (assign, nonatomic) NSInteger clickedButton;
@property (assign, nonatomic) CGFloat screenHeight;

@property (strong, nonatomic) UIDatePicker *yourDatePickerView;

@property (strong, nonatomic) NSString *startTime;
@property (strong, nonatomic) NSArray *unavailable;
@property (strong, nonatomic) NSArray *allTimes;
@property (strong, nonatomic) NSMutableArray *startTimes;
@property (strong, nonatomic) NSMutableArray *endTimes;
@property (strong, nonatomic) NSArray *repeatItems;

@property (strong, nonatomic) IBOutlet UIButton *selectServiceBtn;
@property (strong, nonatomic) IBOutlet UIButton *selectCustomerBtn;
@property (strong, nonatomic) IBOutlet UIButton *selectStartTimeBtn;
@property (strong, nonatomic) IBOutlet UIButton *selectEndTimeBtn;
@property (strong, nonatomic) IBOutlet UIButton *selectRepeatBtn;

// Values to send in API call
@property (strong, nonatomic) NSString *selectedServiceId;
@property (strong, nonatomic) NSString *selectedCustomerId;
@property (strong, nonatomic) NSString *theDate; // Format: dd/mm/yyyy
@property (strong, nonatomic) NSString *endTime;
@property (strong, nonatomic) NSString *repeat;

// Dropdowns
- (IBAction)selectService:(id)sender;
- (IBAction)selectCustomer:(id)sender;
- (IBAction)selectStartTime:(id)sender;
- (IBAction)selectEndTime:(id)sender;
- (IBAction)selectRepeat:(id)sender;
@property (strong, nonatomic) IBOutlet UITableViewCell *repeatEndsCell;

// Save BOOKING
- (IBAction)saveBooking:(id)sender;

// Repeat Ends Never
@property (strong, nonatomic) IBOutlet UISwitch *repeatEndsNeverSwitch;
- (IBAction)repeatEndsNeverSwitchValue:(id)sender;

// Repeat Ends After ... Occurrences
@property (strong, nonatomic) IBOutlet UISwitch *repeatEndsAfterSwitch;
@property (strong, nonatomic) IBOutlet UITextField *repeatEndsAfterTextfield;
- (IBAction)repeatEndsAfterSwitchValue:(id)sender;

// Repeat Ends On .........
@property (strong, nonatomic) IBOutlet UISwitch *repeatEndsOnSwitch;
@property (strong, nonatomic) IBOutlet UITextField *repeatEndsOnTextField;
- (IBAction)repeatEndsOnSwitchValue:(id)sender;
- (IBAction)repeatEndsOnBeginEditing:(id)sender;



@end
