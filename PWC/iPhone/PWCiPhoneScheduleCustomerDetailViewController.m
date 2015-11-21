//
//  PWCiPhoneScheduleCustomerDetailViewController.m
//  PWC
//
//  Created by Samiul Hoque on 7/24/13.
//  Copyright (c) 2013 Premium Web Cart. All rights reserved.
//

#import "PWCiPhoneScheduleCustomerDetailViewController.h"
#import "PWCGlobal.h"
#import "PWCiPhoneServicesBuyUnitsViewController.h"

@interface PWCiPhoneScheduleCustomerDetailViewController ()

@end

@implementation PWCiPhoneScheduleCustomerDetailViewController

@synthesize custInfo;

@synthesize custBalance;
@synthesize custName;
@synthesize genInfo;
@synthesize contactInfo;

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
    
    NSLog(@"%@", custInfo);
    
    self.custName.text = [NSString stringWithFormat:@"%@ %@", [custInfo objectForKey:@"firstName"], [custInfo objectForKey:@"lastName"]];
    NSString *unit = @"Unit";
    if ([[custInfo objectForKey:@"balance"] floatValue] > 1.00) {
        unit = @"Units";
    }
    
    //NSLog(@"Balance length: %d", [[custInfo objectForKey:@"balance"] length]);
    
    if ([[custInfo objectForKey:@"balance"] length] == 0) {
        //NSLog(@"balance == 0");
        self.custBalance.text = @"Balance: 0 Unit";
    } else {
        //NSLog(@"balance > 0");
        self.custBalance.text = [NSString stringWithFormat:@"Balance: %@ %@", [custInfo objectForKey:@"balance"], unit];
    }
    
    // GEN INFO
    NSString *temp = [self appendStringByNewLine:[custInfo objectForKey:@"workPhone"] appendingString:[custInfo objectForKey:@"homePhone"]];
    temp = [self appendStringByNewLine:temp appendingString:[custInfo objectForKey:@"email"]];
    self.genInfo.text = temp;
    
    // Contact Info
    // Address, city, state, zip, country
    NSString *tmp = [NSString stringWithFormat:@"Address: %@", [custInfo objectForKey:@"address"]];
    temp = [self appendStringByNewLine:@"" appendingString:tmp];
    
    tmp = [NSString stringWithFormat:@"City: %@", [custInfo objectForKey:@"city"]];
    temp = [self appendStringByNewLine:temp appendingString:tmp];
    
    tmp = [NSString stringWithFormat:@"State: %@", [custInfo objectForKey:@"state"]];
    temp = [self appendStringByNewLine:temp appendingString:tmp];
    
    tmp = [NSString stringWithFormat:@"Zip Code: %@", [custInfo objectForKey:@"zipCode"]];
    temp = [self appendStringByNewLine:temp appendingString:tmp];
    
    tmp = [NSString stringWithFormat:@"Country: %@", [custInfo objectForKey:@"country"]];
    temp = [self appendStringByNewLine:temp appendingString:tmp];
    
    tmp = [NSString stringWithFormat:@"Company: %@", [custInfo objectForKey:@"companyName"]];
    temp = [self appendStringByNewLine:temp appendingString:tmp];
    
    tmp = [NSString stringWithFormat:@"Fax: %@", [custInfo objectForKey:@"fax"]];
    temp = [self appendStringByNewLine:temp appendingString:tmp];
    
    self.contactInfo.text = temp;
    
    // BUY UNITS BUTTON
    //if ([[PWCGlobal getTheGlobal].coachRowId intValue] == 0) {
    //    self.navigationItem.rightBarButtonItem = nil;
    //}
}

- (void)viewDidAppear:(BOOL)animated
{
    //NSLog(@"%@", custInfo);
    NSString *unit = @"Unit";
    if ([[self.custInfo objectForKey:@"balance"] floatValue] > 1.00) {
        unit = @"Units";
    }
    
    if ([[custInfo objectForKey:@"balance"] length] == 0) {
        //NSLog(@"balance == 0");
        self.custBalance.text = @"Balance: 0 Unit";
    } else {
        //NSLog(@"balance > 0");
        self.custBalance.text = [NSString stringWithFormat:@"Balance: %@ %@", [custInfo objectForKey:@"balance"], unit];
    }
}

- (NSString *)appendStringByNewLine:(NSString *)firstString appendingString:(NSString *)secondString
{
    NSString *ret = @"";
    
    if ([firstString length] > 0) {
        ret = [NSString stringWithFormat:@"%@", firstString];
    }
    
    if ([secondString length] > 0) {
        if ([firstString length] > 0) {
            ret = [NSString stringWithFormat:@"%@\r\n%@", firstString, secondString];
        } else {
            ret = [NSString stringWithFormat:@"%@", secondString];
        }
    }
    
    return ret;
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    PWCiPhoneServicesBuyUnitsViewController *dest = segue.destinationViewController;
    dest.customerInfo = self.custInfo;
}


@end
