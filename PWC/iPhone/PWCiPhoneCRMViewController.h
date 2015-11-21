//
//  PWCiPhoneCRMViewController.h
//  PWC
//
//  Created by Samiul Hoque on 7/9/13.
//  Copyright (c) 2013 Premium Web Cart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@interface PWCiPhoneCRMViewController : UITableViewController {
    sqlite3 *pwcDB;
}

- (IBAction)updateCRMdata:(id)sender;

@end
