//
//  PWCOrderList.m
//  PWC
//
//  Created by Samiul Hoque on 2/20/13.
//  Copyright (c) 2013 Premium Web Cart. All rights reserved.
//

#import "PWCOrderList.h"
#import "PWCOrders.h"
#import "PWCGlobal.h"

@implementation PWCOrderList

static PWCOrderList *_database;

+ (PWCOrderList*)database
{
    if (_database == nil) {
        _database = [[PWCOrderList alloc] init];
    }
    return _database;
}

- (id)init
{
    if ((self = [super init])) {
        
        if (sqlite3_open([[PWCGlobal getTheGlobal].getDBPath UTF8String], &_database) != SQLITE_OK) {
            NSLog(@"Failed to open database!");
        } else {
            /*
            char *errMsg;
            const char *sql_stmt =
            "CREATE TABLE IF NOT EXISTS order_table " \
            "(order_table_id INTEGER PRIMARY KEY AUTOINCREMENT, " \
            "OrderRowId TEXT," \
            "OrderId TEXT," \
            "OrderChargeStatus TEXT," \
            "OrderStatus TEXT," \
            "OrderDate TEXT," \
            "ProductName TEXT," \
            "OrderAmount TEXT," \
            "CustomerName TEXT," \
            "AffiliateName TEXT," \
            "OrderReadStatus TEXT," \
            "OrderDetails TEXT" \
            ")";
            
            if (sqlite3_exec(_database, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK)
            {
                //status.text = @"Failed to create table";
            }
             */
        }
    }
    
    return self;
}

- (void)dealloc
{
    sqlite3_close(_database);
}

- (NSArray *)pwcOrdersTodays
{
    NSMutableArray *retVal = [[NSMutableArray alloc] init];
    
    NSString *query = @"SELECT * FROM order_table WHERE date(OrderDate) = date('now') ORDER BY OrderRowId DESC";

    sqlite3_stmt *statement;
    
    if (sqlite3_prepare_v2(_database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            int uniqueId = sqlite3_column_int(statement, 0);
            char *corderRowId = (char *) sqlite3_column_text(statement, 1);
            char *corderId = (char *) sqlite3_column_text(statement, 2);
            char *corderChargeStatus = (char *) sqlite3_column_text(statement, 3);
            char *corderStatus = (char *) sqlite3_column_text(statement, 4);
            char *corderDate = (char *) sqlite3_column_text(statement, 5);
            char *cproduct = (char *) sqlite3_column_text(statement, 6);
            char *corderAmount = (char *) sqlite3_column_text(statement, 7);
            char *ccustomer = (char *) sqlite3_column_text(statement, 8);
            char *caffiliate = (char *) sqlite3_column_text(statement, 9);
            char *corderReadStatus = (char *) sqlite3_column_text(statement, 10);
            char *corderDetails = (char *) sqlite3_column_text(statement, 11);
            char *corderTypes = (char *) sqlite3_column_text(statement, 12);
            
            NSString *orderRowId = [[NSString alloc] initWithUTF8String:corderRowId];
            NSString *orderId = [[NSString alloc] initWithUTF8String:corderId];
            NSString *orderChargeStatus = [[NSString alloc] initWithUTF8String:corderChargeStatus];
            NSString *orderStatus = [[NSString alloc] initWithUTF8String:corderStatus];
            NSString *orderDate = [[NSString alloc] initWithUTF8String:corderDate];
            NSString *product = [[NSString alloc] initWithUTF8String:cproduct];
            NSString *orderAmount = [[NSString alloc] initWithUTF8String:corderAmount];
            NSString *customer = [[NSString alloc] initWithUTF8String:ccustomer];
            NSString *affiliate = [[NSString alloc] initWithUTF8String:caffiliate];
            NSString *orderReadStatus = [[NSString alloc] initWithUTF8String:corderReadStatus];
            NSString *orderDetails = [[NSString alloc] initWithUTF8String:corderDetails];
            NSString *orderTypes = [[NSString alloc] initWithUTF8String:corderTypes];
            
            PWCOrders *order = [[PWCOrders alloc] initWithUniqueId:uniqueId
                                                        orderRowId:orderRowId
                                                           orderId:orderId
                                                 orderChargeStatus:orderChargeStatus
                                                       orderStatus:orderStatus
                                                         orderDate:orderDate
                                                           product:product
                                                       orderAmount:orderAmount
                                                          customer:customer
                                                         affiliate:affiliate
                                                   orderReadStatus:orderReadStatus
                                                      orderDetails:orderDetails
                                                        orderTypes:orderTypes];
            [retVal addObject:order];
        }
        sqlite3_finalize(statement);
    }
    
    return retVal;
}

