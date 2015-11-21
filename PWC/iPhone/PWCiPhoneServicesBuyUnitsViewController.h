//
//  PWCiPhoneServicesBuyUnitsViewController.h
//  PWC
//
//  Created by Samiul Hoque on 7/24/13.
//  Copyright (c) 2013 Premium Web Cart. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PWCiPhoneServicesBuyUnitsViewController : UITableViewController

@property (strong, nonatomic) NSDictionary *customerInfo;

@property (strong, nonatomic) IBOutlet UITextField *quantity;
@property (strong, nonatomic) IBOutlet UITextField *totalAmount;


- (IBAction)toCheckout:(id)sender;

@end
