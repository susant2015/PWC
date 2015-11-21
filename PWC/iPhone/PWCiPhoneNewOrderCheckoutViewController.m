//
//  PWCiPhoneNewOrderCheckoutViewController.m
//  BackUpFiles
//
//  Created by Samiul Hoque on 6/13/13.
//  Copyright (c) 2013 Premium Web Cart. All rights reserved.
//

#import "PWCiPhoneNewOrderCheckoutViewController.h"
#import "PWCGlobal.h"
#import <QuartzCore/QuartzCore.h>
#import "PWCShoppingCart.h"
#import "AFNetworking.h"
#import "PWCProducts.h"

@interface PWCiPhoneNewOrderCheckoutViewController ()

@end

@implementation PWCiPhoneNewOrderCheckoutViewController

@synthesize myArray;
@synthesize totalRows;
@synthesize totalAmount;

@synthesize cardNumber;
@synthesize cardHolderName;
@synthesize cardExpireDate;
@synthesize cardTypeImage;

@synthesize email;
@synthesize phone;
@synthesize comment;

@synthesize track1value;
@synthesize track2value;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    //init alert views
    prompt_doConnection = [[UIAlertView alloc] initWithTitle:@"PWC"
                                                     message:@"Device detected in headphone jack. Try connecting it?"
                                                    delegate:self
                                           cancelButtonTitle:@"Cancel"
                                           otherButtonTitles:@"OK", nil];
    
    prompt_connecting = [[UIAlertView alloc] initWithTitle:@"PWC"
                                                   message:@"Connecting with the device..."
                                                  delegate:self
                                         cancelButtonTitle:@"Cancel"
                                         otherButtonTitles:nil];
    
    prompt_waitingForSwipe = [[UIAlertView alloc] initWithTitle:@"Payment System Ready"
                                                        message:@"Please swipe the card now."
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:nil];
    
    prompt_noCardData = [[UIAlertView alloc] initWithTitle:@"PWC"
                                                   message:@"Can't read card data yet!"
                                                  delegate:self
                                         cancelButtonTitle:@"Cancel"
                                         otherButtonTitles:@"Swipe again", nil];
    
    //reset ui state
    [self setConnectedLabelState:FALSE];
    
    //activate SDK
    [self umsdk_activate];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    //deallocate alert views
    prompt_doConnection = nil;
    prompt_connecting = nil;
    prompt_waitingForSwipe = nil;
    prompt_noCardData = nil;
    
    //deactivate SDK
    [self umsdk_deactivate];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.myArray = [PWCShoppingCart cart].products;
    totalAmount = 0.0;
    
    for (NSDictionary *d in [PWCShoppingCart cart].products) {
        totalAmount += [[d objectForKey:@"productTotal"] floatValue];
    }
    
    totalRows = [myArray count] + 3;
    [self resetFields];
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.tableView addGestureRecognizer:gestureRecognizer];
}

- (void)hideKeyboard
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(totalRows-1) inSection:0];
    UITableViewCell *cell = [self.checkoutTableView cellForRowAtIndexPath:indexPath];
    
    UITextView *tv = (UITextView *)[cell viewWithTag:10010];
    self.comment = tv.text;
    
    UITextField *emailField = (UITextField *)[cell viewWithTag:10008];
    self.email = emailField.text;
    
    UITextField *mobileField = (UITextField *)[cell viewWithTag:10009];
    self.phone = mobileField.text;
    
    [tv resignFirstResponder];
    [emailField resignFirstResponder];
    [mobileField resignFirstResponder];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self hideKeyboard];
}