- (NSArray *)pwcOrders7days
{
    NSMutableArray *retVal = [[NSMutableArray alloc] init];
    
    NSString *query = @"SELECT * FROM order_table WHERE date(OrderDate) > date('now','-14 day') ORDER BY OrderRowId DESC";
    
    sqlite3_stmt *statement;
    
    if (sqlite3_prepare_v2(_database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            int uniqueId = sqlite3_column_int(statement, 0);
            char *corderRowId = (char *) sqlite3_column_text(statement, 1);
            char *corderId = (char *) sqlite3_column_text(statement, 2);
            char *corderChargeStatus = (char *) sqlite3_column_text(statement, 3);
            char *corderStatus = (char *) sqlite3_column_text(statement, 4);
            char *corderDate = (char *) sqlite3_column_text(statement, 5);
            char *cproduct = (char *) sqlite3_column_text(statement, 6);
            char *corderAmount = (char *) sqlite3_column_text(statement, 7);
            char *ccustomer = (char *) sqlite3_column_text(statement, 8);
            char *caffiliate = (char *) sqlite3_column_text(statement, 9);
            char *corderReadStatus = (char *) sqlite3_column_text(statement, 10);
            char *corderDetails = (char *) sqlite3_column_text(statement, 11);
            char *corderTypes = (char *) sqlite3_column_text(statement, 12);
            
            NSString *orderRowId = [[NSString alloc] initWithUTF8String:corderRowId];
            NSString *orderId = [[NSString alloc] initWithUTF8String:corderId];
            NSString *orderChargeStatus = [[NSString alloc] initWithUTF8String:corderChargeStatus];
            NSString *orderStatus = [[NSString alloc] initWithUTF8String:corderStatus];
            NSString *orderDate = [[NSString alloc] initWithUTF8String:corderDate];
            NSString *product = [[NSString alloc] initWithUTF8String:cproduct];
            NSString *orderAmount = [[NSString alloc] initWithUTF8String:corderAmount];
            NSString *customer = [[NSString alloc] initWithUTF8String:ccustomer];
            NSString *affiliate = [[NSString alloc] initWithUTF8String:caffiliate];
            NSString *orderReadStatus = [[NSString alloc] initWithUTF8String:corderReadStatus];
            NSString *orderDetails = [[NSString alloc] initWithUTF8String:corderDetails];
            NSString *orderTypes = [[NSString alloc] initWithUTF8String:corderTypes];
            
            PWCOrders *order = [[PWCOrders alloc] initWithUniqueId:uniqueId
                                                        orderRowId:orderRowId
                                                           orderId:orderId
                                                 orderChargeStatus:orderChargeStatus
                                                       orderStatus:orderStatus
                                                         orderDate:orderDate
                                                           product:product
                                                       orderAmount:orderAmount
                                                          customer:customer
                                                         affiliate:affiliate
                                                   orderReadStatus:orderReadStatus
                                                      orderDetails:orderDetails
                                                        orderTypes:orderTypes];
            [retVal addObject:order];
        }
        sqlite3_finalize(statement);
    }
    
    return retVal;
}

