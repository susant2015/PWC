//
//  PWCiPhoneCRMTaskListViewController.h
//  PWC
//
//  Created by Samiul Hoque on 6/27/13.
//  Copyright (c) 2013 Premium Web Cart. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PWCiPhoneCRMTaskListViewController : UITableViewController

@property (strong, nonatomic) NSString *taskCategory;
@property (strong, nonatomic) NSString *taskCount;
@property (strong, nonatomic) NSMutableArray *taskList;

@end
