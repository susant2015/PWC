//
//  PWCTasksListViewController.m
//  PWC
//
//  Created by JianJinHu on 11/27/13.
//  Copyright (c) 2013 Premium Web Cart. All rights reserved.
//

#import "PWCTasksListViewController.h"
#import "DataManager.h"
#import "ASIFormDataRequest.h"
#import "PWCGlobal.h"
#import "JSON.h"
#import "PWCPMTaskDetailViewController.h"
#import "PWCPMTaskCell.h"
#import "PWCAppDelegate.h"

@interface PWCTasksListViewController ()

@end

@implementation PWCTasksListViewController
@synthesize m_strProjectID;
@synthesize m_strTitleID;
@synthesize m_strTodoID;
@synthesize m_nPrevIndex;
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
    
    [PWCGlobal getTheGlobal].m_gPMTaskListController = self;
    m_bUpdateFlag = NO;
}

//==============================================================================================================
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//==============================================================================================================
-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    [self initMember];
}

//==============================================================================================================
-(void) initMember
{
    m_arrList = [[NSMutableArray alloc] init];
    
    if(m_nPrevIndex == 0)
    {
        NSArray* arrList = [[DataManager sharedScoreManager] getPMTaskListsByProjectID: self.m_strProjectID title_id: self.m_strTitleID];
        if(arrList == nil || [arrList count] <= 0)
        {
            [self getTaskList];
            return;
        }
        else
        {
            for(int i = 0; i < [arrList count]; i++)
            {
                NSDictionary* dicRecord = [arrList objectAtIndex: i];
                [m_arrList addObject: dicRecord];
            }
        }
    }
    
    //New assigned Task
    else if(m_nPrevIndex == 1)
    {
        NSArray* arrList = [[DataManager sharedScoreManager] getAllPMAddedTasks: 0];
        if(arrList != nil && [arrList count] > 0)
        {
            for(int i = 0; i < [arrList count]; i++)
            {
                NSDictionary* dicRecord = [arrList objectAtIndex: i];
                [m_arrList addObject: dicRecord];
            }
        }
    }
    
    //Updated Assigned Task
    else if(m_nPrevIndex == 2)
    {
        NSArray* arrList = [[DataManager sharedScoreManager] getAllPMAddedTasks: 1];
        if(arrList != nil && [arrList count] > 0)
        {
            for(int i = 0; i < [arrList count]; i++)
            {
                NSDictionary* dicRecord = [arrList objectAtIndex: i];
                [m_arrList addObject: dicRecord];
            }
        }
    }
    
    if(m_bUpdateFlag)
    {
        [self actionSync: self];
        return;
    }
    
    [m_tableView reloadData];
}

//==============================================================================================================
-(void) getTaskList
{
    [SVProgressHUD showWithStatus:@"Loading ..." maskType:SVProgressHUDMaskTypeBlack];
    NSString* strURL = [@"https://pwcproject.com/v2/mobilepm/api/tasklist" stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    
    NSLog(@"account_id = %@", [PWCGlobal getTheGlobal].account_id);
    NSLog(@"userhash = %@", [PWCGlobal getTheGlobal].hashKey);
    NSLog(@"project_id = %@", self.m_strProjectID);
    NSLog(@"title_id = %@", self.m_strTitleID);
    
    ASIFormDataRequest* request = [ASIFormDataRequest requestWithURL: [NSURL URLWithString: strURL]];
    [request setDelegate: self];
    [request setTimeOutSeconds: REQUEST_TIME_OUT];    
    [request setPostValue: [PWCGlobal getTheGlobal].account_id forKey: @"account_id"];
    [request setPostValue: [PWCGlobal getTheGlobal].hashKey forKey: @"userhash"];
    [request setPostValue: self.m_strProjectID forKey: @"project_id"];
    [request setPostValue: self.m_strTitleID forKey: @"title_id"];
    
    [request setDidFinishSelector: @selector(finishedGetTaskList:)];
    [request setDidFailSelector: @selector(failedSync:)];
    [request startAsynchronous];
}

//==============================================================================================================
-(void) finishedGetTaskList: (ASIFormDataRequest*) theRequest
{
    [SVProgressHUD showSuccessWithStatus:@"Syncing Successful."];
    NSString* strResponse = [theRequest responseString];
    NSArray* arrList = [strResponse JSONValue];
    NSLog(@"result = %@", arrList);
    
    [[DataManager sharedScoreManager] deleteAllPMTaskListsByProjectID: self.m_strProjectID title_id: self.m_strTitleID];
    [m_arrList removeAllObjects];
    
    for(int i = 0; i < [arrList count]; i++)
    {
        NSDictionary* dicRecord = [arrList objectAtIndex: i];
        [m_arrList addObject: dicRecord];
        
        [[DataManager sharedScoreManager] insertPMTaskList: [dicRecord valueForKey: @"assignedto"]
                                                  priority: [dicRecord valueForKey: @"priority"]
                                                sprintname: [dicRecord valueForKey: @"sprintname"]
                                                 tasktitle: [dicRecord valueForKey: @"tasktitle"]
                                                   taskurl: [dicRecord valueForKey: @"taskurl"]
                                                project_id: self.m_strProjectID
                                                  title_id: self.m_strTitleID
                                                    todoid: [dicRecord valueForKey: @"todoid"]];
    }
    
    [m_tableView reloadData];
}

//==============================================================================================================
-(void) failedSync: (ASIFormDataRequest*) theRequest
{
    [SVProgressHUD showSuccessWithStatus:@"Syncing Failed."];
}

#pragma mark - Table view data source
//==============================================================================================================
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [m_arrList count];
}

