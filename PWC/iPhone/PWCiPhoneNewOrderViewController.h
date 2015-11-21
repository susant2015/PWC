//
//  PWCiPhoneNewOrderViewController.h
//  BackUpFiles
//
//  Created by Samiul Hoque on 6/13/13.
//  Copyright (c) 2013 Premium Web Cart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@interface PWCiPhoneNewOrderViewController : UIViewController {
    sqlite3 *pwcDB;
}

@property (strong, nonatomic) IBOutlet UIButton *productOrder;
@property (strong, nonatomic) IBOutlet UIButton *miscOrder;

- (IBAction)syncProducts:(id)sender;

@end
