//
//  PWCProductListViewController.h
//  PWC
//
//  Created by JianJinHu on 8/19/13.
//  Copyright (c) 2013 Premium Web Cart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@interface PWCProductListViewController : UITableViewController <UISearchBarDelegate>
{
    NSMutableArray*                 m_arrOriginProducts;
    NSMutableArray*                 m_arrProducts;
    
    sqlite3 *pwcDB;
    
    IBOutlet UISearchBar*           m_searchBar;
}

@end
