//
//  PWCCRMRoleSelViewController.m
//  PWC
//
//  Created by JianJinHu on 8/8/13.
//  Copyright (c) 2013 Premium Web Cart. All rights reserved.
//

#import "PWCCRMRoleSelViewController.h"
#import "DataManager.h"
#import "PWCGlobal.h"
#import "ASIFormDataRequest.h"
#import "JSON.h"
#import "PWCGlobal.h"
#import "PWCCRMGlobal.h"
#import "NSData+Base64.h"
#import "AFNetworking.h"
#import "PWCCustomers.h"
#import "PWCViewTaskViewController.h"

@interface PWCCRMRoleSelViewController ()

@end

@implementation PWCCRMRoleSelViewController
@synthesize m_nType;
@synthesize m_bFunnelUserFlag;
@synthesize m_nFunnelID;

//==============================================================================================================
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
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
-(void) initMember
{
    if (sqlite3_open([[PWCGlobal getTheGlobal].getDBPath UTF8String], &pwcDB) != SQLITE_OK) {
        NSLog(@"Failed to open DB! - Account View Controller");
    } else {
        NSLog(@"DB open! - Account View Controller");
    }
    
    m_arrTasks = [[NSMutableArray alloc] init];
    m_arrUserList = [[NSMutableArray alloc] init];
    
    NSArray* arrTemp;
    
    switch (m_nType)
    {
        case 0:
            arrTemp = [[DataManager sharedScoreManager] getLeadRoleByType: 0];
            m_titleBar.title = @"Primary Role";
            break;
            
        case 1:
            arrTemp = [[DataManager sharedScoreManager] getLeadRoleByType: 1];
            m_titleBar.title = @"Technical Role";
            break;
            
        case 2:
            arrTemp = [[DataManager sharedScoreManager] getLeadRoleByType: 2];
            m_titleBar.title = @"Support Role";
            break;
            
        case 3:
            arrTemp = [[DataManager sharedScoreManager] getAllAssignedUser];
            if(m_bFunnelUserFlag)
            {
                m_titleBar.title = @"User";                
            }
            else
            {
                m_titleBar.title = @"Assigned User";
            }
            break;
           
        case 4:
            arrTemp = [PWCGlobal getTheGlobal].customers;
            m_titleBar.title = @"Customers";
            break;
            
        case 5:
            arrTemp = [[DataManager sharedScoreManager] getAllTask2];
            m_titleBar.title = @"Choose A Task";
            break;
            
        default:
            break;
    }
    
    
    if(arrTemp == nil || [arrTemp count] <= 0)
    {
        if(m_nType == 5)
        {
            [self getTaskList];
        }
        else if(m_nType == 4)
        {
            [self refreshCustomers];
        }
        {
            [self getRoleList];
        }        
    }
    else
    {
        if(m_nType == 4)
        {
            [self updateCustomerData: arrTemp];
        }
        else if(m_nType == 5)
        {
            [self updateTaskData];
        }
        else
        {
            NSMutableArray* sortedArray = [self sortArray: arrTemp];
            
            for(int i = 0; i < [sortedArray count]; i++)
            {
                NSDictionary* dic = [sortedArray objectAtIndex: i];
                [m_arrUserList addObject: dic];
            }
        }
    }
}

