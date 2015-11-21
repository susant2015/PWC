//
//  PWCOrdersViewController.h
//  PWC
//
//  Created by Samiul Hoque on 2/19/13.
//  Copyright (c) 2013 Premium Web Cart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@interface PWCOrdersViewController : UITableViewController {
    sqlite3 *pwcDB;
}

@property (strong, nonatomic) NSString *listTitle;
@property (retain, nonatomic) NSArray *data;
@property (assign, nonatomic) float total;
@property (retain, nonatomic) NSString *currency;

@end
