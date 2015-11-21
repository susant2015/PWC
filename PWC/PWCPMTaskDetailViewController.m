
//
//  PWCPMTaskDetailViewController.m
//  PWC
//
//  Created by JianJinHu on 11/28/13.
//  Copyright (c) 2013 Premium Web Cart. All rights reserved.
//

#import "PWCPMTaskDetailViewController.h"
#import "ASIFormDataRequest.h"
#import "JSON.h"
#import "PWCGlobal.h"
#import "DataManager.h"
#import <QuartzCore/QuartzCore.h>
#import "PWCPMNotificationToViewController.h"
#import "PWCAppDelegate.h"
#import "PWCPMSprintViewController.h"
#import "SSCheckBoxView.h"

@interface PWCPMTaskDetailViewController ()

@end

@implementation PWCPMTaskDetailViewController
@synthesize m_strProjectID;
@synthesize m_strTodoID;
@synthesize m_strAssignedByID;
@synthesize m_strAssignedToID;
@synthesize m_strAllSprints;
@synthesize m_bUpdateFlag;

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
-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear: animated];
    if(![[PWCGlobal getTheGlobal].m_gSelectedSprintID isKindOfClass: [NSNull class]] && [PWCGlobal getTheGlobal].m_gSelectedSprintID != nil && [[PWCGlobal getTheGlobal].m_gSelectedSprintID length] > 0)
    {
        NSString* sprintName = [[DataManager sharedScoreManager] getPMSprintNameByID: [PWCGlobal getTheGlobal].m_gSelectedSprintID];
        m_lblSprint.text = sprintName;
    }
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
    [PWCGlobal getTheGlobal].m_gPMTaskDetailController = self;
    m_imgAssignedBySub.hidden = YES;
    m_bUpdateFlag = NO;
    
    [self updateMainView: 0];
    
    m_arrStatus = [[NSMutableArray alloc] init];
    m_arrPeopleCheckBox = [[NSMutableArray alloc] init];
    
    [m_txtComment setInputAccessoryView: m_topToolBar];
    m_txtComment.layer.masksToBounds = YES;
    m_txtComment.layer.borderWidth = 1.0f;
    m_txtComment.layer.cornerRadius = 5.0f;
    m_txtComment.layer.borderColor = [UIColor grayColor].CGColor;

    NSArray* arr = [[DataManager sharedScoreManager] getPMTaskDetails: self.m_strTodoID ProjId: self.m_strProjectID];
    if(arr == nil || [arr count] <= 0)
    {
        [self getTaskDetail];
    }
    else
    {
        NSDictionary* dicDetail = [arr objectAtIndex: 0];
        
        m_lblTaskName.text = [[PWCAppDelegate getDelegate] decodeBase64String: [self checkString: [dicDetail valueForKey: @"TodoTitle"]]];
        m_lblPriority.text = [self checkString: [dicDetail valueForKey: @"Priority"]];
        m_lblFirstPostOn.text = [self checkString: [dicDetail valueForKey: @"Date"]];
        m_lblAssignedBy.text = [NSString stringWithFormat: @"%@ %@",
                                [self checkString: [dicDetail valueForKey: @"assignedby_firstname"]],
                                [self checkString: [dicDetail valueForKey: @"assignedby_lastname"]]];
        m_lblAssignedTo.text = [NSString stringWithFormat: @"%@ %@",
                                [self checkString: [dicDetail valueForKey: @"assignedto_firstname"]],
                                [self checkString: [dicDetail valueForKey: @"assignedto_lastname"]]];
        m_lblSprint.text = [self checkString: [dicDetail valueForKey: @"sprintname"]];
        m_lblDuration.text = [self checkString: [dicDetail valueForKey: @"Duration"]];
        m_lblStartDate.text = [self checkString: [dicDetail valueForKey: @"startdate"]];
        m_lblEndDate.text = [self checkString: [dicDetail valueForKey: @"enddate"]];
        self.m_strAssignedByID = [self checkString: [dicDetail valueForKey: @"assignbyid"]];
        self.m_strAllSprints = [dicDetail valueForKey: @"allsprint"];
        [PWCGlobal getTheGlobal].m_gSelectedSprintID = [dicDetail valueForKey: @"SprintId"];
        
//        if(self.m_strAssignedByID == nil || [self.m_strAssignedByID length] <= 0)
//        {
//            m_imgAssignedBySub.hidden = YES;
//        }
//        
        self.m_strAssignedToID = [self checkString: [dicDetail valueForKey: @"assigntoid"]];
//        if(self.m_strAssignedToID == nil || [self.m_strAssignedToID length] <= 0)
//        {
//            m_imgAssignedToSub.hidden = YES;
//        }
        
        m_lblTaskDescription.text = [[PWCAppDelegate getDelegate] decodeBase64String: [dicDetail valueForKey: @"task_description"]];

        NSString* taskDetailComment = [dicDetail valueForKey: @"taskdetailcomment"];
        [self updateCommentView: taskDetailComment];
        
        NSString* taskprogress = [dicDetail valueForKey: @"taskprogress"];
        [self updateStatus: taskprogress];

        NSString* taskemaillist = [dicDetail valueForKey: @"taskemaillist"];            
        [self updateTaskEmailList: taskemaillist];
    }
}

//==============================================================================================================
-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    if(m_bUpdateFlag)
    {
        m_bUpdateFlag = NO;
        [self getTaskDetail];
    }
}