//==============================================================================================================
-(NSMutableArray*) sortArray: (NSArray*) arr
{
    NSMutableArray* arrResult = [[NSMutableArray alloc] init];
    for(int i = 0; i < [arr count]; i++)
    {
        [arrResult addObject: [arr objectAtIndex: i]];
    }
    
    for(int i = 0; i < [arrResult count] - 1; i++)
    {
        for(int j = i + 1; j < [arrResult count]; j++)
        {
            NSDictionary* dicRecord1 = [arrResult objectAtIndex: i];
            
            NSString* strFirstName1 = [[dicRecord1 objectForKey: @"firstname"] lowercaseString];
            NSString* strLastName1 = [[dicRecord1 objectForKey: @"lastname"] lowercaseString];
            NSString* strName1 = [NSString stringWithFormat: @"%@ %@", strFirstName1, strLastName1];

            NSDictionary* dicRecord2 = [arrResult objectAtIndex: j];
            NSString* strFirstName2 = [[dicRecord2 objectForKey: @"firstname"] lowercaseString];
            NSString* strLastName2 = [[dicRecord2 objectForKey: @"lastname"] lowercaseString];
            NSString* strName2 = [NSString stringWithFormat: @"%@ %@", strFirstName2, strLastName2];
            
//            NSLog(@"strName 1 = %@ ============== strName2 = %@", strName1, strName2);
            NSComparisonResult result = [strName1 compare: strName2];
//            NSLog(@"result = %d", result);
            
            if (result > 0)
            {
                [arrResult replaceObjectAtIndex: i withObject: dicRecord2];
                [arrResult replaceObjectAtIndex: j withObject: dicRecord1];
            }
        }
    }
    
    return arrResult;
}

//==============================================================================================================
-(void) updateTaskData
{
    [m_arrTasks removeAllObjects];

    NSArray* arrTemp = [[DataManager sharedScoreManager] getAllTask2];
    NSMutableArray* arr1 = [[NSMutableArray alloc] init];
    NSMutableArray* arr2 = [[NSMutableArray alloc] init];
    
    for(int i = 0; i < [arrTemp count]; i++)
    {
        NSDictionary* dicRecord = [arrTemp objectAtIndex: i];
        int nType = [[dicRecord valueForKey: @"task_type"] intValue];
        
        if(nType == 1)
        {
            [arr1 addObject: dicRecord];
        }
        else
        {
            [arr2 addObject: dicRecord];
        }
    }
    

    [m_arrTasks addObject: arr1];
    [m_arrTasks addObject: arr2];
    
    [self.tableView reloadData];
}

//==============================================================================================================
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//==============================================================================================================
-(void) updateCustomerData: (NSArray*) arrTemp
{
    [m_arrUserList removeAllObjects];
    
    for(int i = 0; i < [arrTemp count]; i++)
    {
        NSDictionary* dic = [arrTemp objectAtIndex: i];
        NSArray* arrValues = [dic allValues];
        if(arrValues != nil)
        {
            for(int j = 0; j < [arrValues count]; j++)
            {
                NSArray* arrRecord = [arrValues objectAtIndex: j];
                for(int k = 0; k < [arrRecord count]; k++)
                {
                    [m_arrUserList addObject: [arrRecord objectAtIndex: k]];
                }
                
            }
        }
    }
}

#pragma mark - Table view data source

//==============================================================================================================
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(m_nType == 5)
    {
        return 2;
    }
    else
    {
        return 1;
    }
}

//==============================================================================================================
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(m_nType == 5)
    {
        if(section == 0)
        {
            return @"Default Task";
        }
        else
        {
            return @"Other Task";
        }
    }
    
    return nil;
}

//==============================================================================================================
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(m_nType == 5)
    {
        if(m_arrTasks != nil && [m_arrTasks count] > 0)
        {
            if([m_arrTasks objectAtIndex: section] != nil && [[m_arrTasks objectAtIndex: section] count] > 0)
            {
                return [[m_arrTasks objectAtIndex: section] count];
            }
        }
    }
    else
    {
        if(m_bFunnelUserFlag)
        {
            return [m_arrUserList count] + 1;
        }
        else
        {
            return [m_arrUserList count];
        }
        
    }

    return 0;
}