- (NSArray *)pwcOrderForPush
{
    NSMutableArray *retVal = [[NSMutableArray alloc] init];
    
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM order_table WHERE OrderRowId = '%@'", [PWCGlobal getTheGlobal].notificationParam];
    
    sqlite3_stmt *statement;
    
    if (sqlite3_prepare_v2(_database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            int uniqueId = sqlite3_column_int(statement, 0);
            char *corderRowId = (char *) sqlite3_column_text(statement, 1);
            char *corderId = (char *) sqlite3_column_text(statement, 2);
            char *corderChargeStatus = (char *) sqlite3_column_text(statement, 3);
            char *corderStatus = (char *) sqlite3_column_text(statement, 4);
            char *corderDate = (char *) sqlite3_column_text(statement, 5);
            char *cproduct = (char *) sqlite3_column_text(statement, 6);
            char *corderAmount = (char *) sqlite3_column_text(statement, 7);
            char *ccustomer = (char *) sqlite3_column_text(statement, 8);
            char *caffiliate = (char *) sqlite3_column_text(statement, 9);
            char *corderReadStatus = (char *) sqlite3_column_text(statement, 10);
            char *corderDetails = (char *) sqlite3_column_text(statement, 11);
            char *corderTypes = (char *) sqlite3_column_text(statement, 12);
            
            NSString *orderRowId = [[NSString alloc] initWithUTF8String:corderRowId];
            NSString *orderId = [[NSString alloc] initWithUTF8String:corderId];
            NSString *orderChargeStatus = [[NSString alloc] initWithUTF8String:corderChargeStatus];
            NSString *orderStatus = [[NSString alloc] initWithUTF8String:corderStatus];
            NSString *orderDate = [[NSString alloc] initWithUTF8String:corderDate];
            NSString *product = [[NSString alloc] initWithUTF8String:cproduct];
            NSString *orderAmount = [[NSString alloc] initWithUTF8String:corderAmount];
            NSString *customer = [[NSString alloc] initWithUTF8String:ccustomer];
            NSString *affiliate = [[NSString alloc] initWithUTF8String:caffiliate];
            NSString *orderReadStatus = [[NSString alloc] initWithUTF8String:corderReadStatus];
            NSString *orderDetails = [[NSString alloc] initWithUTF8String:corderDetails];
            NSString *orderTypes = [[NSString alloc] initWithUTF8String:corderTypes];
            
            PWCOrders *order = [[PWCOrders alloc] initWithUniqueId:uniqueId
                                                        orderRowId:orderRowId
                                                           orderId:orderId
                                                 orderChargeStatus:orderChargeStatus
                                                       orderStatus:orderStatus
                                                         orderDate:orderDate
                                                           product:product
                                                       orderAmount:orderAmount
                                                          customer:customer
                                                         affiliate:affiliate
                                                   orderReadStatus:orderReadStatus
                                                      orderDetails:orderDetails
                                                        orderTypes:orderTypes];
            [retVal addObject:order];
        }
        sqlite3_finalize(statement);
    }
    
    return retVal;
}

- (NSString *)pwcTodaysUnread
{
    NSString *query = @"SELECT COUNT(*) FROM order_table WHERE date(OrderDate) = date('now') AND OrderReadStatus = 'Unread' ORDER BY OrderRowId DESC";
    NSString *numbers = [[NSString alloc] init];
    sqlite3_stmt *statement;
    
    if (sqlite3_prepare_v2(_database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            char *number = (char *) sqlite3_column_text(statement, 0);
            numbers = [[NSString alloc] initWithUTF8String:number];
        }
        sqlite3_finalize(statement);
    }
    
    return numbers;
}

- (NSString *)pwc7DaysUnread
{
    NSString *query = @"SELECT COUNT(*) FROM order_table WHERE date(OrderDate) > date('now','-7 day') AND OrderReadStatus = 'Unread' ORDER BY OrderRowId DESC";
    NSString *numbers = [[NSString alloc] init];
    sqlite3_stmt *statement;
    
    if (sqlite3_prepare_v2(_database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            char *number = (char *) sqlite3_column_text(statement, 0);
            numbers = [[NSString alloc] initWithUTF8String:number];
        }
        sqlite3_finalize(statement);
    }
    
    return numbers;
}

- (NSString *)lasOrderRowId
{
    NSString *query = @"SELECT * FROM order_table ORDER BY OrderRowId DESC";
    NSString *numbers = [[NSString alloc] init];
    sqlite3_stmt *statement;
    
    if (sqlite3_prepare_v2(_database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            char *number = (char *) sqlite3_column_text(statement, 1);
            numbers = [[NSString alloc] initWithUTF8String:number];
            break;
        }
        sqlite3_finalize(statement);
    }
    
    return numbers;
}

/*
- (BOOL)insertOrderData:(NSDictionary *)orders
{
    BOOL done = NO;
    sqlite3_stmt *statement;
    
    NSString *insertSQL = [NSString stringWithFormat: @"INSERT INTO order_table (OrderRowId,OrderId,OrderChargeStatus,OrderStatus,OrderDate,ProductName,OrderAmount,CustomerName,AffiliateName,OrderReadStatus,OrderDetails) VALUES (\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\")",
                           [orders objectForKey:@"OrderRowId"], [orders objectForKey:@"OrderId"], [orders objectForKey:@"OrderChargeStatus"], [orders objectForKey:@"OrderStatus"],
                           [orders objectForKey:@"OrderDateTime"], [orders objectForKey:@"ProductName"], [orders objectForKey:@"OrderAmount"], [orders objectForKey:@"CustomerName"],
                           [orders objectForKey:@"AffiliatesName"], @"Unread", [[orders objectForKey:@"OrderDetails"] objectAtIndex:0]];
    
    const char *insert_stmt = [insertSQL UTF8String];
    
    sqlite3_prepare_v2(_database, insert_stmt, -1, &statement, NULL);
    if (sqlite3_step(statement) == SQLITE_DONE)
    {
        done = YES;
    } else {
        done = NO;
    }
    sqlite3_finalize(statement);
    
    return done;
}
 */

@end
