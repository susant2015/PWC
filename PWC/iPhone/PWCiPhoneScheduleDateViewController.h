//
//  PWCiPhoneScheduleDateViewController.h
//  PWC
//
//  Created by Samiul Hoque on 5/20/13.
//  Copyright (c) 2013 Premium Web Cart. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PWCiPhoneScheduleDateViewController : UITableViewController

@property (strong, nonatomic) NSDate *theDate;
@property (strong, nonatomic) NSMutableArray *bookingData;
@property (strong, nonatomic) NSMutableArray *availableData;
@property (strong, nonatomic) NSMutableArray *unavailableData;
@property (strong, nonatomic) NSArray *timeSlots;

@property (strong, nonatomic) NSArray *forCustomerList;
@property (strong, nonatomic) NSString *bookingStartTime;
@property (strong, nonatomic) NSString *togglingTime;

- (IBAction)makeTimeUnavailable:(id)sender;
- (IBAction)makeTimeAvailable:(id)sender;
- (IBAction)scheduleBooking:(id)sender;
- (IBAction)showCustomerList:(id)sender;
- (IBAction)editBooking:(id)sender;


@end