//==============================================================================================================
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"role_cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    if(m_nType == 4)
    {
        NSDictionary* dicRecord = [m_arrUserList objectAtIndex: indexPath.row];        
        NSString* strFirstName = [dicRecord objectForKey: @"firstName"];
        NSString* strLastName = [dicRecord objectForKey: @"lastName"];
        NSString* strName = [NSString stringWithFormat: @"%@ %@", strFirstName, strLastName];
        int admin_id = [[dicRecord objectForKey: @"customerId"] intValue];
        if(admin_id == m_nSelectID)
        {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        cell.textLabel.text = strName;
    }
    else if(m_nType == 5)
    {
        NSDictionary* dicRecord = [[m_arrTasks objectAtIndex: indexPath.section] objectAtIndex: indexPath.row];
        NSString* strTaskName = [dicRecord objectForKey: @"task_name"];
        int task_id = [[dicRecord objectForKey: @"task_id"] intValue];
        if(task_id == m_nSelectID)
        {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        cell.textLabel.text = strTaskName;
    }
    else
    {        
        if(m_bFunnelUserFlag)
        {
            if(indexPath.row == 0)
            {
                cell.textLabel.text = @"Admin/User";
            }
            else
            {
                NSDictionary* dicRecord = [m_arrUserList objectAtIndex: indexPath.row - 1];
                NSString* strFirstName = [dicRecord objectForKey: @"firstname"];
                NSString* strLastName = [dicRecord objectForKey: @"lastname"];
                NSString* strName = [NSString stringWithFormat: @"%@ %@", strFirstName, strLastName];
                cell.textLabel.text = strName;
            }
            
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        else
        {
            NSDictionary* dicRecord = [m_arrUserList objectAtIndex: indexPath.row];
            NSString* strFirstName = [dicRecord objectForKey: @"firstname"];
            NSString* strLastName = [dicRecord objectForKey: @"lastname"];
            NSString* strName = [NSString stringWithFormat: @"%@ %@", strFirstName, strLastName];
            int admin_id = [[dicRecord objectForKey: @"admin_id"] intValue];

            cell.textLabel.text = strName;
            
            if(admin_id == m_nSelectID)
            {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
            else
            {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
        }
    }
    
    
    return cell;
}

#pragma mark - Table view delegate

//==============================================================================================================
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Configure the cell...

    if(m_nType == 4)
    {
        NSDictionary* dicRecord = [m_arrUserList objectAtIndex: indexPath.row];
        NSString* strFirstName = [dicRecord objectForKey: @"firstName"];
        NSString* strLastName = [dicRecord objectForKey: @"lastName"];
        NSString* strName = [NSString stringWithFormat: @"%@ %@", strFirstName, strLastName];
        int admin_id = [[dicRecord objectForKey: @"customerId"] intValue];
        
        [PWCGlobal getTheGlobal].m_gSelectedCustomerID = admin_id;
        [PWCGlobal getTheGlobal].m_gSelectedCustomerName = strName;

        m_nSelectID = admin_id;
    }
    else if(m_nType == 5)
    {
        NSDictionary* dicRecord = [[m_arrTasks objectAtIndex: indexPath.section] objectAtIndex: indexPath.row];
        [PWCGlobal getTheGlobal].m_gSelectedTaskName = [dicRecord objectForKey: @"task_name"];
        [PWCGlobal getTheGlobal].m_gSelectedTaskID = [[dicRecord objectForKey: @"task_id"] intValue];
        m_nSelectID = [[dicRecord objectForKey: @"task_id"] intValue];
    }
    else
    {
        if(m_bFunnelUserFlag)
        {
            int admin_id = 0;
            if(indexPath.row == 0)
            {
                admin_id = 0;
            }
            else
            {
                NSDictionary* dicRecord = [m_arrUserList objectAtIndex: indexPath.row - 1];
                admin_id = [[dicRecord objectForKey: @"admin_id"] intValue];
            }
            
            [PWCGlobal getTheGlobal].m_gSelectedAssignedID = admin_id;
        }
        else
        {
            NSDictionary* dicRecord = [m_arrUserList objectAtIndex: indexPath.row];
            NSString* strFirstName = [dicRecord objectForKey: @"firstname"];
            NSString* strLastName = [dicRecord objectForKey: @"lastname"];
            NSString* strName = [NSString stringWithFormat: @"%@ %@", strFirstName, strLastName];
            int admin_id = [[dicRecord objectForKey: @"admin_id"] intValue];
            
            switch (m_nType)
            {
                case 0:
                    [PWCGlobal getTheGlobal].m_gSelectedPrimaryName = strName;
                    [PWCGlobal getTheGlobal].m_gSelectedPrimaryID = admin_id;
                    break;
                    
                case 1:
                    [PWCGlobal getTheGlobal].m_gSelectedTechnicalName = strName;
                    [PWCGlobal getTheGlobal].m_gSelectedTechnicalID = admin_id;
                    break;
                    
                case 2:
                    [PWCGlobal getTheGlobal].m_gSelectedSupportName = strName;
                    [PWCGlobal getTheGlobal].m_gSelectedSupportID = admin_id;
                    break;
                    
                case 3:
                    [PWCGlobal getTheGlobal].m_gSelectedAssignedName = strName;
                    [PWCGlobal getTheGlobal].m_gSelectedAssignedID = admin_id;
                    break;
                    
                default:
                    break;
            }

            m_nSelectID = admin_id;
        }
        
        if(m_bFunnelUserFlag)
        {
            [self performSegueWithIdentifier: @"user_task_segue" sender: self];
        }
    }
    
    [self.tableView reloadData];
}


//==============================================================================================================
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"user_task_segue"])
    {
        PWCViewTaskViewController *nextView = segue.destinationViewController;
        nextView.m_nFunnelID = m_nFunnelID;
        nextView.m_nAdminID = [PWCGlobal getTheGlobal].m_gSelectedAssignedID;
    }
}

