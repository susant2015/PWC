//
//  PWCiPhoneCRMTagsViewController.m
//  PWC
//
//  Created by Samiul Hoque on 7/9/13.
//  Copyright (c) 2013 Premium Web Cart. All rights reserved.
//

#import "PWCiPhoneCRMTagsViewController.h"
#import "PWCGlobal.h"
#import "PWCNewLead.h"
#import "PWCCRMData.h"
#import "NSDictionary+MutableDeepCopy.h"
#import "JSON.h"
#import "ASIHTTPRequest.h"
#import "PWCCRMGlobal.h"
#import "DataManager.h"
#import "PWCCRMRolesViewController.h"

@interface PWCiPhoneCRMTagsViewController ()

@end

@implementation PWCiPhoneCRMTagsViewController
@synthesize m_newLead;

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
    NSLog(@"m_newLead = %@", m_newLead.salespaths);
    
    m_arrTags = [[NSMutableArray alloc] init];
    m_arrTagIDs = [[NSMutableArray alloc] init];
    
    NSArray* arrCategory = [[DataManager sharedScoreManager] getAllCategory];
    if(arrCategory == nil || [arrCategory count] <= 0)
    {
        [self getTagList];
    }
    else
    {
        for(int i = 0; i < [arrCategory count]; i++)
        {
            NSDictionary* dicCategory = [arrCategory objectAtIndex: i];
            [m_arrTags addObject: dicCategory];
        }
    }
}

//==============================================================================================================
-(void) getTagList
{
    NSString* strURL = [[NSString stringWithFormat: @"%@tags/%@/%@", SERVER_PENDNG_BASE_URL, [PWCGlobal getTheGlobal].merchantId, [PWCGlobal getTheGlobal].userHash] stringByAddingPercentEscapesUsingEncoding: NSASCIIStringEncoding];
    
    [SVProgressHUD showWithStatus:@"Loading ..." maskType:SVProgressHUDMaskTypeBlack];
    
    NSURL *url = [NSURL URLWithString: strURL];
    
    NSLog(@"Tags List = %@", strURL);
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setDelegate:self];
    [request startAsynchronous];
}

//==============================================================================================================
- (void)requestFinished:(ASIHTTPRequest *)request
{
    [SVProgressHUD showSuccessWithStatus:@"Syncing Successful."];
    NSString* strResponse = [request responseString];
    NSDictionary* dic = [strResponse JSONValue];
    NSArray* arrTags = [dic objectForKey: @"Tags"];
    [self updateTagList: arrTags];
}

//==============================================================================================================
-(void) updateTagList: (NSArray*) arrTags
{
    [[DataManager sharedScoreManager] deleteAllCategoy];
    [[DataManager sharedScoreManager] deleteAllTag];
    [m_arrTags removeAllObjects];
    
    for(int i = 0; i < [arrTags count]; i++)
    {
        NSDictionary* dicCategory = [arrTags objectAtIndex: i];
        NSString* category_name = [dicCategory objectForKey: @"category_name"];
        int category_type = [[dicCategory objectForKey: @"category_type"] intValue];
        int tag_category_id = [[dicCategory objectForKey: @"tag_category_id"] intValue];
        NSArray* arrTags = [dicCategory objectForKey: @"tags"];
        
        NSString* strTags = @"";
        
        for (int j = 0; j < [arrTags count]; j++)
        {
            NSDictionary* dicTags = [arrTags objectAtIndex: j];
            int tag_id = [[dicTags objectForKey: @"tag_id"] intValue];
            NSString* tag_name = [dicTags objectForKey: @"tag_name"];
            
            if(strTags == nil || [strTags length] <= 0)
            {
                strTags = [NSString stringWithFormat: @"%d", tag_id];
            }
            else
            {
                strTags = [strTags stringByAppendingString: [NSString stringWithFormat: @",%d", tag_id]];
            }
            [[DataManager sharedScoreManager] insertTag: tag_id tag_name: tag_name];
        }
        
        [[DataManager sharedScoreManager] insertCategory: tag_category_id category_name: category_name category_type: category_type tags: strTags];
    }
    
    NSArray* arrCategory = [[DataManager sharedScoreManager] getAllCategory];
    for(int i = 0; i < [arrCategory count]; i++)
    {
        NSDictionary* dicCategory = [arrCategory objectAtIndex: i];
        [m_arrTags addObject: dicCategory];
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
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
//==============================================================================================================
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [m_arrTags count];
}

//==============================================================================================================
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary* dicCategory = [m_arrTags objectAtIndex: section];
    NSString* strTags = [dicCategory objectForKey: @"tags"];
    if([strTags isKindOfClass: [NSNumber class]])
    {
        return 1;
    }
    else
    {
        NSArray* arrTags = [strTags componentsSeparatedByString: @","];
        return [arrTags count];
    }
}

