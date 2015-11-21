//
//  PWCViewTaskViewController.m
//  PWC
//
//  Created by JianJinHu on 7/31/13.
//  Copyright (c) 2013 Premium Web Cart. All rights reserved.
//

#import "PWCViewTaskViewController.h"
#import "PWCCRMGlobal.h"
#import "PWCGlobal.h"
#import "DataManager.h"
#import "PWCTaskListViewController.h"
#import "ASIHTTPRequest.h"
#import "JSON.h"

@interface PWCViewTaskViewController ()

@end

@implementation PWCViewTaskViewController
@synthesize m_nFunnelID;
@synthesize m_nAdminID;

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
    NSLog(@"m_nFunnelID = %d", m_nFunnelID);
    NSLog(@"m_nAssignedID = %d", m_nAdminID);
    
    UIBarButtonItem* btnRefresh = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemRefresh target: self action: @selector(actionRefresh)];
    UIBarButtonItem* btnAdd = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemAdd target: self action: @selector(actionAdd)];
    [self.navigationItem setRightBarButtonItems: [NSArray arrayWithObjects: btnRefresh, btnAdd, nil]];
    
    m_arrInfo = [[NSMutableArray alloc] init];
    
    NSArray* arrTaskList = [[DataManager sharedScoreManager] getTaskList];
    if(arrTaskList == nil || [arrTaskList count] <= 0)
    {
        [self getTaskList];
    }
    else
    {
        [self updateTaskContent];
    }
}

//==============================================================================================================
-(void) updateTaskContent
{
    [m_arrInfo removeAllObjects];
    NSArray* arr = [[DataManager sharedScoreManager] getTaskList];
    for(int i = 0; i < [arr count]; i++)
    {
        NSDictionary* dic = [arr objectAtIndex: i];
        [m_arrInfo addObject: dic];
    }
    
    [m_tableView reloadData];
}

//==============================================================================================================
-(void) getTaskList
{
    NSString* strURL = [[NSString stringWithFormat: @"%@tasksnolist/%@/%@", SERVER_PENDNG_BASE_URL, [PWCGlobal getTheGlobal].merchantId, [PWCGlobal getTheGlobal].userHash] stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    NSLog(@"task list = %@", strURL);

    [SVProgressHUD showWithStatus:@"Loading ..." maskType:SVProgressHUDMaskTypeBlack];
    
    NSURL *url = [NSURL URLWithString: strURL];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setDelegate:self];
    [request startAsynchronous];
}

//==============================================================================================================
- (void)requestFinished:(ASIHTTPRequest *)request
{
    [SVProgressHUD showSuccessWithStatus:@"Syncing successful."];
    // Use when fetching text data
    NSString* strResponse = [request responseString];
    NSDictionary* dic = [strResponse JSONValue];
    
    NSLog(@"task list = %@", dic);
    [self updateTaskList: dic];
}

//==============================================================================================================
- (void)requestFailed:(ASIHTTPRequest *)request
{
    [SVProgressHUD dismissWithError:@"Syncing failed. Try again later." afterDelay:1.0];
}

//==============================================================================================================
-(void) updateTaskList: (NSDictionary*) json
{
    [[DataManager sharedScoreManager] deleteTaskList];
    [[DataManager sharedScoreManager] deleteAllTasks];
    
    NSLog(@"task list = %@", json);
    NSArray* arrTaskNo = [json objectForKey: @"taskno"];
    for(int i = 0; i < [arrTaskNo count]; i++)
    {
        NSDictionary* dic = [arrTaskNo objectAtIndex: i];
        NSString* task_list_name;
        int list_count;
        
        switch (i)
        {
            case 0:
                task_list_name = @"Overdue";
                list_count = [[dic objectForKey: @"Overdue"] intValue];
                break;
                
            case 1:
                task_list_name = @"Today";
                list_count = [[dic objectForKey: @"Today"] intValue];
                break;
                
            case 2:
                task_list_name = @"Tomorrow";
                list_count = [[dic objectForKey: @"Tomorrow"] intValue];
                break;
                
            case 3:
                task_list_name = @"2 Days";
                list_count = [[dic objectForKey: @"2 Days"] intValue];
                break;
                
            case 4:
                task_list_name = @"3 Days";
                list_count = [[dic objectForKey: @"3 Days"] intValue];
                break;
                
            case 5:
                task_list_name = @"4 Days";
                list_count = [[dic objectForKey: @"4 Days"] intValue];
                break;
                
            case 6:
                task_list_name = @"5 Days";
                list_count = [[dic objectForKey: @"5 Days"] intValue];
                break;
                
            case 7:
                task_list_name = @"6 Days";
                list_count = [[dic objectForKey: @"6 Days"] intValue];
                break;
        }
        
        int task_list_id = [[DataManager sharedScoreManager] insertTaskList: list_count task_list_name: task_list_name];
        NSArray* arrList = [dic objectForKey: @"lists"];
        for(int j = 0; j < [arrList count]; j++)
        {
            NSDictionary* dicList = [arrList objectAtIndex: j];
            NSString* strID = [dicList objectForKey: @"id"];
            NSString* assigned_by = [dicList objectForKey: @"assigned_by"];
            NSString* assigned_on = [dicList objectForKey: @"assigned_on"];
            NSString* assigned_to = [dicList objectForKey: @"assigned_to"];
            NSString* customer_id = [dicList objectForKey: @"customer_id"];
            NSString* assigned_to_id = [dicList objectForKey: @"assigned_to_id"];
            NSString* customer_name = [dicList objectForKey: @"customer_name"];
            NSString* delayed_by = [dicList objectForKey: @"delayed_by"];
            NSString* duedate = [dicList objectForKey: @"duedate"];
            NSString* lead_id = [dicList objectForKey: @"lead_id"];
            NSString* reason = [dicList objectForKey: @"reason"];
            NSString* status = [dicList objectForKey: @"status"];
            NSString* task = [dicList objectForKey: @"task"];
            NSString* task_id = [dicList objectForKey: @"task_id"];
            int funnel_id = [[dicList objectForKey: @"funnel_id"] intValue];
            
            [[DataManager sharedScoreManager] insertTask: strID
                                            task_list_id: task_list_id
                                             assigned_by: assigned_by
                                             assigned_on: assigned_on
                                             assigned_to: assigned_to
                                          assigned_to_id: assigned_to_id             
                                             customer_id: customer_id
                                           customer_name: customer_name
                                              delayed_by: delayed_by
                                                 duedate: duedate
                                                 lead_id: lead_id
                                                  reason: reason
                                                  status: status
                                                    task: task
                                                 task_id: task_id
                                               funnel_id: funnel_id];
        }
    }
    
    [self updateTaskContent];
}

