//
//  PWCiPhoneCRMTaskDetailViewController.h
//  PWC
//
//  Created by Samiul Hoque on 6/28/13.
//  Copyright (c) 2013 Premium Web Cart. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PWCiPhoneCRMTaskDetailViewController : UITableViewController

@property (strong, nonatomic) NSDictionary *taskObj;
@property (strong, nonatomic) IBOutlet UILabel *taskName;
@property (strong, nonatomic) IBOutlet UILabel *taskAssignedTo;
@property (strong, nonatomic) IBOutlet UILabel *taskAssignedBy;
@property (strong, nonatomic) IBOutlet UILabel *taskAssignedOn;
@property (strong, nonatomic) IBOutlet UILabel *taskDueDate;
@property (strong, nonatomic) IBOutlet UILabel *taskDelayedBy;
@property (strong, nonatomic) IBOutlet UILabel *taskCustomer;
@property (strong, nonatomic) IBOutlet UILabel *taskReason;
@property (strong, nonatomic) IBOutlet UILabel *taskStatus;
@property (strong, nonatomic) IBOutlet UITextView *taskComment;
@property (strong, nonatomic) IBOutlet UILabel *delayedOrDue;

@property (strong, nonatomic) NSString *taskStatusText;

@end
