//
//  PWCiPhoneScheduleRemoveFunnelViewController.m
//  PWC
//
//  Created by Samiul Hoque on 9/5/13.
//  Copyright (c) 2013 Premium Web Cart. All rights reserved.
//

#import "PWCiPhoneScheduleRemoveFunnelViewController.h"
#import "PWCSelectedServiceData.h"
#import "PWCGlobal.h"

@interface PWCiPhoneScheduleRemoveFunnelViewController ()

@end

@implementation PWCiPhoneScheduleRemoveFunnelViewController

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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[PWCGlobal getTheGlobal].funnels count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"removeFunnelCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.textLabel.text = [[[PWCGlobal getTheGlobal].funnels objectAtIndex:indexPath.row] objectForKey:@"name"];
    
    if ([self valueFound:[[[PWCGlobal getTheGlobal].funnels objectAtIndex:indexPath.row] objectForKey:@"funnel_id"]]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self checkValue:[[[PWCGlobal getTheGlobal].funnels objectAtIndex:indexPath.row] objectForKey:@"funnel_id"]]) {
        [self.tableView reloadData];
    } else {
        [[PWCSelectedServiceData selectedService].removedFunnels addObject:[[[PWCGlobal getTheGlobal].funnels objectAtIndex:indexPath.row] objectForKey:@"funnel_id"]];
        [self.tableView reloadData];
    }
    NSLog(@"%@", [PWCSelectedServiceData selectedService].removedFunnels);
}

- (BOOL)valueFound:(NSString *)value
{
    for (NSString *s in [PWCSelectedServiceData selectedService].removedFunnels) {
        if ([s isEqualToString:value]) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)checkValue:(NSString *)val
{
    BOOL found = NO;
    int i = 0;
    
    for (i = 0; i < [[PWCSelectedServiceData selectedService].removedFunnels count]; i++) {
        NSString *s = [[PWCSelectedServiceData selectedService].removedFunnels objectAtIndex:i];
        if ([s isEqualToString:val]) {
            found = YES;
            break;
        }
    }
    
    if (found == YES && i < [[PWCSelectedServiceData selectedService].removedFunnels count]) {
        [[PWCSelectedServiceData selectedService].removedFunnels removeObjectAtIndex:i];
    }
    
    return found;
}

@end
