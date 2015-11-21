//
//  PWCProjectTitleViewController.h
//  PWC
//
//  Created by JianJinHu on 11/27/13.
//  Copyright (c) 2013 Premium Web Cart. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PWCProjectTitleViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
{
    IBOutlet UITableView*               m_tableView;
    NSMutableArray*                     m_arrList;
}

@property(nonatomic, retain) NSString*          m_strProjectID;
@property(nonatomic, retain) NSString*          m_strProjectTitle;
@property(nonatomic, retain) NSString*          m_strTitleID;
@property(nonatomic, assign) int                m_nNextPageIndex;

@end
