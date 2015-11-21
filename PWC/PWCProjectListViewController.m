//
//  PWCProjectListViewController.m
//  PWC
//
//  Created by JianJinHu on 11/27/13.
//  Copyright (c) 2013 Premium Web Cart. All rights reserved.
//

#import "PWCProjectListViewController.h"
#import "PWCGlobal.h"
#import "ASIFormDataRequest.h"
#import "DataManager.h"
#import "JSON.h"
#import "PWCProjectTitleViewController.h"
#import "PWCPMAddTaskViewController.h"
#import "PWCPMMessageListViewController.h"
#import "PWCAppDelegate.h"

@interface PWCProjectListViewController ()

@end

@implementation PWCProjectListViewController
@synthesize m_strSelectedID;
@synthesize m_strSelectedProjectID;
@synthesize m_strSelectedName;
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
    m_arrList = [[NSMutableArray alloc] init];
    NSArray* arrList = [[DataManager sharedScoreManager] getAllProjectLists];
    if(arrList == nil || [arrList count] <= 0)
    {
        [self getProjectList];
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

//==============================================================================================================
-(void) getProjectList
{
    [SVProgressHUD showWithStatus:@"Loading ..." maskType:SVProgressHUDMaskTypeBlack];
    NSString* strURL = [@"https://pwcproject.com/v2/mobilepm/api/projectuserlist" stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    
    NSLog(@"account_id = %@", [PWCGlobal getTheGlobal].account_id);
    NSLog(@"userhash = %@", [PWCGlobal getTheGlobal].hashKey);
    
    ASIFormDataRequest* request = [ASIFormDataRequest requestWithURL: [NSURL URLWithString: strURL]];
    [request setDelegate: self];
    [request setTimeOutSeconds: REQUEST_TIME_OUT];
    [request setPostValue: [PWCGlobal getTheGlobal].account_id forKey: @"account_id"];
    [request setPostValue: [PWCGlobal getTheGlobal].hashKey forKey: @"userhash"];
    
    [request setDidFinishSelector: @selector(finishedGetProjectList:)];
    [request setDidFailSelector: @selector(failedSync:)];
    [request startAsynchronous];
}

//==============================================================================================================
-(void) finishedGetProjectList: (ASIFormDataRequest*) theRequest
{
    [SVProgressHUD showSuccessWithStatus:@"Syncing Successful."];
    NSString* strResponse = [theRequest responseString];
    NSLog(@"strResponse = %@", strResponse);
    
    NSArray* arrList = [strResponse JSONValue];
    
    [[DataManager sharedScoreManager] deleteAllProjectLists];
    [m_arrList removeAllObjects];
    
    for(int i = 0; i < [arrList count]; i++)
    {
        NSDictionary* dicRecord = [arrList objectAtIndex: i];
        [m_arrList addObject: dicRecord];
        
        [[DataManager sharedScoreManager] insertProjectList: [dicRecord valueForKey: @"Id"]
                                                   ProjName: [dicRecord valueForKey: @"ProjName"]];
        
        //UserList
        NSDictionary* dicUserList = [dicRecord valueForKey: @"Userlist"];
        if(dicUserList != nil && [dicUserList isKindOfClass: [NSDictionary class]])
        {
            NSArray* arrList = [dicUserList allValues];
            NSString* people = @"";
            
            //    [[DataManager sharedScoreManager] deleteAllPMTaskUserListByProjectID: self.m_strSelectedProjectID];
            if(arrList != nil && [arrList count] > 0)
            {
                for(int i = 0; i < [arrList count]; i++)
                {
                    people = @"";
                    
                    NSDictionary* dicUser = [arrList objectAtIndex: i];
                    NSArray* arrPeople = [[dicUser valueForKey: @"people"] allValues];
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
                                                                        selected: @"0"];
                            
                            if(people == nil || [people length] <=0 )
                            {
                                people = [dicPeople valueForKey: @"tp_id"];
                            }
                            else
                            {
                                people = [people stringByAppendingString: [NSString stringWithFormat: @",%@", [dicPeople valueForKey: @"tp_id"]]];
                            }
                        }
                    }
                    [[DataManager sharedScoreManager] insertPMTaskUserList: [dicUser valueForKey: @"tc_comapnyid"]
                                                            tc_companyname: [dicUser valueForKey: @"tc_companyname"]
                                                               tc_ismaster: [dicUser valueForKey: @"tc_ismaster"]
                                                                   tc_type: [dicUser valueForKey: @"tc_type"]
                                                                    people: people
                                                                project_id: self.m_strSelectedProjectID];
                }
            }
            
            NSLog(@"result = %@", [[DataManager sharedScoreManager] getAllPMTaskUserListByProjectID: self.m_strSelectedProjectID]);
        }
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
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSDictionary* dicRecord = [m_arrList objectAtIndex: indexPath.row];
    cell.textLabel.text = [[PWCAppDelegate getDelegate] decodeBase64String: [dicRecord valueForKey: @"ProjName"]];
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - Table view delegate

//==============================================================================================================
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary* dicRecord = [m_arrList objectAtIndex: indexPath.row];
    self.m_strSelectedID = [dicRecord valueForKey: @"Id"];
    self.m_strSelectedName = [[PWCAppDelegate getDelegate]decodeBase64String: [dicRecord valueForKey: @"ProjName"]];
    
    if(self.m_nNextPageIndex == 0 || self.m_nNextPageIndex == 1)
    {
        [self performSegueWithIdentifier: @"task_title_segue" sender: self];
    }
    //    else if()
    //    {
    //        [self performSegueWithIdentifier: @"add_task_segue" sender: self];
    //    }
    else if(self.m_nNextPageIndex == 2)
    {
        [self performSegueWithIdentifier: @"pm_message_list_segue" sender: self];
    }
}

//==============================================================================================================
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if(self.m_nNextPageIndex == 0 || self.m_nNextPageIndex == 1)
    {
        PWCProjectTitleViewController* nextView = segue.destinationViewController;
        nextView.m_strProjectID = self.m_strSelectedID;
        nextView.m_strProjectTitle = self.m_strSelectedName;
        nextView.m_nNextPageIndex = self.m_nNextPageIndex;
    }
    //    else if(self.m_nNextPageIndex == 1)
    //    {
    //        PWCPMAddTaskViewController* nextView = segue.destinationViewController;
    //        nextView.m_strProjectID = self.m_strSelectedID;
    //    }
    else if(self.m_nNextPageIndex == 2)
    {
        PWCPMMessageListViewController* nextView = segue.destinationViewController;
        nextView.m_strProjectID = self.m_strSelectedID;
    }
}


#pragma mark -
#pragma mark Action Management.

//==============================================================================================================
-(IBAction) actionSync:(id)sender
{
    [self getProjectList];
}

//==============================================================================================================
@end
