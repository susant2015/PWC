//
//  PWCiPhoneScheduleRemoveTagsViewController.h
//  PWC
//
//  Created by Samiul Hoque on 9/5/13.
//  Copyright (c) 2013 Premium Web Cart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@interface PWCiPhoneScheduleRemoveTagsViewController : UITableViewController {
    sqlite3 *pwcDB;
}

- (IBAction)saveService:(id)sender;

@end
