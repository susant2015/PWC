//
//  PWCProductListViewController.m
//  PWC
//
//  Created by JianJinHu on 8/19/13.
//  Copyright (c) 2013 Premium Web Cart. All rights reserved.
//

#import "PWCProductListViewController.h"
#import "ASIHTTPRequest.h"
#import "PWCGlobal.h"
#import "PWCCRMGlobal.h"
#import "JSON.h"
#import "PWCProducts.h"
#import "PWCProductDetailViewController.h"

@interface PWCProductListViewController ()

@end

@implementation PWCProductListViewController


//==============================================================================================================
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

//==============================================================================================================
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initMember];
	// Do any additional setup after loading the view.
}

//==============================================================================================================
-(void) initMember
{
    if (sqlite3_open([[PWCGlobal getTheGlobal].getDBPath UTF8String], &pwcDB) != SQLITE_OK) {
        NSLog(@"Failed to open DB! - Account View Controller");
    } else {
        NSLog(@"DB open! - Account View Controller");
    }
    
    m_arrProducts = [[NSMutableArray alloc] init];
    m_arrOriginProducts = [[NSMutableArray alloc] init];
    if([[PWCProducts products].pwcProducts count] <= 0)
    {
        [self getProductList];
    }
    else
    {
        [m_arrOriginProducts removeAllObjects];
        [m_arrProducts removeAllObjects];
        
        NSArray* arrLetter = [PWCProducts products].pwcProducts;
        for(int i = 0; i < [arrLetter count]; i++)
        {
            NSDictionary* dic = [arrLetter objectAtIndex: i];
            [m_arrProducts addObject: dic];
            [m_arrOriginProducts addObject: dic];
        }
        
        [self.tableView reloadData];
    }
}

//==============================================================================================================
-(void) getProductList
{
    NSCharacterSet *set = [NSCharacterSet URLQueryAllowedCharacterSet];
    NSString *strHashKey = [[PWCGlobal getTheGlobal].hashKey stringByAddingPercentEncodingWithAllowedCharacters:set];
    NSString* strURL = [NSString stringWithFormat: @"%@getAccess/%@/productlistwithprices/%@", SERVER_PRODUCT_BASE_URL, [PWCGlobal getTheGlobal].merchantId,strHashKey];
    NSLog(@"Product list = %@", strURL);
    
    [SVProgressHUD showWithStatus:@"Loading ..." maskType:SVProgressHUDMaskTypeBlack];
    
    NSURL *url = [NSURL URLWithString: strURL];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setTimeOutSeconds: 60.0f];
    [request setDelegate:self];
    [request startAsynchronous];
}

//==============================================================================================================
- (void)requestFinished:(ASIHTTPRequest *)request
{
    [SVProgressHUD showSuccessWithStatus:@"Syncing successful."];
    // Use when fetching text data
    NSString* strResponse = [request responseString];
    NSDictionary* dic = [strResponse JSONValue];
    
    [m_arrOriginProducts removeAllObjects];
    [m_arrProducts removeAllObjects];
    
    int resultCode = [[dic objectForKey:@"result"] intValue];
    
    if (resultCode == 1) {
        NSArray *productArray = [dic objectForKey:@"productlist"];
        [self saveProductData:productArray];
    }

    NSArray* arrLetter = [dic objectForKey: @"productlist"];
    for(int i = 0; i < [arrLetter count]; i++)
    {
        NSDictionary* dic = [arrLetter objectAtIndex: i];
        [m_arrProducts addObject: dic];
        [m_arrOriginProducts addObject: dic];
    }
    
    [self.tableView reloadData];
}

- (void)saveProductData:(NSArray *)products
{
    int ok = 0, notok = 0;
    
    for (NSDictionary *d in products) {
        NSString *key = [[d allKeys] objectAtIndex:0];
        NSArray *val = [d allValues];
        
        for (NSDictionary *dp in [val objectAtIndex:0]) {
            if ([self insertProductData:dp key:key]) {
                ok++;
            } else {
                notok++;
            }
        }
        ok = 0; notok = 0;
    }
}

