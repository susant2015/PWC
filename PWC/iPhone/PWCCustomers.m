//
//  PWCCustomers.m
//  PWC
//
//  Created by Samiul Hoque on 7/23/13.
//  Copyright (c) 2013 Premium Web Cart. All rights reserved.
//

#import "PWCCustomers.h"
#import "PWCGlobal.h"

@implementation PWCCustomers

static PWCCustomers *_customers;

+ (PWCCustomers*)customers
{
    if (_customers == nil) {
        _customers = [[PWCCustomers alloc] init];
    }
    return _customers;
}

- (id)init
{
    if ((self = [super init])) {
        if (sqlite3_open([[PWCGlobal getTheGlobal].getDBPath UTF8String], &_customers) != SQLITE_OK) {
            NSLog(@"Failed to open db!");
        } else {
            
        }
    }
    return self;
}

- (void)dealloc
{
    sqlite3_close(_customers);
}

- (NSArray *)pwcCustomers
{
    NSMutableArray *retVal = [[NSMutableArray alloc] init];
    NSString *last = nil;
    NSDictionary *dic = nil;
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    
    NSString *query = @"SELECT * FROM customers ORDER BY section, firstName";
    
    sqlite3_stmt *statement;
    
    if (sqlite3_prepare_v2(_customers, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
        int i = 0;
        while (sqlite3_step(statement) == SQLITE_ROW) {
            //int uniqueId = sqlite3_column_int(statement, 0);
            char *ccustomerId = (char *) sqlite3_column_text(statement, 1);
            char *ccustomerCrmId = (char *) sqlite3_column_text(statement, 2);
            char *cfirstName = (char *) sqlite3_column_text(statement, 3);
            char *clastName = (char *) sqlite3_column_text(statement, 4);
            
            char *chomePhone = (char *) sqlite3_column_text(statement, 5);
            char *cworkPhone = (char *) sqlite3_column_text(statement, 6);
            char *cemail = (char *) sqlite3_column_text(statement, 7);
            char *caddress = (char *) sqlite3_column_text(statement, 8);
            
            char *ccity = (char *) sqlite3_column_text(statement, 9);
            char *cstate = (char *) sqlite3_column_text(statement, 10);
            char *czipCode = (char *) sqlite3_column_text(statement, 11);
            char *ccountry = (char *) sqlite3_column_text(statement, 12);
            
            char *cfax = (char *) sqlite3_column_text(statement, 13);
            char *ccompanyName = (char *) sqlite3_column_text(statement, 14);
            char *cbalance = (char *) sqlite3_column_text(statement, 15);
            char *cnotes = (char *) sqlite3_column_text(statement, 16);
            
            char *csection = (char *) sqlite3_column_text(statement, 17);
            char *ccrm_customer = (char *) sqlite3_column_text(statement, 18);

            NSString *customerId = [[NSString alloc] initWithUTF8String:ccustomerId];
            NSString *customerCrmId = [[NSString alloc] initWithUTF8String:ccustomerCrmId];
            NSString *firstName = [[NSString alloc] initWithUTF8String:cfirstName];
            NSString *lastName = [[NSString alloc] initWithUTF8String:clastName];
            
            NSString *homePhone = [[NSString alloc] initWithUTF8String:chomePhone];
            NSString *workPhone = [[NSString alloc] initWithUTF8String:cworkPhone];
            NSString *email = [[NSString alloc] initWithUTF8String:cemail];
            NSString *address = [[NSString alloc] initWithUTF8String:caddress];
            
            NSString *city = [[NSString alloc] initWithUTF8String:ccity];
            NSString *state = [[NSString alloc] initWithUTF8String:cstate];
            NSString *zipCode = [[NSString alloc] initWithUTF8String:czipCode];
            NSString *country = [[NSString alloc] initWithUTF8String:ccountry];
            
            NSString *fax = [[NSString alloc] initWithUTF8String:cfax];
            NSString *companyName = [[NSString alloc] initWithUTF8String:ccompanyName];
            NSString *balance = [[NSString alloc] initWithUTF8String:cbalance];
            NSString *notes = [[NSString alloc] initWithUTF8String:cnotes];
            
            NSString *section = [[NSString alloc] initWithUTF8String:csection];
            NSString *crm_customer = [[NSString alloc] initWithUTF8String: ccrm_customer];
            
            NSDictionary *customer = [NSDictionary dictionaryWithObjectsAndKeys:customerId, @"customerId", customerCrmId, @"customerCrmId",
                                      firstName, @"firstName", lastName, @"lastName", homePhone, @"homePhone", workPhone, @"workPhone", email, @"email",
                                      address, @"address", city, @"city", state, @"state", zipCode, @"zipCode", country, @"country", fax, @"fax",
                                      companyName, @"companyName", balance, @"balance", notes, @"notes", crm_customer, @"crm_customer", nil];
            
            if (last == nil) {
                last = section;
                [temp addObject:customer];
            } else if ([last isEqualToString:section]) {
                [temp addObject:customer];
            } else {
                dic = [NSDictionary dictionaryWithObjectsAndKeys:temp, last, nil];
                [retVal addObject:dic];
                
                last = section;
                temp = [[NSMutableArray alloc] init];
                [temp addObject:customer];
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

- (NSArray *)pwcCustomerList
{
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    
    NSString *query = @"SELECT * FROM customers ORDER BY section, firstName";
    
    sqlite3_stmt *statement;
    
    if (sqlite3_prepare_v2(_customers, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
        int i = 0;
        while (sqlite3_step(statement) == SQLITE_ROW) {
            //int uniqueId = sqlite3_column_int(statement, 0);
            char *ccustomerId = (char *) sqlite3_column_text(statement, 1);
            char *ccustomerCrmId = (char *) sqlite3_column_text(statement, 2);
            char *cfirstName = (char *) sqlite3_column_text(statement, 3);
            char *clastName = (char *) sqlite3_column_text(statement, 4);
            
            char *chomePhone = (char *) sqlite3_column_text(statement, 5);
            char *cworkPhone = (char *) sqlite3_column_text(statement, 6);
            char *cemail = (char *) sqlite3_column_text(statement, 7);
            char *caddress = (char *) sqlite3_column_text(statement, 8);
            
            char *ccity = (char *) sqlite3_column_text(statement, 9);
            char *cstate = (char *) sqlite3_column_text(statement, 10);
            char *czipCode = (char *) sqlite3_column_text(statement, 11);
            char *ccountry = (char *) sqlite3_column_text(statement, 12);
            
            char *cfax = (char *) sqlite3_column_text(statement, 13);
            char *ccompanyName = (char *) sqlite3_column_text(statement, 14);
            char *cbalance = (char *) sqlite3_column_text(statement, 15);
            char *cnotes = (char *) sqlite3_column_text(statement, 16);
            char *ccrm_customer = (char *) sqlite3_column_text(statement, 18);
            
            NSString *customerId = [[NSString alloc] initWithUTF8String:ccustomerId];
            NSString *customerCrmId = [[NSString alloc] initWithUTF8String:ccustomerCrmId];
            NSString *firstName = [[NSString alloc] initWithUTF8String:cfirstName];
            NSString *lastName = [[NSString alloc] initWithUTF8String:clastName];
            
            NSString *homePhone = [[NSString alloc] initWithUTF8String:chomePhone];
            NSString *workPhone = [[NSString alloc] initWithUTF8String:cworkPhone];
            NSString *email = [[NSString alloc] initWithUTF8String:cemail];
            NSString *address = [[NSString alloc] initWithUTF8String:caddress];
            
            NSString *city = [[NSString alloc] initWithUTF8String:ccity];
            NSString *state = [[NSString alloc] initWithUTF8String:cstate];
            NSString *zipCode = [[NSString alloc] initWithUTF8String:czipCode];
            NSString *country = [[NSString alloc] initWithUTF8String:ccountry];
            
            NSString *fax = [[NSString alloc] initWithUTF8String:cfax];
            NSString *companyName = [[NSString alloc] initWithUTF8String:ccompanyName];
            NSString *balance = [[NSString alloc] initWithUTF8String:cbalance];
            NSString *notes = [[NSString alloc] initWithUTF8String:cnotes];
            NSString *crm_customer = [[NSString alloc] initWithUTF8String:ccrm_customer];
            
            NSDictionary *customer = [NSDictionary dictionaryWithObjectsAndKeys:customerId, @"customerId", customerCrmId, @"customerCrmId",
                                      firstName, @"firstName", lastName, @"lastName", homePhone, @"homePhone", workPhone, @"workPhone", email, @"email",
                                      address, @"address", city, @"city", state, @"state", zipCode, @"zipCode", country, @"country", fax, @"fax",
                                      companyName, @"companyName", balance, @"balance", notes, @"notes", crm_customer, @"crm_customer", nil];

            [temp addObject:customer];
            i++;
        }
        sqlite3_finalize(statement);
    }
    return temp;
}

- (NSString *)lastCustomerId
{
    NSString *last = nil;
    
    NSString *query = @"SELECT customerId FROM customers";
    
    sqlite3_stmt *statement;
    
    if (sqlite3_prepare_v2(_customers, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            char *ccustomerId = (char *) sqlite3_column_text(statement, 0);
            
            NSString *customerId = [[NSString alloc] initWithUTF8String:ccustomerId];
            
            if (last == nil) {
                last = customerId;
            } else if ([last intValue] < [customerId intValue]) {
                last = customerId;
            }
        }
        sqlite3_finalize(statement);
    }
    
    return last;
}


@end
