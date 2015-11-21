//
//  PWCiPhoneScheduleAvailabilityDayViewController.h
//  PWC
//
//  Created by Samiul Hoque on 8/19/13.
//  Copyright (c) 2013 Premium Web Cart. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PWCiPhoneScheduleAvailabilityDayViewController : UITableViewController

@property (strong, nonatomic) NSString *dayName;
@property (assign, nonatomic) NSInteger daySerial;
@property (strong, nonatomic) NSArray *timeSlots;
@property (strong, nonatomic) NSMutableArray *slotStatus;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *saveButton;

- (IBAction)toggleAvailability:(id)sender;
- (IBAction)submitAvailabilityTime:(id)sender;


@end
