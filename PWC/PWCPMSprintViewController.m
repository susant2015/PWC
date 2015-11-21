//
//  PWCPMSprintViewController.m
//  PWC
//
//  Created by jian on 12/15/13.
//  Copyright (c) 2013 Premium Web Cart. All rights reserved.
//

#import "PWCPMSprintViewController.h"
#import "DataManager.h"
#import "PWCGlobal.h"
#import "ASIFormDataRequest.h"
#import "PWCPMTaskDetailViewController.h"
#import "PWCTasksListViewController.h"

@interface PWCPMSprintViewController ()

@end

@implementation PWCPMSprintViewController
@synthesize m_strAllSprint;
@synthesize m_strTodoID;
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
    m_arrSprints = [[NSMutableArray alloc] init];
    if(self.m_strAllSprint != nil && [self.m_strAllSprint length] > 0)
    {
        NSArray* arrIDs = [self.m_strAllSprint componentsSeparatedByString: @","];
        if(arrIDs != nil && [arrIDs count] > 0)
        {
            for(int i = 0; i < [arrIDs count]; i++)
            {
                NSString* strID = [arrIDs objectAtIndex: i];
                NSDictionary* dicItem = [[DataManager sharedScoreManager] getPMSprintByID: strID];
                [m_arrSprints addObject: dicItem];
            }
        }
    }
}

#pragma mark - Table view data source

//==============================================================================================================
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [m_arrSprints count];
}

//==============================================================================================================
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    NSDictionary* dicRecord = [m_arrSprints objectAtIndex: indexPath.row];
    NSString* strID = [dicRecord valueForKey: @"sprint_id"];
    
    if([PWCGlobal getTheGlobal].m_gSelectedSprintID != nil && [strID isEqualToString: [PWCGlobal getTheGlobal].m_gSelectedSprintID])
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    cell.textLabel.text = [dicRecord valueForKey: @"sprint_name"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

//==============================================================================================================
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary* dicRecord = [m_arrSprints objectAtIndex: indexPath.row];
    NSString* strID = [dicRecord valueForKey: @"sprint_id"];
    [PWCGlobal getTheGlobal].m_gSelectedSprintID = strID;
    
    [self updateSprintItem];
    [m_tableView reloadData];
}

//==============================================================================================================
-(void) updateSprintItem
{
    [SVProgressHUD showWithStatus:@"Loading ..." maskType:SVProgressHUDMaskTypeBlack];
    NSString* strURL = [@"https://pwcproject.com/v2/mobilepm/api/updatesprint" stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    
    NSLog(@"account_id = %@", [PWCGlobal getTheGlobal].account_id);
    NSLog(@"userhash = %@", [PWCGlobal getTheGlobal].hashKey);
    NSLog(@"project_id = %@", self.m_strTodoID);
    
    ASIFormDataRequest* request = [ASIFormDataRequest requestWithURL: [NSURL URLWithString: strURL]];
    [request setDelegate: self];
    [request setTimeOutSeconds: REQUEST_TIME_OUT];
    [request setPostValue: [PWCGlobal getTheGlobal].account_id forKey: @"account_id"];
    [request setPostValue: [PWCGlobal getTheGlobal].hashKey forKey: @"userhash"];
    [request setPostValue: [PWCGlobal getTheGlobal].m_gSelectedSprintID forKey: @"sprintid"];
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
