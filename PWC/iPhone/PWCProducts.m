//
//  PWCProducts.m
//  PWC
//
//  Created by Samiul Hoque on 4/24/13.
//  Copyright (c) 2013 Premium Web Cart. All rights reserved.
//

#import "PWCProducts.h"
#import "PWCGlobal.h"

@implementation PWCProducts

static PWCProducts *_products;

+ (PWCProducts*)products
{
    if (_products == nil) {
        _products = [[PWCProducts alloc] init];
    }
    return _products;
}

- (id)init
{
    if ((self = [super init])) {
        
        if (sqlite3_open([[PWCGlobal getTheGlobal].getDBPath UTF8String], &_products) != SQLITE_OK) {
            NSLog(@"Failed to open database!");
        } else {

        }
    }
    
    return self;
}

- (void)dealloc
{
    sqlite3_close(_products);
}

- (NSArray *)pwcProducts
{
    NSMutableArray *retVal = [[NSMutableArray alloc] init];
    NSString *last = nil;
    NSDictionary *dic = nil;
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    
    NSString *query = @"SELECT * FROM products ORDER BY section, productName";
    
    sqlite3_stmt *statement;
    
    if (sqlite3_prepare_v2(_products, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
        int i = 0;
        while (sqlite3_step(statement) == SQLITE_ROW) {
            //int uniqueId = sqlite3_column_int(statement, 0);
            char *cproductId = (char *) sqlite3_column_text(statement, 1);
            char *cattributeId = (char *) sqlite3_column_text(statement, 2);
            char *cproductName = (char *) sqlite3_column_text(statement, 3);
            char *cproductPrice = (char *) sqlite3_column_text(statement, 4);
            char *csection = (char *) sqlite3_column_text(statement, 5);
            
            NSString *productId = [[NSString alloc] initWithUTF8String:cproductId];
            NSString *attributeId = [[NSString alloc] initWithUTF8String:cattributeId];
            NSString *productName = [[NSString alloc] initWithUTF8String:cproductName];
            NSString *productPrice = [[NSString alloc] initWithUTF8String:cproductPrice];
            NSString *section = [[NSString alloc] initWithUTF8String:csection];

            NSDictionary *product = [NSDictionary dictionaryWithObjectsAndKeys:productId, @"pid", attributeId, @"aid", productName, @"name", productPrice, @"price", nil];
            
            if (last == nil) {
                last = section;
                [temp addObject:product];
            } else if ([last isEqualToString:section]) {
                [temp addObject:product];
            } else {
                dic = [NSDictionary dictionaryWithObjectsAndKeys:temp, last, nil];
                [retVal addObject:dic];
                
                last = section;
                temp = [[NSMutableArray alloc] init];
                [temp addObject:product];
            }
            i++;
        }
        
        if (i > 0) {
            dic = [NSDictionary dictionaryWithObjectsAndKeys:temp, last, nil];
            [retVal addObject:dic];
        }
        
        sqlite3_finalize(statement);
    }
    
    return retVal;
}

- (NSString *)lastProductId
{
    NSString *last = nil;
    
    NSString *query = @"SELECT productId FROM products";
    
    sqlite3_stmt *statement;
    
    if (sqlite3_prepare_v2(_products, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            char *cproductId = (char *) sqlite3_column_text(statement, 0);
            
            NSString *productId = [[NSString alloc] initWithUTF8String:cproductId];
            
            if (last == nil) {
                last = productId;
            } else if ([last intValue] < [productId intValue]) {
                last = productId;
            }
        }
        sqlite3_finalize(statement);
    }
    
    return last;
}

@end
