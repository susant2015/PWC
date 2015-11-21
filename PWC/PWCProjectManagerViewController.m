//
//  PWCProjectManagerViewController.m
//  PWC
//
//  Created by JianJinHu on 11/26/13.
//  Copyright (c) 2013 Premium Web Cart. All rights reserved.
//

#import "PWCProjectManagerViewController.h"
#import "PWCAppDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import "PWCProjectListViewController.h"
#import "ASIFormDataRequest.h"
#import "JSON.h"
#import "DataManager.h"
#import "PWCTasksListViewController.h"

@interface PWCProjectManagerViewController ()

@end

@implementation PWCProjectManagerViewController

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
    if([[PWCAppDelegate getDelegate] isIPhone4])
    {
        m_scrollView.frame = CGRectMake(m_scrollView.frame.origin.x,
                                        m_scrollView.frame.origin.y - 40.0f,
                                        m_scrollView.frame.size.width,
                                        m_scrollView.frame.size.height);
    }
    
    [self updateNumbers];
    
    int nAddedNewTask = [[[DataManager sharedScoreManager] getAllPMAddedTasks: 0] count];
    int nUpdatedNewTask = [[[DataManager sharedScoreManager] getAllPMAddedTasks: 1] count];
    
    if(nAddedNewTask == 0 && nUpdatedNewTask == 0)
    {
        [self getDashboard];
    }
    else
    {
        if(nAddedNewTask > 0)
        {
            m_lblNewTaskNumbers.hidden = NO;
            m_lblNewTaskNumbers.text = [NSString stringWithFormat: @"%d", nAddedNewTask];
        }
        if(nUpdatedNewTask > 0)
        {
            m_lblUpdatedTaskNumbers.hidden = NO;
            m_lblUpdatedTaskNumbers.text = [NSString stringWithFormat: @"%d", nUpdatedNewTask];
        }
    }
}

