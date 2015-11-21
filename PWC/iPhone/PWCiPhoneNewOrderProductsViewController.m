//
//  PWCiPhoneNewOrderProductsViewController.m
//  BackUpFiles
//
//  Created by Samiul Hoque on 6/13/13.
//  Copyright (c) 2013 Premium Web Cart. All rights reserved.
//

#import "PWCiPhoneNewOrderProductsViewController.h"
#import "NSDictionary+MutableDeepCopy.h"
#import "PWCiPhoneNewOrderCreateProductViewController.h"
#import "PWCShoppingCart.h"
#import "PWCGlobal.h"

@interface PWCiPhoneNewOrderProductsViewController ()

@end

@implementation PWCiPhoneNewOrderProductsViewController

@synthesize isSearching;
@synthesize names;
@synthesize keys;

@synthesize aKeys;
@synthesize aNames;

@synthesize productTable;
@synthesize allnames;

#pragma mark -
#pragma mark Custome Methods
- (void)resetSearch
{
    self.names = [self.allnames mutableDeepCopy];
    NSMutableArray *keyArray = [[NSMutableArray alloc] init];
    [keyArray addObjectsFromArray:[[self.allnames allKeys] sortedArrayUsingComparator:^(NSString *firstObj, NSString *secondObj) {
        int ascii1 = [firstObj characterAtIndex:0];
        int ascii2 = [secondObj characterAtIndex:0];
        
        if (ascii1 < 40) {
            ascii1 = 125;
        }
        
        if (ascii2 < 40) {
            ascii2 = 125;
        }
        
        if (ascii1 < ascii2) {
            return NSOrderedAscending;
        } else if (ascii1 > ascii2) {
            return NSOrderedDescending;
        } else {
            return NSOrderedSame;
        }
    }]];
    self.keys = keyArray;
}

- (void)handleSearchForTerm:(NSString *)searchTerm
{
    NSMutableArray *sectionsToRemove = [[NSMutableArray alloc] init];
    [self resetSearch];
    for (NSString *key in self.keys) {
        NSMutableArray *array = [names valueForKey:key];
        NSMutableArray *toRemove = [[NSMutableArray alloc] init];
        for (NSDictionary *d in array) {
            if ([[d objectForKey:@"name"] rangeOfString:searchTerm
                                                options:NSCaseInsensitiveSearch].location == NSNotFound) {
                [toRemove addObject:d];
            }
        }
        if ([array count] == [toRemove count]) {
            [sectionsToRemove addObject:key];
        }
        [array removeObjectsInArray:toRemove];
    }
    [self.keys removeObjectsInArray:sectionsToRemove];
}

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
    //NSLog(@"%@",[PWCGlobal getTheGlobal].products);
    isSearching = NO;
    
    NSMutableArray *keysArray = [[NSMutableArray alloc] init];
    NSMutableArray *valuesArray = [[NSMutableArray alloc] init];
    for (NSDictionary *d in [PWCGlobal getTheGlobal].products) {
        [keysArray addObjectsFromArray:[d allKeys]];
        [valuesArray addObjectsFromArray:[d allValues]];
    }
    
    self.allnames = [NSDictionary dictionaryWithObjects:valuesArray forKeys:keysArray];
    
    self.aNames = [self.allnames mutableDeepCopy];
    NSMutableArray *keyArray = [[NSMutableArray alloc] init];
    [keyArray addObjectsFromArray:[[self.allnames allKeys] sortedArrayUsingComparator:^(NSString *firstObj, NSString *secondObj) {
        int ascii1 = [firstObj characterAtIndex:0];
        int ascii2 = [secondObj characterAtIndex:0];
        
        if (ascii1 < 40) {
            ascii1 = 125;
        }
        
        if (ascii2 < 40) {
            ascii2 = 125;
        }
        
        if (ascii1 < ascii2) {
            return NSOrderedAscending;
        } else if (ascii1 > ascii2) {
            return NSOrderedDescending;
        } else {
            return NSOrderedSame;
        }
    }]];
    self.aKeys = keyArray;
    
    [self resetSearch];
    [self.productTable setContentOffset:CGPointMake(0.0, 44.0) animated:NO];
    
    if ([[PWCShoppingCart cart].products count] > 0) {
        self.checkoutBtn.enabled = YES;
    } else {
        self.checkoutBtn.enabled = NO;
    }
    
    //[self.searchDisplayController.searchResultsTableView registerClass:[PWCiPhoneNewOrderProductsViewController class] forCellReuseIdentifier:@"newOrderProductCell"];
}