- (void)resetFields
{
    self.cardNumber = @"Card Number - Swipe Card Now";
    self.cardHolderName = @"Card Holder Name - Swipe Card Now";
    self.cardExpireDate = @"Expiration Date - Swipe Card Now";
    self.cardTypeImage = @"";
    
    self.track1value = @"";
    self.track2value = @"";
    
    self.email = @"";
    self.phone = @"";
    self.comment = @"Comment (Optional)";
    
    [self.checkoutTableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return totalRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = [indexPath row];
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    
    if (row == (totalRows-1)) {
        // Last Row
        CellIdentifier = @"checkoutOptionalCell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        UITextView *tv = (UITextView *)[cell viewWithTag:10010];
        tv.layer.cornerRadius = 8.0;
        tv.clipsToBounds = YES;
        [tv.layer setBorderColor:[[UIColor grayColor] colorWithAlphaComponent:0.5].CGColor];
        [tv.layer setBorderWidth:2.0];
        tv.text = self.comment;
        
        UITextField *emailField = (UITextField *)[cell viewWithTag:10008];
        emailField.text = self.email;
        
        UITextField *mobileField = (UITextField *)[cell viewWithTag:10009];
        mobileField.text = self.phone;
        
        UIButton *processButton = (UIButton *)[cell viewWithTag:10011];
        if ([self.track1value length] > 1 && totalAmount > 0.0) {
            processButton.enabled = YES;
        } else {
            processButton.enabled = NO;
        }
        
    } else if (row == (totalRows-2)) {
        // Credit card info
        CellIdentifier = @"checkoutCreditCardCell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        UIImageView *iv = (UIImageView *)[cell viewWithTag:10005];
        if ([self.cardTypeImage length] > 1) {
            iv.image = [UIImage imageNamed:self.cardTypeImage];
        } else {
            iv.image = nil;
        }
        
        [iv.layer setBorderColor:[[UIColor grayColor] colorWithAlphaComponent:0.5].CGColor];
        [iv.layer setBorderWidth:1.0];
        
        UITextField *cardNum = (UITextField *)[cell viewWithTag:10004];
        cardNum.text = self.cardNumber;
        
        UITextField *cardHolderNm = (UITextField *)[cell viewWithTag:10006];
        cardHolderNm.text = self.cardHolderName;
        
        UITextField *expire = (UITextField *)[cell viewWithTag:10007];
        expire.text = self.cardExpireDate;
        
    } else if (row == (totalRows-3)) {
        // Grand total row
        CellIdentifier = @"checkoutGrandTotalCell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        UILabel *gprice = (UILabel *)[cell viewWithTag:10003];
        gprice.text = [NSString stringWithFormat:@"%@ %.2f", [PWCGlobal getTheGlobal].currencySymbol, totalAmount];
        
    } else {
        // Product row
        CellIdentifier = @"checkoutProductCell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        UILabel *pname = (UILabel *)[cell viewWithTag:10001];
        UILabel *price = (UILabel *)[cell viewWithTag:10002];
        UIButton *button = (UIButton *)[cell viewWithTag:10012];
        
        pname.text = [[self.myArray objectAtIndex:row] objectForKey:@"productName"];
        price.text = [NSString stringWithFormat:@"%@ %@", [PWCGlobal getTheGlobal].currencySymbol, [[self.myArray objectAtIndex:row] objectForKey:@"productTotal"]];
        button.titleLabel.text = [NSString stringWithFormat:@"%d",row];
    }

    
    // Configure the cell...
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = [indexPath row];
    CGFloat rowHeight = 30.0;
    
    if (row == (totalRows-1)) {
        rowHeight = 215.0;
    } else if (row == (totalRows-2)) {
        rowHeight = 141.0;
    } else {
        rowHeight = 30.0;
    }
    
    return rowHeight;
}

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

- (IBAction)startSwiping:(id)sender
{
    [self hideKeyboard];
    UmRet ret = [uniReader requestSwipe];
    NSLog(@"requestSwipe return code: \"%@\"", UmRet_lookup(ret));
    if ([UmRet_lookup(ret) isEqualToString:@"UMRET_NO_READER"]) {
        [SVProgressHUD dismissWithError:@"Connect Reader" afterDelay:5.0];
    }
}

- (IBAction)chargeTheCard:(id)sender
{
    [self hideKeyboard];
    [SVProgressHUD showWithStatus:@"Processing transaction ..." maskType:SVProgressHUDMaskTypeBlack];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(totalRows-1) inSection:0];
    UITableViewCell *cell = [self.checkoutTableView cellForRowAtIndexPath:indexPath];
    
    UITextView *tv = (UITextView *)[cell viewWithTag:10010];
    self.comment = tv.text;
    
    UITextField *emailField = (UITextField *)[cell viewWithTag:10008];
    self.email = emailField.text;
    
    UITextField *mobileField = (UITextField *)[cell viewWithTag:10009];
    self.phone = mobileField.text;
    
    SEL backSel = @selector(doProcessTransaction);
    [self performSelectorInBackground:backSel withObject:self];
}

