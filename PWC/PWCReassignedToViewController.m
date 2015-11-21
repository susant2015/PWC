//
//  PWCReassignedToViewController.m
//  PWC
//
//  Created by JianJinHu on 8/3/13.
//  Copyright (c) 2013 Premium Web Cart. All rights reserved.
//

#import "PWCReassignedToViewController.h"
#import "JSON.h"
#import "ASIHTTPRequest.h"
#import "PWCGlobal.h"
#import "PWCCRMGlobal.h"
#import "DataManager.h"

@interface PWCReassignedToViewController ()

@end

@implementation PWCReassignedToViewController

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
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//==============================================================================================================
-(void) initMember
{
    NSArray* arrUserList = [[DataManager sharedScoreManager] getAllRoleUsers];
    if([arrUserList count] <= 0)
    {
        [self getUserList];
    }
    else
    {
        m_arrUsers = [NSMutableArray arrayWithArray: [self sortArray: arrUserList]];
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
            
            NSComparisonResult result = [strName1 compare: strName2];
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
-(void) getUserList
{
    [m_arrUsers removeAllObjects];
    [[DataManager sharedScoreManager] deleteAllRoleUsers];

    NSString* strURL = [[NSString stringWithFormat: @"%@rolelist/%@/%@", SERVER_PENDNG_BASE_URL, [PWCGlobal getTheGlobal].merchantId, @"a8fea3db2b2692b2ee35be2d0f4fcb17"] stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    NSLog(@"rolelist = %@", strURL);
    
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
    
    NSLog(@"dic = %@", dic);
    
    NSArray* arr = [dic objectForKey: @"RoleList"];
    for(int i = 0; i < [arr count]; i++)
    {
        NSDictionary* dicRecord = [arr objectAtIndex: i];
        int admin_id = [[dicRecord objectForKey: @"admin_id"] intValue];
        NSString* email = [dicRecord objectForKey: @"email"];
        NSString* firstname = [dicRecord objectForKey: @"firstname"];
        NSString* is_def_primary = [dicRecord objectForKey: @"is_def_primary"];
        NSString* is_def_support = [dicRecord objectForKey: @"is_def_support"];
        NSString* is_def_tech = [dicRecord objectForKey: @"is_def_tech"];
        NSString* lastname = [dicRecord objectForKey: @"lastname"];
        
        [[DataManager sharedScoreManager] insertRoleUser: admin_id
                                                   email: email
                                               firstname: firstname
                                          is_def_primary: is_def_primary
                                          is_def_support: is_def_support
                                             is_def_tech: is_def_tech
                                                lastname: lastname];
    }
    
    NSArray* arrLast = [[DataManager sharedScoreManager] getAllRoleUsers];
    m_arrUsers = [NSMutableArray arrayWithArray: [self sortArray: arrLast]];
    
    [self.tableView reloadData];
}

//==============================================================================================================
- (void)requestFailed:(ASIHTTPRequest *)request
{
    [SVProgressHUD dismissWithError:@"Syncing failed. Try again later." afterDelay:1.0];
}

#pragma mark - Table view data source

//==============================================================================================================
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [m_arrUsers count];
}

//==============================================================================================================
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"reassigned_to_cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    NSDictionary* dicRecord = [m_arrUsers objectAtIndex: indexPath.row];
    NSString* strFirstName = [dicRecord objectForKey: @"firstname"];
    NSString* strLastName = [dicRecord objectForKey: @"lastname"];
    NSString* strName = [NSString stringWithFormat: @"%@ %@", strFirstName, strLastName];
    int admin_id = [[dicRecord objectForKey: @"admin_id"] intValue];
    
    cell.textLabel.text = strName;
    
    if(admin_id == [PWCGlobal getTheGlobal].m_gSelectedAdminID)
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}


#pragma mark - Table view delegate

//==============================================================================================================
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary* dicRecord = [m_arrUsers objectAtIndex: indexPath.row];
    int admin_id = [[dicRecord objectForKey: @"admin_id"] intValue];
    NSString* strFirstName = [dicRecord objectForKey: @"firstname"];
    NSString* strLastName = [dicRecord objectForKey: @"lastname"];
    NSString* strName = [NSString stringWithFormat: @"%@ %@", strFirstName, strLastName];

    
    [PWCGlobal getTheGlobal].m_gSelectedAdminID = admin_id;
    [PWCGlobal getTheGlobal].m_gUpdatedReasiggnedUserName = strName;
    [self.tableView reloadData];
}

#pragma mark -
#pragma mark Action Management.

//==============================================================================================================
-(IBAction) actionRefresh:(id)sender
{
    [self getUserList];
}

//==============================================================================================================
@end
