//
//  PWCPMNotificationToViewController.m
//  PWC
//
//  Created by Jian on 12/6/13.
//  Copyright (c) 2013 Premium Web Cart. All rights reserved.
//

#import "PWCPMNotificationToViewController.h"
#import "ASIFormDataRequest.h"
#import "JSON.h"
#import "PWCGlobal.h"
#import "DataManager.h"
#import "PWCAppDelegate.h"
#import "PWCPMTaskDetailViewController.h"
#import "PWCTasksListViewController.h"

@interface PWCPMNotificationToViewController ()

@end

@implementation PWCPMNotificationToViewController
@synthesize m_strProjectID;
@synthesize m_strSelectUserID;
@synthesize m_arrUserList;
@synthesize m_nPrevIndex;
@synthesize m_strTodoID;

//==============================================================================================================
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

//==============================================================================================================
- (void)viewDidLoad
{
    [super viewDidLoad];
}

//==============================================================================================================
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

//==============================================================================================================
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.m_arrUserList count];
}

//==============================================================================================================
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSDictionary* dicUser = [self.m_arrUserList objectAtIndex: section];
    return [dicUser valueForKey: @"tc_companyname"];
}

//==============================================================================================================
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary* dicUser = [self.m_arrUserList objectAtIndex: section];
    NSString* people = [dicUser valueForKey: @"people"];
    NSArray* arrPeple = [people componentsSeparatedByString: @","];
    if(arrPeple != nil)
    {
        return [arrPeple count];
    }
    
    return 0;
}

//==============================================================================================================
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSDictionary* dicUser = [self.m_arrUserList objectAtIndex: indexPath.section];
    NSString* people = [dicUser valueForKey: @"people"];
    NSArray* arrPeple = [people componentsSeparatedByString: @","];
    if(arrPeple != nil)
    {
        NSString* tp_id = [arrPeple objectAtIndex: indexPath.row];
        if(self.m_strSelectUserID != nil && [self.m_strSelectUserID isEqualToString: tp_id])
        {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        
        NSArray* arrTemp = [[DataManager sharedScoreManager] getPMTaskPeopleByID: tp_id];
        if(arrTemp != nil && [arrTemp count] > 0)
        {
            NSDictionary* dicRecord = [arrTemp objectAtIndex: 0];
            cell.textLabel.text = [NSString stringWithFormat: @"%@ %@", [dicRecord valueForKey: @"tp_firstname"], [dicRecord valueForKey: @"tp_lastname"]];
        }
    }
    return cell;
}

#pragma mark - Table view delegate

//==============================================================================================================
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary* dicUser = [self.m_arrUserList objectAtIndex: indexPath.section];
    NSString* people = [dicUser valueForKey: @"people"];
    NSArray* arrPeple = [people componentsSeparatedByString: @","];
    if(arrPeple != nil)
    {
        NSString* tp_id = [arrPeple objectAtIndex: indexPath.row];
        NSArray* arrTemp = [[DataManager sharedScoreManager] getPMTaskPeopleByID: tp_id];
        if(arrTemp != nil && [arrTemp count] > 0)
        {
            NSDictionary* dicRecord = [arrTemp objectAtIndex: 0];
            self.m_strSelectUserID = [dicRecord valueForKey: @"tp_id"];
        }
    }
    
    [PWCGlobal getTheGlobal].m_gPMAddTaskSelectedAssignedTo = self.m_strSelectUserID;
    [m_tableView reloadData];
    
    if(m_nPrevIndex == PM_TASK_DETAIL_VIEW)
    {
        [self updateAssignedUser];
    }
}

//==============================================================================================================
-(void) updateAssignedUser
{
    [SVProgressHUD showWithStatus:@"Loading ..." maskType:SVProgressHUDMaskTypeBlack];
    NSString* strURL = [@"https://pwcproject.com/v2/mobilepm/api/updateassignto" stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    
    NSLog(@"account_id = %@", [PWCGlobal getTheGlobal].account_id);
    NSLog(@"userhash = %@", [PWCGlobal getTheGlobal].hashKey);
    NSLog(@"project_id = %@", self.m_strSelectUserID);
    NSLog(@"project_id = %@", self.m_strTodoID);
    
    ASIFormDataRequest* request = [ASIFormDataRequest requestWithURL: [NSURL URLWithString: strURL]];
    [request setDelegate: self];
    [request setTimeOutSeconds: REQUEST_TIME_OUT];
    [request setPostValue: [PWCGlobal getTheGlobal].account_id forKey: @"account_id"];
    [request setPostValue: [PWCGlobal getTheGlobal].hashKey forKey: @"userhash"];
    [request setPostValue: self.m_strSelectUserID forKey: @"assignedtoid"];
    [request setPostValue: self.m_strTodoID forKey: @"todoid"];
    
    [request setDidFinishSelector: @selector(finishedUpdatedAssignedUser:)];
    [request setDidFailSelector: @selector(failedSync:)];
    [request startAsynchronous];
}

//==============================================================================================================
-(void) finishedUpdatedAssignedUser: (ASIFormDataRequest*) theRequest
{
    [SVProgressHUD showSuccessWithStatus:@"Syncing Successful."];
    NSString* strResponse = [theRequest responseString];
    NSLog(@"strResponse = %@", strResponse);
    
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle: nil
                                                    message: strResponse
                                                   delegate: self
                                          cancelButtonTitle: @"Ok"
                                          otherButtonTitles: nil, nil];
    [alert show];
}

//==============================================================================================================
-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if([PWCGlobal getTheGlobal].m_gPMTaskDetailController != nil)
    {
        [(PWCPMTaskDetailViewController*)[PWCGlobal getTheGlobal].m_gPMTaskDetailController setM_bUpdateFlag: YES];
    }
    
    if([PWCGlobal getTheGlobal].m_gPMTaskListController != nil)
    {
        [(PWCTasksListViewController*)[PWCGlobal getTheGlobal].m_gPMTaskListController setM_bUpdateFlag: YES];        
    }

    [self.navigationController popViewControllerAnimated: YES];
}

//==============================================================================================================
-(void) failedSync: (ASIFormDataRequest*) theRequest
{
    [SVProgressHUD showSuccessWithStatus:@"Syncing Failed."];
}

//==============================================================================================================
@end

