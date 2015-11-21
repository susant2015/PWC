//
//  PWCPMDetailMessageViewController.h
//  PWC
//
//  Created by jian on 12/20/13.
//  Copyright (c) 2013 Premium Web Cart. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PWCPMDetailMessageViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    //Detail.
    IBOutlet UIView*        m_viewDetail;
    IBOutlet UIToolbar*     m_topToolBar;
    IBOutlet UIScrollView*  m_scrollDetail;
    IBOutlet UILabel*       m_lblSubject;
    IBOutlet UILabel*       m_lblContentTile;
    IBOutlet UILabel*       m_lblContent;
    IBOutlet UIScrollView*  m_scrollComments;
    IBOutlet UIView*        m_viewNotitification;
    IBOutlet UIView*        m_viewAttached;
    IBOutlet UIScrollView*  m_scrollAttach;
    IBOutlet UIButton*      m_btnSubmit;

    IBOutlet UIView*        m_viewAddComment;    
    IBOutlet UITextView*    m_txtCommentPost;

    //Submit.
    IBOutlet UIView*        m_viewSummary;
    IBOutlet UITableView*   m_tableNotifiedTo;
    
    NSMutableArray*         m_arrNotifiedList;
    NSMutableArray*         m_arrPeopleCheckBox;    
}

@property(nonatomic, retain) NSString*          m_strProjectID;;
@property(nonatomic, retain) NSString*          m_strMessageID;
@end
