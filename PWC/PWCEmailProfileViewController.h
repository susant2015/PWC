//
//  PWCEmailProfileViewController.h
//  PWC
//
//  Created by JianJinHu on 7/25/13.
//  Copyright (c) 2013 Premium Web Cart. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PWCEmailProfileViewController : UITableViewController
{
    NSIndexPath *         lastIndexPath;
}

@property(nonatomic, retain)NSArray*     m_arrProfiles;
@end