//==============================================================================================================
-(void) getTaskList
{
    NSString* strURL = [[NSString stringWithFormat: @"%@tasklist/%@/%@", SERVER_PENDNG_BASE_URL, [PWCGlobal getTheGlobal].merchantId, [PWCGlobal getTheGlobal].userHash] stringByAddingPercentEscapesUsingEncoding: NSASCIIStringEncoding];
    NSLog(@"task list = %@", strURL);
    [SVProgressHUD showWithStatus:@"Loading ..." maskType:SVProgressHUDMaskTypeBlack];
    
    NSURL *url = [NSURL URLWithString: strURL];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(doneGetTask:)];
    [request startAsynchronous];
    
}

//==============================================================================================================
-(void) doneGetTask:(ASIHTTPRequest *)request
{
    [[DataManager sharedScoreManager] deleteAllTask2];
    [m_arrUserList removeAllObjects];
    
    [SVProgressHUD showSuccessWithStatus:@"Syncing successful."];
    NSString* strResponse = [request responseString];
    NSDictionary* dic = [strResponse JSONValue];
    NSArray* arrTasks = [dic objectForKey: @"TasksList"];
    
    if(arrTasks == nil) return;
    for(int i = 0; i < [arrTasks count]; i++)
    {
        NSDictionary* dicRecord = [arrTasks objectAtIndex: i];
        int task_id = [[dicRecord valueForKey: @"task_id"] intValue];
        NSString* task_name = [dicRecord valueForKey: @"task_name"];
        int task_type = [[dicRecord valueForKey: @"task_type"] intValue];
        
        NSData* data = [NSData dataFromBase64String: task_name];
        NSString* task_name2 = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];

        [[DataManager sharedScoreManager] insertTask2: task_id task_name: task_name2 task_type: task_type];
    }
    
    [self updateTaskData];
}

//==============================================================================================================
-(void) getRoleList
{
    NSString* strURL = [[NSString stringWithFormat: @"%@allrolelist/%@/%@", SERVER_PENDNG_BASE_URL, [PWCGlobal getTheGlobal].merchantId, @"a8fea3db2b2692b2ee35be2d0f4fcb17"] stringByAddingPercentEscapesUsingEncoding: NSASCIIStringEncoding];
    NSLog(@"role url = %@", strURL);
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
    NSString* strResponse = [request responseString];
    NSDictionary* dic = [strResponse JSONValue];
    NSArray* arrPrimaryRoleList = [dic objectForKey: @"PrimaryRoleList"];
    NSArray* arrTechnicalRoleList = [dic objectForKey: @"TechnicalRoleList"];
    NSArray* arrSupportList = [dic objectForKey: @"SupportRoleList"];
    NSArray* arrAssignedList = [dic objectForKey: @"AssignedRoleList"];
    
    [self updatePrimaryRoleList: arrPrimaryRoleList
                  technicalList: arrTechnicalRoleList
                    supportList: arrSupportList
                   assignedList: arrAssignedList];
}

