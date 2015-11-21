//
//  PWCiPhoneCRMTasksViewController.h
//  PWC
//
//  Created by Samiul Hoque on 6/27/13.
//  Copyright (c) 2013 Premium Web Cart. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PWCiPhoneCRMTasksViewController : UITableViewController

@property (strong, nonatomic) IBOutlet UILabel *overdue;
@property (strong, nonatomic) IBOutlet UILabel *today;
@property (strong, nonatomic) IBOutlet UILabel *tomorrow;
@property (strong, nonatomic) IBOutlet UILabel *days2;
@property (strong, nonatomic) IBOutlet UILabel *days3;
@property (strong, nonatomic) IBOutlet UILabel *days4;
@property (strong, nonatomic) IBOutlet UILabel *days5;
@property (strong, nonatomic) IBOutlet UILabel *days6;

@end
