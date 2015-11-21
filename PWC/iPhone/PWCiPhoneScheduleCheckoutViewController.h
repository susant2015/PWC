//
//  PWCiPhoneScheduleCheckoutViewController.h
//  PWC
//
//  Created by Samiul Hoque on 7/24/13.
//  Copyright (c) 2013 Premium Web Cart. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "uniMag.h"
#import <sqlite3.h>

@interface PWCiPhoneScheduleCheckoutViewController : UITableViewController <UIActionSheetDelegate> {
    uniMag *uniReader;
    
    // Alertviews
    UIAlertView *prompt_doConnection;
    UIAlertView *prompt_connecting;
    UIAlertView *prompt_waitingForSwipe;
    UIAlertView *prompt_noCardData;
    
    sqlite3 *pwcDB;
}


@property (strong, nonatomic) NSDictionary *custInfo;
@property (strong, nonatomic) NSDictionary *prodInfo;

@property (strong, nonatomic) IBOutlet UISwitch *useSwipe;
@property (strong, nonatomic) IBOutlet UITextField *cardNumber;
@property (strong, nonatomic) IBOutlet UIImageView *cardType;
@property (strong, nonatomic) IBOutlet UITextField *cardName;
@property (strong, nonatomic) IBOutlet UITextField *expireMonth;
@property (strong, nonatomic) IBOutlet UITextField *expireYear;
@property (strong, nonatomic) IBOutlet UITextField *cvc;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *swipeButton;
@property (strong, nonatomic) IBOutlet UIButton *chargeCard;

@property (strong, nonatomic) NSString *cCardNumber;
@property (strong, nonatomic) NSString *cardHolderName;
@property (strong, nonatomic) NSString *cardExpireDate;
@property (strong, nonatomic) NSString *cardTypeImage;

@property (strong, nonatomic) NSString *track1value;
@property (strong, nonatomic) NSString *track2value;

- (IBAction)useSwipeChanged:(id)sender;
- (IBAction)chargeTheCard:(id)sender;

- (IBAction)startSwiping:(id)sender;


@end
