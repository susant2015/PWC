//
//  PWCiPhoneNewOrderCreateProductViewController.h
//  PWC
//
//  Created by Samiul Hoque on 4/16/13.
//  Copyright (c) 2013 Premium Web Cart. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PWCiPhoneNewOrderCreateProductViewController : UITableViewController

@property (strong, nonatomic) IBOutlet UITextField *productName;
@property (strong, nonatomic) IBOutlet UITextField *productPrice;
@property (strong, nonatomic) IBOutlet UITextField *productQuantity;
@property (strong, nonatomic) IBOutlet UITextField *discount;
@property (strong, nonatomic) IBOutlet UITextField *taxRate;
@property (strong, nonatomic) IBOutlet UITextField *taxAmount;
@property (strong, nonatomic) IBOutlet UITextField *shipping;
@property (strong, nonatomic) IBOutlet UITextField *productTotal;
@property (strong, nonatomic) NSString *pid;
@property (strong, nonatomic) NSString *aid;
@property (strong, nonatomic) NSString *existingProductName;
@property (strong, nonatomic) NSString *existingProductPrice;

@property (strong, nonatomic) IBOutlet UILabel *priceSign;
@property (strong, nonatomic) IBOutlet UILabel *discountSign;
@property (strong, nonatomic) IBOutlet UILabel *taxSign;
@property (strong, nonatomic) IBOutlet UILabel *shippingSign;
@property (strong, nonatomic) IBOutlet UILabel *totalSign;

- (IBAction)checkout:(id)sender;


- (void)refreshTotal;
- (void)calculateTax;
- (void)updateAll;
- (IBAction)editingEnd:(id)sender;

- (void)addProductInTheCart;

- (IBAction)addNewProduct:(id)sender;
- (IBAction)addAndCheckout:(id)sender;

@end
