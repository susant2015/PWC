//
//  PWCBuildEmailViewController.h
//  PWC
//
//  Created by JianJinHu on 7/25/13.
//  Copyright (c) 2013 Premium Web Cart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RadioButton.h"

@interface PWCBuildEmailViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate, RadioButtonDelegate>
{
    IBOutlet UITextField*       m_txtFrom;
    IBOutlet UITextField*       m_txtReplyTo;
    IBOutlet UITextField*       m_txtSubject;
    IBOutlet UITextView*        m_txtMessage;
    IBOutlet UIButton*          m_btnDate;
    IBOutlet UIButton*          m_btnTime;
    IBOutlet UIToolbar*         m_topToolBar;
    IBOutlet UIView*            m_viewInput;
    IBOutlet UIDatePicker*      m_datePicker;
    IBOutlet UIScrollView*      m_scrollView;
    
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

-(IBAction) actionSubmit:(id)sender;
-(IBAction) actionInputDone: (id) sender;
-(IBAction) actionDate:(id)sender;
-(IBAction) actionTime:(id)sender;
-(IBAction) actionRefresh:(id)sender;
-(IBAction) actionTextViewDone:(id)sender;

@end
