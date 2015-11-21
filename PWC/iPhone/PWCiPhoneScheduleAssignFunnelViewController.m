//
//  PWCiPhoneScheduleAssignFunnelViewController.m
//  PWC
//
//  Created by Samiul Hoque on 9/4/13.
//  Copyright (c) 2013 Premium Web Cart. All rights reserved.
//

#import "PWCiPhoneScheduleAssignFunnelViewController.h"
#import "PWCSelectedServiceData.h"
#import "PWCGlobal.h"

@interface PWCiPhoneScheduleAssignFunnelViewController ()

@end

@implementation PWCiPhoneScheduleAssignFunnelViewController

@synthesize funnelSection;
@synthesize salespathRow;

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
    
    self.funnelSection = [[NSMutableArray alloc] init];
    self.salespathRow = [[NSMutableArray alloc] init];
    
    //NSLog(@"Funnels: %@", [PWCGlobal getTheGlobal].funnels);
    
    for (NSDictionary *d in [PWCGlobal getTheGlobal].funnels) {
        NSArray *salespathList = [d objectForKey:@"salespathlist"];
        if ([salespathList count] > 0) {
            [self.funnelSection addObject:d];
            [self.salespathRow addObject:salespathList];
        }
    }
    
    
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
    return [self.funnelSection count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[self.salespathRow objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"assignFunnelCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSArray *arr = [self.salespathRow objectAtIndex:indexPath.section];
    NSDictionary *d = [arr objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [d objectForKey:@"sales_path_name"];
    
    if ([self valueFound:[d objectForKey:@"sales_path_id"]]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [[self.funnelSection objectAtIndex:section] objectForKey:@"name"];
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //UITableViewCell *thisCell = (UITableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    
    NSDictionary *f = [self.funnelSection objectAtIndex:indexPath.section];
    NSArray *arr = [self.salespathRow objectAtIndex:indexPath.section];
    NSDictionary *d = [arr objectAtIndex:indexPath.row];
    
    NSString *fs = [NSString stringWithFormat:@"%@#%@", [f objectForKey:@"funnel_id"], [d objectForKey:@"sales_path_id"]];
    
    if ([self checkValue:fs]) {
        [self.tableView reloadData];
    } else {
        [[PWCSelectedServiceData selectedService].assignedFunnels addObject:fs];
        [self.tableView reloadData];
    }
    NSLog(@"%@", [PWCSelectedServiceData selectedService].assignedFunnels);
}

- (BOOL)valueFound:(NSString *)value
{
    for (NSString *s in [PWCSelectedServiceData selectedService].assignedFunnels) {
        NSArray *t = [s componentsSeparatedByString:@"#"];
        if ([[t objectAtIndex:1] isEqualToString:value]) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)checkValue:(NSString *)val
{
    BOOL found = NO;
    int i = 0;
    
    for (i = 0; i < [[PWCSelectedServiceData selectedService].assignedFunnels count]; i++) {
        NSString *s = [[PWCSelectedServiceData selectedService].assignedFunnels objectAtIndex:i];
        if ([s isEqualToString:val]) {
            found = YES;
            break;
        }
    }
    
    if (found == YES && i < [[PWCSelectedServiceData selectedService].assignedFunnels count]) {
        [[PWCSelectedServiceData selectedService].assignedFunnels removeObjectAtIndex:i];
    }
    
    return found;
}

@end
