//
//  PWCPMNotificationToViewController.h
//  PWC
//
//  Created by Jian on 12/6/13.
//  Copyright (c) 2013 Premium Web Cart. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PWCPMNotificationToViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>
{
    IBOutlet UITableView*           m_tableView;

}

@property(nonatomic, retain) NSString*          m_strProjectID;
@property(nonatomic, retain) NSString*          m_strTodoID;
@property(nonatomic, retain) NSString*          m_strSelectUserID;
@property(nonatomic, retain) NSMutableArray*    m_arrUserList;
@property(nonatomic, assign) int                m_nPrevIndex;
@end
