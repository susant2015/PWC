//
//  PWCiPhoneCRMTasksViewController.m
//  PWC
//
//  Created by Samiul Hoque on 6/27/13.
//  Copyright (c) 2013 Premium Web Cart. All rights reserved.
//

#import "PWCiPhoneCRMTasksViewController.h"
#import "PWCiPhoneCRMTaskListViewController.h"
#import "PWCGlobal.h"
#import "PWCTasks.h"

@interface PWCiPhoneCRMTasksViewController ()

@end

@implementation PWCiPhoneCRMTasksViewController

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
    
    int overdueT = 0, todayT = 0, tomorrowT = 0, days2T = 0, days3T = 0, days4T = 0, days5T = 0, days6T = 0;
    
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
        NSLog(@"Diff: %d, today: %@, theDate: %@",days, today, dateValue);
        
        if (days < 0) {
            overdueT++;
        } else if (days == 0) {
            todayT++;
        } else if (days == 1) {
            tomorrowT++;
        } else if (days == 2) {
            days2T++;
        } else if (days == 3) {
            days3T++;
        } else if (days == 4) {
            days4T++;
        } else if (days == 5) {
            days5T++;
        } else {
            days6T++;
        }
    }
    
    self.overdue.text = [NSString stringWithFormat:@"%d", overdueT];
    self.today.text = [NSString stringWithFormat:@"%d", todayT];
    self.tomorrow.text = [NSString stringWithFormat:@"%d", tomorrowT];
    self.days2.text = [NSString stringWithFormat:@"%d", days2T];
    self.days3.text = [NSString stringWithFormat:@"%d", days3T];
    self.days4.text = [NSString stringWithFormat:@"%d", days4T];
    self.days5.text = [NSString stringWithFormat:@"%d", days5T];
    self.days6.text = [NSString stringWithFormat:@"%d", days6T];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Segue Transition

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *path = [self.tableView indexPathForSelectedRow];
    //NSInteger row = path.row;
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:path];
    
    PWCiPhoneCRMTaskListViewController *dest = segue.destinationViewController;
    dest.taskCategory = cell.textLabel.text;
    dest.taskCount = cell.detailTextLabel.text;
}


#pragma mark - Table view data source
/*
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
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
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
