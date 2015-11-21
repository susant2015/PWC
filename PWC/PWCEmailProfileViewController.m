//
//  PWCEmailProfileViewController.m
//  PWC
//
//  Created by JianJinHu on 7/25/13.
//  Copyright (c) 2013 Premium Web Cart. All rights reserved.
//

#import "PWCEmailProfileViewController.h"
#import "DataManager.h"
#import "PWCGlobal.h"

@interface PWCEmailProfileViewController ()

@end

@implementation PWCEmailProfileViewController
@synthesize m_arrProfiles;

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
    self.m_arrProfiles = [[DataManager sharedScoreManager] getAllEmailProfiles];
}

//==============================================================================================================
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source
/*
//==============================================================================================================
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 0;
}*/

//==============================================================================================================
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.m_arrProfiles count];
}

//==============================================================================================================
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"emailProfile";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    NSDictionary* dicRecord = [self.m_arrProfiles objectAtIndex: indexPath.row];
    NSString* strProfileName = [dicRecord objectForKey: @"profile_name"];

    if([strProfileName isEqualToString: [PWCGlobal getTheGlobal].m_gSelectedProfile])
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        lastIndexPath = indexPath;
    }
    cell.textLabel.text = strProfileName;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - Table view delegate
//==============================================================================================================
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* newCell = [tableView cellForRowAtIndexPath:indexPath];
    int newRow = [indexPath row];
    int oldRow = (lastIndexPath != nil) ? [lastIndexPath row] : -1;
    
    if(newRow != oldRow)
    {
        newCell.accessoryType = UITableViewCellAccessoryCheckmark;
        newCell.highlighted =YES;
        UITableViewCell* oldCell = [tableView cellForRowAtIndexPath:lastIndexPath];
        oldCell.accessoryType = UITableViewCellAccessoryNone;
        lastIndexPath = indexPath;
        oldCell.highlighted = NO;
        
    }
    [tableView deselectRowAtIndexPath:(NSIndexPath *)indexPath animated:YES];
    
    NSDictionary* dicRecord = [self.m_arrProfiles objectAtIndex: indexPath.row];
    NSString* strProfileName = [dicRecord objectForKey: @"profile_name"];
    
    [PWCGlobal getTheGlobal].m_gSelectedFrom = [dicRecord objectForKey: @"profile_from_name"];
    [PWCGlobal getTheGlobal].m_gSelectedReplyTo = [dicRecord objectForKey: @"reply_to_email"];
    [PWCGlobal getTheGlobal].m_gSelectedProfileID = [dicRecord objectForKey: @"profile_id"];
    [PWCGlobal getTheGlobal].m_gSelectedProfile = strProfileName;
}

//==============================================================================================================
@end
