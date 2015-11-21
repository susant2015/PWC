//
//  PWCCRMRolesViewController.m
//  PWC
//
//  Created by JianJinHu on 8/7/13.
//  Copyright (c) 2013 Premium Web Cart. All rights reserved.
//

#import "PWCCRMRolesViewController.h"
#import "ASIHTTPRequest.h"
#import "PWCCRMGlobal.h"
#import "PWCGlobal.h"
#import "JSON.h"
#import "DataManager.h"
#import "PWCCRMRoleSelViewController.h"
#import "PWCCRMSaveNewLeadViewController.h"

@interface PWCCRMRolesViewController ()

@end

@implementation PWCCRMRolesViewController
@synthesize m_newLead;

//==============================================================================================================
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
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
    [self initMember];
}

//==============================================================================================================
-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear: animated];

    if([PWCGlobal getTheGlobal].m_gSelectedPrimaryName != nil)
    {
        [m_btnPrimary setTitle: [PWCGlobal getTheGlobal].m_gSelectedPrimaryName  forState: UIControlStateNormal];
        m_newLead.primary_role_id = [NSString stringWithFormat: @"%d",  [PWCGlobal getTheGlobal].m_gSelectedPrimaryID];
    }
    
    if([PWCGlobal getTheGlobal].m_gSelectedTechnicalName != nil)
    {
        [m_btnTechnical setTitle: [PWCGlobal getTheGlobal].m_gSelectedTechnicalName  forState: UIControlStateNormal];
        m_newLead.secondary_role_id = [NSString stringWithFormat: @"%d",  [PWCGlobal getTheGlobal].m_gSelectedTechnicalID];
    }
    
    if([PWCGlobal getTheGlobal].m_gSelectedSupportName != nil)
    {
        [m_btnSupport setTitle: [PWCGlobal getTheGlobal].m_gSelectedSupportName  forState: UIControlStateNormal];
        m_newLead.support_role_id = [NSString stringWithFormat: @"%d", [PWCGlobal getTheGlobal].m_gSelectedSupportID];
    }
    
    if([PWCGlobal getTheGlobal].m_gSelectedAssignedName != nil)
    {
        [m_btnAssignedTo setTitle: [PWCGlobal getTheGlobal].m_gSelectedAssignedName  forState: UIControlStateNormal];
        m_newLead.assignedto_role_id = [NSString stringWithFormat: @"%d",  [PWCGlobal getTheGlobal].m_gSelectedAssignedID];
    }
}

//==============================================================================================================
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

//==============================================================================================================
-(void) initMember
{
    NSLog(@"tags = %@", m_newLead.tags);
    
    NSArray* arrLeadRoleList = [[DataManager sharedScoreManager] getAllLeadRole];
    if(arrLeadRoleList == nil || [arrLeadRoleList count] <= 0)
    {
        [self getRoleList];
    }
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
}

//==============================================================================================================
- (void)requestFailed:(ASIHTTPRequest *)request
{
    //    NSError *error = [request error];
    [SVProgressHUD dismissWithError:@"Syncing failed. Try again later." afterDelay:1.0];
}


#pragma mark - 
#pragma mark Action Management.

//==============================================================================================================
-(IBAction) actionSubmit:(id)sender
{
    
}

//==============================================================================================================
-(IBAction) actionRefresh:(id)sender
{
    [self getRoleList];
}

//==============================================================================================================
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    PWCCRMRoleSelViewController *nextView = segue.destinationViewController;
    if ([segue.identifier isEqualToString:@"primary_role"])
    {
        nextView.m_nType = 0;
    }
    else if ([segue.identifier isEqualToString:@"technical_role"])
    {
        nextView.m_nType = 1;
    }
    else if([segue.identifier isEqualToString:@"support_role"])
    {
        nextView.m_nType = 2;
    }
    else if([segue.identifier isEqualToString: @"assigned_to_role"])
    {
        nextView.m_nType = 3;
    }
    else if([segue.identifier isEqualToString: @"save_new_lead_segue"])
    {
        PWCCRMSaveNewLeadViewController* nextView = segue.destinationViewController;
        nextView.m_newLead = m_newLead;
    }
}

//==============================================================================================================
@end