//==============================================================================================================
-(float) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.0f;
}

//==============================================================================================================
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TableCellWithNumberCellIdentifier";
    
    PWCPMTaskCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = (PWCPMTaskCell *)[PWCPMTaskCell cellFromNibNamed:@"PWCPMTaskCell"];
    }
    
    NSDictionary* dicRecord = [m_arrList objectAtIndex: indexPath.row];
    
    if(m_nPrevIndex == 0)
    {
        cell.m_lblTaskTitle.text = [[PWCAppDelegate getDelegate] decodeBase64String: [dicRecord valueForKey: @"tasktitle"]];
        cell.m_lblAssigned.text = [NSString stringWithFormat: @"Assigned To: %@", [dicRecord valueForKey: @"assignedto"]];
        cell.m_lblSprint.text = [NSString stringWithFormat: @"Sprint: %@", [self checkString: [dicRecord valueForKey: @"sprintname"]]];
    }
    else
    {
        cell.m_lblTaskTitle.text = [[PWCAppDelegate getDelegate] decodeBase64String: [dicRecord valueForKey: @"TodoTitle"]];
        cell.m_lblAssigned.text = [NSString stringWithFormat: @"Assigned To: %@", [self checkString: [dicRecord valueForKey: @"assignedtoname"]]];
        cell.m_lblSprint.text = [NSString stringWithFormat: @"Sprint: %@", [self checkString: [dicRecord valueForKey: @"sprintname"]]];
    }
    return cell;
}

#pragma mark - Table view delegate

//==============================================================================================================
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary* dicRecord = [m_arrList objectAtIndex: indexPath.row];
    
    if(m_nPrevIndex == 0)
    {
        self.m_strTodoID = [dicRecord valueForKey: @"todoid"];
    }
    else
    {
        self.m_strProjectID = [dicRecord valueForKey: @"ProjId"];
        self.m_strTodoID = [dicRecord valueForKey: @"Id"];        
    }

    [self performSegueWithIdentifier: @"pm_task_detail_segue" sender: self];
}

//==============================================================================================================
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    PWCPMTaskDetailViewController* nextView = segue.destinationViewController;
    nextView.m_strProjectID = self.m_strProjectID;
    nextView.m_strTodoID = self.m_strTodoID;
}

//==============================================================================================================
-(NSString*) checkString: (NSString*) strValue
{
    if(strValue == nil || [strValue isKindOfClass: [NSNull class]] || [strValue isEqualToString: @"<null>"])
    {
        return @"None";
    }
    
    return strValue;
}

#pragma mark -
#pragma mark Action Management.

//==============================================================================================================
-(IBAction) actionSync:(id)sender
{
    [self getTaskList];
}

//==============================================================================================================
@end
