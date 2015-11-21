//
//  PWCiPhoneLoginViewController.h
//  PWC
//
//  Created by Samiul Hoque on 2/11/13.
//  Copyright (c) 2013 Premium Web Cart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

#define kEmailKey    @"email"
#define kPasswordKey @"password"
//#define kCoachLogin  @"coachLogin"

@interface PWCiPhoneLoginViewController : BaseViewController


//@property (strong, nonatomic) IBOutlet UISwitch *coachLoginSwitch;

@property (strong, nonatomic) NSString *emailValue;
@property (strong, nonatomic) NSString *passValue;

//- (IBAction)changeCoachLogin:(id)sender;

- (IBAction)textFieldDoneEditing:(id)sender;
- (IBAction)nextTextField:(id)sender;
- (IBAction)backgroundTap:(id)sender;
- (IBAction)processLogin:(id)sender;
- (IBAction)forgotPassword:(id)sender;
- (IBAction)signUp:(id)sender;

- (void)doProcess;

@end
