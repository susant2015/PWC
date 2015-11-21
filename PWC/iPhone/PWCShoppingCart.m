//
//  PWCShoppingCart.m
//  PWC
//
//  Created by Samiul Hoque on 4/16/13.
//  Copyright (c) 2013 Premium Web Cart. All rights reserved.
//

#import "PWCShoppingCart.h"

@implementation PWCShoppingCart

@synthesize products = _products;

static PWCShoppingCart* _cart = nil;

+(PWCShoppingCart*)cart
{
    @synchronized([PWCShoppingCart class])
    {
        if (!_cart) {
            _cart = [[self alloc] init];
        }
        return _cart;
    }
    return nil;
}

+(id)alloc
{
    @synchronized([PWCShoppingCart class])
    {
        NSAssert(_cart == nil, @"Attempted to allocate a second instance of a singleton.");
        _cart = [super alloc];
        return _cart;
    }
    return nil;
}

-(id)init
{
    self = [super init];
    if (self != nil) {
        // initialize stuff here
        self.products = [[NSMutableArray alloc] init];
    }
    return self;
}


@end
