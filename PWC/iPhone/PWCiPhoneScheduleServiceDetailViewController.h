//
//  PWCiPhoneScheduleServiceDetailViewController.h
//  PWC
//
//  Created by Samiul Hoque on 7/24/13.
//  Copyright (c) 2013 Premium Web Cart. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PWCiPhoneScheduleServiceDetailViewController : UITableViewController

@property (strong, nonatomic) NSDictionary *serviceInfo;

@property (strong, nonatomic) IBOutlet UILabel *serviceNameLbl;
@property (strong, nonatomic) IBOutlet UILabel *maxParticipantsLbl;
@property (strong, nonatomic) IBOutlet UILabel *minDurationLbl;
@property (strong, nonatomic) IBOutlet UILabel *reqUnitLbl;
@property (strong, nonatomic) IBOutlet UILabel *serviceTypeLbl;
@property (strong, nonatomic) IBOutlet UITextView *descriptionTxtView;
@property (strong, nonatomic) IBOutlet UILabel *chargePerUnitLbl;
@property (strong, nonatomic) IBOutlet UILabel *editRuleLbl;
@property (strong, nonatomic) IBOutlet UILabel *cancelRuleLbl;
@property (strong, nonatomic) IBOutlet UITextView *termsTxtView;


@end
