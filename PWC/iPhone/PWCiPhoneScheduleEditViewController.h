//
//  PWCiPhoneScheduleEditViewController.h
//  PWC
//
//  Created by Samiul Hoque on 7/30/13.
//  Copyright (c) 2013 Premium Web Cart. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PWCiPhoneScheduleEditViewController : UITableViewController <UIActionSheetDelegate>

@property (strong, nonatomic) NSArray *list;
@property (strong, nonatomic) NSArray *options;
@property (strong, nonatomic) NSString *theDate; // Format: dd/mm/yyyy
@property (strong, nonatomic) NSString *selectedOption;

@property (strong, nonatomic) NSString *startTime;
@property (strong, nonatomic) NSArray *unavailable;

@property (assign, nonatomic) NSInteger selectedRow;

- (IBAction)deleteBooking:(id)sender;
- (IBAction)editBooking:(id)sender;

@end
