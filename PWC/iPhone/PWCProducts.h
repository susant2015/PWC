//
//  PWCProducts.h
//  PWC
//
//  Created by Samiul Hoque on 4/24/13.
//  Copyright (c) 2013 Premium Web Cart. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface PWCProducts : NSObject {
    sqlite3 *_products;
}

+ (PWCProducts*)products;
- (NSArray *)pwcProducts;
- (NSString *)lastProductId;


@end
