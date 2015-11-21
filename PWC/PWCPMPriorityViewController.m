//
//  PWCPMPriorityViewController.m
//  PWC
//
//  Created by jian on 12/17/13.
//  Copyright (c) 2013 Premium Web Cart. All rights reserved.
//

#import "PWCPMPriorityViewController.h"
#import "PWCGlobal.h"

@interface PWCPMPriorityViewController ()

@end

@implementation PWCPMPriorityViewController

//==============================================================================================================
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
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
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//==============================================================================================================
-(void) initMember
{
    m_arrPriority = [[NSMutableArray alloc] initWithObjects: @"Highest", @"High", @"Normal", @"Low", @"Lowest", nil];
}

#pragma mark - Table view data source

//==============================================================================================================
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [m_arrPriority count];
}

//==============================================================================================================
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    
    NSString* strPriority = [m_arrPriority objectAtIndex: indexPath.row];
    if([PWCGlobal getTheGlobal].m_gSelectedPriority != nil && [strPriority isEqualToString: [PWCGlobal getTheGlobal].m_gSelectedPriority])
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    cell.textLabel.text = strPriority;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - Table view delegate

//==============================================================================================================
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [PWCGlobal getTheGlobal].m_gSelectedPriority = [m_arrPriority objectAtIndex: indexPath.row];
    [m_tableView reloadData];
}

//==============================================================================================================
@end