//==============================================================================================================
-(void) updatePrimaryRoleList: (NSArray*) arrRoleList
                technicalList: (NSArray*) technicalList
                  supportList: (NSArray*) supportList
                 assignedList: (NSArray*) assignedList
{
    NSLog(@"PrimaryRoleList = %@", arrRoleList);
    NSLog(@"technicalList = %@", technicalList);
    NSLog(@"supportList = %@", supportList);
    NSLog(@"assignedList = %@", assignedList);
    
    [m_arrUserList removeAllObjects];
    [[DataManager sharedScoreManager] deleteAllLeadRole];
    [[DataManager sharedScoreManager] deleteAllAssignedUser];
    
    //Primary Role User.
    for(int i = 0; i < [arrRoleList count]; i++)
    {
        NSDictionary* dicPrimary = [arrRoleList objectAtIndex: i];
        int admin_id = [[dicPrimary objectForKey: @"admin_id"] intValue];
        NSString* email = [dicPrimary objectForKey: @"email"];
        NSString* firstname = [dicPrimary objectForKey: @"firstname"];
        int is_def_primary = [[dicPrimary objectForKey: @"is_def_primary"] intValue];
        int is_def_support = [[dicPrimary objectForKey: @"is_def_support"] intValue];
        int is_def_tech = [[dicPrimary objectForKey: @"is_def_tech"] intValue];
        NSString* lastname = [dicPrimary objectForKey: @"lastname"];
        [[DataManager sharedScoreManager] insertLeadRole: admin_id
                                                   email: email
                                               firstname: firstname
                                          is_def_primary: is_def_primary
                                          is_def_support: is_def_support
                                             is_def_tech: is_def_tech
                                                lastname: lastname
                                               role_type: 0];
    }
    
    //technicalList Role User.
    for(int i = 0; i < [technicalList count]; i++)
    {
        NSDictionary* dicPrimary = [technicalList objectAtIndex: i];
        int admin_id = [[dicPrimary objectForKey: @"admin_id"] intValue];
        NSString* email = [dicPrimary objectForKey: @"email"];
        NSString* firstname = [dicPrimary objectForKey: @"firstname"];
        int is_def_primary = [[dicPrimary objectForKey: @"is_def_primary"] intValue];
        int is_def_support = [[dicPrimary objectForKey: @"is_def_support"] intValue];
        int is_def_tech = [[dicPrimary objectForKey: @"is_def_tech"] intValue];
        NSString* lastname = [dicPrimary objectForKey: @"lastname"];
        [[DataManager sharedScoreManager] insertLeadRole: admin_id
                                                   email: email
                                               firstname: firstname
                                          is_def_primary: is_def_primary
                                          is_def_support: is_def_support
                                             is_def_tech: is_def_tech
                                                lastname: lastname
                                               role_type: 1];
    }
    NSLog(@"technical = %d", [[[DataManager sharedScoreManager] getAllLeadRole] count]);
    
    //supportList Role User.
    for(int i = 0; i < [supportList count]; i++)
    {
        NSDictionary* dicPrimary = [supportList objectAtIndex: i];
        int admin_id = [[dicPrimary objectForKey: @"admin_id"] intValue];
        NSString* email = [dicPrimary objectForKey: @"email"];
        NSString* firstname = [dicPrimary objectForKey: @"firstname"];
        int is_def_primary = [[dicPrimary objectForKey: @"is_def_primary"] intValue];
        int is_def_support = [[dicPrimary objectForKey: @"is_def_support"] intValue];
        int is_def_tech = [[dicPrimary objectForKey: @"is_def_tech"] intValue];
        NSString* lastname = [dicPrimary objectForKey: @"lastname"];
        [[DataManager sharedScoreManager] insertLeadRole: admin_id
                                                   email: email
                                               firstname: firstname
                                          is_def_primary: is_def_primary
                                          is_def_support: is_def_support
                                             is_def_tech: is_def_tech
                                                lastname: lastname
                                               role_type: 2];
    }
    
    //assignedList Role User.
    for(int i = 0; i < [assignedList count]; i++)
    {
        NSDictionary* dicPrimary = [assignedList objectAtIndex: i];
        int admin_id = [[dicPrimary objectForKey: @"admin_id"] intValue];
        NSString* email = [dicPrimary objectForKey: @"email"];
        NSString* firstname = [dicPrimary objectForKey: @"firstname"];
        int coach_row_id = [[dicPrimary objectForKey: @"coach_row_id"] intValue];
        NSString* lastname = [dicPrimary objectForKey: @"lastname"];
        [[DataManager sharedScoreManager] insertAssignedUser: admin_id
                                                coach_row_id: coach_row_id
                                                       email: email
                                                   firstname: firstname
                                                    lastname: lastname];
    }
    
    NSArray* arrTemp = [[NSArray alloc] init];
    switch (m_nType)
    {
        case 0:
            arrTemp = [[DataManager sharedScoreManager] getLeadRoleByType: 0];
            break;
            
        case 1:
            arrTemp = [[DataManager sharedScoreManager] getLeadRoleByType: 1];
            break;
            
        case 2:
            arrTemp = [[DataManager sharedScoreManager] getLeadRoleByType: 2];
            break;
            
        case 3:
            arrTemp = [[DataManager sharedScoreManager] getAllAssignedUser];
            break;
            
        default:
            break;
    }
    
    if(arrTemp == nil) return;
    
    NSMutableArray* sortedArray = [self sortArray: arrTemp];
    
    for(int i = 0; i < [sortedArray count]; i++)
    {
        NSDictionary* dic = [sortedArray objectAtIndex: i];
        [m_arrUserList addObject: dic];
    }
    
    [self.tableView reloadData];
}

