//
//  PWCProjectListViewController.h
//  PWC
//
//  Created by JianJinHu on 11/27/13.
//  Copyright (c) 2013 Premium Web Cart. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PWCProjectListViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UITableView*               m_tableView;
    NSMutableArray*                     m_arrList;
    
    int                                 m_nProjectIndex;
}

@property(nonatomic, retain) NSString*  m_strSelectedID;
@property(nonatomic, retain) NSString*  m_strSelectedProjectID;
@property(nonatomic, retain) NSString*  m_strSelectedName;
@property(nonatomic, assign) int        m_nNextPageIndex;
@end
