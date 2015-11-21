//
//  PWCAffiliateViewController.m
//  PWC
//
//  Created by Samiul Hoque on 3/19/13.
//  Copyright (c) 2013 Premium Web Cart. All rights reserved.
//

#import "PWCAffiliateViewController.h"
#import "PWCWebViewController.h"
#import "PWCGlobal.h"

@interface PWCAffiliateViewController ()

@end

@implementation PWCAffiliateViewController

@synthesize requestURL;
@synthesize affiliateItems;

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
    
    self.requestURL = @"http://www.secureinfossl.com/app/getAccess";
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"AffiliateData" ofType:@"plist"];
    NSDictionary *affiliateData = [NSDictionary dictionaryWithContentsOfFile:path];
    self.affiliateItems = [affiliateData objectForKey:@"affiliateitems"];
}

- (void)viewDidAppear:(BOOL)animated
{
    self.navigationController.toolbarHidden = YES;
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
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.affiliateItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *affiliateCell = @"affiliateCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:affiliateCell];
    
    NSDictionary *dict = [self.affiliateItems objectAtIndex:indexPath.row];
    NSString *itemName = [dict objectForKey:@"itemName"];
    cell.textLabel.text = itemName;
    UIImage *image = [UIImage imageNamed:@"TabAffiliate"];
    cell.imageView.image = image;
    
    return cell;
}

#pragma mark - Table view delegate
/*
 - (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Navigation logic may go here. Create and push another view controller.
 
 <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
 // ...
 // Pass the selected object to the new view controller.
 [self.navigationController pushViewController:detailViewController animated:YES];
 }
 */

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    PWCWebViewController *destination = segue.destinationViewController;
    
    //if ([destination respondsToSelector:@selector(setSelection:)]) {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    
    NSDictionary *dict = [self.affiliateItems objectAtIndex:indexPath.row];
    
    destination.webViewTitle = [dict objectForKey:@"itemName"];
    NSString *urlString = [NSString stringWithFormat:@"%@/%@/%@/%@",
                           self.requestURL, [PWCGlobal getTheGlobal].merchantId,
                           [dict objectForKey:@"itemUrl"], [PWCGlobal getTheGlobal].hashKey];
    
    destination.webViewUrl = [NSURL URLWithString:urlString];
    //}
}

@end