#pragma mark -
#pragma mark Update

//==============================================================================================================
-(void)fetchJSON: (NSString*) strURL index: (int) nIndex
{
    [SVProgressHUD showWithStatus:@"Loading ..." maskType:SVProgressHUDMaskTypeBlack];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData* kivaData = [NSData dataWithContentsOfURL:
                            [NSURL URLWithString:strURL]
                            ];
        NSArray* json = nil;
        if (kivaData)
        {
            json = [NSJSONSerialization JSONObjectWithData:kivaData options:kNilOptions error:nil];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self updateUIWithDictionary: (NSDictionary*) json index: nIndex];
        });
    });
}

//==============================================================================================================
-(void)updateUIWithDictionary:(NSDictionary*)json index: (int) nIndex
{
    @try
    {
        [SVProgressHUD showSuccessWithStatus:@"Syncing successful."];
        if(json != nil)
        {
            switch (nIndex)
            {
                case GET_TASK_LIST:
                    [self updateTaskList: json];
                    break;
                    
                default:
                    break;
            }
            
        }
    }
    
    @catch (NSException *exception)
    {
        NSLog(@"exception = %@", [exception description]);
        [SVProgressHUD dismissWithError:@"Syncing failed. Try again later." afterDelay:1.0];
    }
    
    //turn off the network indicator in the status bar
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

#pragma mark -
#pragma mark - Table view data source
//==============================================================================================================
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [m_arrInfo count];
}

//==============================================================================================================
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"viewtasklist";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSDictionary* dic = [m_arrInfo objectAtIndex: indexPath.row];
    cell.textLabel.text = [dic objectForKey: @"task_list_name"];
    int nTaskListID = [[dic objectForKey: @"id"] intValue];

    NSArray* arrTasks = [[DataManager sharedScoreManager] getTaskWithListID: nTaskListID funnelID: m_nFunnelID assigned_to_id: m_nAdminID];
    int nCount = [arrTasks count];
    cell.detailTextLabel.text = [NSString stringWithFormat: @"%d", nCount];
    return cell;
}

#pragma mark - Table view delegate
//==============================================================================================================
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

//==============================================================================================================
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"task_list_segue"])
    {
        int nSelIndex = [m_tableView indexPathForSelectedRow].row;
        PWCTaskListViewController *nextView = segue.destinationViewController;
        
        NSDictionary* dic = [m_arrInfo objectAtIndex: nSelIndex];
        int nTaskListID = [[dic objectForKey: @"id"] intValue];
        NSString* strTaskListName = [dic objectForKey: @"task_list_name"];
        NSArray* arrTasks = [[DataManager sharedScoreManager] getTaskWithListID: nTaskListID funnelID: m_nFunnelID assigned_to_id: m_nAdminID];
        
        nextView.m_strName = strTaskListName;
        nextView.m_arrTaskList = [NSArray arrayWithArray: arrTasks];
        nextView.m_nTaskListIndex = nTaskListID;
        nextView.m_nFunnelID = m_nFunnelID;
    }
}

//==============================================================================================================
-(void) actionRefresh
{
    [self getTaskList];
}

//==============================================================================================================
-(void) actionAdd
{
    [self performSegueWithIdentifier: @"task_add_segue" sender: self];
}

//==============================================================================================================
@end
