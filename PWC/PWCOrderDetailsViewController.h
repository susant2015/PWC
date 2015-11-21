//
//  PWCOrderDetailsViewController.h
//  PWC
//
//  Created by Samiul Hoque on 3/12/13.
//  Copyright (c) 2013 Premium Web Cart. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PWCOrderDetailsViewController : UITableViewController 

@property (strong, nonatomic) NSArray *jsonObj;
@property (strong, nonatomic) NSDictionary *billing;
@property (strong, nonatomic) NSDictionary *payment;
@property (strong, nonatomic) NSDictionary *invoice;
@property (strong, nonatomic) NSDictionary *shipping;
@property (strong, nonatomic) NSArray *products;
@property (strong, nonatomic) NSString *grandTotal;

@property (strong, nonatomic) NSArray *productsDiscounts;

@end
