//
//  PWCCRMRoleSelViewController.h
//  PWC
//
//  Created by JianJinHu on 8/8/13.
//  Copyright (c) 2013 Premium Web Cart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@interface PWCCRMRoleSelViewController : UITableViewController
{
    IBOutlet UINavigationItem*          m_titleBar;
    int                                 m_nType;
    
    int                                 m_nSelectID;
    NSMutableArray*                     m_arrUserList;
    NSMutableArray*                     m_arrTasks;
    
    sqlite3*                            pwcDB;
}

@property(nonatomic, assign) int    m_nType;
@property(nonatomic, assign) int    m_nFunnelID;
@property(nonatomic, assign) BOOL   m_bFunnelUserFlag;

-(IBAction) actionRefresh:(id)sender;
@end
