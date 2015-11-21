//
//  PWCTaskDetailViewController.m
//  PWC
//
//  Created by JianJinHu on 8/1/13.
//  Copyright (c) 2013 Premium Web Cart. All rights reserved.
//

#import "PWCTaskDetailViewController.h"
#import "PWCChangeStatusViewController.h"
#import "ASIFormDataRequest.h"
#import "JSON.h"
#import "PWCGlobal.h"
#import "PWCCRMGlobal.h"
#import "PWCAppDelegate.h"
#import "DataManager.h"

@interface PWCTaskDetailViewController ()

@end

@implementation PWCTaskDetailViewController
@synthesize m_dicTask;


//==============================================================================================================
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initMember];
}

//==============================================================================================================
-(void) initMember
{
    NSLog(@"m_dicTask = %@", m_dicTask);

    [PWCGlobal getTheGlobal].m_gUpdatedTaskStatus = nil;
    [PWCGlobal getTheGlobal].m_gUpdatedReasiggnedUserId = nil;
    [PWCGlobal getTheGlobal].m_gUpdatedRescheduleFromDate = nil;
    [PWCGlobal getTheGlobal].m_gUpdatedRescheduleToDate = nil;
    [PWCGlobal getTheGlobal].m_gUpdatedReasiggnedUserName = nil;
    
    m_lblTaskName.text = [m_dicTask objectForKey: @"task"];
    m_lblAssignedBy.text = [m_dicTask objectForKey: @"assigned_by"];
    m_lblAssignedOn.text = [m_dicTask objectForKey: @"assigned_on"];
    m_lblAssignedTo.text = [m_dicTask objectForKey: @"assigned_to"];
    m_lblCustomer.text = [m_dicTask objectForKey: @"customer_name"];
    m_lblDueDate.text = [m_dicTask objectForKey: @"duedate"];
    m_lblDelayedBy.text = [m_dicTask objectForKey: @"delayed_by"];
    m_lblReason.text = [m_dicTask objectForKey: @"reason"];
    m_lblStatus.text = [m_dicTask objectForKey: @"status"];
    
    m_txtComment.layer.masksToBounds = YES;
    m_txtComment.layer.borderWidth = 1.0f;
    m_txtComment.layer.cornerRadius = 5.0f;
    m_txtComment.layer.borderColor = [UIColor grayColor].CGColor;
    
    [m_txtComment setInputAccessoryView: m_topToolBar];
}

//==============================================================================================================
-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear: animated];

    if([PWCGlobal getTheGlobal].m_gUpdatedReasiggnedUserName != nil)
    {
        m_lblAssignedTo.text = [PWCGlobal getTheGlobal].m_gUpdatedReasiggnedUserName;
    }
    
    NSLog(@"*** [PWCGlobal getTheGlobal].m_gUpdatedTaskStatus = %@", [PWCGlobal getTheGlobal].m_gUpdatedTaskStatus);    
    if([PWCGlobal getTheGlobal].m_gUpdatedTaskStatus != nil)
    {
        m_lblStatus.text = [PWCGlobal getTheGlobal].m_gUpdatedTaskStatus;
    }

    
    if([PWCGlobal getTheGlobal].m_gUpdatedRescheduleFromDate != nil)
    {
        m_lblAssignedOn.text = [PWCGlobal getTheGlobal].m_gUpdatedRescheduleFromDate;
    }
    
    if([PWCGlobal getTheGlobal].m_gUpdatedRescheduleToDate != nil)
    {
        m_lblDueDate.text = [PWCGlobal getTheGlobal].m_gUpdatedRescheduleToDate;
    }
}

#pragma mark -
#pragma mark UITextField Delegate.

//==============================================================================================================
-(void) textViewDidBeginEditing:(UITextView *)textView
{
    m_fScrollHeight = m_scrollView.contentSize.height;
    m_scrollView.contentSize = CGSizeMake(0, m_fScrollHeight + 200);
    [m_scrollView setContentOffset:CGPointMake(0, 200) animated: YES];
}

