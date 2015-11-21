//
//  PWCiPhoneScheduleAddServiceViewController.h
//  PWC
//
//  Created by Samiul Hoque on 9/3/13.
//  Copyright (c) 2013 Premium Web Cart. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PWCiPhoneScheduleAddServiceViewController : UITableViewController <UIActionSheetDelegate> 

@property (strong, nonatomic) NSString *serviceRowId;

@property (strong, nonatomic) IBOutlet UITextField *serviceNameTxt;
@property (strong, nonatomic) IBOutlet UIButton *reqUnitDecimalBtn;
@property (strong, nonatomic) IBOutlet UIButton *reqUnitFractionBtn;
@property (strong, nonatomic) IBOutlet UIButton *maxParticipantsBtn;
@property (strong, nonatomic) IBOutlet UIButton *minDurationDecimalBtn;
@property (strong, nonatomic) IBOutlet UIButton *minDurationFractionBtn;
@property (strong, nonatomic) IBOutlet UIButton *serviceTypeBtn;
@property (strong, nonatomic) IBOutlet UITextView *descriptionTxt;

@property (strong, nonatomic) NSString *selectedButton;
@property (strong, nonatomic) NSMutableArray *unitDecimal;
@property (strong, nonatomic) NSMutableArray *unitFraction;
@property (strong, nonatomic) NSMutableArray *unitMinutes;
@property (strong, nonatomic) NSMutableArray *participants;
@property (strong, nonatomic) NSMutableArray *serviceType;

- (IBAction)reqUnitDecClick:(id)sender;
- (IBAction)reqUnitFracClick:(id)sender;
- (IBAction)maxPartClick:(id)sender;
- (IBAction)minDurDecClick:(id)sender;
- (IBAction)minDurFracClick:(id)sender;
- (IBAction)servTypeClick:(id)sender;

@end
