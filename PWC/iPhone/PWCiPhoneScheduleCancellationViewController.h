//
//  PWCiPhoneScheduleCancellationViewController.h
//  PWC
//
//  Created by Samiul Hoque on 9/4/13.
//  Copyright (c) 2013 Premium Web Cart. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PWCiPhoneScheduleCancellationViewController : UITableViewController <UIActionSheetDelegate>

@property (strong, nonatomic) IBOutlet UIButton *editRuleDayBtn;
@property (strong, nonatomic) IBOutlet UIButton *editRuleHourBtn;
@property (strong, nonatomic) IBOutlet UIButton *cancelRuleDayBtn;
@property (strong, nonatomic) IBOutlet UIButton *cancelRuleHourBtn;
@property (strong, nonatomic) IBOutlet UITextView *termsTxtView;

@property (strong, nonatomic) NSString *selectedButton;
@property (strong, nonatomic) NSMutableArray *unitDay;
@property (strong, nonatomic) NSMutableArray *unitHour;

- (IBAction)editRuleDayClick:(id)sender;
- (IBAction)editRuleHourClick:(id)sender;
- (IBAction)cancelRuleDayClick:(id)sender;
- (IBAction)cancelRuleHourClick:(id)sender;

@end
