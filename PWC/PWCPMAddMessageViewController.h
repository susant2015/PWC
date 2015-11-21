//
//  PWCPMAddMessageViewController.h
//  PWC
//
//  Created by jian on 12/20/13.
//  Copyright (c) 2013 Premium Web Cart. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PWCPMAddMessageViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, UIAlertViewDelegate>
{
    IBOutlet UIScrollView*          m_scrollView;
    IBOutlet UITextField*           m_txtSubject;
    IBOutlet UITextView*            m_txtContent;
    IBOutlet UIView*                m_viewAttach;
    IBOutlet UIScrollView*          m_scrollAttachFiles;
    IBOutlet UIView*                m_viewUsers;
    IBOutlet UIToolbar*             m_topToolBar;

    BOOL                            m_bPhotoFlag;
    NSMutableArray*                 m_arrAttachedImages;
    NSMutableArray*                 m_arrAttachedVideos;
    
    BOOL                            m_bPrivate;
    NSMutableArray*                 m_arrPeopleCheckBox;
}

@property(nonatomic, retain) NSString*  m_strProjectID;
@end
