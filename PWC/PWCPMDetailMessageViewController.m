//
//  PWCPMDetailMessageViewController.m
//  PWC
//
//  Created by jian on 12/20/13.
//  Copyright (c) 2013 Premium Web Cart. All rights reserved.
//

#import "PWCPMDetailMessageViewController.h"
#import "DataManager.h"
#import "JSON.h"
#import "ASIFormDataRequest.h"
#import "PWCGlobal.h"
#import "PWCAppDelegate.h"
#import "SSCheckBoxView.h"
#import "PWCPMNotificationToViewController.h"

@interface PWCPMDetailMessageViewController ()

@end

@implementation PWCPMDetailMessageViewController
@synthesize m_strMessageID;
@synthesize m_strProjectID;

//==============================================================================================================
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

//==============================================================================================================
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initMember];
}

//==============================================================================================================
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//==============================================================================================================
-(void) initMember
{
    m_arrNotifiedList = [[NSMutableArray alloc] init];
    m_arrPeopleCheckBox = [[NSMutableArray alloc] init];
    
    [m_txtCommentPost setInputAccessoryView: m_topToolBar];
    m_txtCommentPost.layer.masksToBounds = YES;
    m_txtCommentPost.layer.borderWidth = 1.0f;
    m_txtCommentPost.layer.cornerRadius = 5.0f;
    m_txtCommentPost.layer.borderColor = [UIColor grayColor].CGColor;
    
    m_scrollComments.layer.borderWidth = 1.0f;
    m_scrollComments.layer.borderColor = [UIColor grayColor].CGColor;
    
    NSDictionary* dicDetail = [[DataManager sharedScoreManager] getPMMessageDetail: self.m_strMessageID];
    if(dicDetail == nil)
    {
        [self getMessageDetail];
    }
    
    [self updateContent: dicDetail];
}

