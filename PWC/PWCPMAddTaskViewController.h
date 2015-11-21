//
//  PWCPMAddTaskViewController.h
//  PWC
//
//  Created by jian on 12/16/13.
//  Copyright (c) 2013 Premium Web Cart. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PWCPMAddTaskViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, UIAlertViewDelegate>
{
    
    IBOutlet UIScrollView*          m_scrollView;
    IBOutlet UIView*                m_viewNewListName;
    IBOutlet UITextField*           m_txtNewListName;
    
    IBOutlet UIView*                m_viewMain;
    IBOutlet UITextField*           m_txtTask;
    IBOutlet UITextView*            m_txtFullDescription;
    IBOutlet UIButton*              m_btnTaskDuration;
    IBOutlet UIButton*              m_btnAssignedTo;
    IBOutlet UIScrollView*          m_scrollAttachFiles;
    IBOutlet UIButton*              m_btnPriority;
    IBOutlet UIButton*              m_btnStartDate;
    IBOutlet UIButton*              m_btnEndDate;
    IBOutlet UIView*                m_viewUsers;
    IBOutlet UIToolbar*             m_topToolBar;

    
    IBOutlet UIView*                m_viewInput;
    IBOutlet UIPickerView*          m_pickerDuration;
    IBOutlet UIDatePicker*          m_datePicker;
    
    int                             m_nSelectedDayDuration;
    int                             m_nSelectedHourDuration;
    int                             m_nSelectedMinuteDuration;
    
    int                             m_nDateType;
    int                             m_nInputType;
    
    BOOL                            m_bPhotoFlag;
    NSMutableArray*                 m_arrAttachedImages;
    NSMutableArray*                 m_arrAttachedVideos;
    
    BOOL                            m_bAddNewList;
    
    NSMutableArray*                 m_arrAssignUser;
    NSMutableArray*                 m_arrPriority;
    
}
@property(nonatomic, retain) NSString*          m_strProjectID;
@property(nonatomic, retain) NSString*          m_strTitleID;
//@property(nonatomic, ret)
-(IBAction) actionAttach:(id)sender;
@end
