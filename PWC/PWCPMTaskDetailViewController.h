//
//  PWCPMTaskDetailViewController.h
//  PWC
//
//  Created by JianJinHu on 11/28/13.
//  Copyright (c) 2013 Premium Web Cart. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PWCPMTaskDetailViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UITextViewDelegate>
{
    NSMutableArray*                     m_arrList;
    
    IBOutlet UIToolbar*                 m_topToolBar;
    
    //Detail.
    IBOutlet UIView*                    m_viewDetails;
    IBOutlet UILabel*                   m_lblTaskName;
    IBOutlet UILabel*                   m_lblTaskDescription;
    IBOutlet UIView*                    m_viewUserList;
    
    IBOutlet UILabel*                   m_lblCommentCount;
    IBOutlet UIScrollView*              m_scrollComment;
    IBOutlet UIView*                    m_viewCommentPost;
    IBOutlet UITextView*                m_txtComment;
    IBOutlet UIScrollView*              m_scrollDetail;
    IBOutlet UIButton*                  m_btnSubmit;
    
    //Status.
    IBOutlet UIView*                    m_viewStatus;
    IBOutlet UITableView*               m_tableStatus;
    NSMutableArray*                     m_arrStatus;
    
    //Summary.
    IBOutlet UIView*                    m_viewSummary;
    IBOutlet UILabel*                   m_lblPriority;
    IBOutlet UILabel*                   m_lblFirstPostOn;
    IBOutlet UILabel*                   m_lblAssignedBy;
    IBOutlet UILabel*                   m_lblAssignedTo;
    IBOutlet UILabel*                   m_lblStartDate;
    IBOutlet UILabel*                   m_lblEndDate;
    IBOutlet UILabel*                   m_lblDuration;
    IBOutlet UILabel*                   m_lblSprint;
    IBOutlet UIImageView*               m_imgAssignedBySub;
    IBOutlet UIImageView*               m_imgAssignedToSub;
    
    float                               m_fScrollHeight;
    
    NSMutableArray*                     m_arrPeopleCheckBox;
}

@property(nonatomic, retain) NSString*          m_strProjectID;
@property(nonatomic, retain) NSString*          m_strTodoID;
@property(nonatomic, retain) NSString*          m_strAssignedByID;
@property(nonatomic, retain) NSString*          m_strAssignedToID;
@property(nonatomic, retain) NSString*          m_strAllSprints;
@property(nonatomic, assign) BOOL               m_bUpdateFlag;
@end
