//
//  PWCTaskListViewController.h
//  PWC
//
//  Created by JianJinHu on 7/31/13.
//  Copyright (c) 2013 Premium Web Cart. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PWCTaskListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UINavigationItem*       m_titleBar;
    IBOutlet UITableView*            m_tableView;
    
    NSArray*            m_arrTaskList;
    NSString*           m_strName;
    int                 m_nTaskListIndex;
    int                 m_nFunnelID;
}

@property(nonatomic, retain) NSArray*   m_arrTaskList;
@property(nonatomic, retain) NSString*  m_strName;
@property(nonatomic, assign) int        m_nTaskListIndex;
@property(nonatomic, assign) int        m_nFunnelID;
@end