//==============================================================================================================
-(void) updateContent: (NSDictionary*) dicDetail
{
    //Summary.
    [m_arrNotifiedList removeAllObjects];
    NSString* postedTo = [[PWCAppDelegate getDelegate] decodeBase64String: [dicDetail valueForKey: @"postedTo"]];
    NSLog(@"postedTo = %@", postedTo);
    
    NSArray* arrPostedTo = [postedTo componentsSeparatedByString: @","];
    if(arrPostedTo != nil && [arrPostedTo count] > 0)
    {
        for(int i = 0; i < [arrPostedTo count]; i++)
        {
            [m_arrNotifiedList addObject: [arrPostedTo objectAtIndex: i]];
        }
    }
    [m_tableNotifiedTo reloadData];
    
    
    //Detail
    float fy = 0;
    
    m_lblSubject.text = [[PWCAppDelegate getDelegate] decodeBase64String:[dicDetail valueForKey: @"messageSubject"]];
    self.navigationItem.title = m_lblSubject.text;
    NSString* strBody = [[PWCAppDelegate getDelegate] decodeBase64String: [dicDetail valueForKey: @"messageBody"]];
    m_lblContent.text = strBody;
    [m_lblContent sizeToFit];

    //File Attached:
    
    fy = m_lblContent.frame.origin.y + m_lblContent.frame.size.height + 20;
    m_viewAttached.frame = CGRectMake(m_viewAttached.frame.origin.x,
                                      fy,
                                      m_viewAttached.frame.size.width,
                                      m_viewAttached.frame.size.height);
    NSString* messageFiles = [dicDetail valueForKey: @"messageFile"];
    
    for(UIView* view in m_scrollAttach.subviews)
    {
        [view removeFromSuperview];
    }
    
    float fx = 0;
    if(messageFiles != nil && [messageFiles length] > 0)
    {
        m_viewAttached.hidden = NO;
        NSArray* arrMessageFiles = [messageFiles componentsSeparatedByString: @","];
        for(int i = 0; i < [arrMessageFiles count]; i++)
        {
            NSString* strFileID = [arrMessageFiles objectAtIndex: i];
            NSDictionary* dicFile = [[DataManager sharedScoreManager] getPMMessageFile: strFileID];
            
            UIButton* btnComment = [[UIButton alloc] initWithFrame: CGRectMake(fx + 30, 10, 18, 23)];
            [btnComment setImage: [UIImage imageNamed: @"file_icon.png"] forState: UIControlStateNormal];
            btnComment.tag = [[dicFile valueForKey: @"fileid"] intValue];
            [btnComment addTarget: self action: @selector(actionFileURL:) forControlEvents: UIControlEventTouchUpInside];
            [m_scrollAttach addSubview: btnComment];
            
            UILabel* lblFileName = [[UILabel alloc] initWithFrame: CGRectMake(fx + 5, 35, 75, 25)];
            lblFileName.font = [UIFont systemFontOfSize: 12.0f];
            lblFileName.backgroundColor = [UIColor clearColor];
            lblFileName.text = [dicFile valueForKey: @"filename"];
//            [lblFileName sizeToFit];
            lblFileName.textAlignment = NSTextAlignmentCenter;
            lblFileName.center = CGPointMake(btnComment.center.x, lblFileName.center.y);
            [m_scrollAttach addSubview: lblFileName];
            
            fx += 70;
        }
        [m_scrollAttach setContentSize: CGSizeMake(fx, m_scrollAttach.contentSize.height)];
        m_scrollComments.frame = CGRectMake(m_scrollComments.frame.origin.x,
                                            m_viewAttached.frame.origin.y + m_viewAttached.frame.size.height,
                                            m_scrollComments.frame.size.width,
                                            m_scrollComments.frame.size.height);
    }
    else
    {
        m_viewAttached.hidden = YES;
        m_scrollComments.frame = CGRectMake(m_scrollComments.frame.origin.x,
                                            m_viewAttached.frame.origin.y,
                                            m_scrollComments.frame.size.width,
                                            m_scrollComments.frame.size.height);
    }
    
    //Comment.
    for(UIView* view in m_scrollComments.subviews)
    {
        [view removeFromSuperview];
    }
    
    fy = 0;
    NSString* messageComment = [dicDetail valueForKey: @"messageComment"];
    if(![messageComment isKindOfClass: [NSNull class]] && messageComment != nil && [messageComment length] > 0)
    {
        NSArray* arrMessageComment = [messageComment componentsSeparatedByString: @","];
        if(arrMessageComment != nil && [arrMessageComment count] > 0)
        {
            for(int i = 0; i < [arrMessageComment count]; i++)
            {
                NSString* strMessageID = [arrMessageComment objectAtIndex: i];
                NSDictionary* dicMessageComment = [[DataManager sharedScoreManager] getPMMessageComment: strMessageID];
                
                UILabel* lblTop = [[UILabel alloc] initWithFrame: CGRectMake(0, fy, 320, 30)];
                lblTop.font = [UIFont systemFontOfSize: 14.0f];
                lblTop.backgroundColor = [UIColor colorWithRed: 163.0f/255.0f green: 173.0f/255.0f blue: 182.0f/255.0f alpha: 1.0f];
                NSString* msg_comment_date = [dicMessageComment valueForKey: @"msg_comment_date"];
                lblTop.text = [NSString stringWithFormat: @"   Comment on %@", msg_comment_date];
                [m_scrollComments addSubview: lblTop];
                
                fy += lblTop.frame.size.height + 10;

                NSString* comment = [[PWCAppDelegate getDelegate] decodeBase64String: [dicMessageComment valueForKey: @"msg_comment_details"]];
                UILabel* lblComment = [[UILabel alloc] initWithFrame: CGRectMake(10, fy, 290, 30)];
                lblComment.font = [UIFont systemFontOfSize: 14.0f];
                lblComment.numberOfLines = 0;
                lblComment.text = comment;
                [lblComment sizeToFit];
                [m_scrollComments addSubview: lblComment];
                
                fy += lblComment.frame.size.height + 5;
                
                NSString* CommentFiles = [dicMessageComment valueForKey: @"msg_comment_files"];
                if(CommentFiles != nil && [CommentFiles length] > 0)
                {
                    NSArray* arrCommentFilesID = [CommentFiles componentsSeparatedByString: @","];
                    if(arrCommentFilesID != nil && [arrCommentFilesID count] > 0)
                    {
                        UIImageView* imgDotLine = [[UIImageView alloc] initWithImage: [UIImage imageNamed: @"dot_line.png"]];
                        imgDotLine.frame = CGRectMake(0, fy, 320, 1);
                        [m_scrollComments addSubview: imgDotLine];
                        
                        fy += 3;
                        
                        UILabel* lblFilesAttached = [[UILabel alloc] initWithFrame: CGRectMake(10, fy, 290, 30)];
                        lblFilesAttached.text = @"File(s) Attached:";
                        lblFilesAttached.font = [UIFont systemFontOfSize: 14.0f];
                        [m_scrollComments addSubview: lblFilesAttached];
                        
                        fy += 30;
                        
                        UIScrollView* scrollCommentFiles = [[UIScrollView alloc] initWithFrame: CGRectMake(0, fy, 320, 60)];
                        
                        for(int j = 0; j < [arrCommentFilesID count]; j++)
                        {
                            NSString* commentFileId = [arrCommentFilesID objectAtIndex: j];
                            NSDictionary* dicCommentFile = [[DataManager sharedScoreManager] getPMMessageFile: commentFileId];
                            
                            UIButton* btnComment = [[UIButton alloc] initWithFrame: CGRectMake(j * (35 + 20) + 30, 10, 18, 23)];
                            [btnComment setImage: [UIImage imageNamed: @"file_icon.png"] forState: UIControlStateNormal];
                            btnComment.tag = [[dicCommentFile valueForKey: @"fileid"] intValue];
                            [btnComment addTarget: self action: @selector(actionFileURL:) forControlEvents: UIControlEventTouchUpInside];
                            [scrollCommentFiles addSubview: btnComment];
                            
                            UILabel* lblFileName = [[UILabel alloc] initWithFrame: CGRectMake(j * (35 + 20) + 5, 35, 70, 25)];
                            lblFileName.font = [UIFont systemFontOfSize: 12.0f];
                            lblFileName.backgroundColor = [UIColor clearColor];
                            lblFileName.text = [dicCommentFile valueForKey: @"filename"];
//                            [lblFileName sizeToFit];
                            lblFileName.textAlignment = NSTextAlignmentCenter;
                            lblFileName.center = CGPointMake(btnComment.center.x, lblFileName.center.y);
                            [scrollCommentFiles addSubview: lblFileName];
                        }
                        
                        [scrollCommentFiles setContentSize: CGSizeMake([arrCommentFilesID count] * 35 + 50, scrollCommentFiles.contentSize.height)];
                        [m_scrollComments addSubview: scrollCommentFiles];
                        
                        fy += 60;
                    }
                }
            }
        }
    }
    
    m_scrollComments.frame = CGRectMake(m_scrollComments.frame.origin.x,
                                        m_scrollComments.frame.origin.y,
                                        m_scrollComments.frame.size.width,
                                        fy);

    //Comment Post.
    m_viewAddComment.frame = CGRectMake(m_viewAddComment.frame.origin.x,
                                        m_scrollComments.frame.origin.y + m_scrollComments.frame.size.height + 10,
                                        m_viewAddComment.frame.size.width,
                                        m_viewAddComment.frame.size.height);
    
    //Notification Users.
    
    [m_arrPeopleCheckBox removeAllObjects];
    
    for(UIView* view in m_viewNotitification.subviews)
    {
        [view removeFromSuperview];
    }
    
    m_viewNotitification.frame = CGRectMake(m_viewNotitification.frame.origin.x,
                                            m_viewAddComment.frame.origin.y + m_viewAddComment.frame.size.height + 20,
                                            m_viewNotitification.frame.size.width,
                                            m_viewNotitification.frame.size.height);
    
    NSArray* arrUserList = [[DataManager sharedScoreManager] getAllPMTaskUserListByProjectID: self.m_strProjectID];
    
    if(arrUserList != nil && [arrUserList count] > 0)
    {
        float fy1 = 0;
        for(int i = 0; i < [arrUserList count]; i++)
        {
            NSDictionary* dicCompany = [arrUserList objectAtIndex: i];
            
            SSCheckBoxView *cbv = [[SSCheckBoxView alloc] initWithFrame: CGRectMake(0, fy1, 280, 30)
                                                                  style: 2
                                                                checked: NO];
            [cbv setText: [dicCompany valueForKey: @"tc_companyname"]];
            cbv.tag = [[dicCompany valueForKey: @"tc_comapnyid"] intValue];
            [cbv setStateChangedTarget:self
                              selector:@selector(checkCompanyChanged:)];
            [m_viewNotitification addSubview: cbv];
            
            fy1 += 30;
            
            NSString* people = [dicCompany valueForKey: @"people"];
            if(people != nil && [people length] > 0)
            {
                NSArray* arrPeople = [people componentsSeparatedByString: @","];
                if(arrPeople != nil && [arrPeople count] > 0)
                {
                    for(int j = 0; j < [arrPeople count]; j++)
                    {
                        NSString* strPeopleID = [arrPeople objectAtIndex: j];
                        NSDictionary* dicPeople = [[DataManager sharedScoreManager] getPMTaskPeopleByTPID: strPeopleID];
                        SSCheckBoxView *cbv = [[SSCheckBoxView alloc] initWithFrame: CGRectMake(30, fy1, 200, 30)
                                                                              style: 2
                                                                            checked: NO];
                        [cbv setText: [NSString stringWithFormat: @"%@ %@", [dicPeople valueForKey: @"tp_firstname"], [dicPeople valueForKey: @"tp_lastname"]]];
                        [cbv setSubTextStyle];
                        cbv.tag = [strPeopleID intValue];
                        [m_arrPeopleCheckBox addObject: cbv];
                        [m_viewNotitification addSubview: cbv];
                    }
                    
                    fy1 += 30;
                }
            }
        }
        
        m_viewNotitification.frame = CGRectMake(m_viewNotitification.frame.origin.x,
                                                m_viewNotitification.frame.origin.y,
                                                m_viewNotitification.frame.size.width,
                                                fy1);
    }
    
    
    m_btnSubmit.frame = CGRectMake(m_btnSubmit.frame.origin.x,
                                   m_viewNotitification.frame.origin.y + m_viewNotitification.frame.size.height + 10,
                                   m_btnSubmit.frame.size.width,
                                   m_btnSubmit.frame.size.height);

    
    NSLog(@"m_btnSubmit = %f", m_viewAddComment.frame.origin.y + m_viewAddComment.frame.size.height + 10);
    [m_scrollDetail setContentSize: CGSizeMake(m_scrollDetail.contentSize.width, m_btnSubmit.frame.origin.y + m_btnSubmit.frame.size.height + 100)];
}