- (IBAction)deleteFromCart:(id)sender
{
    UIButton *senderButton = (UIButton *)sender;
    NSInteger buttonValue = [senderButton.titleLabel.text integerValue];
    
    [[PWCShoppingCart cart].products removeObjectAtIndex:buttonValue];
    
    self.myArray = [PWCShoppingCart cart].products;
    totalAmount = 0.0;
    
    for (NSDictionary *d in [PWCShoppingCart cart].products) {
        totalAmount += [[d objectForKey:@"productTotal"] floatValue];
    }
    
    totalRows = [myArray count]+3;
    [self.checkoutTableView reloadData];
}

//-------START: DO PROCESS TRANSACTION --------------

- (void)doProcessTransaction
{
    // Call API and Get Data
    NSURL *url = [NSURL URLWithString:@"https://secureinfossl.com"];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [httpClient setDefaultHeader:@"Accept" value:@"application/json"];
    
    NSMutableDictionary *parDic = [[NSMutableDictionary alloc] init];
    
    // USER INFO
    [parDic addEntriesFromDictionary:[NSDictionary dictionaryWithObject:[PWCGlobal getTheGlobal].merchantId forKey:@"merchantid"]];
    [parDic addEntriesFromDictionary:[NSDictionary dictionaryWithObject:[PWCGlobal getTheGlobal].applicationApiKey forKey:@"apikey"]];
    
    // CARD INFO
    NSArray *details = [self.track1value componentsSeparatedByString:@"^"];
    
    [parDic addEntriesFromDictionary:[NSDictionary dictionaryWithObject:[[details objectAtIndex:0] substringFromIndex:2] forKey:@"card_number"]];
    [parDic addEntriesFromDictionary:[NSDictionary dictionaryWithObject:[details objectAtIndex:1] forKey:@"card_holder_name"]];
    [parDic addEntriesFromDictionary:[NSDictionary dictionaryWithObject:[[[details objectAtIndex:2] substringToIndex:4] substringFromIndex:2] forKey:@"card_expire_month"]];
    [parDic addEntriesFromDictionary:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"20%@",[[details objectAtIndex:2] substringToIndex:2]] forKey:@"card_expire_year"]];
    
    if ([self.cardTypeImage isEqualToString:@"amex"]) {
        [parDic addEntriesFromDictionary:[NSDictionary dictionaryWithObject:@"Amex" forKey:@"card_type"]];
    } else if ([self.cardTypeImage isEqualToString:@"visa"]) {
        [parDic addEntriesFromDictionary:[NSDictionary dictionaryWithObject:@"Visa" forKey:@"card_type"]];
    } else if ([self.cardTypeImage isEqualToString:@"mastercard"]) {
        [parDic addEntriesFromDictionary:[NSDictionary dictionaryWithObject:@"MasterCard" forKey:@"card_type"]];
    } else if ([self.cardTypeImage isEqualToString:@"discover"]) {
        [parDic addEntriesFromDictionary:[NSDictionary dictionaryWithObject:@"Discover" forKey:@"card_type"]];
    }
    
    // CARD TRACK DATA
    if ([self.track2value length] < 16) {
        self.track2value = [NSString stringWithFormat:@"%@=%@",[[details objectAtIndex:0] substringFromIndex:2], [details objectAtIndex:2]];
    }
    
    NSString *trackData = [NSString stringWithFormat:@"%@;%@", self.track1value, self.track2value];
    [parDic addEntriesFromDictionary:[NSDictionary dictionaryWithObject:trackData forKey:@"card_track_data"]];
    [parDic addEntriesFromDictionary:[NSDictionary dictionaryWithObject:self.track1value forKey:@"card_track_data1"]];
    [parDic addEntriesFromDictionary:[NSDictionary dictionaryWithObject:self.track2value forKey:@"card_track_data2"]];
    
    // OPTIONAL INFO
    [parDic addEntriesFromDictionary:[NSDictionary dictionaryWithObject:self.email forKey:@"customer_email"]];
    [parDic addEntriesFromDictionary:[NSDictionary dictionaryWithObject:self.phone forKey:@"customer_mobile"]];
    
    if ([self.comment isEqualToString:@"Comment (Optional)"]) {
        [parDic addEntriesFromDictionary:[NSDictionary dictionaryWithObject:@"" forKey:@"customer_comment"]];
    } else {
        [parDic addEntriesFromDictionary:[NSDictionary dictionaryWithObject:self.comment forKey:@"customer_comment"]];
    }
    
    // PRODUCT DATA
    int existing = 1, newProd = 1;
    for (NSDictionary *d in [PWCShoppingCart cart].products) {
        if ([[d objectForKey:@"pid"] isEqualToString:@"0"]) {
            // NEW PRODUCT
            [parDic addEntriesFromDictionary:[NSDictionary dictionaryWithObject:[d objectForKey:@"productName"]
                                                                         forKey:[NSString stringWithFormat:@"new_product_name%d", newProd]]];
            [parDic addEntriesFromDictionary:[NSDictionary dictionaryWithObject:[d objectForKey:@"price"]
                                                                         forKey:[NSString stringWithFormat:@"new_product_price%d", newProd]]];
            [parDic addEntriesFromDictionary:[NSDictionary dictionaryWithObject:[d objectForKey:@"quantity"]
                                                                         forKey:[NSString stringWithFormat:@"new_product_quantity%d", newProd]]];
            [parDic addEntriesFromDictionary:[NSDictionary dictionaryWithObject:[d objectForKey:@"discount"]
                                                                         forKey:[NSString stringWithFormat:@"new_product_discount%d", newProd]]];
            [parDic addEntriesFromDictionary:[NSDictionary dictionaryWithObject:[d objectForKey:@"taxAmount"]
                                                                         forKey:[NSString stringWithFormat:@"new_product_tax%d", newProd]]];
            [parDic addEntriesFromDictionary:[NSDictionary dictionaryWithObject:[d objectForKey:@"shipping"]
                                                                         forKey:[NSString stringWithFormat:@"new_product_shipping%d", newProd]]];
            [parDic addEntriesFromDictionary:[NSDictionary dictionaryWithObject:[d objectForKey:@"productTotal"]
                                                                         forKey:[NSString stringWithFormat:@"new_product_total%d", newProd]]];
            [parDic addEntriesFromDictionary:[NSDictionary dictionaryWithObject:[d objectForKey:@"pid"]
                                                                         forKey:[NSString stringWithFormat:@"new_product_pid%d", newProd]]];
            [parDic addEntriesFromDictionary:[NSDictionary dictionaryWithObject:[d objectForKey:@"aid"]
                                                                         forKey:[NSString stringWithFormat:@"new_product_attributeid%d", newProd]]];
            
            newProd++;
        } else {
            // EXISTING PRODUCT
            [parDic addEntriesFromDictionary:[NSDictionary dictionaryWithObject:[d objectForKey:@"productName"]
                                                                         forKey:[NSString stringWithFormat:@"exist_product_name%d", existing]]];
            [parDic addEntriesFromDictionary:[NSDictionary dictionaryWithObject:[d objectForKey:@"price"]
                                                                         forKey:[NSString stringWithFormat:@"exist_product_price%d", existing]]];
            [parDic addEntriesFromDictionary:[NSDictionary dictionaryWithObject:[d objectForKey:@"quantity"]
                                                                         forKey:[NSString stringWithFormat:@"exist_product_quantity%d", existing]]];
            [parDic addEntriesFromDictionary:[NSDictionary dictionaryWithObject:[d objectForKey:@"discount"]
                                                                         forKey:[NSString stringWithFormat:@"exist_product_discount%d", existing]]];
            [parDic addEntriesFromDictionary:[NSDictionary dictionaryWithObject:[d objectForKey:@"taxAmount"]
                                                                         forKey:[NSString stringWithFormat:@"exist_product_tax%d", existing]]];
            [parDic addEntriesFromDictionary:[NSDictionary dictionaryWithObject:[d objectForKey:@"shipping"]
                                                                         forKey:[NSString stringWithFormat:@"exist_product_shipping%d", existing]]];
            [parDic addEntriesFromDictionary:[NSDictionary dictionaryWithObject:[d objectForKey:@"productTotal"]
                                                                         forKey:[NSString stringWithFormat:@"exist_product_total%d", existing]]];
            [parDic addEntriesFromDictionary:[NSDictionary dictionaryWithObject:[d objectForKey:@"pid"]
                                                                         forKey:[NSString stringWithFormat:@"exist_product_pid%d", existing]]];
            [parDic addEntriesFromDictionary:[NSDictionary dictionaryWithObject:[d objectForKey:@"aid"]
                                                                         forKey:[NSString stringWithFormat:@"exist_product_attributeid%d", existing]]];
            
            existing++;
        }
    }
    
    NSString *path = [NSString stringWithFormat:@"/api/swipeSale.html"];
    //NSLog(@"PATH: %@", path);
    
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST" path:path parameters:parDic];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                                            NSLog(@"Success");
                                                                                            //NSLog(@"DATA: %@", JSON);
                                                                                            
                                                                                            int result = [[JSON objectForKey:@"result"] intValue];
                                                                                            //NSLog(@"Result: %d", result);
                                                                                            [SVProgressHUD dismiss];
                                                                                            //NSLog(@"Dissmiss");
                                                                                            
                                                                                            if (result == 1) {
                                                                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                                                                    [self createActionSheet:@"Success"];
                                                                                                });
                                                                                            } else {
                                                                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                                                                    [self createActionSheet:@"Failure"];
                                                                                                });
                                                                                            }
                                                                                            
                                                                                        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                                            NSLog(@"Failure");
                                                                                            //NSLog(@"Request: %@", JSON);
                                                                                            
                                                                                            [SVProgressHUD dismiss];
                                                                                            
                                                                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                                                                [self createActionSheet:@"Failure"];
                                                                                            });
                                                                                        }];
    [operation start];
    [operation waitUntilFinished];
}

