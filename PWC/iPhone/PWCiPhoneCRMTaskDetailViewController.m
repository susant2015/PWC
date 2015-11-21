//
//  PWCiPhoneCRMTaskDetailViewController.m
//  PWC
//
//  Created by Samiul Hoque on 6/28/13.
//  Copyright (c) 2013 Premium Web Cart. All rights reserved.
//

#import "PWCiPhoneCRMTaskDetailViewController.h"

@interface PWCiPhoneCRMTaskDetailViewController ()

@end

@implementation PWCiPhoneCRMTaskDetailViewController

@synthesize taskObj;
@synthesize taskStatusText;

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
    
    NSLog(@"%@",taskObj);
    
    self.taskName.text = [taskObj objectForKey:@"task"];
    self.taskAssignedTo.text = [taskObj objectForKey:@"assignedto"];
    self.taskAssignedBy.text = [taskObj objectForKey:@"assignedby"];
    
    NSDateFormatter *dFormatter = [[NSDateFormatter alloc] init];
    [dFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss ZZZ"];
    NSDate *assignedDateValue = [dFormatter dateFromString:[taskObj objectForKey:@"assignedon"]];
    //NSLog(@"%@ | %@ | %@ | %@",d.orderDate, tempD, dateValue, [dateValue descriptionWithLocale:[NSLocale systemLocale]]);
    [dFormatter setDateFormat:@"dd MMM yyyy"];
    self.taskAssignedOn.text = [dFormatter stringFromDate:assignedDateValue];

    [dFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss ZZZ"];
    NSDate *dueDateValue = [dFormatter dateFromString:[taskObj objectForKey:@"duedate"]];
    //NSLog(@"%@ | %@ | %@ | %@",d.orderDate, tempD, dateValue, [dateValue descriptionWithLocale:[NSLocale systemLocale]]);
    [dFormatter setDateFormat:@"dd MMM yyyy hh:mm a"];
    self.taskDueDate.text = [dFormatter stringFromDate:dueDateValue];
    
    NSDate *today = [NSDate date];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSUInteger unitFlags = NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit;
    NSDateComponents *components = [gregorian components:unitFlags
                                                fromDate:today
                                                  toDate:dueDateValue
                                                 options:0];
    
    if([today compare:dueDateValue] == NSOrderedDescending) { // if start is later in time than end
        // OVERDUE
        self.delayedOrDue.text = @"Delayed By";
        components = [gregorian components:unitFlags
                                  fromDate:dueDateValue
                                    toDate:today
                                   options:0];
    } else {
        // NORMAL
        self.delayedOrDue.text = @"Due In";
    } 
    
    NSInteger months = [components month];
    NSInteger days = [components day];
    NSInteger hours = [components hour];
    NSInteger minutes = [components minute];
    
    NSString *delayOrDueTime = @"";
    
    if (months == 0) {
        if (days == 0) {
            if (hours == 0) {
                if (minutes == 0) {
                    delayOrDueTime = @"Now";
                } else {
                    delayOrDueTime = [NSString stringWithFormat:@"%d Mins", minutes];
                }
            } else {
                delayOrDueTime = [NSString stringWithFormat:@"%d Hrs %d Mins", hours, minutes];
            }
        } else {
            delayOrDueTime = [NSString stringWithFormat:@"%d Days %d Hrs %d Mins", days, hours, minutes];
        }
    } else {
        delayOrDueTime = [NSString stringWithFormat:@"%d Mnths %d Days %d Hrs %d Mins", months, days, hours, minutes];
    }
    
    self.taskDelayedBy.text = delayOrDueTime;
    
    self.taskCustomer.text = [taskObj objectForKey:@"customer"];
    self.taskReason.text = [taskObj objectForKey:@"reason"];
    
    if ([self.taskStatusText length] < 4) {
        self.taskStatus.text = [taskObj objectForKey:@"status"];
    } else {
        self.taskStatus.text = self.taskStatusText;
    }
    
    self.taskComment.text = [taskObj objectForKey:@"comment"];
    self.taskComment.layer.cornerRadius = 8.0;
    self.taskComment.clipsToBounds = YES;
    [self.taskComment.layer setBorderColor:[[UIColor grayColor] colorWithAlphaComponent:0.5].CGColor];
    [self.taskComment.layer setBorderWidth:2.0];
}

- (void)viewWillAppear:(BOOL)animated
{
    if ([self.taskStatusText length] < 4) {
        self.taskStatus.text = [taskObj objectForKey:@"status"];
    } else {
        self.taskStatus.text = self.taskStatusText;
    }
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