//==============================================================================================================
-(void) checkCompanyChanged: (SSCheckBoxView *)cbv
{
    NSString* companyid = [NSString stringWithFormat: @"%d", cbv.tag];
    NSDictionary* dicCompany = [[DataManager sharedScoreManager] getPMTaskUserListById: companyid project_id: self.m_strProjectID];
    NSString* people = [dicCompany valueForKey: @"people"];
    if(people != nil && [people length] > 0)
    {
        NSArray* arrPeople = [people componentsSeparatedByString: @","];
        if(arrPeople != nil && [arrPeople count] > 0)
        {
            for(int j = 0; j < [arrPeople count]; j++)
            {
                int nPeopleID = [[arrPeople objectAtIndex: j] intValue];
                for(int k = 0; k < [m_arrPeopleCheckBox count]; k++)
                {
                    SSCheckBoxView* checkBox = [m_arrPeopleCheckBox objectAtIndex: k];
                    
                    if(checkBox.tag == nPeopleID)
                    {
                        [checkBox setChecked: cbv.checked];
                    }
                }
            }
        }
    }
}

//==============================================================================================================
-(void) getMessageDetail
{
    [SVProgressHUD showWithStatus:@"Loading ..." maskType:SVProgressHUDMaskTypeBlack];
    NSString* strURL = [@"https://pwcproject.com/v2/mobilepm/api/messagedetails" stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    
    NSLog(@"account_id = %@", [PWCGlobal getTheGlobal].account_id);
    NSLog(@"userhash = %@", [PWCGlobal getTheGlobal].hashKey);
    NSLog(@"message_id = %@", self.m_strMessageID);
    
    ASIFormDataRequest* request = [ASIFormDataRequest requestWithURL: [NSURL URLWithString: strURL]];
    [request setDelegate: self];
    [request setTimeOutSeconds: REQUEST_TIME_OUT];
    [request setPostValue: [PWCGlobal getTheGlobal].account_id forKey: @"account_id"];
    [request setPostValue: [PWCGlobal getTheGlobal].hashKey forKey: @"userhash"];
    [request setPostValue: self.m_strMessageID forKey: @"message_id"];
    
    [request setDidFinishSelector: @selector(finishedGetMessageDetail:)];
    [request setDidFailSelector: @selector(failedSync:)];
    [request startAsynchronous];
}

//==============================================================================================================
-(void) finishedGetMessageDetail: (ASIFormDataRequest*) theRequest
{
    [SVProgressHUD showSuccessWithStatus:@"Syncing Successful."];
    NSString* strResponse = [theRequest responseString];
    NSDictionary* dicList = [strResponse JSONValue];
    
//    NSLog(@"arrList = %@", dicList);
    NSArray* arrComments = [dicList valueForKey: @"messageComment"];
    
    NSString* comments = @"";
    if(arrComments != nil && [arrComments count] > 0)
    {
        for(int i = 0; i < [arrComments count]; i++)
        {
            NSDictionary* dicMessageRecord = [arrComments objectAtIndex: i];
            NSDictionary* dicCommentFiles = [dicMessageRecord valueForKey: @"msg_comment_files"];
            NSArray* arrCommentFilesKey = [dicCommentFiles allKeys];
            
            NSString* strFileID = @"";
            if(arrCommentFilesKey != nil && [arrCommentFilesKey count] > 0)
            {
                for(int j = 0; j < [arrCommentFilesKey count]; j++)
                {
                    NSString* fileid = [arrCommentFilesKey objectAtIndex: j];
                    NSDictionary* dicCommentFile = [dicCommentFiles valueForKey: fileid];
                    [[DataManager sharedScoreManager] insertPMMessageFile: fileid
                                                             filename: [dicCommentFile valueForKey: @"filename"]
                                                              fileurl: [dicCommentFile valueForKey: @"fileurl"]];
                    
                    if(strFileID == nil || [strFileID length] <= 0)
                    {
                        strFileID = fileid;
                    }
                    else
                    {
                        strFileID = [strFileID stringByAppendingString: [NSString stringWithFormat: @",%@", fileid]];
                    }
                }
            }
            [[DataManager sharedScoreManager] insertPMMessageComment: [dicMessageRecord valueForKey: @"msg_comment_id"]
                                                msg_comment_peopleid: [dicMessageRecord valueForKey: @"msg_comment_peopleid"]
                                                msg_comment_submitby: [dicMessageRecord valueForKey: @"msg_comment_submitby"]
                                                 msg_comment_adminid: [dicMessageRecord valueForKey: @"msg_comment_adminid"]
                                                    msg_comment_date: [dicMessageRecord valueForKey: @"msg_comment_date"]
                                                 msg_comment_details: [dicMessageRecord valueForKey: @"msg_comment_details"]
                                                   msg_comment_files: strFileID];
            
            NSLog(@"saved comment = %@", [[DataManager sharedScoreManager] getAllPMMessageComments]);
            if(comments == nil || [comments length] <= 0)
            {
                comments = [dicMessageRecord valueForKey: @"msg_comment_id"];
            }
            else
            {
                comments = [comments stringByAppendingString: [NSString stringWithFormat: @",%@", [dicMessageRecord valueForKey: @"msg_comment_id"]]];
            }
        }
    }
    
    //Message File.
    NSString* messageFile = @"";
    NSArray* arrMessageFiles = [dicList valueForKey: @"messageFile"];
    if(arrMessageFiles != nil && [arrMessageFiles count] > 0)
    {
        for(int i = 0; i < [arrMessageFiles count]; i++)
        {
            NSDictionary* dicMessageFile = [arrMessageFiles objectAtIndex: i];
            [[DataManager sharedScoreManager] insertPMMessageFile: [dicMessageFile valueForKey: @"fileid"]
                                                         filename: [dicMessageFile valueForKey: @"filename"]
                                                          fileurl: [dicMessageFile valueForKey: @"fileurl"]];
            
            if(messageFile == nil || [messageFile length] <= 0)
            {
                messageFile = [dicMessageFile valueForKey: @"fileid"];
            }
            else
            {
                messageFile = [messageFile stringByAppendingString: [NSString stringWithFormat: @",%@", [dicMessageFile valueForKey: @"fileid"]]];
            }
        }
    }
    
    NSLog(@"postTo = %@", [[PWCAppDelegate getDelegate] decodeBase64String: [dicList valueForKey: @"PostedTo"]]);
    [[DataManager sharedScoreManager] insertPMMessageDetail: [dicList valueForKey: @"messageID"]
                                           messageProjectId: [dicList valueForKey: @"messageProjectId"]
                                             messageSubject: [dicList valueForKey: @"messageSubject"]
                                                   postedBy: [dicList valueForKey: @"PostedBy"]
                                                   postedTo: [dicList valueForKey: @"PostedTo"]
                                                messageBody: [dicList valueForKey: @"messageBody"]
                                             messageComment: comments
                                                messageFile: messageFile];
    
    NSDictionary* dicDetail = [[DataManager sharedScoreManager] getPMMessageDetail: [dicList valueForKey: @"messageID"]];
    [self updateContent: dicDetail];
}

//==============================================================================================================
-(void) failedSync: (ASIFormDataRequest*) theRequest
{
    [SVProgressHUD showSuccessWithStatus:@"Syncing Failed."];
}

//==============================================================================================================
-(IBAction) actionSync:(id)sender
{
    [self getMessageDetail];
}

//==============================================================================================================
-(void)actionFileURL: (UIButton*) btn
{
    NSDictionary* dicFile = [[DataManager sharedScoreManager] getPMMessageFile: [NSString stringWithFormat: @"%d", btn.tag]];
    NSURL* url = [NSURL URLWithString: [dicFile valueForKey: @"fileurl"]];
    [[UIApplication sharedApplication] openURL: url];
}

//==============================================================================================================
-(IBAction) actionInputDone:(id)sender
{
    [m_txtCommentPost resignFirstResponder];
}

//==============================================================================================================
-(IBAction) actionSegment:(UISegmentedControl*)sender
{
    int nIndex = sender.selectedSegmentIndex;
    
    m_viewDetail.hidden = YES;
    m_viewSummary.hidden = YES;
    if(nIndex == 0)
    {
        m_viewDetail.hidden = NO;
    }
    else
    {
        m_viewSummary.hidden = NO;
    }
}

#pragma mark - Table view data source

//==============================================================================================================
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

//==============================================================================================================
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Notified To";
}

