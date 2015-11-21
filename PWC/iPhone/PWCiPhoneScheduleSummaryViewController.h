//
//  PWCiPhoneScheduleSummaryViewController.h
//  PWC
//
//  Created by Samiul Hoque on 5/20/13.
//  Copyright (c) 2013 Premium Web Cart. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PWCiPhoneScheduleSummaryViewController : UITableViewController

@property (strong, nonatomic) NSDate *theDate;
@property (strong, nonatomic) NSMutableArray *bookingData;

@end