//-------END: DO PROCESS TRANSACTION --------------

- (void)createActionSheet:(NSString *)status
{
    if ([status isEqualToString:@"Success"]) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Thank you! Your order has been successfully completed."
                                                                 delegate:self
                                                        cancelButtonTitle:nil
                                                   destructiveButtonTitle:@"Dashboard"
                                                        otherButtonTitles:nil];
        [actionSheet showInView:super.view];
    } else {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"This order has been declined by the Credit Card Gateway, please double check the information submitted."
                                                                 delegate:self
                                                        cancelButtonTitle:@"Use New Card"
                                                   destructiveButtonTitle:@"Dashboard"
                                                        otherButtonTitles:@"Resubmit", nil];
        [actionSheet showInView:super.view];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == [actionSheet cancelButtonIndex]) {
        // USE NEW CARD
        self.cardNumber = @"Card Number - Swipe Card Now";
        self.cardHolderName = @"Card Holder Name - Swipe Card Now";
        self.cardExpireDate = @"Expiration Date - Swipe Card Now";
        self.cardTypeImage = @"";
        
        self.track1value = @"";
        self.track2value = @"";
        
        [self.checkoutTableView reloadData];
        
    } else if (buttonIndex == [actionSheet destructiveButtonIndex]) {
        // DASHBOARD
        [PWCShoppingCart cart].products = nil;
        [PWCShoppingCart cart].products = [[NSMutableArray alloc] init];
        
        if (sqlite3_open([[PWCGlobal getTheGlobal].getDBPath UTF8String], &pwcDB) != SQLITE_OK) {
            //NSLog(@"Failed to open db - Checkout");
        } else {
            //NSLog(@"DB openned. - Checkout");
        }
        
        [SVProgressHUD showWithStatus:@"Loading ..." maskType:SVProgressHUDMaskTypeBlack];
        
        SEL newOrderSel = @selector(doGetProductsForNewOrder);
        [self performSelectorInBackground:newOrderSel withObject:self];
        
    } else {
        // RESUBMIT
        [self chargeTheCard:self];
    }
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
    
    //NSLog(@"PATH: %@", path);
    
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
                                                                                            
                                                                                            [SVProgressHUD dismiss];
                                                                                            [self.navigationController popToRootViewControllerAnimated:YES];
                                                                                            
                                                                                        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                                            NSLog(@"Failure");
                                                                                            
                                                                                            [SVProgressHUD dismiss];
                                                                                            [PWCGlobal getTheGlobal].products = [PWCProducts products].pwcProducts;
                                                                                            [self.navigationController popToRootViewControllerAnimated:YES];
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

