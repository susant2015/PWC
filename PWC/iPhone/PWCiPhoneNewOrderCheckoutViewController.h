//
//  PWCiPhoneNewOrderCheckoutViewController.h
//  BackUpFiles
//
//  Created by Samiul Hoque on 6/13/13.
//  Copyright (c) 2013 Premium Web Cart. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "uniMag.h"
#import <sqlite3.h>

@interface PWCiPhoneNewOrderCheckoutViewController : UITableViewController <UIActionSheetDelegate> {
    uniMag *uniReader;
    
    // Alertviews
    UIAlertView *prompt_doConnection;
    UIAlertView *prompt_connecting;
    UIAlertView *prompt_waitingForSwipe;
    UIAlertView *prompt_noCardData;
    
    sqlite3 *pwcDB;
}

@property (strong, nonatomic) NSMutableArray *myArray;
@property (assign, nonatomic) NSInteger totalRows;
@property (assign, nonatomic) float totalAmount;

@property (strong, nonatomic) NSString *cardNumber;
@property (strong, nonatomic) NSString *cardHolderName;
@property (strong, nonatomic) NSString *cardExpireDate;
@property (strong, nonatomic) NSString *cardTypeImage;

@property (strong, nonatomic) NSString *track1value;
@property (strong, nonatomic) NSString *track2value;

@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *phone;
@property (strong, nonatomic) NSString *comment;

@property (strong, nonatomic) IBOutlet UITableView *checkoutTableView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *doASwipeButton;

- (IBAction)startSwiping:(id)sender;
- (IBAction)chargeTheCard:(id)sender;
- (IBAction)deleteFromCart:(id)sender;

@end
