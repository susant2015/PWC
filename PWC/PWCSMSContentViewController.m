//
//  PWCSMSContentViewController.m
//  PWC
//
//  Created by JianJinHu on 7/29/13.
//  Copyright (c) 2013 Premium Web Cart. All rights reserved.
//

#import "PWCSMSContentViewController.h"
#import "PWCGlobal.h"
#import "DataManager.h"

@interface PWCSMSContentViewController ()

@end

@implementation PWCSMSContentViewController
@synthesize m_arrContents;

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
    m_nSelRow = -1;
    m_nSelSection = -1;
    m_arrContents = [[NSMutableArray alloc] init];
    
    //Get the Category
    NSMutableArray* arrCategory = [[NSMutableArray alloc] init];
    NSArray* arrLocal = [[DataManager sharedScoreManager] getAllSMSContents];
    for(int i = 0; i < [arrLocal count]; i++)
    {
        NSDictionary* dic = [arrLocal objectAtIndex: i];
        NSString* strCatID = [dic objectForKey: @"cat_id"];
        NSString* strCategory = [dic objectForKey: @"category"];
        
        BOOL bFlag = YES;
        for(int j = 0; j < [arrCategory count]; j++)
        {
            NSString* strRecord = [arrCategory objectAtIndex: j];
            NSArray* arrTemp = [strRecord componentsSeparatedByString: @", "];
            NSString* strPrevCat = [arrTemp objectAtIndex: 0];
            if([strCatID isEqualToString: strPrevCat])
            {
                bFlag = NO;
                break;
            }
        }
        
        NSString* strRecord = [NSString stringWithFormat: @"%@, %@", strCatID, strCategory];
        if(bFlag) [arrCategory addObject: strRecord];
    }
    
    //Order according to the category.
    for(int i = 0; i < [arrCategory count]; i++)
    {
        NSString* strRecord = [arrCategory objectAtIndex: i];
        NSArray* arrTemp = [strRecord componentsSeparatedByString: @", "];
        NSString* strCatID = [arrTemp objectAtIndex: 0];
        NSString* strCatName = [arrTemp objectAtIndex: 1];
        
        NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
        [dic setValue: strCatName forKey: @"category"];
        NSMutableArray* arrContents = [[NSMutableArray alloc] init];
        
        for(int j = 0; j < [arrLocal count]; j++)
        {
            NSDictionary* dicData = [arrLocal objectAtIndex: j];
            NSString* strNextCatID = [dicData objectForKey: @"cat_id"];
            if([strCatID isEqualToString: strNextCatID])
            {
                [arrContents addObject: dicData];
            }
        }
        [dic setValue: arrContents forKey: @"content"];
        [m_arrContents addObject: dic];
    }
    
    
}

#pragma mark - Table view data source
//==============================================================================================================
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [m_arrContents count];
}

//==============================================================================================================
-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSDictionary* dicRecord = [m_arrContents objectAtIndex: section];
    NSString* strCategory = [dicRecord objectForKey: @"category"];
    return strCategory;
}

//==============================================================================================================
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary* dicRecord = [m_arrContents objectAtIndex: section];
    NSArray* arrContents = [dicRecord objectForKey: @"content"];
    return [arrContents count];
}

//==============================================================================================================
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"smscontent";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSDictionary* dicRecord = [m_arrContents objectAtIndex: indexPath.section];
    NSArray* arrContents = [dicRecord objectForKey: @"content"];
    NSDictionary* dic = [arrContents objectAtIndex: indexPath.row];
    NSString* strSubject = [dic objectForKey: @"signature"];
    NSString* strContentID = [dic objectForKey: @"content_id"];
    
    cell.textLabel.text = strSubject;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if([strContentID isEqualToString: [PWCGlobal getTheGlobal].m_gSelectedSMSContentID])
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
    m_nSelSection = indexPath.section;
    m_nSelRow = indexPath.row;
    
    NSDictionary* dicRecord = [m_arrContents objectAtIndex: indexPath.section];
    NSArray* arrContents = [dicRecord objectForKey: @"content"];
    NSDictionary* dic = [arrContents objectAtIndex: indexPath.row];
    NSString* strSubject = [dic objectForKey: @"subject"];
    NSString* strSignature = [dic objectForKey: @"signature"];
    
    [PWCGlobal getTheGlobal].m_gSelectedSMSSubject = strSubject;
    [PWCGlobal getTheGlobal].m_gSelectedSMSSignature = strSignature;
    [PWCGlobal getTheGlobal].m_gSelectedSMSContentID = [dic objectForKey: @"content_id"];
    
    [self.tableView reloadData];
}

//==============================================================================================================
@end