- (void)alertView:(const UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	if (alertView == prompt_doConnection)
    {
        //selected option to start the connection task at the reader attachment prompt
        if (1 == buttonIndex) {
            [uniReader startUniMag:TRUE];
            //self.doASwipeButton.enabled = YES;
        }
    }
    else if (alertView == prompt_connecting)
    {
        //selected cancel connection at the connecting prompt.
        // This aborts the connect task
        if (0 == buttonIndex)
            [uniReader cancelTask];
    }
    else if (alertView == prompt_waitingForSwipe)
    {
        //selected cancel swipe at the swipe waiting prompt.
        // This aborts the swipe task
        if (0 == buttonIndex)
            [uniReader cancelTask];
    }
    else if (alertView == prompt_noCardData)
    {
        if (1 == buttonIndex) {
            [self startSwiping:self];
        }
    }
    
}

//-----------------------------------------------------------------------------
#pragma mark - uniMag SDK activation/deactivation -
//-----------------------------------------------------------------------------

-(void) umsdk_registerObservers:(BOOL) reg {
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    
    //list of notifications and their corresponding selector
    const struct {__unsafe_unretained NSString *n; SEL s;} noteAndSel[] = {
        //
        {uniMagAttachmentNotification       , @selector(umDevice_attachment:)},
        {uniMagDetachmentNotification       , @selector(umDevice_detachment:)},
        //
        {uniMagInsufficientPowerNotification, @selector(umConnection_lowVolume:)},
        {uniMagPoweringNotification         , @selector(umConnection_starting:)},
        {uniMagTimeoutNotification          , @selector(umConnection_timeout:)},
        {uniMagDidConnectNotification       , @selector(umConnection_connected:)},
        {uniMagDidDisconnectNotification    , @selector(umConnection_disconnected:)},
        //
        {uniMagSwipeNotification            , @selector(umSwipe_starting:)},
        {uniMagTimeoutSwipeNotification     , @selector(umSwipe_timeout:)},
        {uniMagDataProcessingNotification   , @selector(umDataProcessing:)},
        {uniMagInvalidSwipeNotification     , @selector(umSwipe_invalid:)},
        {uniMagDidReceiveDataNotification   , @selector(umSwipe_receivedSwipe:)},
        //
        {uniMagSystemMessageNotification    , @selector(umSystemMessage:)},
        
        {nil, nil},
    };
    
    //register or unregister
    for (int i=0; noteAndSel[i].s != nil ;i++) {
        if (reg)
            [nc addObserver:self selector:noteAndSel[i].s name:noteAndSel[i].n object:nil];
        else
            [nc removeObserver:self name:noteAndSel[i].n object:nil];
    }
}

