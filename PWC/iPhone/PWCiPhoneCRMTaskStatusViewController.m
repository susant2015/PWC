//
//  PWCiPhoneCRMTaskStatusViewController.m
//  PWC
//
//  Created by Samiul Hoque on 7/1/13.
//  Copyright (c) 2013 Premium Web Cart. All rights reserved.
//

#import "PWCiPhoneCRMTaskStatusViewController.h"
#import "PWCiPhoneCRMTaskDetailViewController.h"

@interface PWCiPhoneCRMTaskStatusViewController ()

@end

@implementation PWCiPhoneCRMTaskStatusViewController

@synthesize lastSelected;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
/*
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return;
    }
    
    NSArray *navController = [self.navigationController viewControllers];
    PWCiPhoneCRMTaskDetailViewController *d = [navController objectAtIndex:(navController.count-2)];
    
    if (self.lastSelected == indexPath) {
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryNone;
        [cell setSelected:FALSE animated:TRUE];
        
        //PWCiPhoneCRMTaskDetailViewController *d = (PWCiPhoneCRMTaskDetailViewController *)self.parentViewController;
        d.taskStatusText = @"";
    } else if (self.lastSelected == nil) {
        // select new
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [cell setSelected:TRUE animated:TRUE];
        
        //PWCiPhoneCRMTaskDetailViewController *d = (PWCiPhoneCRMTaskDetailViewController *)self.parentViewController;
        d.taskStatusText = cell.textLabel.text;
    } else {
        // deselect old
        UITableViewCell *old = [self.tableView cellForRowAtIndexPath:self.lastSelected];
        old.accessoryType = UITableViewCellAccessoryNone;
        [old setSelected:FALSE animated:TRUE];
        
        // select new
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [cell setSelected:TRUE animated:TRUE];
        
        //PWCiPhoneCRMTaskDetailViewController *d = (PWCiPhoneCRMTaskDetailViewController *)self.parentViewController;
        d.taskStatusText = cell.textLabel.text;
    }
    
    // keep track of the last selected cell
    self.lastSelected = indexPath;
    
    /*
    NSInteger row = indexPath.row;
    
    if (row == 2) {
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        
    } else if (row == 4) {
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
     */
}

@end
