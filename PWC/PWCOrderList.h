//
//  PWCOrderList.h
//  PWC
//
//  Created by Samiul Hoque on 2/20/13.
//  Copyright (c) 2013 Premium Web Cart. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface PWCOrderList : NSObject {
    sqlite3 *_database;
}

+ (PWCOrderList*)database;
- (NSArray *)pwcOrdersTodays;
- (NSArray *)pwcOrders7days;
- (NSArray *)pwcOrderForPush;
- (NSString *)pwcTodaysUnread;
- (NSString *)pwc7DaysUnread;
- (NSString *)lasOrderRowId;
//- (BOOL)insertOrderData:(NSDictionary *)orders;

@end