//==============================================================================================================
-(void) updateTaskEmailList: (NSString*) taskemaillist
{
    [m_arrPeopleCheckBox removeAllObjects];
    
    //Remove All User List.
    for(UIView* view in m_viewUserList.subviews)
    {
        [view removeFromSuperview];
    }

    //Add All User List.
    float fy = m_viewCommentPost.frame.origin.y + m_viewCommentPost.frame.size.height;
    m_viewUserList.frame = CGRectMake(m_viewUserList.frame.origin.x, fy, 0, 0);
    
    if(taskemaillist != nil && [taskemaillist length] > 0)
    {
        NSArray* arrUserList = [taskemaillist componentsSeparatedByString: @","];
        float fy1 = 0;
        if(arrUserList != nil && [arrUserList count] > 0)
        {
            for(int i = 0; i < [arrUserList count]; i++)
            {
                NSString* companyid = [arrUserList objectAtIndex: i];
                SSCheckBoxView *cbv = [[SSCheckBoxView alloc] initWithFrame: CGRectMake(0, fy1, 280, 30)
                                                                      style: 2
                                                                    checked: NO];
                cbv.tag = [companyid intValue];
                [cbv setStateChangedTarget:self
                                  selector:@selector(checkCompanyChanged:)];
                [m_viewUserList addSubview: cbv];
                
                NSDictionary* dicCompany = [[DataManager sharedScoreManager] getPMTaskUserListById: companyid project_id: self.m_strProjectID];
                [cbv setText: [dicCompany valueForKey: @"tc_companyname"]];
                
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
                            cbv.tag = [strPeopleID intValue];
                            [m_arrPeopleCheckBox addObject: cbv];
                            
                            [cbv setText: [NSString stringWithFormat: @"%@ %@", [dicPeople valueForKey: @"tp_firstname"], [dicPeople valueForKey: @"tp_lastname"]]];
                            [cbv setSubTextStyle];
                            
                            [m_viewUserList addSubview: cbv];
                            fy1 += 30;
                        }
                        
//                        fy1 += 30;
                    }
                }
            }
        }
        
        [m_scrollDetail addSubview: m_viewUserList];
        m_viewUserList.frame = CGRectMake(m_viewUserList.frame.origin.x,
                                             m_viewUserList.frame.origin.y,
                                             320,
                                             fy1);
        
        fy += fy1;
    }
    
    fy += 50;
    
    m_btnSubmit.frame = CGRectMake(m_btnSubmit.frame.origin.x, fy, m_btnSubmit.frame.size.width, m_btnSubmit.frame.size.height);
    [m_scrollDetail setContentSize: CGSizeMake(m_scrollDetail.contentSize.width, m_btnSubmit.frame.origin.y + m_btnSubmit.frame.size.height + 20)];
}

//==============================================================================================================
-(void) updateStatus: (NSString*) taskprogress
{
    [m_arrStatus removeAllObjects];
    
    NSArray* arrStatus = [[DataManager sharedScoreManager] getPMTaskProgressByPathId: taskprogress];
    if(arrStatus != nil && [arrStatus count] > 0)
    {
        NSDictionary* dicStatus = [arrStatus objectAtIndex: 0];
        NSString* progress_bar = [dicStatus valueForKey: @"progress_bar"];
        if(progress_bar != nil && [progress_bar length] > 0)
        {
            NSArray* arrStatus = [progress_bar componentsSeparatedByString: @","];
            if(arrStatus != nil && [arrStatus count] > 0)
            {
                for(int i = 0; i < [arrStatus count]; i++)
                {
                    NSString* strID = [arrStatus objectAtIndex: i];
                    NSArray* arrItem = [[DataManager sharedScoreManager] getPMProgressBarById: strID];
                    if(arrItem != nil && [arrItem count] > 0)
                    {
                        NSDictionary* dicItem = [arrItem objectAtIndex: 0];
                        [m_arrStatus addObject: dicItem];
                    }
                }
            }
        }
        
        NSString* approve_title = [dicStatus valueForKey: @"approve_title"];
        NSString* unapprove_title = [dicStatus valueForKey: @"unapprove_title"];
        
        NSDictionary* dicApprove = [NSDictionary dictionaryWithObjects: [NSArray arrayWithObjects: @"1", approve_title, nil] forKeys: [NSArray arrayWithObjects: @"Id", @"title", nil]];
        NSDictionary* dicUnApprove = [NSDictionary dictionaryWithObjects: [NSArray arrayWithObjects: @"2", unapprove_title, nil] forKeys: [NSArray arrayWithObjects: @"Id", @"title", nil]];
        
        [m_arrStatus addObject: dicApprove];
        [m_arrStatus addObject: dicUnApprove];
    }
    
    [m_tableStatus reloadData];
}

//==============================================================================================================
-(NSString*) checkString: (NSString*) strValue
{
    if(strValue == nil || [strValue isKindOfClass: [NSNull class]] || [strValue isEqualToString: @"<null>"])
    {
        return @"";
    }
    
    return strValue;
}

//==============================================================================================================
-(void) updateMainView: (int) nSelected
{
    m_viewDetails.hidden = YES;
    m_viewStatus.hidden = YES;
    m_viewSummary.hidden = YES;
    
    switch (nSelected)
    {
        case 0:
            m_viewDetails.hidden = NO;
            break;
           
        case 1:
            m_viewStatus.hidden = NO;
            break;
            
        case 2:
            m_viewSummary.hidden = NO;
            break;
            
        default:
            break;
    }
}

