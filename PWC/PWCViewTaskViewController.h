//
//  PWCViewTaskViewController.h
//  PWC
//
//  Created by JianJinHu on 7/31/13.
//  Copyright (c) 2013 Premium Web Cart. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PWCViewTaskViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray*         m_arrInfo;
    IBOutlet UITableView*   m_tableView;
    
    int                     m_nFunnelID;
}
@property(nonatomic, assign) int    m_nFunnelID;
@property(nonatomic, assign) int    m_nAdminID;
@end
