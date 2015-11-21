//
//  PWCTaskDetailViewController.h
//  PWC
//
//  Created by JianJinHu on 8/1/13.
//  Copyright (c) 2013 Premium Web Cart. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PWCTaskDetailViewController : UIViewController <UITextViewDelegate>
{
    IBOutlet UILabel*           m_lblTaskName;
    IBOutlet UILabel*           m_lblAssignedTo;
    IBOutlet UILabel*           m_lblAssignedBy;
    IBOutlet UILabel*           m_lblAssignedOn;
    IBOutlet UILabel*           m_lblDueDate;
    IBOutlet UILabel*           m_lblDelayedBy;
    IBOutlet UILabel*           m_lblCustomer;
    IBOutlet UILabel*           m_lblReason;
    IBOutlet UILabel*           m_lblStatus;
    IBOutlet UITextView*        m_txtComment;
    IBOutlet UIScrollView*      m_scrollView;
    
    IBOutlet UIToolbar*         m_topToolBar;
    
    NSDictionary*               m_dicTask;
    float                       m_fScrollHeight;
}
@property(nonatomic, retain) NSDictionary*      m_dicTask;

-(IBAction) actionSubmit:(id)sender;

@end