//==============================================================================================================
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"tagsCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSUInteger section = [indexPath section];
    NSUInteger row = [indexPath row];
    
    NSDictionary* dicCategory = [m_arrTags objectAtIndex: section];
    NSString* strTags = [dicCategory objectForKey: @"tags"];
    
    int nTag;
    if([strTags isKindOfClass: [NSNumber class]])
    {
        nTag = [strTags intValue];
    }
    else
    {
        NSArray* arrTags = [strTags componentsSeparatedByString: @","];
        nTag = [[arrTags objectAtIndex: row] intValue];
    }
    
    NSArray* arrTempTag = [[DataManager sharedScoreManager] getTagWithID: nTag];
    if(arrTempTag != nil && [arrTempTag count] > 0)
    {
        NSDictionary* dicTag = [arrTempTag objectAtIndex: 0];
        NSString* strTagName = [dicTag objectForKey: @"tag_name"];
        cell.textLabel.text = strTagName;
        
        int tag_id = [[dicTag objectForKey: @"tag_id"] intValue];
        if([self checkUITagID: tag_id])
        {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        
    }
    return cell;
}

//==============================================================================================================
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSDictionary* dicCategory = [m_arrTags objectAtIndex: section];
    NSString* strCategory = [dicCategory objectForKey: @"category_name"];
    return strCategory;
}

#pragma mark - Table view delegate
//==============================================================================================================
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger section = [indexPath section];
    NSUInteger row = [indexPath row];
    
    NSDictionary* dicCategory = [m_arrTags objectAtIndex: section];
    NSString* strTags = [dicCategory objectForKey: @"tags"];
    
    int nTag;
    if([strTags isKindOfClass: [NSNumber class]])
    {
        nTag = [strTags intValue];
    }
    else
    {
        NSArray* arrTags = [strTags componentsSeparatedByString: @","];
        nTag = [[arrTags objectAtIndex: row] intValue];
    }
    
    NSArray* arrTempTag = [[DataManager sharedScoreManager] getTagWithID: nTag];
    if(arrTempTag != nil && [arrTempTag count] > 0)
    {
        NSDictionary* dicTag = [arrTempTag objectAtIndex: 0];
        int nTagID = [[dicTag objectForKey: @"tag_id"] intValue];
        
        [self checkTagID: nTagID];
    }
    
    [self.tableView reloadData];
}

//==============================================================================================================
-(BOOL) checkUITagID: (int) salesPath_slider_id
{
    if([m_arrTagIDs count] <= 0) return NO;
    
    for(int i = 0; i < [m_arrTagIDs count]; i++)
    {
        int nID = [[m_arrTagIDs objectAtIndex: i] intValue];
        if(nID == salesPath_slider_id)
        {
            return YES;
        }
    }
    return NO;
}


//==============================================================================================================
-(void) checkTagID: (int) salesPath_slider_id
{
    BOOL bFlag = YES;
    
    for(int i = 0; i < [m_arrTagIDs count]; i++)
    {
        int nID = [[m_arrTagIDs objectAtIndex: i] intValue];
        if(nID == salesPath_slider_id)
        {
            [m_arrTagIDs removeObjectAtIndex: i];
            return;
        }
    }
    
    if(bFlag)
    {
        [m_arrTagIDs addObject: [NSString stringWithFormat: @"%d", salesPath_slider_id]];
    }
}

//==============================================================================================================
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"role_segue"])
    {
        PWCCRMRolesViewController *nextView = segue.destinationViewController;
        [m_newLead.tags removeAllObjects];        
        for(int i = 0; i < [m_arrTagIDs count]; i++)
        {
            int nID = [[m_arrTagIDs objectAtIndex: i] intValue];
            [m_newLead.tags addObject: [NSString stringWithFormat: @"%d", nID]];
        }
        
        nextView.m_newLead = m_newLead;
    }
}

#pragma mark -
#pragma mark Action Management.

//==============================================================================================================
-(IBAction) actionRefresh:(id)sender
{
    [self getTagList];
}

//==============================================================================================================
@end
