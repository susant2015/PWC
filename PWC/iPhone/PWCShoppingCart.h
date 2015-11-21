//
//  PWCShoppingCart.h
//  PWC
//
//  Created by Samiul Hoque on 4/16/13.
//  Copyright (c) 2013 Premium Web Cart. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PWCShoppingCart : NSObject {
    NSMutableArray *_products;
}

@property (retain, nonatomic) NSMutableArray *products;

+(PWCShoppingCart*)cart;

@end
