//
//  PWCiPhoneScheduleCustomerDetailViewController.h
//  PWC
//
//  Created by Samiul Hoque on 7/24/13.
//  Copyright (c) 2013 Premium Web Cart. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PWCiPhoneScheduleCustomerDetailViewController : UITableViewController

@property (strong, nonatomic) IBOutlet UILabel *custName;
@property (strong, nonatomic) IBOutlet UILabel *custBalance;
@property (strong, nonatomic) IBOutlet UITextView *genInfo;
@property (strong, nonatomic) IBOutlet UITextView *contactInfo;
@property (strong, nonatomic) NSDictionary *custInfo;


@end
