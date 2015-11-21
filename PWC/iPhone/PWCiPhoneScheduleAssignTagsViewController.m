//
//  PWCiPhoneScheduleAssignTagsViewController.m
//  PWC
//
//  Created by Samiul Hoque on 9/5/13.
//  Copyright (c) 2013 Premium Web Cart. All rights reserved.
//

#import "PWCiPhoneScheduleAssignTagsViewController.h"
#import "PWCSelectedServiceData.h"
#import "PWCGlobal.h"

@interface PWCiPhoneScheduleAssignTagsViewController ()

@end

@implementation PWCiPhoneScheduleAssignTagsViewController

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
    //NSLog(@"%@", [PWCGlobal getTheGlobal].tags);
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
    return [[PWCGlobal getTheGlobal].tags count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSDictionary *d = [[PWCGlobal getTheGlobal].tags objectAtIndex:section];
    NSArray *a = [d objectForKey:@"tagslist"];
    return [a count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"assignTagCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSDictionary *dd = [[PWCGlobal getTheGlobal].tags objectAtIndex:indexPath.section];
    NSArray *a = [dd objectForKey:@"tagslist"];
    NSDictionary *d = [a objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [d objectForKey:@"tag_name"];
    
    if ([self valueFound:[d objectForKey:@"tag_id"]]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [[[PWCGlobal getTheGlobal].tags objectAtIndex:section] objectForKey:@"category_name"];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dd = [[PWCGlobal getTheGlobal].tags objectAtIndex:indexPath.section];
    NSArray *a = [dd objectForKey:@"tagslist"];
    NSDictionary *d = [a objectAtIndex:indexPath.row];
    
    if ([self checkValue:[d objectForKey:@"tag_id"]]) {
        [self.tableView reloadData];
    } else {
        [[PWCSelectedServiceData selectedService].assignedTags addObject:[d objectForKey:@"tag_id"]];
        [self.tableView reloadData];
    }
    NSLog(@"%@", [PWCSelectedServiceData selectedService].assignedTags);
}

- (BOOL)valueFound:(NSString *)value
{
    for (NSString *s in [PWCSelectedServiceData selectedService].assignedTags) {
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
    
    for (i = 0; i < [[PWCSelectedServiceData selectedService].assignedTags count]; i++) {
        NSString *s = [[PWCSelectedServiceData selectedService].assignedTags objectAtIndex:i];
        if ([s isEqualToString:val]) {
            found = YES;
            break;
        }
    }
    
    if (found == YES && i < [[PWCSelectedServiceData selectedService].assignedTags count]) {
        [[PWCSelectedServiceData selectedService].assignedTags removeObjectAtIndex:i];
    }
    
    return found;
}

@end
