//
//  PWCiPhoneScheduleBookedCustomersViewController.m
//  PWC
//
//  Created by Samiul Hoque on 7/26/13.
//  Copyright (c) 2013 Premium Web Cart. All rights reserved.
//

#import "PWCiPhoneScheduleBookedCustomersViewController.h"

@interface PWCiPhoneScheduleBookedCustomersViewController ()

@end

@implementation PWCiPhoneScheduleBookedCustomersViewController

@synthesize list;

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
    return [self.list count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"bookedCustomerCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    NSInteger row = indexPath.row;
    NSDictionary *d = [self.list objectAtIndex:row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", [d objectForKey:@"first_name"], [d objectForKey:@"last_name"]];
    
    return cell;
}


@end
