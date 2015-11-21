//
//  PWCTaskListViewController.m
//  PWC
//
//  Created by JianJinHu on 7/31/13.
//  Copyright (c) 2013 Premium Web Cart. All rights reserved.
//

#import "PWCTaskListViewController.h"
#import "PWCTaskDetailViewController.h"
#import "PWCGlobal.h"
#import "PWCCRMGlobal.h"
#import "DataManager.h"
#import "JSON.h"
#import "ASIHTTPRequest.h"
#import "PWCTaskListCell.h"

@interface PWCTaskListViewController ()

@end

@implementation PWCTaskListViewController
@synthesize m_arrTaskList;
@synthesize m_strName;
@synthesize m_nTaskListIndex;
@synthesize m_nFunnelID;

//==============================================================================================================
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initMember];
}

//==============================================================================================================
-(void) initMember
{
    self.navigationItem.title = self.m_strName;
}

//==============================================================================================================
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark - Table view data source

//==============================================================================================================
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [m_arrTaskList count];
}

//==============================================================================================================
-(float) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

//==============================================================================================================
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"task_list";
    
    PWCTaskListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PWCTaskListCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    NSDictionary* dicTask = [m_arrTaskList objectAtIndex: indexPath.row];
    
    NSString* strTask = [dicTask objectForKey: @"task"];
    NSString* strCustomer = [dicTask objectForKey: @"customer_name"];
    NSString* strDueDate = [dicTask objectForKey: @"duedate"];
    
    cell.m_lblTask.text = strTask;
    cell.m_lblCustomer.text = strCustomer;
    cell.m_lblDueDate.text = strDueDate;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

//==============================================================================================================
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier: @"task_detail_segue" sender: self];
}

#pragma mark - 
#pragma mark Action Managememnt.

//==============================================================================================================
-(IBAction) actionRefresh:(id)sender
{
    [self getTaskList];
}

//==============================================================================================================
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"task_detail_segue"])
    {
        int nSelIndex = [m_tableView indexPathForSelectedRow].row;
        PWCTaskDetailViewController *nextView = segue.destinationViewController;
        
        NSDictionary* dic = [m_arrTaskList objectAtIndex: nSelIndex];
        nextView.m_dicTask = [NSDictionary dictionaryWithDictionary: dic];
    }
}

//==============================================================================================================
-(void) getTaskList
{
    //    NSString* strURL = [[NSString stringWithFormat: @"%@tasksnolist/%@/%@", SERVER_PENDNG_BASE_URL, [PWCGlobal getTheGlobal].merchantId, [PWCGlobal getTheGlobal].userHash] stringByAddingPercentEscapesUsingEncoding: NSASCIIStringEncoding];
    
    NSString* strURL = [[NSString stringWithFormat: @"%@tasksnolist/%@/%@", SERVER_PENDNG_BASE_URL, [PWCGlobal getTheGlobal].merchantId, @"a8fea3db2b2692b2ee35be2d0f4fcb17"] stringByAddingPercentEscapesUsingEncoding: NSASCIIStringEncoding];
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
    
    [self updateTaskList: dic];
}

//==============================================================================================================
- (void)requestFailed:(ASIHTTPRequest *)request
{
    //    NSError *error = [request error];
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
    
    
    NSArray* arrTasks = [[DataManager sharedScoreManager] getTaskWithListID: m_nTaskListIndex funnelID: m_nFunnelID assigned_to_id: 0];
    self.m_arrTaskList = [NSArray arrayWithArray: arrTasks];
    [m_tableView reloadData];
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

//==============================================================================================================
@end