//==============================================================================================================
-(NSString*) convertDate: (NSString*) strDate
{
    if([strDate isKindOfClass: [NSNull class]] || [strDate length] <= 0) return @"None";
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    NSDate* date = [formatter dateFromString: strDate];
    
    [formatter setDateFormat: @"EEE, dd MMM, yyyy"];
    return [formatter stringFromDate: date];
}

//==============================================================================================================
-(void) updateCommentView: (NSString*) taskDetailComments
{
    float fy = 0;
    
    NSArray* arrList = [taskDetailComments componentsSeparatedByString: @","];
    if([taskDetailComments length] <= 0 || arrList == nil || [arrList count] < 1)
    {
        m_lblCommentCount.hidden = YES;
        m_scrollComment.hidden = YES;
        m_lblCommentCount.text = [NSString stringWithFormat: @"Comment: %d", 0];
        
        m_viewCommentPost.frame = CGRectMake(m_viewCommentPost.frame.origin.x,
                                             m_scrollComment.frame.origin.y,
                                             m_viewCommentPost.frame.size.width,
                                             m_viewCommentPost.frame.size.height);
    }
    else
    {
        m_lblCommentCount.hidden = NO;
        m_lblCommentCount.text = [NSString stringWithFormat: @"Comment: %d", [arrList count]];
        m_scrollComment.hidden = NO;
        for(UIView* view in m_scrollComment.subviews)
        {
            [view removeFromSuperview];
        }
        
        for(int i = 0; i < [arrList count]; i++)
        {
            NSString* strID = [arrList objectAtIndex: i];
            NSLog(@"strID = %@", strID);
            NSArray* arrRecord = [[DataManager sharedScoreManager] getPMTaskDetailComment: strID];
            if(arrRecord != nil && [arrRecord count] > 0)
            {
                NSDictionary* dic = [arrRecord objectAtIndex: 0];
                
                UILabel* lblTop = [[UILabel alloc] initWithFrame: CGRectMake(0, fy, 320, 30)];
                lblTop.font = [UIFont systemFontOfSize: 14.0f];
                lblTop.backgroundColor = [UIColor colorWithRed: 163.0f/255.0f green: 173.0f/255.0f blue: 182.0f/255.0f alpha: 1.0f];
                NSString* strDate = [dic valueForKey: @"comment_date"];
                NSString* PeopleId = [dic valueForKey: @"comment_peopleid"];
                
                NSArray* arrPeople = [[DataManager sharedScoreManager] getPMTaskPeopleByID: PeopleId];
                
                NSString* strName = @"";
                if(arrPeople != nil && [arrPeople count] > 0)
                {
                    NSDictionary* dicPeople = [arrPeople objectAtIndex: 0];
                    NSString* firstName = [dicPeople valueForKey: @"tp_firstname"];
                    NSString* lastName = [dicPeople valueForKey: @"tp_lastname"];
                    strName = [NSString stringWithFormat: @"%@ %@", firstName, lastName];
                }
                
                lblTop.text = [NSString stringWithFormat: @"   %@ Posted on %@", strName, strDate];
                [m_scrollComment addSubview: lblTop];
                
                fy += lblTop.frame.size.height + 10;
                
                NSString* comment = [self checkString: [[PWCAppDelegate getDelegate] decodeBase64String: [dic valueForKey: @"comment_description"]]];
                UILabel* lblComment = [[UILabel alloc] initWithFrame: CGRectMake(10, fy, 290, 30)];
                lblComment.font = [UIFont systemFontOfSize: 14.0f];
                lblComment.numberOfLines = 0;
                lblComment.text = comment;
                [lblComment sizeToFit];
                [m_scrollComment addSubview: lblComment];
                
                fy += lblComment.frame.size.height + 5;
                
                NSString* CommentFiles = [dic valueForKey: @"Comment_files"];
                if(CommentFiles != nil && [CommentFiles length] > 0)
                {
                    NSArray* arrCommentFilesID = [CommentFiles componentsSeparatedByString: @","];
                    if(arrCommentFilesID != nil && [arrCommentFilesID count] > 0)
                    {
                        UIImageView* imgDotLine = [[UIImageView alloc] initWithImage: [UIImage imageNamed: @"dot_line.png"]];
                        imgDotLine.frame = CGRectMake(0, fy, 320, 1);
                        [m_scrollComment addSubview: imgDotLine];
                        
                        fy += 3;
                        
                        UILabel* lblFilesAttached = [[UILabel alloc] initWithFrame: CGRectMake(10, fy, 290, 30)];
                        lblFilesAttached.text = @"File(s) Attached:";
                        lblFilesAttached.font = [UIFont systemFontOfSize: 14.0f];
                        [m_scrollComment addSubview: lblFilesAttached];
                        
                        fy += 30;
                        
                        UIScrollView* scrollCommentFiles = [[UIScrollView alloc] initWithFrame: CGRectMake(0, fy, 320, 60)];
                        
                        for(int j = 0; j < [arrCommentFilesID count]; j++)
                        {
                            NSString* commentFileId = [arrCommentFilesID objectAtIndex: j];
                            NSDictionary* dicCommentFile = [[DataManager sharedScoreManager] getPMTaskCommentFile: commentFileId];
                            
                            UIButton* btnComment = [[UIButton alloc] initWithFrame: CGRectMake(j * (35 + 20) + 30, 10, 18, 23)];
                            [btnComment setImage: [UIImage imageNamed: @"file_icon.png"] forState: UIControlStateNormal];
                            btnComment.tag = [[dicCommentFile valueForKey: @"fileid"] intValue];
                            [btnComment addTarget: self action: @selector(actionFileURL:) forControlEvents: UIControlEventTouchUpInside];
                            [scrollCommentFiles addSubview: btnComment];
                            
                            UILabel* lblFileName = [[UILabel alloc] initWithFrame: CGRectMake(j * (35 + 20) + 5, 35, 60, 25)];
                            lblFileName.font = [UIFont systemFontOfSize: 12.0f];
                            lblFileName.backgroundColor = [UIColor clearColor];
                            lblFileName.text = [dicCommentFile valueForKey: @"filname"];
                            lblFileName.textAlignment = NSTextAlignmentCenter;
                            lblFileName.center = CGPointMake(btnComment.center.x, lblFileName.center.y);
                            [scrollCommentFiles addSubview: lblFileName];
                        }
                        
                        [scrollCommentFiles setContentSize: CGSizeMake([arrCommentFilesID count] * 35 + 50, scrollCommentFiles.contentSize.height)];
                        [m_scrollComment addSubview: scrollCommentFiles];
                        
                        fy += 60;
                    }
                }
            }
        }
        m_scrollComment.frame = CGRectMake(m_scrollComment.frame.origin.x,
                                           m_scrollComment.frame.origin.y,
                                           m_scrollComment.frame.size.width,
                                           fy);
        m_viewCommentPost.frame = CGRectMake(m_viewCommentPost.frame.origin.x,
                                             m_scrollComment.frame.origin.y + m_scrollComment.frame.size.height + 10,
                                             m_viewCommentPost.frame.size.width,
                                             m_viewCommentPost.frame.size.height);

    }
}

