//
//  PWCBuildSMSViewController.h
//  PWC
//
//  Created by JianJinHu on 7/29/13.
//  Copyright (c) 2013 Premium Web Cart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RadioButton.h"

@interface PWCBuildSMSViewController : UIViewController <UITextViewDelegate, RadioButtonDelegate>
{
    IBOutlet UITextView*            m_txtMessage;
    IBOutlet UILabel*               m_lblLetters;
    IBOutlet UIButton*              m_btnDate;
    IBOutlet UIButton*              m_btnTime;
    IBOutlet UIToolbar*             m_topToolBar;
    IBOutlet UIView*                m_viewInput;
    IBOutlet UIDatePicker*          m_datePicker;
    IBOutlet UIScrollView*          m_scrollView;
    
    int                         m_nDatePickerType;
    
    int                         m_nAddToQuene;
    NSString*                   m_strQueneHour;
    NSString*                   m_strQueneMin;
    NSString*                   m_strQueneAM;
    
    float                       m_fScrollHeight;
}

@property(nonatomic, retain) NSString* m_strQueneHour;
@property(nonatomic, retain) NSString* m_strQueneMin;
@property(nonatomic, retain) NSString* m_strQueneAM;

-(IBAction) actionInputDone: (id) sender;
-(IBAction) actionDate:(id)sender;
-(IBAction) actionTime:(id)sender;
-(IBAction) actionRefresh:(id)sender;
-(IBAction) actionSubmit:(id)sender;
-(IBAction) actionTextViewDone:(id)sender;

@end
