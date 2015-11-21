//
//  PWCPMSprintViewController.h
//  PWC
//
//  Created by jian on 12/15/13.
//  Copyright (c) 2013 Premium Web Cart. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PWCPMSprintViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UITableView*           m_tableView;
    
    NSMutableArray*                 m_arrSprints;
}

@property(nonatomic, retain) NSString*      m_strAllSprint;
@property(nonatomic, retain) NSString*      m_strProjectID;
@property(nonatomic, retain) NSString*      m_strTodoID;

@end