//==============================================================================================================
-(void) textViewDidEndEditing:(UITextView *)textView
{
    m_scrollView.contentSize = CGSizeMake(0, m_fScrollHeight);
}

//==============================================================================================================
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//==============================================================================================================
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"change_status_segue"])
    {
        PWCChangeStatusViewController *nextView = segue.destinationViewController;
        NSString* task_id = [m_dicTask objectForKey: @"id"];
        nextView.task_id = task_id;
    }
}

#pragma mark -
#pragma mark Action Management.

//==============================================================================================================
-(IBAction) actionDone:(id)sender
{
    [m_txtComment resignFirstResponder];
}

//==============================================================================================================
-(IBAction) actionSubmit:(id)sender
{
    NSString* comments = m_txtComment.text;
    [SVProgressHUD showWithStatus:@"Loading ..." maskType:SVProgressHUDMaskTypeBlack];
    NSString* strURL = [NSString stringWithFormat: @"%@updatetaskdetails", SERVER_PENDNG_BASE_URL];
    ASIFormDataRequest* request = [ASIFormDataRequest requestWithURL: [NSURL URLWithString: strURL]];
    
    [request setDelegate: self];
    [request setTimeOutSeconds: REQUEST_TIME_OUT];
    
    NSString* task_id = [m_dicTask objectForKey: @"task_id"];
    NSString* lead_id = [m_dicTask objectForKey: @"lead_id"];
    NSString* status = [PWCGlobal getTheGlobal].m_gUpdatedTaskStatus;
    NSString* reassigned_to_user_id = [PWCGlobal getTheGlobal].m_gUpdatedReasiggnedUserId;
    NSString* reschedule_date_from = [PWCGlobal getTheGlobal].m_gUpdatedRescheduleFromDate;
    NSString* reschedule_date_to = [PWCGlobal getTheGlobal].m_gUpdatedRescheduleToDate;

    if(comments != nil && [comments length] > 0)
    {
        [request setPostValue: comments forKey: @"commments"];
    }
    [request setPostValue: task_id forKey: @"task_id"];
    [request setPostValue: lead_id forKey: @"lead_id"];
    
    if(status != nil && [status length] > 0)
    {
        [request setPostValue: status forKey: @"status"];
    }
    
    if(reassigned_to_user_id != nil && [reassigned_to_user_id length] > 0)
    {
        [request setPostValue: reassigned_to_user_id forKey: @"reassigned_to_user_id"];
    }

    if(reschedule_date_from != nil && [reschedule_date_from length] > 0)
    {
        [request setPostValue: reschedule_date_from forKey: @"reschedule_date_from"];
    }

    if(reschedule_date_to != nil && [reschedule_date_to length] > 0)
    {
        [request setPostValue: reschedule_date_to forKey: @"reschedule_date_to"];
    }

    [request setDidFinishSelector: @selector(finishedUpdateTask:)];
    [request setDidFailSelector: @selector(failedRequest:)];
    [request startAsynchronous];
}

//==============================================================================================================
-(void) finishedUpdateTask: (ASIFormDataRequest*) theRequest
{
    [SVProgressHUD showSuccessWithStatus:@"Syncing Successful."];
    NSString* strResponse = [theRequest responseString];
    NSDictionary* dic = [strResponse JSONValue];
    NSLog(@"dic = %@", dic);
    
    NSString* status = [dic valueForKey: @"status"];
    if([status isEqualToString: @"Error"])
    {
        [[PWCAppDelegate getDelegate] showMessage: @"Sorry! Could Not Process Update Task Request"];
        return;
    }
    else
    {
        [[DataManager sharedScoreManager] deleteTaskList];
        [[DataManager sharedScoreManager] deleteAllTasks];
        
        [self.navigationController popToViewController: [PWCGlobal getTheGlobal].m_gCRMViewController animated: YES];
    }
}

//==============================================================================================================
-(void) failedRequest: (ASIFormDataRequest*) theRequest
{
    [SVProgressHUD showSuccessWithStatus:@"Syncing Failed."];
}

//==============================================================================================================
@end
