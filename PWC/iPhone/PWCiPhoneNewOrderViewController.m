//
//  PWCiPhoneNewOrderViewController.m
//  BackUpFiles
//
//  Created by Samiul Hoque on 6/13/13.
//  Copyright (c) 2013 Premium Web Cart. All rights reserved.
//

#import "PWCiPhoneNewOrderViewController.h"
#import "PWCiPhoneNewOrderCreateProductViewController.h"
#import "PWCShoppingCart.h"
#import "PWCGlobal.h"
#import "PWCProducts.h"
#import "AFNetworking.h"

@interface PWCiPhoneNewOrderViewController ()

@end

@implementation PWCiPhoneNewOrderViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    if (sqlite3_open([[PWCGlobal getTheGlobal].getDBPath UTF8String], &pwcDB) != SQLITE_OK) {
        // NSLog(@"Failed to open db");
    } else {
        // NSLog(@"DB openned.");
    }
    
    [SVProgressHUD dismiss];
    
    if ([PWCGlobal getTheGlobal].defaultTaxRate == nil || [[PWCGlobal getTheGlobal].defaultTaxRate isEqualToString:@""]) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *taxrate = [defaults objectForKey:@"taxRate"];
        if (taxrate == nil) {
            taxrate = @"0.00";
        }
        [PWCGlobal getTheGlobal].defaultTaxRate = taxrate;
    }
    
    if ([PWCProducts products].pwcProducts == nil || [PWCProducts products].lastProductId == nil) {
        [self syncProducts:self];
    } else {
        [PWCGlobal getTheGlobal].products = [PWCProducts products].pwcProducts;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"newProduct"]) {
        PWCiPhoneNewOrderCreateProductViewController *dest = segue.destinationViewController;
        dest.pid = @"0";
        dest.aid = @"0";
        dest.existingProductName = nil;
        dest.existingProductPrice = nil;
    }
}

- (IBAction)syncProducts:(id)sender
{
    [SVProgressHUD showWithStatus:@"Loading ..." maskType:SVProgressHUDMaskTypeBlack];
    
    SEL newOrderSel = @selector(doGetProductsForNewOrder);
    
    [self performSelectorInBackground:newOrderSel withObject:self];
}

- (void)doGetProductsForNewOrder
{
    // Call API and Get Data
    NSURL *url = [NSURL URLWithString:@"https://secureinfossl.com"];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [httpClient setDefaultHeader:@"Accept" value:@"application/json"];
    
    NSString *path = [NSString stringWithFormat:@"/app/getAccess/%@/productlistwithprices/%@", [PWCGlobal getTheGlobal].merchantId, [PWCGlobal getTheGlobal].hashKey];
    
    if (([PWCProducts products].lastProductId != nil) && ([[PWCProducts products].lastProductId length] > 0)) {
        path = [NSString stringWithFormat:@"%@/%@", path, [PWCProducts products].lastProductId];
    }
    
    NSLog(@"PATH: %@", path);
    
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET" path:path parameters:nil];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                                            NSLog(@"Success");
                                                                                            //NSLog(@"DATA: %@", JSON);
                                                                                            
                                                                                            int resultCode = [[JSON objectForKey:@"result"] intValue];
                                                                                            
                                                                                            if (resultCode == 1) {
                                                                                                NSArray *productArray = [JSON objectForKey:@"productlist"];
                                                                                                [self saveProductData:productArray];
                                                                                            }
                                                                                            
                                                                                            [PWCGlobal getTheGlobal].products = [PWCProducts products].pwcProducts;
                                                                                            
                                                                                            [SVProgressHUD showSuccessWithStatus:@"Syncing successful."];
                                                                                            
                                                                                        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                                            NSLog(@"Failure");
                                                                                            
                                                                                            [SVProgressHUD dismissWithError:@"Syncing failed. Try again later." afterDelay:1.0];
                                                                                            [PWCGlobal getTheGlobal].products = [PWCProducts products].pwcProducts;
                                                                                            
                                                                                        }];
    [operation start];
    [operation waitUntilFinished];
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

@end
