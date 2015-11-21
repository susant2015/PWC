//
//  PWCPMMessageListViewController.h
//  PWC
//
//  Created by jian on 12/20/13.
//  Copyright (c) 2013 Premium Web Cart. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PWCPMMessageListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    IBOutlet UITableView*               m_tableView;
    NSMutableArray*                     m_arrMessageList;
}

@property(nonatomic, retain) NSString*  m_strProjectID;
@property(nonatomic, retain) NSString*  m_strSelectedMessageID;
@end