//==============================================================================================================
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [m_arrNotifiedList count];
}

//==============================================================================================================
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSString* strUser = [m_arrNotifiedList objectAtIndex: indexPath.row];
    cell.textLabel.text = strUser;
    [cell setSelectionStyle: UITableViewCellSelectionStyleNone];
    
    return cell;
}

//==============================================================================================================
-(IBAction) actionSubmit:(id)sender
{
    [m_txtCommentPost resignFirstResponder];
    
    NSString* msgcomment = m_txtCommentPost.text;
    if(msgcomment == nil || [msgcomment length] <= 0)
    {
        [[PWCAppDelegate getDelegate] showMessage: @"Please Input Valid Message Comment."];
        return;
    }
    
    NSString* checksuperadmin = @"1";
    NSString* people;
    for(int i = 0; i < [m_arrPeopleCheckBox count]; i++)
    {
        SSCheckBoxView* box = [m_arrPeopleCheckBox objectAtIndex: i];
        if(box.checked)
        {
            NSString* peopleID = [NSString stringWithFormat: @"%d", box.tag];
            if(people == nil || [people length] <= 0)
            {
                people = peopleID;
            }
            else
            {
                people = [people stringByAppendingString: [NSString stringWithFormat: @",%@", peopleID]];
            }
        }
    }
    
    [SVProgressHUD showWithStatus:@"Loading ..." maskType:SVProgressHUDMaskTypeBlack];
    NSString* strURL = [@"https://pwcproject.com/v2/mobilepm/api/addmessagecomment" stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    
    ASIFormDataRequest* request = [ASIFormDataRequest requestWithURL: [NSURL URLWithString: strURL]];
    [request setDelegate: self];
    [request setTimeOutSeconds: REQUEST_TIME_OUT];    
    [request setPostValue: [PWCGlobal getTheGlobal].account_id forKey: @"account_id"];
    [request setPostValue: [PWCGlobal getTheGlobal].hashKey forKey: @"userhash"];
    [request setPostValue: self.m_strProjectID forKey: @"project_id"];
    [request setPostValue: self.m_strMessageID forKey: @"message_id"];
    [request setPostValue: msgcomment forKey: @"msgcomment"];
    [request setPostValue: checksuperadmin forKey: @"checksuperadmin"];
    [request setPostValue: people forKey: @"people"];
    
    [request setDidFinishSelector: @selector(finishedAddMessageComment:)];
    [request setDidFailSelector: @selector(failedSync:)];
    [request startAsynchronous];
}

//==============================================================================================================
-(void) finishedAddMessageComment: (ASIFormDataRequest*) theRequest
{
    [SVProgressHUD showSuccessWithStatus:@"Syncing Successful."];
    m_txtCommentPost.text = @"";
    
    NSString* strResponse = [theRequest responseString];
    NSLog(@"strResponse = %@", strResponse);
    
    [self getMessageDetail];
}

//==============================================================================================================
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    [self scrollViewToCenterOfScreen: m_viewAddComment];
    return YES;
}

//==============================================================================================================
- (void) scrollViewToCenterOfScreen:(UIView *)theView
{
    CGFloat viewCenterY = theView.center.y;
    CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
    
    CGFloat availableHeight = applicationFrame.size.height - 300;            // Remove area covered by keyboard
    
    CGFloat y = viewCenterY - availableHeight / 2.0;
    
    if (y < 0)
    {
        y = 0;
    }
    [m_scrollDetail setContentOffset:CGPointMake(0, y) animated:YES];
}

//==============================================================================================================
@end