//==============================================================================================================
- (void)requestFailed:(ASIHTTPRequest *)request
{
    //    NSError *error = [request error];
    [SVProgressHUD dismissWithError:@"Syncing failed. Try again later." afterDelay:1.0];
}

//==============================================================================================================
-(IBAction) actionRefresh:(id)sender
{
    switch (m_nType)
    {
        case 0:
        case 1:
        case 2:
        case 3:
            [self getRoleList];
            break;
            
        case 4:
            [self refreshCustomers];
            break;
            
        case 5:
            [self getTaskList];
            break;
        default:
            break;
    }

}

//==============================================================================================================
- (void)saveCustomerData:(NSArray *)customers
{
    int ok = 0, notok = 0;
    
    for (NSDictionary *d in customers) {
        if ([self insertCustomerData:d]) {
            ok++;
        } else {
            notok++;
        }
    }
    NSLog(@"OK: %d, NOT OK: %d", ok, notok);
}

//==============================================================================================================
- (BOOL)insertCustomerData:(NSDictionary *)customer
{
    BOOL done = NO;
    sqlite3_stmt *statement;
    NSLog(@"%@", customer);
    
    NSString *section = @"#";
    
    if ([[customer objectForKey:@"first_name"] length] > 0) {
        section = [[[customer objectForKey:@"first_name"] substringToIndex:1] uppercaseString];
    }
    
    NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO customers (customerId, customerCrmId, firstName, lastName, homePhone, workPhone, email, address, city, state, zipCode, country, fax, companyName, balance, notes, section, crm_customer) VALUES ('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",
                           [customer objectForKey:@"customer_id"],
                           [customer objectForKey:@"customer_crm_id"],
                           [customer objectForKey:@"first_name"],
                           [customer objectForKey:@"last_name"],
                           
                           [customer objectForKey:@"home_phone_number"],
                           [customer objectForKey:@"work_phone_number"],
                           [customer objectForKey:@"customer_email"],
                           [NSString stringWithFormat:@"%@, %@", [customer objectForKey:@"address_line1"],[customer objectForKey:@"address_line2"]],
                           
                           [customer objectForKey:@"customer_city"],
                           [customer objectForKey:@"customer_state"],
                           [customer objectForKey:@"customer_zip"],
                           [customer objectForKey:@"country"],
                           
                           [customer objectForKey:@"fax"],
                           [customer objectForKey:@"company_name"],
                           [customer objectForKey:@"balance"],
                           @"",
                           section,
                           [customer objectForKey:@"crm_customer"]];
    
    const char *insert_stmt = [insertSQL UTF8String];
    // NSLog(@"%@", orderDetail);
    sqlite3_prepare_v2(pwcDB, insert_stmt, -1, &statement, NULL);
    if (sqlite3_step(statement) == SQLITE_DONE) {
        done = YES;
    } else {
        done = NO;
    }
    
    sqlite3_finalize(statement);
    
    return done;
}


