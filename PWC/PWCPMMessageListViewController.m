//
//  PWCPMMessageListViewController.m
//  PWC
//
//  Created by jian on 12/20/13.
//  Copyright (c) 2013 Premium Web Cart. All rights reserved.
//

#import "PWCPMMessageListViewController.h"
#import "ASIFormDataRequest.h"
#import "JSON.h"
#import "DataManager.h"
#import "PWCGlobal.h"
#import "PWCMessageListCell.h"
#import "PWCPMAddMessageViewController.h"
#import "PWCPMDetailMessageViewController.h"
#import "PWCAppDelegate.h"

@interface PWCPMMessageListViewController ()

@end

@implementation PWCPMMessageListViewController
@synthesize m_strProjectID;
@synthesize m_strSelectedMessageID;

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
-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
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
    m_arrMessageList = [[NSMutableArray alloc] init];
    
    UIBarButtonItem* btnRefresh = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemRefresh target: self action: @selector(actionRefresh:)];
    UIBarButtonItem* btnAdd = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemAdd target: self action: @selector(actionAddNew:)];
    [self.navigationItem setRightBarButtonItems: [NSArray arrayWithObjects: btnRefresh, btnAdd, nil]];
    
    NSArray* arrList = [[DataManager sharedScoreManager] getPMMessageListByProjectID: self.m_strProjectID];
    if(arrList != nil && [arrList count] > 0)
    {
        for(int i = 0; i < [arrList count]; i++)
        {
            [m_arrMessageList addObject: [arrList objectAtIndex: i]];
        }
    }
    else
    {
        [self performSelector: @selector(getMessageList) withObject: self afterDelay: 1.0f];
        return;
    }

    [m_tableView reloadData];
}

//==============================================================================================================
-(void) getMessageList
{
    [SVProgressHUD showWithStatus:@"Loading ..." maskType:SVProgressHUDMaskTypeBlack];
    NSString* strURL = [@"https://pwcproject.com/v2/mobilepm/api/messages" stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    
    NSLog(@"account_id = %@", [PWCGlobal getTheGlobal].account_id);
    NSLog(@"userhash = %@", [PWCGlobal getTheGlobal].hashKey);
    NSLog(@"project_id = %@", self.m_strProjectID);
    
    ASIFormDataRequest* request = [ASIFormDataRequest requestWithURL: [NSURL URLWithString: strURL]];
    [request setDelegate: self];
    [request setTimeOutSeconds: REQUEST_TIME_OUT];    
    [request setPostValue: [PWCGlobal getTheGlobal].account_id forKey: @"account_id"];
    [request setPostValue: [PWCGlobal getTheGlobal].hashKey forKey: @"userhash"];
    [request setPostValue: self.m_strProjectID forKey: @"project_id"];
    
    [request setDidFinishSelector: @selector(finishedGetMessageList:)];
    [request setDidFailSelector: @selector(failedSync:)];
    [request startAsynchronous];
}

//==============================================================================================================
-(void) finishedGetMessageList: (ASIFormDataRequest*) theRequest
{
    [SVProgressHUD showSuccessWithStatus:@"Syncing Successful."];
    NSString* strResponse = [theRequest responseString];
    NSLog(@"Get Message List = %@", strResponse);
    
    NSDictionary* dicList = [strResponse JSONValue];
    
    [[DataManager sharedScoreManager] deleteAllPMMessageListByProjectID: self.m_strProjectID];
    [m_arrMessageList removeAllObjects];
    
    if(dicList != nil && [dicList isKindOfClass: [NSDictionary class]])
    {
        NSArray* arrList = [dicList allValues];
        if(arrList != nil && [arrList count] > 0)
        {
            for(int i = 0; i < [arrList count]; i++)
            {
                NSDictionary* dicRecord = [arrList objectAtIndex: i];
                [m_arrMessageList addObject: dicRecord];
                
                [[DataManager sharedScoreManager] insertPMMessageList: [dicRecord valueForKey: @"Id"]
                                                                 Date: [dicRecord valueForKey: @"Date"]
                                                          MessageType: [dicRecord valueForKey: @"MessageType"]
                                                             PostedBy: [dicRecord valueForKey: @"PostedBy"]
                                                              Subject: [dicRecord valueForKey: @"Subject"]
                                                           project_id: self.m_strProjectID];
            }
        }
        
        [m_tableView reloadData];
    }
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
    return [m_arrMessageList count];
}

//==============================================================================================================
-(float) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0f;
}

//==============================================================================================================
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"pm_message_list_cell";
    
    PWCMessageListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = (PWCMessageListCell *)[PWCMessageListCell cellFromNibNamed:@"PWCMessageListCell"];
    }
    
    NSDictionary* dicRecord = [m_arrMessageList objectAtIndex: indexPath.row];
    cell.m_lblSubject.text = [[PWCAppDelegate getDelegate] decodeBase64String: [dicRecord valueForKey: @"Subject"]];
    cell.m_lblPostedBy.text = [dicRecord valueForKey: @"PostedBy"];
    cell.m_lblPostedDate.text = [dicRecord valueForKey: @"Date"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark - Table view delegate

//==============================================================================================================
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary* dicRecord = [m_arrMessageList objectAtIndex: indexPath.row];
    self.m_strSelectedMessageID = [dicRecord valueForKey: @"Id"];
    [self performSegueWithIdentifier: @"pm_message_detail_segue" sender: self];
}


//==============================================================================================================
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString: @"pm_add_new_message_segue"])
    {
        PWCPMAddMessageViewController* nextView = segue.destinationViewController;
        nextView.m_strProjectID = self.m_strProjectID;
    }
    else if([segue.identifier isEqualToString: @"pm_message_detail_segue"])
    {
        PWCPMDetailMessageViewController* nextView = segue.destinationViewController;
        nextView.m_strMessageID = self.m_strSelectedMessageID;
        nextView.m_strProjectID = self.m_strProjectID;
    }
}

#pragma mark -
#pragma mark Action Management.

//==============================================================================================================
-(IBAction) actionRefresh:(id)sender
{
    [self getMessageList];
}

//==============================================================================================================
-(IBAction) actionAddNew:(id)sender
{
    [self performSegueWithIdentifier: @"pm_add_new_message_segue" sender: self];
}

//==============================================================================================================
@end
