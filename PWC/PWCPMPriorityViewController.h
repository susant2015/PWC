//
//  PWCPMPriorityViewController.h
//  PWC
//
//  Created by jian on 12/17/13.
//  Copyright (c) 2013 Premium Web Cart. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PWCPMPriorityViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UITableView*               m_tableView;
    NSMutableArray*                     m_arrPriority;
}

@end