//==============================================================================================================
-(void) getTaskDetail
{
    [SVProgressHUD showWithStatus:@"Loading ..." maskType:SVProgressHUDMaskTypeBlack];
    NSString* strURL = [@"https://pwcproject.com/v2/mobilepm/api/taskdetails" stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    
//    NSLog(@"account_id = %@", [PWCGlobal getTheGlobal].account_id);
//    NSLog(@"userhash = %@", [PWCGlobal getTheGlobal].hashKey);
//    NSLog(@"project_id = %@", self.m_strProjectID);
//    NSLog(@"todoid = %@", self.m_strTodoID);
//    NSLog(@"strURL = %@", strURL);
    
    ASIFormDataRequest* request = [ASIFormDataRequest requestWithURL: [NSURL URLWithString: strURL]];
    [request setDelegate: self];
    [request setTimeOutSeconds: REQUEST_TIME_OUT];
    [request setPostValue: [PWCGlobal getTheGlobal].account_id forKey: @"account_id"];
    [request setPostValue: [PWCGlobal getTheGlobal].hashKey forKey: @"userhash"];
    [request setPostValue: self.m_strProjectID forKey: @"project_id"];
    [request setPostValue: self.m_strTodoID forKey: @"todoid"];
    
    [request setDidFinishSelector: @selector(finishedGetTaskDetail:)];
    [request setDidFailSelector: @selector(failedSync:)];
    [request startAsynchronous];
}

//==============================================================================================================
-(void) finishedGetTaskDetail: (ASIFormDataRequest*) theRequest
{
    [SVProgressHUD showSuccessWithStatus:@"Syncing Successful."];

    NSString* strResponse = [theRequest responseString];
    NSDictionary* dicList = [strResponse JSONValue];
    
    if(dicList == nil) return;
    [[DataManager sharedScoreManager] deletePMTaskDetails: self.m_strTodoID ProjId: self.m_strProjectID];
    NSDictionary* dicDetail = [dicList valueForKey: @"taskdetail"];

    NSLog(@"dicList = %@", dicList);
    
    //Task Email List
    NSString* taskemaillist = @"";
    NSDictionary* dicTaskEmailList = [dicDetail valueForKey: @"taskemaillist"];
    if(dicTaskEmailList != nil && [dicTaskEmailList isKindOfClass: [NSDictionary class]])
    {
        NSArray* arrTaskEmailList1 = [dicTaskEmailList allValues];
        if(arrTaskEmailList1 != nil && [arrTaskEmailList1 count] > 0)
        {
            for(int i = 0; i < [arrTaskEmailList1 count]; i++)
            {
                NSDictionary* dicTaskEmail = [arrTaskEmailList1 objectAtIndex: i];
                NSString* people = @"";
                NSDictionary* dicPeople = [dicTaskEmail valueForKey: @"people"];
                NSArray* arrPeople = [dicPeople allValues];
                if(arrPeople != nil && [arrPeople count] > 0)
                {
                    for(int j = 0; j < [arrPeople count]; j++)
                    {
                        NSDictionary* dicPeople = [arrPeople objectAtIndex: j];
                        [[DataManager sharedScoreManager] insertPMTaskPeople: [dicPeople valueForKey: @"tc_companyname"]
                                                                       tc_id: [dicPeople valueForKey: @"tc_id"]
                                                                 tc_ismaster: [dicPeople valueForKey: @"tc_ismaster"]
                                                                     tc_type: [dicPeople valueForKey: @"tc_type"]
                                                                tp_firstname: [dicPeople valueForKey: @"tp_firstname"]
                                                                       tp_id: [dicPeople valueForKey: @"tp_id"]
                                                                 tp_lastname: [dicPeople valueForKey: @"tp_lastname"]
                                                                    selected: [dicPeople valueForKey: @"selected"]];
                        if(people == nil || [people length] <= 0)
                        {
                            people = [dicPeople valueForKey: @"tp_id"];
                        }
                        else
                        {
                            people = [people stringByAppendingString: [NSString stringWithFormat: @",%@", [dicPeople valueForKey: @"tp_id"]]];
                        }
                    }
                }
                [[DataManager sharedScoreManager] insertPMTaskUserList: [dicTaskEmail valueForKey: @"tc_comapnyid"]
                                                        tc_companyname: [dicTaskEmail valueForKey: @"tc_companyname"]
                                                           tc_ismaster: [dicTaskEmail valueForKey: @"tc_ismaster"]
                                                               tc_type: [dicTaskEmail valueForKey: @"tc_type"]
                                                                people: people
                                                            project_id: self.m_strProjectID];
                
                
                if(taskemaillist == nil || [taskemaillist length] <= 0)
                {
                    taskemaillist = [dicTaskEmail valueForKey: @"tc_comapnyid"];
                }
                else
                {
                    taskemaillist = [taskemaillist stringByAppendingString: [NSString stringWithFormat: @",%@", [dicTaskEmail valueForKey: @"tc_comapnyid"]]];
                }
            }
        }
        NSLog(@"taskemaillist = %@", taskemaillist);
    }

    //Comment
    NSArray* arrComments = [dicDetail valueForKey: @"taskdetailcomment"];
    NSString* taskdetailcomment = @"";
    if(arrComments != nil || [arrComments count] > 0)
    {
        for(int i = 0; i < [arrComments count]; i++)
        {
            NSDictionary* dicRecord = [arrComments objectAtIndex: i];
            
            NSString* Comment_files = @"";
            NSArray* arrCommentFiles = [dicRecord valueForKey: @"Comment_files"];
            if(arrCommentFiles != nil && [arrCommentFiles count] > 0)
            {
                for(int j = 0; j < [arrCommentFiles count]; j++)
                {
                    NSDictionary* dicComment = [arrCommentFiles objectAtIndex: j];
                    [[DataManager sharedScoreManager] insertPMTaskCommentFiles: [dicComment valueForKey: @"fileid"]
                                                                       fileurl: [dicComment valueForKey: @"fileurl"]
                                                                       filname: [dicComment valueForKey: @"filname"]
                                                                  uploadeddate: [dicComment valueForKey: @"uploadeddate"]];
                    
                    if(Comment_files == nil || [Comment_files length] <= 0)
                    {
                        Comment_files = [dicComment valueForKey: @"fileid"];
                    }
                    else
                    {
                        Comment_files = [Comment_files stringByAppendingString: [NSString stringWithFormat: @",%@", [dicComment valueForKey: @"fileid"]]];
                    }
                }
            }
            
            [[DataManager sharedScoreManager] insertPMTaskDetailComment: [dicRecord valueForKey: @"comment_adminid"]
                                                    comment_description: [dicRecord valueForKey: @"comment_description"]
                                                           comment_date: [dicRecord valueForKey: @"comment_date"]
                                                             comment_id: [dicRecord valueForKey: @"comment_id"]
                                                       comment_peopleid: [dicRecord valueForKey: @"comment_peopleid"]
                                                       comment_submitby: [dicRecord valueForKey: @"comment_submitby"]
                                                          Comment_files: Comment_files];
            
            NSString* Id = [dicRecord valueForKey: @"comment_id"];
            if(taskdetailcomment == nil || [taskdetailcomment length] <= 0)
            {
                taskdetailcomment = Id;
            }
            else
            {
                taskdetailcomment = [taskdetailcomment stringByAppendingString: [NSString stringWithFormat: @",%@", Id]];
            }
        }
    }

    //Sprint.
    NSArray* arrAllSprint = [dicDetail valueForKey: @"allsprint"];
    NSString* allsprint = [self updateSprintData: arrAllSprint];
    self.m_strAllSprints = allsprint;
    
    //TaskProgress.
    NSDictionary* dicTaskProgress = [dicDetail valueForKey: @"taskprogress"];
    NSDictionary* dicApproveUnApprove = [dicTaskProgress valueForKey: @"approve_unapprove"];
    
    NSArray* arrProgressBar = [dicTaskProgress valueForKey: @"progress_bar"];
    NSString* progress_bar = @"";
    
    if(arrProgressBar != nil && [arrProgressBar count] > 0)
    {
        for(int i = 0; i < [arrProgressBar count]; i++)
        {
            NSDictionary* dicProgressBar = [arrProgressBar objectAtIndex: i];
            [[DataManager sharedScoreManager] deletePMProgressBar: [dicProgressBar valueForKey: @"Id"]];
            
            
            [[DataManager sharedScoreManager] insertPMProgressBar: [dicProgressBar valueForKey: @"Id"]
                                                    progress_date: [dicProgressBar valueForKey: @"progress_date"]
                                                  progress_status: [dicProgressBar valueForKey: @"progress_status"]
                                                   progress_title: [dicProgressBar valueForKey: @"progress_title"]
                                                            title: [dicProgressBar valueForKey: @"title"]];
            if(progress_bar == nil || [progress_bar length] <= 0)
            {
                progress_bar = [dicProgressBar valueForKey: @"Id"];
            }
            else
            {
                progress_bar = [progress_bar stringByAppendingString: [NSString stringWithFormat: @",%@", [dicProgressBar valueForKey: @"Id"]]];
            }
        }
    }

    NSString* PathId = [dicTaskProgress valueForKey: @"PathId"];
    [[DataManager sharedScoreManager] deletePMTaskProgress: PathId];
    
    [[DataManager sharedScoreManager] insertPMTaskProgress: [dicTaskProgress valueForKey: @"PathId"]
                                                 ProjectId: [dicTaskProgress valueForKey: @"ProjectId"]
                                              progress_bar: progress_bar
                                             approve_title: [dicApproveUnApprove valueForKey: @"approve_title"]
                                                      date: [dicApproveUnApprove valueForKey: @"date"]
                                                    status: [dicApproveUnApprove valueForKey: @"status"]
                                              status_title: [dicApproveUnApprove valueForKey: @"status_title"]
                                           unapprove_title: [dicApproveUnApprove valueForKey: @"unapprove_title"]];

    [[DataManager sharedScoreManager] insertPMTaskDetail: [dicDetail valueForKey: @"AdminId"]
                                         CurrentStatusId: [dicDetail valueForKey: @"CurrentStatusId"]
                                                    Date: [dicDetail valueForKey: @"Date"]
                                                      Id: [dicDetail valueForKey: @"Id"]
                                                  IsArcv: [dicDetail valueForKey: @"IsArcv"]
                                                  IsLock: [dicDetail valueForKey: @"IsLock"]
                                                  PathId: [dicDetail valueForKey: @"PathId"]
                                                Priority: [dicDetail valueForKey: @"Priority"]
                                              PriorityId: [dicDetail valueForKey: @"PriorityId"]
                                                  ProjId: [dicDetail valueForKey: @"ProjId"]
                                                ProjName: [dicDetail valueForKey: @"ProjName"]
                                                SprintId: [dicDetail valueForKey: @"SprintId"]
                                             TaskTitleId: [dicDetail valueForKey: @"TaskTitleId"]
                                                   Title: [dicDetail valueForKey: @"Title"]
                                               TodoTitle: [dicDetail valueForKey: @"TodoTitle"]
                                                    Type: [dicDetail valueForKey: @"Type"]
                                                  UserId: [dicDetail valueForKey: @"UserId"]
                                              assignbyid: [dicDetail valueForKey: @"assignbyid"]
                                    assignedby_firstname: [dicDetail valueForKey: @"assignedby_firstname"]
                                     assignedby_lastname: [dicDetail valueForKey: @"assignedby_lastname"]
                                    assignedto_firstname: [dicDetail valueForKey: @"assignedto_firstname"]
                                     assignedto_lastname: [dicDetail valueForKey: @"assignedto_lastname"]
                                              assigntoid: [dicDetail valueForKey: @"assigntoid"]
                                     peopleResponsibleId: [dicDetail valueForKey: @"peopleResponsibleId"]
                                              sprintname: [dicDetail valueForKey: @"sprintname"]
                                       taskdetailcomment: taskdetailcomment
                                               ticket_id: [dicDetail valueForKey: @"ticket_id"]
                                             ticket_type: [dicDetail valueForKey: @"ticket_type"]
                                                Duration: [dicDetail valueForKey: @"Duration"]
                                                 enddate: [dicDetail valueForKey: @"enddate"]
                                               startdate: [dicDetail valueForKey: @"startdate"]
                                            taskprogress: PathId
                                        task_description: [dicDetail valueForKey: @"task_description"]
                                               allsprint: allsprint
                                           taskemaillist: taskemaillist];
    
    [PWCGlobal getTheGlobal].m_gSelectedSprintID = [dicDetail valueForKey: @"SprintId"];
    self.m_strAssignedByID = [self checkString: [dicDetail valueForKey: @"assignbyid"]];
    self.m_strAssignedToID = [self checkString: [dicDetail valueForKey: @"assigntoid"]];

    m_lblTaskName.text = [[PWCAppDelegate getDelegate] decodeBase64String: [self checkString: [dicDetail valueForKey: @"TodoTitle"]]];
    m_lblPriority.text = [self checkString: [dicDetail valueForKey: @"Priority"]];
    m_lblFirstPostOn.text = [self checkString: [dicDetail valueForKey: @"Date"]];
    m_lblAssignedBy.text = [NSString stringWithFormat: @"%@ %@",
                            [self checkString: [dicDetail valueForKey: @"assignedby_firstname"]],
                            [self checkString: [dicDetail valueForKey: @"assignedby_lastname"]]];
    m_lblAssignedTo.text = [NSString stringWithFormat: @"%@ %@",
                            [self checkString: [dicDetail valueForKey: @"assignedto_firstname"]],
                            [self checkString: [dicDetail valueForKey: @"assignedto_lastname"]]];
    
    //Sprint.
    NSString* strSprint = [dicDetail valueForKey: @"sprintname"];
    if(strSprint == nil || [strSprint isKindOfClass: [NSNull class]] || [strSprint isEqualToString: @"<null>"])
    {
        strSprint = @"Not Set";
    }
    m_lblSprint.text = strSprint;
    
    //Duration.
    NSString* strDuration = [dicDetail valueForKey: @"Duration"];
    if(strDuration == nil || [strDuration isKindOfClass: [NSNull class]] || [strDuration isEqualToString: @"<null>"])
    {
        strDuration = @"None";
    }
    m_lblDuration.text = strDuration;
    
    
    m_lblStartDate.text = [self checkString: [dicDetail valueForKey: @"startdate"]];
    m_lblEndDate.text = [self checkString: [dicDetail valueForKey: @"enddate"]];
    m_lblTaskDescription.text = [[PWCAppDelegate getDelegate] decodeBase64String: [dicDetail valueForKey: @"task_description"]];
    
    [self updateStatus: PathId];
    
    [self updateCommentView: taskdetailcomment];
    [self updateTaskEmailList: taskemaillist];
}

//==============================================================================================================
-(NSString*) updateSprintData: (NSArray*) arrAllSprint
{
    [[DataManager sharedScoreManager] deletePMAllSprintByProjectID: self.m_strProjectID todoid: self.m_strTodoID];

    if(arrAllSprint == nil || [arrAllSprint count] <= 0) return @"";
    
    NSString* strResult = @"";
    for(int i = 0; i < [arrAllSprint count]; i++)
    {
        NSDictionary* dicItem = [arrAllSprint objectAtIndex: i];
        [[DataManager sharedScoreManager] insertPMSprite: [dicItem valueForKey: @"sprint_id"]
                                             sprint_name: [dicItem valueForKey: @"sprint_name"]
                                          current_sprint: [dicItem valueForKey: @"current_sprint"]
                                              project_id: self.m_strProjectID
                                                  todoid: self.m_strTodoID];
        
        if(strResult == nil || [strResult length] <= 0)
        {
            strResult = [dicItem valueForKey: @"sprint_id"];
        }
        else
        {
            strResult = [strResult stringByAppendingString: [NSString stringWithFormat: @",%@", [dicItem valueForKey: @"sprint_id"]]];
        }
    }
    
    return strResult;
}

//==============================================================================================================
-(void) failedSync: (ASIFormDataRequest*) theRequest
{
    [SVProgressHUD showSuccessWithStatus:@"Syncing Failed."];
}

#pragma mark -
#pragma mark UITextView Delegate.

//==============================================================================================================
-(void) textViewDidBeginEditing:(UITextView *)textView
{
    m_fScrollHeight = m_scrollDetail.contentSize.height;
    m_scrollDetail.contentSize = CGSizeMake(0, m_fScrollHeight + m_viewCommentPost.frame.origin.y);
    [m_scrollDetail setContentOffset:CGPointMake(0, m_viewCommentPost.frame.origin.y) animated: YES];
}

//==============================================================================================================
-(void) textViewDidEndEditing:(UITextView *)textView
{
    m_scrollDetail.contentSize = CGSizeMake(0, m_fScrollHeight);
    [m_scrollDetail setContentOffset: CGPointZero animated: YES];
}

//==============================================================================================================
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString: @"notification_to_segue"])
    {
        PWCPMNotificationToViewController* nextView = segue.destinationViewController;
        nextView.m_strProjectID = self.m_strProjectID;
        nextView.m_nPrevIndex = PM_TASK_DETAIL_VIEW;
        nextView.m_strTodoID = self.m_strTodoID;
        NSArray* arrUserList = [[DataManager sharedScoreManager] getAllPMTaskUserListByProjectID: self.m_strProjectID];
        
        if(arrUserList != nil && [arrUserList count] > 0)
        {
            nextView.m_arrUserList = [[NSMutableArray alloc] init];
            for(int i = 0; i < [arrUserList count]; i++)
            {
                [nextView.m_arrUserList addObject: [arrUserList objectAtIndex: i]];
            }
        }
    }
    else if([segue.identifier isEqualToString: @"pm_assigend_to_segue"])
    {
        PWCPMNotificationToViewController* nextView = segue.destinationViewController;
        nextView.m_strProjectID = self.m_strProjectID;
        nextView.m_strSelectUserID = self.m_strAssignedToID;
        nextView.m_strTodoID = self.m_strTodoID;        
        nextView.m_nPrevIndex = PM_TASK_DETAIL_VIEW;
        
        NSArray* arrUserList = [[DataManager sharedScoreManager] getAllPMTaskUserListByProjectID: self.m_strProjectID];
        
        if(arrUserList != nil && [arrUserList count] > 0)
        {
            nextView.m_arrUserList = [[NSMutableArray alloc] init];
            for(int i = 0; i < [arrUserList count]; i++)
            {
                [nextView.m_arrUserList addObject: [arrUserList objectAtIndex: i]];
            }
        }
    }
    else if([segue.identifier isEqualToString: @"pm_assigend_by_segue"])
    {
        PWCPMNotificationToViewController* nextView = segue.destinationViewController;
        nextView.m_strProjectID = self.m_strProjectID;
        nextView.m_strSelectUserID = self.m_strAssignedByID;
        nextView.m_strTodoID = self.m_strTodoID;        
        nextView.m_nPrevIndex = PM_TASK_DETAIL_VIEW;
        
        NSArray* arrUserList = [[DataManager sharedScoreManager] getAllPMTaskUserListByProjectID: self.m_strProjectID];
        if(arrUserList != nil && [arrUserList count] > 0)
        {
            nextView.m_arrUserList = [[NSMutableArray alloc] init];
            for(int i = 0; i < [arrUserList count]; i++)
            {
                [nextView.m_arrUserList addObject: [arrUserList objectAtIndex: i]];
            }
        }
    }
    else if([segue.identifier isEqualToString: @"pm_sprint_segue"])
    {
        PWCPMSprintViewController* nextView = segue.destinationViewController;
        nextView.m_strAllSprint = self.m_strAllSprints;
        nextView.m_strProjectID = self.m_strProjectID;
        nextView.m_strTodoID = self.m_strTodoID;
    }
}