-(void) umsdk_activate {
    
    //register observers for all uniMag notifications
	[self umsdk_registerObservers:TRUE];
    
    
	//enable info level NSLogs inside SDK
    // Here we turn on before initializing SDK object so the act of initializing is logged
    [uniMag enableLogging:TRUE];
    
    //initialize the SDK by creating a uniMag class object
    uniReader = [[uniMag alloc] init];
    
    /*
     //set SDK to perform the connect task automatically when headset is attached
     [uniReader setAutoConnect:TRUE];
     */
    
    //set swipe timeout to infinite. By default, swipe task will timeout after 20 seconds
	[uniReader setSwipeTimeoutDuration:0];
    
    //make SDK maximize the volume automatically during connection
    [uniReader setAutoAdjustVolume:TRUE];
    
    //By default, the diagnostic wave file logged by the SDK is stored under the temp directory
    // Here it is set to be under the Documents folder in the app sandbox so the log can be accessed
    // through iTunes file sharing. See UIFileSharingEnabled in iOS doc.
    [uniReader setWavePath: [NSHomeDirectory() stringByAppendingPathComponent: @"/Documents/audio.caf"]];
}

-(void) umsdk_deactivate {
    //it is the responsibility of SDK client to unregister itself as notification observer
    [self umsdk_registerObservers:FALSE];
}

