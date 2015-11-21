//
//  PWCCustomers.h
//  PWC
//
//  Created by Samiul Hoque on 7/23/13.
//  Copyright (c) 2013 Premium Web Cart. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface PWCCustomers : NSObject {
    sqlite3 *_customers;
}

+ (PWCCustomers*)customers;
- (NSArray *)pwcCustomers;
- (NSArray *)pwcCustomerList;
- (NSString *)lastCustomerId;

@end
