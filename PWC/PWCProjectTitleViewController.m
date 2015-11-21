//
//  PWCProjectTitleViewController.m
//  PWC
//
//  Created by JianJinHu on 11/27/13.
//  Copyright (c) 2013 Premium Web Cart. All rights reserved.
//

#import "PWCProjectTitleViewController.h"
#import "DataManager.h"
#import "ASIFormDataRequest.h"
#import "PWCGlobal.h"
#import "JSON.h"
#import "PWCTasksListViewController.h"
#import "PWCPMAddTaskViewController.h"
#import "PWCAppDelegate.h"

@interface PWCProjectTitleViewController ()

@end

@implementation PWCProjectTitleViewController
@synthesize m_strProjectID;
@synthesize m_strProjectTitle;
@synthesize m_nNextPageIndex;

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
    self.navigationItem.title = self.m_strProjectTitle;
    
    m_arrList = [[NSMutableArray alloc] init];
    
    NSArray* arrList = [[DataManager sharedScoreManager] getPMTaskTitlesByProjectID: self.m_strProjectID];
    if(arrList == nil || [arrList count] <= 0)
    {
        [self getTaskTitle];
    }
    else
    {
        for(int i = 0; i < [arrList count]; i++)
        {
            NSDictionary* dicRecord = [arrList objectAtIndex: i];
            [m_arrList addObject: dicRecord];
        }
    }
    
    [self checkNewList];
}

//==============================================================================================================
-(void) checkNewList
{
    if(m_nNextPageIndex == 1)
    {
        NSDictionary* dicNew = [NSDictionary dictionaryWithObjectsAndKeys: @"-100", @"tasktitleid",
                                @"Add New List", @"tasktitle",
                                @"-1", @"taskcount",
                                nil];
        [m_arrList addObject: dicNew];
    }
}

//==============================================================================================================
-(void) getTaskTitle
{
    [SVProgressHUD showWithStatus:@"Loading ..." maskType:SVProgressHUDMaskTypeBlack];
    NSString* strURL = [@"https://pwcproject.com/v2/mobilepm/api/tasktitle" stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    
    NSLog(@"account_id = %@", [PWCGlobal getTheGlobal].account_id);
    NSLog(@"userhash = %@", [PWCGlobal getTheGlobal].hashKey);
    NSLog(@"project_id = %@", self.m_strProjectID);
    
    ASIFormDataRequest* request = [ASIFormDataRequest requestWithURL: [NSURL URLWithString: strURL]];
    [request setDelegate: self];
    [request setTimeOutSeconds: REQUEST_TIME_OUT];    
    [request setPostValue: [PWCGlobal getTheGlobal].account_id forKey: @"account_id"];
    [request setPostValue: [PWCGlobal getTheGlobal].hashKey forKey: @"userhash"];
    [request setPostValue: self.m_strProjectID forKey: @"project_id"];
    
    [request setDidFinishSelector: @selector(finishedGetTaskTitle:)];
    [request setDidFailSelector: @selector(failedSync:)];
    [request startAsynchronous];
}

//==============================================================================================================
-(void) finishedGetTaskTitle: (ASIFormDataRequest*) theRequest
{
    [SVProgressHUD showSuccessWithStatus:@"Syncing Successful."];
    NSString* strResponse = [theRequest responseString];
    NSArray* arrList = [strResponse JSONValue];
    NSLog(@"result = %@", arrList);
    
    [[DataManager sharedScoreManager] deleteAllPMTaskTitleByProjectID: self.m_strProjectID];
    [m_arrList removeAllObjects];
    
    for(int i = 0; i < [arrList count]; i++)
    {
        NSDictionary* dicRecord = [arrList objectAtIndex: i];
        [m_arrList addObject: dicRecord];
        
        [[DataManager sharedScoreManager] insertPMTaskTitle: [dicRecord valueForKey: @"tasktitleid"]
                                                  tasktitle: [dicRecord valueForKey: @"tasktitle"]
                                                  taskcount: [dicRecord valueForKey: @"taskcount"]
                                                 project_id: self.m_strProjectID];
    }
    
    [self checkNewList];
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
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    NSDictionary* dicRecord = [m_arrList objectAtIndex: indexPath.row];
    int nIndex = [[dicRecord valueForKey: @"tasktitleid"] intValue];
    if(nIndex == -100)
    {
        cell.textLabel.text =  [dicRecord valueForKey: @"tasktitle"];        
    }
    else
    {
        cell.textLabel.text =  [[PWCAppDelegate getDelegate] decodeBase64String: [dicRecord valueForKey: @"tasktitle"]];
    }

    int taskCount = [[dicRecord valueForKey: @"taskcount"] intValue];
    if(taskCount != -1)
    {
        cell.detailTextLabel.text = [NSString stringWithFormat: @"%d", taskCount];
    }

    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;    
    return cell;
}

#pragma mark - Table view delegate

//==============================================================================================================
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary* dicRecord = [m_arrList objectAtIndex: indexPath.row];
    self.m_strTitleID = [dicRecord valueForKey: @"tasktitleid"];
    
    if(m_nNextPageIndex == 0)
    {
        [self performSegueWithIdentifier: @"pm_tasks_list_segue" sender: self];
    }
    else
    {
        [self performSegueWithIdentifier: @"add_task_segue" sender: self];
    }
}

//==============================================================================================================
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if(m_nNextPageIndex == 0)
    {
        PWCTasksListViewController* nextView = segue.destinationViewController;
        nextView.m_strProjectID = self.m_strProjectID;
        nextView.m_strTitleID = self.m_strTitleID;
        nextView.m_nPrevIndex = 0;
    }
    else
    {
        PWCPMAddTaskViewController* nextView = segue.destinationViewController;
        nextView.m_strProjectID = self.m_strProjectID;
        nextView.m_strTitleID = self.m_strTitleID;
    }
}

#pragma mark -
#pragma mark Action Management.

//==============================================================================================================
-(IBAction) actionSync:(id)sender
{
    [self getTaskTitle];
}

//==============================================================================================================
@end
