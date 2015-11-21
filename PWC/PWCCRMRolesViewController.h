//
//  PWCCRMRolesViewController.h
//  PWC
//
//  Created by JianJinHu on 8/7/13.
//  Copyright (c) 2013 Premium Web Cart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PWCNewLead.h"

@interface PWCCRMRolesViewController : UITableViewController
{
    IBOutlet UIButton*          m_btnPrimary;
    IBOutlet UIButton*          m_btnTechnical;
    IBOutlet UIButton*          m_btnSupport;
    IBOutlet UIButton*          m_btnAssignedTo;
    
    PWCNewLead*                 m_newLead;
}
@property(nonatomic, retain) PWCNewLead*    m_newLead;
@end
