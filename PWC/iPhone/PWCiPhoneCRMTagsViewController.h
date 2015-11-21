//
//  PWCiPhoneCRMTagsViewController.h
//  PWC
//
//  Created by Samiul Hoque on 7/9/13.
//  Copyright (c) 2013 Premium Web Cart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PWCNewLead.h"

@interface PWCiPhoneCRMTagsViewController : UITableViewController
{
    NSMutableArray*     m_arrTags;
    PWCNewLead*         m_newLead;
    NSMutableArray*     m_arrTagIDs;
}

@property(nonatomic, retain) PWCNewLead*    m_newLead;
@end
