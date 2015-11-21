//
//  PWCChangeStatusViewController.h
//  PWC
//
//  Created by JianJinHu on 8/3/13.
//  Copyright (c) 2013 Premium Web Cart. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PWCChangeStatusViewController : UIViewController <UIActionSheetDelegate>
{
    IBOutlet UIButton*              m_btnStatus;
    IBOutlet UIView*                m_viewReassignedTo;
    IBOutlet UIButton*              m_btnUser;
    IBOutlet UIView*                m_viewReschedule;
    IBOutlet UIButton*              m_btnDateFrom;
    IBOutlet UIButton*              m_btnDateTo;
    IBOutlet UIView*                m_viewInputView;
    IBOutlet UIDatePicker*          m_datePicker;
    
    CGRect                          m_rectReassign;
    CGRect                          m_rectReschedule;
    
    int                             m_nDateType;
    NSString*                       task_status;
    NSString*                       task_id;
}
@property(nonatomic, retain)NSString* task_id;
@property(nonatomic, retain)NSString* task_status;
@end