//==============================================================================================================
-(void) refreshCustomers
{
    [SVProgressHUD showWithStatus:@"Loading ..." maskType:SVProgressHUDMaskTypeBlack];
    [self performSelector: @selector(doGetCustomers) withObject: self afterDelay: 0.1f];
}

//==============================================================================================================
- (void)doGetCustomers
{
    // TRUNCATE TABLE
    [self deleteCustomerData];
    
    NSURL *url = [NSURL URLWithString:@"https://www.pwccrm.com"];
    NSString *path = [NSString stringWithFormat:@"/beta/api2/api/customerlist/%@/%@", [PWCGlobal getTheGlobal].merchantId, [PWCGlobal getTheGlobal].userHash];
    //}
    
    // Call API and Get Data
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [httpClient setDefaultHeader:@"Accept" value:@"application/json"];
    
    if (([PWCCustomers customers].lastCustomerId != nil) && ([[PWCCustomers customers].lastCustomerId length] > 0)) {
        path = [NSString stringWithFormat:@"%@/%@", path, [PWCCustomers customers].lastCustomerId];
    }
    
    
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET" path:path parameters:nil];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                                            //NSLog(@"Success");
                                                                                            NSLog(@"CUSTOMER DATA: %@", JSON);
                                                                                            
                                                                                            int resultCode = [[JSON objectForKey:@"result"] intValue];
                                                                                            
                                                                                            if (resultCode == 1) {
                                                                                                NSArray *customerArray = [JSON objectForKey:@"customers"];
                                                                                                [self saveCustomerData: customerArray];
                                                                                            }
                                                                                            
                                                                                            [PWCGlobal getTheGlobal].customers = [PWCCustomers customers].pwcCustomers;
                                                                                            [self updateCustomerData: [PWCGlobal getTheGlobal].customers];
                                                                                            [SVProgressHUD showSuccessWithStatus:@"Customers Synced."];
                                                                                            
                                                                                            [self.tableView reloadData];
                                                                                        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                                            //NSLog(@"Failure");
                                                                                            
                                                                                            [SVProgressHUD dismissWithError:@"Syncing failed. Try again later." afterDelay:1.0];
                                                                                            [PWCGlobal getTheGlobal].customers = [PWCCustomers customers].pwcCustomers;
                                                                                        }];
    [operation start];
    [operation waitUntilFinished];
}

//==============================================================================================================
- (BOOL)deleteStatement:(NSString *)sql
{
    BOOL done = NO;
    sqlite3_stmt *statement;
    
    NSString *updateSQL = sql;
    
    const char *update_stmt = [updateSQL UTF8String];
    
    sqlite3_prepare_v2(pwcDB, update_stmt, -1, &statement, NULL);
    if (sqlite3_step(statement) == SQLITE_DONE)
    {
        done = YES;
    } else {
        done = NO;
    }
    
    sqlite3_finalize(statement);
    return done;
}

//==============================================================================================================
- (void)deleteCustomerData
{
    if ([self deleteStatement:@"DELETE FROM customers"]) {
        if ([self deleteStatement:@"DELETE FROM sqlite_sequence WHERE name = 'customers'"]) {
            NSLog(@"DELETE DONE");
        }
    }
}

//==============================================================================================================
@end
