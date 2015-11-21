//
//  PWCiPhoneScheduleMainViewController.h
//  PWC
//
//  Created by Samiul Hoque on 5/14/13.
//  Copyright (c) 2013 Premium Web Cart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@interface PWCiPhoneScheduleMainViewController : UITableViewController {
    sqlite3 *pwcDB;
}

@property (assign, nonatomic) BOOL custEmpty;
@property (assign, nonatomic) BOOL servEmpty;

- (IBAction)updateScheduleData:(id)sender;
- (IBAction)viewCalendar:(id)sender;

@end
