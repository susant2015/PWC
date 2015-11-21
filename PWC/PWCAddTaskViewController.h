//
//  PWCAddTaskViewController.h
//  PWC
//
//  Created by JianJinHu on 11/7/13.
//  Copyright (c) 2013 Premium Web Cart. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PWCAddTaskViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate>
{
    IBOutlet UILabel*               m_lblCustomer;
    IBOutlet UILabel*               m_lblTask;
    IBOutlet UILabel*               m_lblAssignedTo;
    IBOutlet UILabel*               m_lblDueDate;
    IBOutlet UILabel*               m_lblDueTime;
    IBOutlet UITextField*           m_txtReason;
    IBOutlet UIToolbar*             m_toolbar;
    IBOutlet UIView*                m_viewInput;
    IBOutlet UIPickerView*          m_picker;
    IBOutlet UIDatePicker*          m_datePicker;
    IBOutlet UIScrollView*          m_scrollView;
    
    NSMutableArray*                 m_arrCustomers;
    NSMutableArray*                 m_arrTasks;
    
    float                           m_fScrollHeight;
    
    int                             m_nItemSelectionIndex;
}

@property(nonatomic, retain) NSString*          m_strSelDate;
@end
