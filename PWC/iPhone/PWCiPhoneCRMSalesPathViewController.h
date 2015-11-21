//
//  PWCiPhoneCRMSalesPathViewController.h
//  PWC
//
//  Created by Samiul Hoque on 7/9/13.
//  Copyright (c) 2013 Premium Web Cart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PWCNewLead.h"

@interface PWCiPhoneCRMSalesPathViewController : UITableViewController
{
    NSMutableArray*     m_arrInfo;
    PWCNewLead*         m_newLead;
    int                 m_nSelectedID;
}
@property(nonatomic, retain) PWCNewLead*        m_newLead;
@end
