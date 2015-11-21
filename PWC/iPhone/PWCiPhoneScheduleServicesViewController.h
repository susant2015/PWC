//
//  PWCiPhoneScheduleServicesViewController.h
//  PWC
//
//  Created by Samiul Hoque on 6/6/13.
//  Copyright (c) 2013 Premium Web Cart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@interface PWCiPhoneScheduleServicesViewController : UITableViewController {
    sqlite3 *pwcDB;
}

@property (assign, nonatomic) BOOL isSearching;
@property (strong, nonatomic) IBOutlet UITableView *serviceTableView;

@property (strong, nonatomic) NSDictionary *allNames;
@property (strong, nonatomic) NSMutableDictionary *names;
@property (strong, nonatomic) NSMutableArray *keys;

@property (strong, nonatomic) NSMutableDictionary *aNames;
@property (strong, nonatomic) NSMutableArray *aKeys;

- (void)resetSearch;
- (void)handleSearchForTerm:(NSString *)searchTerm;

@end