- (void)viewDidAppear:(BOOL)animated
{
    if ([[PWCShoppingCart cart].products count] > 0) {
        self.checkoutBtn.enabled = YES;
    } else {
        self.checkoutBtn.enabled = NO;
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
    if (isSearching) {
        return ([keys count] > 0) ? [keys count] : 1;
    } else {
        return [aKeys count];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (isSearching) {
        if ([keys count] == 0) {
            return 0;
        }
        NSString *key = [keys objectAtIndex:section];
        NSArray *nameSection = [names objectForKey:key];
        return [nameSection count];
    } else {
        NSString *key = [aKeys objectAtIndex:section];
        NSArray *nameSection = [aNames objectForKey:key];
        return [nameSection count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"newOrderProductCell";
    UITableViewCell *cell = [self.productTable dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.backgroundColor = [UIColor colorWithRed:241.0/255.0 green:241.0/255.0 blue:241.0/255.0 alpha:1.0];
    }
    
    NSUInteger section = [indexPath section];
    NSUInteger row = [indexPath row];
    
    NSString *key = @"";
    NSArray *nameSection = nil;
    
    if (isSearching) {
        key = [keys objectAtIndex:section];
        nameSection = [names objectForKey:key];
    } else {
        key = [aKeys objectAtIndex:section];
        nameSection = [aNames objectForKey:key];
    }
    cell.textLabel.text = [[nameSection objectAtIndex:row] objectForKey:@"name"];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Price: %@%.2f", [PWCGlobal getTheGlobal].currencySymbol, [[[nameSection objectAtIndex:row] objectForKey:@"price"] floatValue]];
    
    // Configure the cell...
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 36.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 56.0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (isSearching) {
        if ([keys count] == 0) {
            return nil;
        }
        NSString *key = [keys objectAtIndex:section];
        return key;
    } else {
        NSString *key = [aKeys objectAtIndex:section];
        if (key == UITableViewIndexSearch) {
            return nil;
        }
        return key;
    }
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (isSearching) {
        return keys;
    } else {
        return aKeys;
    }
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    if (isSearching) {
        return index;
    } else {
        NSString *key = [aKeys objectAtIndex:index];
        if (key == UITableViewIndexSearch) {
            [self.productTable setContentOffset:CGPointZero animated:NO];
            return NSNotFound;
        } else {
            return index;
        }
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

}

#pragma mark - UISearchDisplayControllerDelegate

- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller
{
    isSearching = YES;
}

- (void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller
{
    isSearching = NO;
    [self resetSearch];
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self handleSearchForTerm:searchString];
    return YES;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    [self handleSearchForTerm:[self.searchDisplayController.searchBar text]];
    return YES;
}

#pragma mark - SEGUE

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"checkoutSegue"]) {
        
    } else {
        PWCiPhoneNewOrderCreateProductViewController *dest = segue.destinationViewController;
        
        NSIndexPath *path = [self.productTable indexPathForSelectedRow];
        if (isSearching) {
            path = [self.searchDisplayController.searchResultsTableView indexPathForSelectedRow];
        }
        NSUInteger section = [path section];
        NSUInteger row = [path row];
        //NSLog(@"SEC: %d, ROW: %d", section, row);
        NSString *key = @"";
        NSArray *nameSection = nil;
        
        if (isSearching) {
            key = [keys objectAtIndex:section];
            nameSection = [names objectForKey:key];
            //NSLog(@"SEARCHING");
        } else {
            key = [aKeys objectAtIndex:section];
            nameSection = [aNames objectForKey:key];
        }
        
        dest.pid = [[nameSection objectAtIndex:row] objectForKey:@"pid"];
        dest.aid = [[nameSection objectAtIndex:row] objectForKey:@"aid"];
        dest.existingProductName = [[nameSection objectAtIndex:row] objectForKey:@"name"];
        dest.existingProductPrice = [NSString stringWithFormat:@"%.2f", [[[nameSection objectAtIndex:row] objectForKey:@"price"] floatValue]];
    }
}


@end