- (BOOL)insertProductData:(NSDictionary *)product key:(NSString *)section
{
    BOOL done = NO;
    sqlite3_stmt *statement;
    // NSLog(@"%@", product);
    
    NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO products (productId, attributeId, productName, productPrice, section) VALUES ('%@','%@','%@','%@','%@')",
                           [product objectForKey:@"pid"],
                           [product objectForKey:@"aid"],
                           [product objectForKey:@"name"],
                           [product objectForKey:@"price"],
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

//==============================================================================================================
-(void) updateProductList: (NSArray*) arrLetter
{
//    NSString* strSearch = @"ABCDEFGHIJKLMNOPQRSTUVWXYZ#";
//    for(int i = 0; i < [strSearch length]; i++)
//    {
//        NSString* strChar = [strSearch substringWithRange: NSMakeRange(i, 1)];
//        NSLog(@"strChar = %@", strChar);
//        NSArray* arr = [dic objectForKey: strChar];
//        NSLog(@"arr = %@", arr);
//    }
}

//==============================================================================================================
- (void)requestFailed:(ASIHTTPRequest *)request
{
    //    NSError *error = [request error];
    [SVProgressHUD dismissWithError:@"Syncing failed. Try again later." afterDelay:1.0];
}

//==============================================================================================================
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source
//==============================================================================================================
 - (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
 {
     NSLog(@"count = %d", [m_arrProducts count]);
     return [m_arrProducts count];
 }

//==============================================================================================================
 - (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
 {
     NSDictionary* dic = [m_arrProducts objectAtIndex: section];
     NSArray* arrKeys = [dic allKeys];
     if(arrKeys == nil || [arrKeys count] <= 0) return 0;
     
     NSString* strKey = [arrKeys objectAtIndex: 0];
     NSArray* arr = [dic objectForKey: strKey];
     
     NSLog(@"count1 = %d", [arr count]);
     return [arr count];
}

//==============================================================================================================
-(NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSDictionary* dic = [m_arrProducts objectAtIndex: section];
    NSArray* arrKeys = [dic allKeys];
    NSString* strKey = [arrKeys objectAtIndex: 0];
    return strKey;
}

//==============================================================================================================
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
 {
     static NSString* MyIdentifier = @"product_list_cell";
     UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: MyIdentifier];

     int nSection = indexPath.section;
     int nRow = indexPath.row;
     
     NSDictionary* dic = [m_arrProducts objectAtIndex: nSection];
     NSArray* arrKeys = [dic allKeys];
     NSString* strKey = [arrKeys objectAtIndex: 0];
     NSArray* arr = [dic objectForKey: strKey];
     NSDictionary* dicContent = [arr objectAtIndex: nRow];
     cell.textLabel.text = [dicContent objectForKey: @"name"];
     NSString* strPrice = [NSString stringWithFormat: @"Price: $%@", [dicContent objectForKey: @"price"]];
     cell.detailTextLabel.text = strPrice;
     return cell;
 }

//==============================================================================================================
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    NSMutableArray* arrKey = [[NSMutableArray alloc] init];
    for(int i = 0; i < [m_arrProducts count]; i++)
    {
        NSDictionary* dic = [m_arrProducts objectAtIndex: i];
        NSArray* arrKeys = [dic allKeys];
        NSString* strKey = [arrKeys objectAtIndex: 0];
        [arrKey addObject: strKey];
    }
    return arrKey;
}

#pragma mark - Table view delegate

//==============================================================================================================
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int nSection = indexPath.section;
    int nRow = indexPath.row;
    
    NSDictionary* dic = [m_arrProducts objectAtIndex: nSection];
    NSArray* arrKeys = [dic allKeys];
    NSString* strKey = [arrKeys objectAtIndex: 0];
    NSArray* arr = [dic objectForKey: strKey];
    NSDictionary* dicContent = [arr objectAtIndex: nRow];
    
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName: @"MainStoryboard_iPhone" bundle: nil];
    PWCProductDetailViewController* nextView = (PWCProductDetailViewController*)[storyboard instantiateViewControllerWithIdentifier: @"product_detail"];
    nextView.m_dicContent = dicContent;
    nextView.m_bEditFlag = YES;
    [self.navigationController pushViewController: nextView animated: YES];
}


#pragma mark -
#pragma mark UISearchBar Delegate.

//==============================================================================================================
-(void) searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [m_searchBar setShowsCancelButton: YES animated: YES];
    self.tableView.allowsSelection = NO;
    self.tableView.scrollEnabled = NO;
}

//==============================================================================================================
-(void) searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    m_searchBar.text = @"";
    [m_searchBar setShowsCancelButton: NO animated: YES];
    self.tableView.allowsSelection = YES;
    self.tableView.scrollEnabled = YES;
}

//==============================================================================================================
-(void) searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [m_searchBar setShowsCancelButton: NO animated: YES];
    [m_searchBar resignFirstResponder];
    self.tableView.allowsSelection = YES;
    self.tableView.scrollEnabled = YES;
    
    NSString* strSearch = m_searchBar.text;
    
    [m_arrProducts removeAllObjects];
    for(int i = 0; i < [m_arrOriginProducts count]; i++)
    {
        NSDictionary* dicRecord = [m_arrOriginProducts objectAtIndex: i];
        NSArray* arrKeys = [dicRecord allKeys];
        NSString* strKey = [arrKeys objectAtIndex: 0];
        NSArray* arrData = [dicRecord objectForKey: strKey];
        NSMutableDictionary* dicAdd = [[NSMutableDictionary alloc] init];
        NSMutableArray* arrAddData = [[NSMutableArray alloc] init];
        
        for(int j = 0; j < [arrData count]; j++)
        {
            NSDictionary* dicOne = [arrData objectAtIndex: j];
            NSString* strName = [dicOne objectForKey: @"name"];
            if([strName rangeOfString: strSearch].location != NSNotFound)
            {
                [arrAddData addObject: dicOne];
            }
        }
        
        if([arrAddData count] > 0)
        {
            [dicAdd setObject: arrAddData forKey: strKey];
            [m_arrProducts addObject: dicAdd];
        }
    }
    
    NSLog(@"m_arrProduct = %@", m_arrProducts);
    [self.tableView reloadData];
}

//==============================================================================================================
@end