#pragma mark -
#pragma mark Action Management.

//==============================================================================================================
-(IBAction) actionAssignedByID:(id)sender
{
//    if(!m_imgAssignedBySub.hidden)
//    {
//        [self performSegueWithIdentifier: @"pm_assigend_by_segue" sender: self];
//    }
}

//==============================================================================================================
-(IBAction) actionAssignedToID:(id)sender
{
//    if(!m_imgAssignedToSub.hidden)
//    {
        [self performSegueWithIdentifier: @"pm_assigend_to_segue" sender: self];
//    }
}

//==============================================================================================================
-(IBAction) actionSync:(id)sender
{
    [self getTaskDetail];
}

//==============================================================================================================
-(IBAction) actionSubmit:(id)sender
{
    [self addNewComment];
}

//==============================================================================================================
-(IBAction) actionDone:(id)sender
{
    [m_txtComment resignFirstResponder];
}

//==============================================================================================================
-(IBAction) actionSegment:(UISegmentedControl*)sender
{
    int nIndex = sender.selectedSegmentIndex;
    [self updateMainView: nIndex];
}


#pragma mark - Table view data source

//==============================================================================================================
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [m_arrStatus count];
}

//==============================================================================================================
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSDictionary* dicRecord = [m_arrStatus objectAtIndex: indexPath.row];
    int status = [[dicRecord valueForKey: @"progress_status"] intValue];
    if(status == 1)
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    cell.textLabel.text = [dicRecord valueForKey: @"title"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

//==============================================================================================================
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [SVProgressHUD showWithStatus:@"Loading ..." maskType:SVProgressHUDMaskTypeBlack];
    NSString* strURL = [@"https://pwcproject.com/v2/mobilepm/api/updatestatuspath" stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    
    ASIFormDataRequest* request = [ASIFormDataRequest requestWithURL: [NSURL URLWithString: strURL]];
    [request setDelegate: self];
    [request setTimeOutSeconds: REQUEST_TIME_OUT];
    [request setPostValue: [PWCGlobal getTheGlobal].account_id forKey: @"account_id"];
    [request setPostValue: [PWCGlobal getTheGlobal].hashKey forKey: @"userhash"];
    [request setPostValue: self.m_strTodoID forKey: @"todoid"];
    
    NSDictionary* dicRecord = [m_arrStatus objectAtIndex: indexPath.row];
    NSString* strID = [dicRecord valueForKey: @"Id"];
    
    if([strID isEqualToString: @"1"] || [strID isEqualToString: @"2"])
    {
        [request setPostValue: strID forKey: @"status"];
    }
    else
    {
        [request setPostValue: strID forKey: @"statusId"];
    }
    
    [request setDidFinishSelector: @selector(finishedUpdateStatusPath:)];
    [request setDidFailSelector: @selector(failedSync:)];
    [request startAsynchronous];
}

//==============================================================================================================
-(void) finishedUpdateStatusPath: (ASIFormDataRequest*) theRequest
{
    [SVProgressHUD showSuccessWithStatus:@"Syncing Successful."];
    
    NSString* strResponse = [theRequest responseString];
//    NSLog(@"strResponse = %@", strResponse);

    if([strResponse isEqualToString: @"\"Path Updated Successfully\""] || [strResponse isEqualToString: @"\"Status Updated Successfully\""])
    {
        [self getTaskDetail];
    }
}

//==============================================================================================================
-(void) actionFileURL: (UIButton*) btn
{
    int fileid = btn.tag;
    NSDictionary* dic = [[DataManager sharedScoreManager] getPMTaskCommentFile: [NSString stringWithFormat: @"%d", fileid]];
    NSString* strURL = [dic valueForKey: @"fileurl"];
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString: strURL]];
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

