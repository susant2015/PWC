//
//  PWCiPhoneScheduleServicesViewController.m
//  PWC
//
//  Created by Samiul Hoque on 6/6/13.
//  Copyright (c) 2013 Premium Web Cart. All rights reserved.
//

#import "PWCiPhoneScheduleServicesViewController.h"
#import "NSDictionary+MutableDeepCopy.h"
#import "PWCGlobal.h"
#import "PWCServiceCell.h"
#import "PWCiPhoneScheduleServiceDetailViewController.h"
#import "AFNetworking.h"
#import "PWCServices.h"
#import "PWCiPhoneScheduleAddServiceViewController.h"

@interface PWCiPhoneScheduleServicesViewController ()

@end

@implementation PWCiPhoneScheduleServicesViewController

@synthesize isSearching;
@synthesize names;
@synthesize keys;
@synthesize allNames;
@synthesize aKeys;
@synthesize aNames;
@synthesize serviceTableView;

#pragma mark -
#pragma mark Custom Methods
- (void)resetSearch
{
    //    static NSStringCompareOptions comparisonOptions =
    //    NSCaseInsensitiveSearch | NSNumericSearch |
    //    NSWidthInsensitiveSearch | NSForcedOrderingSearch;
    
    self.names = [self.allNames mutableDeepCopy];
    NSMutableArray *keyArray = [[NSMutableArray alloc] init];
    [keyArray addObjectsFromArray:[[self.allNames allKeys] sortedArrayUsingComparator:^(NSString *firstObj, NSString *secondObj) {
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
            if ([[d objectForKey:@"serviceName"] rangeOfString:searchTerm
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
    isSearching = NO;
    
    NSMutableArray *keysArray = [[NSMutableArray alloc] init];
    NSMutableArray *valuesArray = [[NSMutableArray alloc] init];
    for (NSDictionary *d in [PWCGlobal getTheGlobal].services) {
        [keysArray addObjectsFromArray:[d allKeys]];
        [valuesArray addObjectsFromArray:[d allValues]];
    }
    
    self.allNames = [NSDictionary dictionaryWithObjects:valuesArray forKeys:keysArray];
    
    self.aNames = [self.allNames mutableDeepCopy];
    NSMutableArray *keyArray = [[NSMutableArray alloc] init];
    [keyArray addObjectsFromArray:[[self.allNames allKeys] sortedArrayUsingComparator:^(NSString *firstObj, NSString *secondObj) {
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
    //[serviceTableView setContentOffset:CGPointMake(0.0, 44.0) animated:NO];
    [self performSelector:@selector(doGetServices) withObject:nil afterDelay:1.0];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self updateAndReloadTable];
}

- (void)updateAndReloadTable
{
    NSMutableArray *keysArray = [[NSMutableArray alloc] init];
    NSMutableArray *valuesArray = [[NSMutableArray alloc] init];
    for (NSDictionary *d in [PWCGlobal getTheGlobal].services) {
        [keysArray addObjectsFromArray:[d allKeys]];
        [valuesArray addObjectsFromArray:[d allValues]];
    }
    
    self.allNames = [NSDictionary dictionaryWithObjects:valuesArray forKeys:keysArray];
    
    self.aNames = [self.allNames mutableDeepCopy];
    NSMutableArray *keyArray = [[NSMutableArray alloc] init];
    [keyArray addObjectsFromArray:[[self.allNames allKeys] sortedArrayUsingComparator:^(NSString *firstObj, NSString *secondObj) {
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
    //[serviceTableView setContentOffset:CGPointMake(0.0, 44.0) animated:NO];
    [serviceTableView reloadData];
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
    static NSString *CellIdentifier = @"serviceCell";
    PWCServiceCell *cell = [self.serviceTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[PWCServiceCell alloc] init];
    }
    
    // Configure the cell...
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

    UILabel *serviceName = (UILabel *)[cell viewWithTag:12001];
    UILabel *reqUnit = (UILabel *)[cell viewWithTag:12002];
    UILabel *maxParticipants = (UILabel *)[cell viewWithTag:12003];
    UILabel *minDuration = (UILabel *)[cell viewWithTag:12004];
    
    serviceName.text = [[nameSection objectAtIndex:row] objectForKey:@"serviceName"];
    
    NSString *unit = @"Unit";
    if ([[[nameSection objectAtIndex:row] objectForKey:@"requiredUnit"] floatValue] > 1.00) {
        unit = @"Units";
    }
    reqUnit.text = [NSString stringWithFormat:@"%@ %@", [[nameSection objectAtIndex:row] objectForKey:@"requiredUnit"], unit];
    
    if ([[[nameSection objectAtIndex:row] objectForKey:@"maxParticipants"] isEqualToString:@"0"]) {
        maxParticipants.text = @"Unlimited";
    } else {
        maxParticipants.text = [[nameSection objectAtIndex:row] objectForKey:@"maxParticipants"];
    }
    
    unit = @"Hour";
    if ([[[nameSection objectAtIndex:row] objectForKey:@"minDuration"] floatValue] > 1.00) {
        unit = @"Hours";
    }
    minDuration.text = [NSString stringWithFormat:@"%@ %@", [[nameSection objectAtIndex:row] objectForKey:@"minDuration"], unit];

    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 36.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 97.0;
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
            [serviceTableView setContentOffset:CGPointZero animated:NO];
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
    if ([segue.identifier isEqualToString:@"newServiceSegue"]) {
        PWCiPhoneScheduleAddServiceViewController *dest = segue.destinationViewController;
        dest.serviceRowId = @"0";
    } else {
        PWCiPhoneScheduleServiceDetailViewController *dest = segue.destinationViewController;
        
        NSIndexPath *path = [self.serviceTableView indexPathForSelectedRow];
        if (isSearching) {
            path = [self.searchDisplayController.searchResultsTableView indexPathForSelectedRow];
        }
        NSUInteger section = [path section];
        NSUInteger row = [path row];
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
        
        //NSLog(@"SEC: %d, ROW: %d", section, row);
        //NSLog(@"%@", [nameSection objectAtIndex:row]);
        
        dest.serviceInfo = [nameSection objectAtIndex:row];
    }
}

#pragma mark - GET SERVICE DATA

- (void)doGetServices
{
    NSURL *url = [NSURL URLWithString:@"http://www.secureinfossl.com"];
    NSString *path = [NSString stringWithFormat:@"/scheduleapi/manageservicelist/%@", [PWCGlobal getTheGlobal].coachRowId];
    
    // Call API and Get Data
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [httpClient setDefaultHeader:@"Accept" value:@"application/json"];
    
    if (([PWCServices services].lastServiceId != nil) && ([[PWCServices services].lastServiceId length] > 0)) {
        path = [NSString stringWithFormat:@"%@/%@", path, [PWCServices services].lastServiceId];
    }
    
    NSLog(@"PATH: %@", path);
    
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET" path:path parameters:nil];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                                            NSLog(@"Success");
                                                                                            //NSLog(@"DATA: %@", JSON);
                                                                                            
                                                                                            int resultCode = [[JSON objectForKey:@"result"] intValue];
                                                                                            
                                                                                            if (resultCode == 1) {
                                                                                                NSArray *serviceArray = [JSON objectForKey:@"services"];
                                                                                                if ([serviceArray count] > 0) {
                                                                                                    [self saveServiceData:serviceArray];
                                                                                                    [PWCGlobal getTheGlobal].services = [PWCServices services].pwcServices;
                                                                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                                                                        [self updateAndReloadTable];
                                                                                                    });
                                                                                                }
                                                                                            }
                                                                                        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                                            NSLog(@"Failure");
                                                                                        
                                                                                        }];
    [operation start];
    [operation waitUntilFinished];
}

- (void)saveServiceData:(NSArray *)services
{
    int ok = 0, notok = 0;
    
    for (NSDictionary *d in services) {
        if ([self insertServiceData:d]) {
            ok++;
        } else {
            notok++;
        }
    }
    NSLog(@"OK: %d, NOT OK: %d", ok, notok);
}

- (BOOL)insertServiceData:(NSDictionary *)service
{
    BOOL done = NO;
    sqlite3_stmt *statement;
    // NSLog(@"%@", product);
    
    NSString *section = @"#";
    
    if ([[service objectForKey:@"service_name"] length] > 0) {
        section = [[[service objectForKey:@"service_name"] substringToIndex:1] uppercaseString];
    }
    
    NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO services (serviceRowId, serviceType, serviceName, description, requiredUnit, maxParticipants, minDuration, chargePerUnit, editRuleDay, editRuleHour, cancelRuleDay, cancelRuleHour, termsAndConditions, removedFunnels, assignedFunnels, removedTags, assignedTags, notes, section) VALUES ('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",
                           [service objectForKey:@"service_row_id"],
                           [service objectForKey:@"service_type"],
                           [service objectForKey:@"service_name"],
                           [service objectForKey:@"description"],
                           
                           [service objectForKey:@"required_unit"],
                           [service objectForKey:@"maximum_participants"],
                           [service objectForKey:@"minimum_duration"],
                           [service objectForKey:@"charge_per_unit"],
                           
                           [service objectForKey:@"edit_rule_day"],
                           [service objectForKey:@"edit_rule_hour"],
                           [service objectForKey:@"cancel_rule_day"],
                           [service objectForKey:@"cancel_rule_hour"],
                           
                           [service objectForKey:@"terms_condition"],
                           
                           [service objectForKey:@"removedfunnels"],
                           [service objectForKey:@"assignedsalespath"],
                           [service objectForKey:@"removedtags"],
                           [service objectForKey:@"assignedtags"],
                           
                           @"",
                           section];
    
    const char *insert_stmt = [insertSQL UTF8String];
    // NSLog(@"%@", orderDetail);
    sqlite3_prepare_v2(pwcDB, insert_stmt, -1, &statement, NULL);
    if (sqlite3_step(statement) == SQLITE_DONE) {
        done = YES;
    } else {
        done = NO;
    }
    
    sqlite3_finalize(statement);
    
    return done;
}

@end
