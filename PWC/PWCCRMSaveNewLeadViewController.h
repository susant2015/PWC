//
//  PWCCRMSaveNewLeadViewController.h
//  PWC
//
//  Created by JianJinHu on 8/13/13.
//  Copyright (c) 2013 Premium Web Cart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PWCNewLead.h"

@interface PWCCRMSaveNewLeadViewController : UIViewController
{
    PWCNewLead*     m_newLead;
}
@property(nonatomic, retain) PWCNewLead*        m_newLead;
@end