#pragma mark - 
#pragma mark Comment Post.

//==============================================================================================================
-(void) addNewComment
{
    NSString* comment = m_txtComment.text;
    if(comment == nil || [comment length] <= 0)
    {
        [[PWCAppDelegate getDelegate] showMessage: @"Please input valid comment"];
        return;
    }
    
    NSString* people = @"";
    for(int i = 0; i < [m_arrPeopleCheckBox count]; i++)
    {
        SSCheckBoxView* checkbox = [m_arrPeopleCheckBox objectAtIndex: i];
        if(checkbox.checked)
        {
            if([people length] <= 0)
            {
                people = [NSString stringWithFormat: @"%d", checkbox.tag];
            }
            else
            {
                people = [people stringByAppendingString: [NSString stringWithFormat: @",%d", checkbox.tag]];
            }
        }
    }
    
    m_txtComment.text = @"";
    
    [SVProgressHUD showWithStatus:@"Loading ..." maskType:SVProgressHUDMaskTypeBlack];
    NSString* strURL = [@"https://pwcproject.com/v2/mobilepm/api/addcomment" stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    
    ASIFormDataRequest* request = [ASIFormDataRequest requestWithURL: [NSURL URLWithString: strURL]];
    [request setDelegate: self];
    [request setTimeOutSeconds: REQUEST_TIME_OUT];    
    [request setPostValue: [PWCGlobal getTheGlobal].account_id forKey: @"account_id"];
    [request setPostValue: [PWCGlobal getTheGlobal].hashKey forKey: @"userhash"];
    [request setPostValue: self.m_strTodoID forKey: @"todoid"];
    [request setPostValue: comment forKey: @"comment"];
    [request setPostValue: people forKey: @"people"];
    
    [request setDidFinishSelector: @selector(finishedAddComment:)];
    [request setDidFailSelector: @selector(failedSync:)];
    [request startAsynchronous];
}

//==============================================================================================================
-(void) finishedAddComment: (ASIFormDataRequest*) theRequest
{
    [SVProgressHUD showSuccessWithStatus:@"Syncing Successful."];
    
    NSString* strResponse = [theRequest responseString];
    NSLog(@"Finished Add Comment Result = %@", strResponse);
    
    [self getTaskDetail];
}

//==============================================================================================================
@end
