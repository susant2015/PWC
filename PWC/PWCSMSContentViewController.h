//
//  PWCSMSContentViewController.h
//  PWC
//
//  Created by JianJinHu on 7/29/13.
//  Copyright (c) 2013 Premium Web Cart. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PWCSMSContentViewController : UITableViewController
{
    int                    m_nSelSection;
    int                    m_nSelRow;
}

@property(nonatomic, retain)NSMutableArray*     m_arrContents;

@end
