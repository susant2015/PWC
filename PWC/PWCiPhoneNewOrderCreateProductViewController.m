//
//  PWCiPhoneNewOrderCreateProductViewController.m
//  PWC
//
//  Created by Samiul Hoque on 4/16/13.
//  Copyright (c) 2013 Premium Web Cart. All rights reserved.
//

#import "PWCiPhoneNewOrderCreateProductViewController.h"
#import "PWCGlobal.h"
#import "PWCShoppingCart.h"

@interface PWCiPhoneNewOrderCreateProductViewController ()

@end

@implementation PWCiPhoneNewOrderCreateProductViewController

@synthesize pid;
@synthesize aid;
@synthesize existingProductName;
@synthesize existingProductPrice;

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
    
    /* CURRENCY SIGN */
    if ([PWCGlobal getTheGlobal].currencySymbol != nil) {
        self.priceSign.text = [PWCGlobal getTheGlobal].currencySymbol;
        self.discountSign.text = [PWCGlobal getTheGlobal].currencySymbol;
        self.taxSign.text = [PWCGlobal getTheGlobal].currencySymbol;
        self.shippingSign.text = [PWCGlobal getTheGlobal].currencySymbol;
        self.totalSign.text = [PWCGlobal getTheGlobal].currencySymbol;
    } else {
        self.priceSign.text = @"$";
        self.discountSign.text = @"$";
        self.taxSign.text = @"$";
        self.shippingSign.text = @"$";
        self.totalSign.text = @"$";
    }
    
    /* IF EXISTING PRODUCT */
    if (existingProductName != nil && existingProductPrice != nil) {
        self.productName.text = existingProductName;
        self.productName.enabled = NO;
        self.productName.backgroundColor = [UIColor lightGrayColor];
        
        self.productPrice.text = existingProductPrice;
        self.productPrice.enabled = NO;
        self.productPrice.backgroundColor = [UIColor lightGrayColor];
    }
    
    /* DEFAULT TAX RATE */
    self.taxRate.text = [PWCGlobal getTheGlobal].defaultTaxRate;
    
    [self updateAll];
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.tableView addGestureRecognizer:gestureRecognizer];
}

- (void) hideKeyboard {
    [self.productName resignFirstResponder];
    [self.productPrice resignFirstResponder];
    [self.productQuantity resignFirstResponder];
    [self.discount resignFirstResponder];
    [self.taxRate resignFirstResponder];
    [self.taxAmount resignFirstResponder];
    [self.shipping resignFirstResponder];
    [self.productTotal resignFirstResponder];
    [self updateAll];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self hideKeyboard];
}

- (IBAction)checkout:(id)sender {
    if ([[PWCShoppingCart cart].products count] > 0) {
        [self performSegueWithIdentifier:@"checkoutProducts" sender:self];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Product"
                                                        message:@"You didn't selected/add any product"
                                                       delegate:nil
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (void)refreshTotal
{
    float total = [self.productPrice.text floatValue] * [self.productQuantity.text floatValue]
    - [self.discount.text floatValue]
    + [self.taxAmount.text floatValue]
    + [self.shipping.text floatValue];
    
    self.productTotal.text = [NSString stringWithFormat:@"%.2f",total];
}

- (void)calculateTax
{
    float taxAmount = [self.productPrice.text floatValue] * [self.productQuantity.text floatValue] * ([self.taxRate.text floatValue]/100.0);
    self.taxAmount.text = [NSString stringWithFormat:@"%.2f",taxAmount];
}

- (void)updateAll
{
    [self calculateTax];
    [self refreshTotal];
}

- (IBAction)editingEnd:(id)sender {
    [self updateAll];
}

- (void)addProductInTheCart
{
    [self updateAll];
    
    NSDictionary *productDesc = [NSDictionary dictionaryWithObjectsAndKeys:
                                 self.productName.text, @"productName",
                                 self.pid, @"pid",
                                 self.aid, @"aid",
                                 self.productPrice.text, @"price",
                                 self.productQuantity.text, @"quantity",
                                 self.discount.text, @"discount",
                                 self.taxRate.text, @"taxRate",
                                 self.taxAmount.text, @"taxAmount",
                                 self.shipping.text, @"shipping",
                                 self.productTotal.text, @"productTotal", nil];
    [[PWCShoppingCart cart].products addObject:productDesc];
    //NSLog(@"%@", [PWCShoppingCart cart].products);
    //NSLog(@"%@", productDesc);
}

- (IBAction)addNewProduct:(id)sender {
    if ([self.productTotal.text floatValue] > 0) {
        [self addProductInTheCart];
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Product?"
                                                        message:@"You didn't created the product"
                                                       delegate:nil
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (IBAction)addAndCheckout:(id)sender {
    if ([self.productTotal.text floatValue] > 0) {
        [self addProductInTheCart];
        [self checkout:sender];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Product?"
                                                        message:@"You didn't created the product"
                                                       delegate:nil
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:nil, nil];
        [alert show];
    }
    
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

@end
