//
//  PWCiPhoneCRMTaskListViewController.m
//  PWC
//
//  Created by Samiul Hoque on 6/27/13.
//  Copyright (c) 2013 Premium Web Cart. All rights reserved.
//

#import "PWCiPhoneCRMTaskListViewController.h"
#import "PWCTasks.h"
#import "PWCiPhoneCRMTaskDetailViewController.h"

@interface PWCiPhoneCRMTaskListViewController ()

@end

@implementation PWCiPhoneCRMTaskListViewController

@synthesize taskCategory;
@synthesize taskCount;
@synthesize taskList;

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
    
    self.taskList = [[NSMutableArray alloc] init];
    
    self.navigationItem.title = [NSString stringWithFormat:@"%@ Tasks", self.taskCategory];
    
    if ([self.taskCount intValue] > 0) {
        [self.tableView setSeparatorColor:[UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1.0]];
    } else {
        [self.tableView setSeparatorColor:[UIColor colorWithRed:229.0/255.0 green:229.0/255.0 blue:229.0/255.0 alpha:1.0]];
    }
    
    int diff = 0;
    
    if ([self.taskCategory isEqualToString:@"Overdue"]) {
        diff = -1;
    } else if ([self.taskCategory isEqualToString:@"Today"]) {
        diff = 0;
    } else if ([self.taskCategory isEqualToString:@"Tomorrow"]) {
        diff = 1;
    } else if ([self.taskCategory isEqualToString:@"2 Days"]) {
        diff = 2;
    } else if ([self.taskCategory isEqualToString:@"3 Days"]) {
        diff = 3;
    } else if ([self.taskCategory isEqualToString:@"4 Days"]) {
        diff = 4;
    } else if ([self.taskCategory isEqualToString:@"5 Days"]) {
        diff = 5;
    } else if ([self.taskCategory isEqualToString:@"6 Days"]) {
        diff = 6;
    }

    for (NSDictionary *d in [[PWCTasks getTasks] allTasks]) {
        NSDateFormatter *dFormatter = [[NSDateFormatter alloc] init];
        [dFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss ZZZ"];
        NSDate *dateValue = [dFormatter dateFromString:[d objectForKey:@"duedate"]];
    
        NSDate *today = [NSDate date];
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSUInteger unitFlags = NSMonthCalendarUnit | NSDayCalendarUnit;
    
        NSDateComponents *components = [gregorian components:unitFlags
                                                    fromDate:today
                                                      toDate:dateValue options:0];
    
        //NSInteger months = [components month];
        NSInteger days = [components day];
        
        //NSLog(@"Diff: %d, today: %@, theDate: %@",days, today, dateValue);
    
        if (days == diff) {
            [self.taskList addObject:d];
        } else if (days <= diff && [self.taskCategory isEqualToString:@"Overdue"]) {
            [self.taskList addObject:d];
        } else if (days >= diff && [self.taskCategory isEqualToString:@"6 Days"]) {
            [self.taskList addObject:d];
        }
    }
    
    NSLog(@"ROWS: %d",[self.taskList count]);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if ([self.taskCount intValue] > 0) {
        return [self.taskCount intValue];
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.taskCount intValue] > 0) {
        static NSString *CellIdentifier = @"taskListTaskCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        UILabel *taskName = (UILabel *)[cell viewWithTag:1300];
        UILabel *taskCustomer = (UILabel *)[cell viewWithTag:1301];
        UILabel *taskDue = (UILabel *)[cell viewWithTag:1302];
        
        taskName.text = [[self.taskList objectAtIndex:indexPath.row] objectForKey:@"taskname"];
        taskCustomer.text = [NSString stringWithFormat:@"Customer: %@", [[self.taskList objectAtIndex:indexPath.row] objectForKey:@"customer"]];
        
        NSDateFormatter *dFormatter = [[NSDateFormatter alloc] init];
        [dFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss ZZZ"];
        NSDate *dateValue = [dFormatter dateFromString:[[self.taskList objectAtIndex:indexPath.row] objectForKey:@"duedate"]];
        
        
        [dFormatter setDateFormat:@"dd MMM yyyy"];
        taskDue.text = [NSString stringWithFormat:@"Due: %@", [dFormatter stringFromDate:dateValue]];
        
        return cell;
    } else {
        static NSString *CellIdentifier = @"taskListNoTaskCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.taskCount intValue] > 0) {
        return 80.0;
    } else {
        return 200.0;
    }
}
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
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    PWCiPhoneCRMTaskDetailViewController *dest = segue.destinationViewController;
    NSIndexPath *path = [self.tableView indexPathForSelectedRow];
    NSInteger row = path.row;
    dest.taskObj = [self.taskList objectAtIndex:row];
}

@end
