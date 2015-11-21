//
//  PWCOrderDetailsViewController.m
//  PWC
//
//  Created by Samiul Hoque on 3/12/13.
//  Copyright (c) 2013 Premium Web Cart. All rights reserved.
//

#import "PWCOrderDetailsViewController.h"
#import "PWCGlobal.h"
#import "PWCOrderList.h"
#import "PWCOrders.h"
#import "SBJson.h"

@interface PWCOrderDetailsViewController ()

@end

@implementation PWCOrderDetailsViewController

@synthesize jsonObj;
@synthesize billing;
@synthesize payment;
@synthesize invoice;
@synthesize shipping;
@synthesize products;
@synthesize grandTotal;

@synthesize productsDiscounts;

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
    
    [SVProgressHUD dismiss];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //PUSH
    if ([[PWCGlobal getTheGlobal].notificationParam length] > 0) {
        jsonObj = [PWCGlobal getTheGlobal].pushOrderData;
        grandTotal = [PWCGlobal getTheGlobal].pushOrderTotal;
        
        [PWCGlobal getTheGlobal].notificationParam = @"";
        [PWCGlobal getTheGlobal].notificationType = @"";
    }
    
    //SBJsonParser *parser = [[SBJsonParser alloc] init];
    //NSError *error;
    
    //self.jsonObj = [parser objectWithString:self.detailsJson];
    //NSLog(@"%@", self.detailsJson);
    //NSLog(@"%@", self.jsonObj);
    //NSDictionary *billing = [jsonObj objectForKey:@"BillingAddress"];
    //NSLog(@"%@", billing);
    //self.products = (NSArray *)[jsonObj objectForKey:@"ProductsOrdered"];
    //NSLog(@"%@ %d",self.products, [self.products count]);
    
    //NSLog(@"%@", self.navigationController.childViewControllers);
    
    self.billing = [[[self.jsonObj objectAtIndex:0] objectForKey:@"BillingAddress"] objectAtIndex:0];
    self.invoice = [[[self.jsonObj objectAtIndex:0] objectForKey:@"InvoiceProperties"] objectAtIndex:0];
    self.payment = [[[self.jsonObj objectAtIndex:0] objectForKey:@"PaymentInformation"] objectAtIndex:0];
    self.products = [[self.jsonObj objectAtIndex:0] objectForKey:@"ProductsOrdered"];
    self.shipping = [[[self.jsonObj objectAtIndex:0] objectForKey:@"ShippingAddress"] objectAtIndex:0];
    
    //NSLog(@"%@", billing);
    NSMutableArray *temp = [[NSMutableArray alloc] init];

    if ([[self.invoice objectForKey:@"QuantityDiscount"] floatValue] > 0) {
        NSDictionary *t = [NSDictionary dictionaryWithObjectsAndKeys:[self.invoice objectForKey:@"QuantityDiscount"], @"TOTPRICE", @"Quantity Discount", @"DESC", nil];
        [temp addObject:t];
    }
    
    if ([[self.invoice objectForKey:@"StateTax"] floatValue] > 0) {
        NSDictionary *t = [NSDictionary dictionaryWithObjectsAndKeys:[self.invoice objectForKey:@"StateTax"], @"TOTPRICE", @"State Tax", @"DESC", nil];
        [temp addObject:t];
    }
    
    if ([[self.invoice objectForKey:@"CountryTax"] floatValue] > 0) {
        NSDictionary *t = [NSDictionary dictionaryWithObjectsAndKeys:[self.invoice objectForKey:@"CountryTax"], @"TOTPRICE", @"Country Tax", @"DESC", nil];
        [temp addObject:t];
    }
    
    if ([[self.invoice objectForKey:@"ShippingAmount"] floatValue] > 0) {
        NSDictionary *t = [NSDictionary dictionaryWithObjectsAndKeys:[self.invoice objectForKey:@"ShippingAmount"], @"TOTPRICE", @"Shipping Amount", @"DESC", nil];
        [temp addObject:t];
    }
    
    if ([[self.invoice objectForKey:@"CouponDiscount"] floatValue] > 0) {
        NSDictionary *t = [NSDictionary dictionaryWithObjectsAndKeys:[self.invoice objectForKey:@"CouponDiscount"], @"TOTPRICE", @"Coupon Discount", @"DESC", nil];
        [temp addObject:t];
    }
    
    if ([[self.invoice objectForKey:@"GiftCertificateAmount"] floatValue] > 0) {
        NSDictionary *t = [NSDictionary dictionaryWithObjectsAndKeys:[self.invoice objectForKey:@"GiftCertificateAmount"], @"TOTPRICE", @"Gift Certificate Amount", @"DESC", nil];
        [temp addObject:t];
    }
    
    if ([[self.invoice objectForKey:@"OrderDiscount"] floatValue] > 0) {
        NSDictionary *t = [NSDictionary dictionaryWithObjectsAndKeys:[self.invoice objectForKey:@"OrderDiscount"], @"TOTPRICE", @"Order Discount", @"DESC", nil];
        [temp addObject:t];
    }
    //NSArray *temp1 = [NSArray arrayWithArray:temp];
    
    self.productsDiscounts = [self.products arrayByAddingObjectsFromArray:temp];
    
    //self.productsDiscounts = [NSMutableArray arrayWithObjects:self.products, temp, nil];
    
    //NSLog(@"%@",self.productsDiscounts);
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
    return 4;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *title = [[NSString alloc] init];
    
    switch (section) {
        case 0:
            title = @"Product Ordered";
            break;
            
        case 1:
            title = @"Customer Billing Information";
            break;
            
        case 2:
            title = @"Payment Information";
            break;
            
        case 3:
            title = @"Shipping Information";
            break;
            
        default:
            break;
    }
    
    return title;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rowCount = 0;
    
    switch (section) {
        case 0:
            //NSArray *products = [jsonObj objectForKey:@"ProductsOrdered"];
            rowCount = [self.productsDiscounts count]+1;
            //rowCount = 3;
            break;
            
        case 1:
            rowCount = 1;
            break;
            
        case 2:
            rowCount = 1;
            break;
            
        case 3:
            rowCount = 2;
            break;
            
        default:
            break;
    }
    
    return rowCount;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0.0;
    
    switch (indexPath.section) {
        case 0:
                if (indexPath.row == 0) {
                    height = 34.0;
                    
                //}
                //else if (indexPath.row == ([self.products count]+1)) {
                //    height = 72.0;
                    
                } else {
                    height = 27.0;
                    
                }
            
            break;
            
        case 1:
            height = 256.0;
            break;
            
        case 2:
            height = 165.0;
            break;
            
        case 3:
            switch (indexPath.row) {
                case 0:
                    height = 34.0;
                    break;
                    
                case 1:
                    height = 96.0;
                    break;
                    
                default:
                    break;
            }
            
            break;
            
        default:
            break;
    }
    
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"";
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    
    switch (indexPath.section) {
        case 0:
            
                if (indexPath.row == 0) {
                    CellIdentifier = @"grandTotalCell";
                    
                    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    UILabel *grand = (UILabel *)[cell viewWithTag:1001];
                    grand.text = self.grandTotal;
                    
                /*} else if (indexPath.row == ([self.products count]+1)) {
                    CellIdentifier = @"discountCell";
                    
                    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    UILabel *qty = (UILabel *)[cell viewWithTag:3001];
                    UILabel *stx = (UILabel *)[cell viewWithTag:3002];
                    UILabel *shp = (UILabel *)[cell viewWithTag:3003];
                    
                    if ([[self.invoice objectForKey:@"QuantityDiscount"] floatValue] <= 0) {
                        qty.text = [NSString stringWithFormat:@"%@0",[PWCGlobal getTheGlobal].currencySymbol];
                    } else {
                        qty.text = [NSString stringWithFormat:@"%@%@",[PWCGlobal getTheGlobal].currencySymbol,[self.invoice objectForKey:@"QuantityDiscount"]];
                    }
                    
                    if ([[self.invoice objectForKey:@"StateTax"] floatValue] <= 0) {
                        stx.text = [NSString stringWithFormat:@"%@0",[PWCGlobal getTheGlobal].currencySymbol];
                    } else {
                        stx.text = [NSString stringWithFormat:@"%@%@",[PWCGlobal getTheGlobal].currencySymbol,[self.invoice objectForKey:@"StateTax"]];
                    }
                    
                    if ([[self.invoice objectForKey:@"ShippingAmount"] floatValue] <= 0) {
                        shp.text = [NSString stringWithFormat:@"%@0",[PWCGlobal getTheGlobal].currencySymbol];
                    } else {
                        shp.text = [NSString stringWithFormat:@"%@%@",[PWCGlobal getTheGlobal].currencySymbol,[self.invoice objectForKey:@"ShippingAmount"]];
                    }
                */    
                } else {
                    CellIdentifier = @"productCell";
                    
                    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    NSDictionary *prd = [self.productsDiscounts objectAtIndex:indexPath.row-1];
                    UILabel *pName = (UILabel *)[cell viewWithTag:2001];
                    UILabel *pPrice = (UILabel *)[cell viewWithTag:2002];
                    
                    pName.text = [prd objectForKey:@"DESC"];
                    pPrice.text = [NSString stringWithFormat:@"%@%@", [PWCGlobal getTheGlobal].currencySymbol, [prd objectForKey:@"TOTPRICE"]];
                }
            
            break;
            
        case 1:
            CellIdentifier = @"customerBillingCell";
            
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        {
            UILabel *fname = (UILabel *)[cell viewWithTag:4001];
            //UILabel *email = (UILabel *)[cell viewWithTag:4002];
            UITextView *email = (UITextView *)[cell viewWithTag:4002];
            UITextView *phone = (UITextView *)[cell viewWithTag:4003];
            UITextView *wphone = (UITextView *)[cell viewWithTag:4004];
            UILabel *addr1 = (UILabel *)[cell viewWithTag:4005];
            UILabel *addr2 = (UILabel *)[cell viewWithTag:4006];
            UILabel *city = (UILabel *)[cell viewWithTag:4007];
            UILabel *state = (UILabel *)[cell viewWithTag:4008];
            UILabel *zip = (UILabel *)[cell viewWithTag:4009];
            UILabel *country = (UILabel *)[cell viewWithTag:4010];
            UILabel *fax = (UILabel *)[cell viewWithTag:4011];
            
            fname.text = [NSString stringWithFormat:@"%@ %@",[self.billing objectForKey:@"FNAME"],[self.billing objectForKey:@"LNAME"]];
            
            //email
            //email.font = [UIFont systemFontOfSize:15];
            email.contentInset = UIEdgeInsetsMake(-11,-6,0,0);
            
            if ([[self.billing objectForKey:@"EMAIL"] length] > 0) {
                email.text = [self.billing objectForKey:@"EMAIL"];
                /*
                TTTAttributedLabel *emailLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectMake(10, 25, 280, 21)];
                emailLabel.font = [UIFont systemFontOfSize:15];
                emailLabel.textColor = [UIColor darkGrayColor];
                //emailLabel.lineBreakMode = UILineBreakModeWordWrap;
                emailLabel.numberOfLines = 0;
                emailLabel.dataDetectorTypes = UIDataDetectorTypeAll; // Automatically detect links when the label text is subsequently changed
                emailLabel.delegate = self;
                emailLabel.text = [NSString stringWithFormat:@"Email: %@",[self.billing objectForKey:@"EMAIL"]];
                NSLog(@"EMAIL");
                */
            } else {
                email.text = [NSString stringWithFormat:@"Email: N/A"];
                /*
                UILabel *emailLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 25, 280, 21)];
                emailLabel.font = [UIFont systemFontOfSize:15];
                emailLabel.textColor = [UIColor darkGrayColor];
                emailLabel.text = [NSString stringWithFormat:@"Email: N/A"];
                NSLog(@"NO EMAIL");
                 */
            }
            
            //phone
            phone.contentInset = UIEdgeInsetsMake(-11,-6,0,0);
            if ([[self.billing objectForKey:@"PHONE"] length] > 0) {
                phone.text = [NSString stringWithFormat:@"Phone No: %@",[self.billing objectForKey:@"PHONE"]];
            } else {
                phone.text = [NSString stringWithFormat:@"Phone No: N/A"];
            }
            
            wphone.contentInset = UIEdgeInsetsMake(-11,-6,0,0);
            if ([[self.billing objectForKey:@"WPHONE"] length] > 0) {
                wphone.text = [NSString stringWithFormat:@"Work Phone No: %@",[self.billing objectForKey:@"WPHONE"]];
            } else {
                wphone.text = [NSString stringWithFormat:@"Work Phone No: N/A"];
            }
            
            addr1.text = [NSString stringWithFormat:@"%@",[self.billing objectForKey:@"ADDR1"]];
            addr2.text = [NSString stringWithFormat:@"%@",[self.billing objectForKey:@"ADDR2"]];
            city.text = [NSString stringWithFormat:@"City/Town: %@",[self.billing objectForKey:@"CITY"]];
            state.text = [NSString stringWithFormat:@"State/Province: %@",[self.billing objectForKey:@"ST"]];
            zip.text = [NSString stringWithFormat:@"Zip/Post Code: %@",[self.billing objectForKey:@"ZIP"]];
            country.text = [NSString stringWithFormat:@"Country: %@",[self.billing objectForKey:@"COUNTRY"]];
            fax.text = [NSString stringWithFormat:@"Fax: %@",[self.billing objectForKey:@"FAX"]];
        }
            break;
            
        case 2:
            CellIdentifier = @"paymentCell";
            
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        {
            UILabel *gateway = (UILabel *)[cell viewWithTag:5001];
            UILabel *type = (UILabel *)[cell viewWithTag:5002];
            UILabel *number = (UILabel *)[cell viewWithTag:5003];
            UILabel *expire = (UILabel *)[cell viewWithTag:5004];
            UILabel *name = (UILabel *)[cell viewWithTag:5005];
            UILabel *status = (UILabel *)[cell viewWithTag:5006];
            UILabel *trans = (UILabel *)[cell viewWithTag:5007];
            
            gateway.text = [NSString stringWithFormat:@"Gateway: %@",[self.payment objectForKey:@"Gateway"]];
            type.text = [NSString stringWithFormat:@"Card Type: %@",[self.payment objectForKey:@"CardType_OR_PaymentMethod"]];
            number.text = [NSString stringWithFormat:@"Card Number: %@",[self.payment objectForKey:@"CardNumber"]];
            expire.text = [NSString stringWithFormat:@"Expire Date: %@",[self.payment objectForKey:@"ExpirationDate"]];
            name.text = [NSString stringWithFormat:@"Name: %@",[self.payment objectForKey:@"CardHolderContractName"]];
            status.text = [NSString stringWithFormat:@"Status: %@",[self.payment objectForKey:@"ChargeStatus"]];
            trans.text = [NSString stringWithFormat:@"Transaction ID: %@",[self.payment objectForKey:@"TransactionId"]];
        }
            break;
            
        case 3:
            switch (indexPath.row) {
                case 0:
                    CellIdentifier = @"shippingMethodCell";
                    
                    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                {
                    UILabel *shipMethod = (UILabel *)[cell viewWithTag:6001];
                    if ([[self.invoice objectForKey:@"ShippingOpt"] length] > 0) {
                        shipMethod.text = [self.invoice objectForKey:@"ShippingOpt"];
                    } else {
                        shipMethod.text = @"N/A";
                    }
                    
                }
                    break;
                    
                case 1:
                    CellIdentifier = @"cardInfoCell";
                    
                    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                {
                    UILabel *name = (UILabel *)[cell viewWithTag:7001];
                    UILabel *addr1 = (UILabel *)[cell viewWithTag:7002];
                    UILabel *addr2 = (UILabel *)[cell viewWithTag:7003];
                    UILabel *city = (UILabel *)[cell viewWithTag:7004];
                    
                    name.text = [self.shipping objectForKey:@"NAME"];
                    addr1.text = [self.shipping objectForKey:@"ADDR1"];
                    addr2.text = [self.shipping objectForKey:@"ADDR2"];
                    city.text = [NSString stringWithFormat:@"%@, %@ %@, %@", [self.shipping objectForKey:@"CITY"],
                                 [self.shipping objectForKey:@"ST"],[self.shipping objectForKey:@"ZIP"],[self.shipping objectForKey:@"COUNTRY"]];
                }
                    break;
                    
                default:
                    break;
            }
            
            break;
            
        default:
            break;
    }
    
    return cell;
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
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
