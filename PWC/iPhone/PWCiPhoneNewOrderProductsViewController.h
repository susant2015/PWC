//
//  PWCiPhoneNewOrderProductsViewController.h
//  BackUpFiles
//
//  Created by Samiul Hoque on 6/13/13.
//  Copyright (c) 2013 Premium Web Cart. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PWCiPhoneNewOrderProductsViewController : UITableViewController <UISearchDisplayDelegate, UISearchBarDelegate>

@property (assign, nonatomic) BOOL isSearching;
@property (strong, nonatomic) IBOutlet UITableView *productTable;

@property (strong, nonatomic) NSDictionary *allnames;
@property (strong, nonatomic) NSMutableDictionary *names;
@property (strong, nonatomic) NSMutableArray *keys;

@property (strong, nonatomic) NSMutableDictionary *aNames;
@property (strong, nonatomic) NSMutableArray *aKeys;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *checkoutBtn;

- (void)resetSearch;
- (void)handleSearchForTerm:(NSString *)searchTerm;

@end