//==============================================================================================================
-(void) getDashboard
{
    NSString* strURL = [@"https://pwcproject.com/v2/mobilepm/api/dashboard" stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    
    ASIFormDataRequest* request = [ASIFormDataRequest requestWithURL: [NSURL URLWithString: strURL]];
    [request setTimeOutSeconds: REQUEST_TIME_OUT];
    [request setDelegate: self];
    [request shouldContinueWhenAppEntersBackground];
    [request allowResumeForFileDownloads];
    [request setPostValue: [PWCGlobal getTheGlobal].account_id forKey: @"account_id"];
    [request setPostValue: [PWCGlobal getTheGlobal].hashKey forKey: @"userhash"];
    
    [request setDidFinishSelector: @selector(finishedGetDashboard:)];
    [request setDidFailSelector: @selector(failedSync:)];
    [request startAsynchronous];
}

//==============================================================================================================
-(void) finishedGetDashboard: (ASIFormDataRequest*) theRequest
{
    NSString* strResponse = [theRequest responseString];
    NSDictionary* dicList = [strResponse JSONValue];
    
    NSLog(@"arrList = %@", dicList);
    
    //Added Task Field.
    [[DataManager sharedScoreManager] deleteAllPMAddedTasks];
    
    NSArray* arrTasksAdded = [dicList valueForKey: @"alltasksadded"];
    if(arrTasksAdded != nil && [arrTasksAdded count] > 0)
    {
        for(int i = 0; i < [arrTasksAdded count]; i++)
        {
            NSDictionary* dicRecord = [arrTasksAdded objectAtIndex: i];
            [[DataManager sharedScoreManager] insertPMAddedTask: [dicRecord valueForKey: @"AdminId"]
                                                           Date: [dicRecord valueForKey: @"Date"]
                                                             Id: [dicRecord valueForKey: @"Id"]
                                                     PriorityId: [dicRecord valueForKey: @"PriorityId"]
                                                         ProjId: [dicRecord valueForKey: @"ProjId"]
                                                      TodoTitle: [dicRecord valueForKey: @"TodoTitle"]
                                                         UserId: [dicRecord valueForKey: @"UserId"]
                                                 assignedtoname: [dicRecord valueForKey: @"assignedtoname"]
                                                     sprintname: [dicRecord valueForKey: @"sprintname"]
                                                           type: @"0"];
        }
    }
    
    int nAddedNewTask = [[[DataManager sharedScoreManager] getAllPMAddedTasks: 0] count];
    if(nAddedNewTask > 0)
    {
        m_lblNewTaskNumbers.hidden = NO;
        m_lblNewTaskNumbers.text = [NSString stringWithFormat: @"%d", nAddedNewTask];
    }
    
    NSArray* arrTasksUpdated = [dicList valueForKey: @"alltasksupdated"];
    if(arrTasksUpdated != nil && [arrTasksUpdated count] > 0)
    {
        for(int i = 0; i < [arrTasksUpdated count]; i++)
        {
            NSDictionary* dicRecord = [arrTasksUpdated objectAtIndex: i];
            [[DataManager sharedScoreManager] insertPMAddedTask: [dicRecord valueForKey: @"AdminId"]
                                                           Date: [dicRecord valueForKey: @"Date"]
                                                             Id: [dicRecord valueForKey: @"Id"]
                                                     PriorityId: [dicRecord valueForKey: @"PriorityId"]
                                                         ProjId: [dicRecord valueForKey: @"ProjId"]
                                                      TodoTitle: [dicRecord valueForKey: @"TodoTitle"]
                                                         UserId: [dicRecord valueForKey: @"UserId"]
                                                 assignedtoname: [dicRecord valueForKey: @"assignedtoname"]
                                                     sprintname: [dicRecord valueForKey: @"sprintname"]
                                                           type: @"1"];
        }
    }
    
    int nUpdatedNewTask = [[[DataManager sharedScoreManager] getAllPMAddedTasks: 1] count];
    if(nUpdatedNewTask > 0)
    {
        m_lblUpdatedTaskNumbers.hidden = NO;
        m_lblUpdatedTaskNumbers.text = [NSString stringWithFormat: @"%d", nUpdatedNewTask];
    }
}

//==============================================================================================================
-(void) failedSync: (ASIFormDataRequest*) theRequest
{
//    [SVProgressHUD showSuccessWithStatus:@"Syncing Failed."];
}

//==============================================================================================================
-(void) updateNumbers
{
    m_lblNewTaskNumbers.hidden = YES;
    m_lblNewTaskNumbers.layer.cornerRadius = 10.0;
    m_lblNewTaskNumbers.layer.borderWidth = 2.0;
    m_lblNewTaskNumbers.layer.borderColor = [UIColor colorWithRed:101.0/255.0 green:101.0/255.0 blue:101.0/255.0 alpha:1.0].CGColor;
    m_lblNewTaskNumbers.layer.shadowPath = [UIBezierPath bezierPathWithRect:m_lblNewTaskNumbers.bounds].CGPath;
    m_lblNewTaskNumbers.layer.masksToBounds = NO;
    m_lblNewTaskNumbers.layer.shadowOffset = CGSizeMake(5, 10);
    m_lblNewTaskNumbers.layer.shadowRadius = 10.0;
    m_lblNewTaskNumbers.layer.shadowOpacity = 0.5;
    m_lblNewTaskNumbers.clipsToBounds = YES;
    
    m_lblSendMessages.hidden = YES;
    m_lblSendMessages.layer.cornerRadius = 10.0;
    m_lblSendMessages.layer.borderWidth = 2.0;
    m_lblSendMessages.layer.borderColor = [UIColor colorWithRed:101.0/255.0 green:101.0/255.0 blue:101.0/255.0 alpha:1.0].CGColor;
    m_lblSendMessages.layer.shadowPath = [UIBezierPath bezierPathWithRect:m_lblNewTaskNumbers.bounds].CGPath;
    m_lblSendMessages.layer.masksToBounds = NO;
    m_lblSendMessages.layer.shadowOffset = CGSizeMake(5, 10);
    m_lblSendMessages.layer.shadowRadius = 10.0;
    m_lblSendMessages.layer.shadowOpacity = 0.5;
    m_lblSendMessages.clipsToBounds = YES;
    
    m_lblUpdatedTaskNumbers.hidden = YES;
    m_lblUpdatedTaskNumbers.layer.cornerRadius = 10.0;
    m_lblUpdatedTaskNumbers.layer.borderWidth = 2.0;
    m_lblUpdatedTaskNumbers.layer.borderColor = [UIColor colorWithRed:101.0/255.0 green:101.0/255.0 blue:101.0/255.0 alpha:1.0].CGColor;
    m_lblUpdatedTaskNumbers.layer.shadowPath = [UIBezierPath bezierPathWithRect:m_lblNewTaskNumbers.bounds].CGPath;
    m_lblUpdatedTaskNumbers.layer.masksToBounds = NO;
    m_lblUpdatedTaskNumbers.layer.shadowOffset = CGSizeMake(5, 10);
    m_lblUpdatedTaskNumbers.layer.shadowRadius = 10.0;
    m_lblUpdatedTaskNumbers.layer.shadowOpacity = 0.5;
    m_lblUpdatedTaskNumbers.clipsToBounds = YES;
}

//==============================================================================================================
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    PWCProjectListViewController* nextView = segue.destinationViewController;
    if([segue.identifier isEqualToString: @"add_task_project_segue"])
    {
        nextView.m_nNextPageIndex = 1;
    }
    else if([segue.identifier isEqualToString: @"view_task_project_segue"])
    {
        nextView.m_nNextPageIndex = 0;
    }
    else if([segue.identifier isEqualToString: @"pm_send_message_segue"])
    {
        nextView.m_nNextPageIndex = 2;
    }
    else if([segue.identifier isEqualToString: @"new_task_assigned_segue"])
    {
        PWCTasksListViewController* nextView = segue.destinationViewController;
        nextView.m_nPrevIndex = 1;
    }
    else if([segue.identifier isEqualToString: @"task_updated_segue"])
    {
        PWCTasksListViewController* nextView = segue.destinationViewController;
        nextView.m_nPrevIndex = 2;
    }
}

#pragma mark -
#pragma mark Action Management.

//==============================================================================================================
-(IBAction) actionSync:(id)sender
{
    [self getDashboard];
}

//==============================================================================================================
@end