#pragma mark attachment

//called when uniMag is physically attached
- (void)umDevice_attachment:(NSNotification *)notification {
    [self dismissAllAlertViews];
	//self.connectedImage.image = [UIImage imageNamed:@"green"];
    [prompt_doConnection show];
}

//called when uniMag is physically detached
- (void)umDevice_detachment:(NSNotification *)notification {
    [self dismissAllAlertViews];
    //self.connectedImage.image = [UIImage imageNamed:@"red"];
}

#pragma mark connection task

//called when attempting to start the connection task but iDevice's headphone playback volume is too low
- (void)umConnection_lowVolume:(NSNotification *)notification {
    [self dismissAllAlertViews];
    
    UIAlertView *volumeBad = [[UIAlertView alloc]
                              initWithTitle:@"uniMag"
                              message:@"Volume too low. Please maximize volume then re-attach uniMag."
                              delegate:self
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
    [volumeBad show];
}

//called when successfully starting the connection task
- (void)umConnection_starting:(NSNotification *)notification {
	[prompt_connecting show];
}

//called when SDK failed to handshake with reader in time. ie, the connection task has timed out
- (void)umConnection_timeout:(NSNotification *)notification {
    [self dismissAllAlertViews];
	
	UIAlertView *connectionFailed = [[UIAlertView alloc]
                                     initWithTitle:@"uniMag"
                                     message:@"Connecting with uniMag timed out. Please try again."
                                     delegate:self
                                     cancelButtonTitle:@"Ok"
                                     otherButtonTitles:nil];
	[connectionFailed show];
}

//called when the connection task is successful, SDK's connection state changes to true
- (void)umConnection_connected:(NSNotification *)notification
{
    [self dismissAllAlertViews];
    [self setConnectedLabelState:TRUE];
}

//called when SDK's connection state changes to false. This happens when reader becomes
// physically detached or when a disconnect API is called
- (void)umConnection_disconnected:(NSNotification *)notification
{
    [self dismissAllAlertViews];
    [self setConnectedLabelState:FALSE];
}

#pragma mark Swipe Task

//called when the swipe task is successfullystarting, meaning the SDK starts to
// wait for a swipe to be made
- (void)umSwipe_starting:(NSNotification *)notification
{
    [prompt_waitingForSwipe show];
}

// "swipe timeout interval".
- (void)umSwipe_timeout:(NSNotification *)notification {
    [self dismissAllAlertViews];
	
	UIAlertView *swipeTimeout = [[UIAlertView alloc]
                                 initWithTitle:@"uniMag"
                                 message:@"Waiting for swipe timed out. Please try again."
                                 delegate:self
                                 cancelButtonTitle:@"Ok"
                                 otherButtonTitles:nil];
	[swipeTimeout show];
}

//called when the SDK has read something from the uniMag device
// (eg a swipe, a response to a command) and is in the process of decoding it
// Use this to provide an early feedback on the UI
- (void)umDataProcessing:(NSNotification *)notification {
}

//called when SDK failed to read a valid card swipe
- (void)umSwipe_invalid:(NSNotification *)notification
{
    [self dismissAllAlertViews];
    
    UIAlertView *invalidSwipe = [[UIAlertView alloc] initWithTitle:@"uniMag"
                                                           message:@"Failed to read a valid Swipe. Please try again."
                                                          delegate:self
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles:nil];
    [invalidSwipe show];
}

//called when SDK received a swipe successfully
- (void)umSwipe_receivedSwipe:(NSNotification *)notification
{
    [self dismissAllAlertViews];
    
    NSData *data = [notification object];
    [self processCardData:data];
}

#pragma mark - other ui chores -

- (void)dismissAllAlertViews
{
    [prompt_doConnection dismissWithClickedButtonIndex:-1 animated:FALSE];
    [prompt_connecting dismissWithClickedButtonIndex:-1 animated:FALSE];
    [prompt_waitingForSwipe dismissWithClickedButtonIndex:-1 animated:FALSE];
    [prompt_noCardData dismissWithClickedButtonIndex:-1 animated:FALSE];
}

- (void)setConnectedLabelState:(BOOL)isConnected
{
    if (isConnected) {
        self.doASwipeButton.enabled = YES;
    } else {
        self.doASwipeButton.enabled = NO;
    } 
}

- (void)processCardData:(NSData *)theData
{
    NSString *data = [[NSString alloc] initWithData:theData encoding:NSASCIIStringEncoding];
    NSArray *tracks = [data componentsSeparatedByString:@";"];
    self.track1value = [tracks objectAtIndex:0];
    self.track2value = [tracks objectAtIndex:1];
    NSLog(@"Track 1 Value: %@", self.track1value);
    NSArray *details = [data componentsSeparatedByString:@"^"];
    NSLog(@"Card info: %@", data);
    
    if ([details count] > 2) {
        NSString *cardNo = [[details objectAtIndex:0] substringFromIndex:2];
        NSString *name = [details objectAtIndex:1];
        NSString *expiry = [[details objectAtIndex:2] substringToIndex:4];
        NSLog(@"Card No = %@", cardNo);
        NSLog(@"Name = %@", name);
        NSLog(@"Expiry = %@", expiry);
        
        self.cardNumber = [self formatCardNumber:cardNo];
        self.cardHolderName = name;
        self.cardExpireDate = [self formatExpiryDate:expiry];
        
        NSString *firstDigit = [cardNo substringToIndex:1];
        NSLog(@"First Digit: %@", firstDigit);
        
        if ([firstDigit isEqualToString:@"3"]) {
            // AMEX
            self.cardTypeImage = @"amex";
        } else if ([firstDigit isEqualToString:@"4"]) {
            // VISA
            self.cardTypeImage = @"visa";
        } else if ([firstDigit isEqualToString:@"5"]) {
            // MasterCard
            self.cardTypeImage = @"mastercard";
        } else if ([firstDigit isEqualToString:@"6"]) {
            // Discover
            self.cardTypeImage = @"discover";
        }
        NSLog(@"imageName: %@", self.cardTypeImage);
        [self.checkoutTableView reloadData];
    } else {
        NSLog(@"No card data");
        [prompt_noCardData show];
    }
}

- (NSString *)formatCardNumber:(NSString *)creditCardNumber
{
    NSString *str = [NSString stringWithFormat:@"**** **** **** %@", [creditCardNumber substringFromIndex:12]];
    NSLog(@"Formatted Card No: %@", str);
    return str;
}

- (NSString *)formatExpiryDate:(NSString *)expiry
{
    NSArray *arr = [[NSArray alloc] initWithObjects:[expiry substringToIndex:2], [expiry substringFromIndex:2], nil];
    NSString *str = [NSString stringWithFormat:@"%@ / %@", [arr objectAtIndex:1], [arr objectAtIndex:0]];
    NSLog(@"Formatted date: %@", str);
    return str;
}

@end
