//
//  PWCServices.m
//  PWC
//
//  Created by Samiul Hoque on 7/23/13.
//  Copyright (c) 2013 Premium Web Cart. All rights reserved.
//

#import "PWCServices.h"
#import "PWCGlobal.h"

@implementation PWCServices

static PWCServices *_services;

+ (PWCServices*)services
{
    if (_services == nil) {
        _services = [[PWCServices alloc] init];
    }
    return _services;
}

- (id)init
{
    if ((self = [super init])) {
        if (sqlite3_open([[PWCGlobal getTheGlobal].getDBPath UTF8String], &_services) != SQLITE_OK) {
            NSLog(@"Failed to open db!");
        } else {
            
        }
    }
    return self;
}

- (void)dealloc
{
    sqlite3_close(_services);
}

- (NSArray *)pwcServices
{
    NSMutableArray *retVal = [[NSMutableArray alloc] init];
    NSString *last = nil;
    NSDictionary *dic = nil;
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    
    NSString *query = @"SELECT * FROM services ORDER BY section, serviceName";
    
    sqlite3_stmt *statement;
    
    if (sqlite3_prepare_v2(_services, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
        int i = 0;
        while (sqlite3_step(statement) == SQLITE_ROW) {
            //int uniqueId = sqlite3_column_int(statement, 0);
            char *cserviceRowId = (char *) sqlite3_column_text(statement, 1);
            char *cserviceType = (char *) sqlite3_column_text(statement, 2);
            char *cserviceName = (char *) sqlite3_column_text(statement, 3);
            char *cdescription = (char *) sqlite3_column_text(statement, 4);
            
            char *crequiredUnit = (char *) sqlite3_column_text(statement, 5);
            char *cmaxParticipants = (char *) sqlite3_column_text(statement, 6);
            char *cminDuration = (char *) sqlite3_column_text(statement, 7);
            char *cchargePerUnit = (char *) sqlite3_column_text(statement, 8);
            
            char *ceditRuleRuleDay = (char *) sqlite3_column_text(statement, 9);
            char *ceditRuleRuleHour = (char *) sqlite3_column_text(statement, 10);
            char *ccancelRuleRuleDay = (char *) sqlite3_column_text(statement, 11);
            char *ccancelRuleRuleHour = (char *) sqlite3_column_text(statement, 12);
            
            char *ctermsAndConditions = (char *) sqlite3_column_text(statement, 13);
            
            char *cremovedFunnels = (char *) sqlite3_column_text(statement, 14);
            char *cassignedFunnels = (char *) sqlite3_column_text(statement, 15);
            char *cremovedTags = (char *) sqlite3_column_text(statement, 16);
            char *cassignedTags = (char *) sqlite3_column_text(statement, 17);
            
            char *cnotes = (char *) sqlite3_column_text(statement, 18);
            char *csection = (char *) sqlite3_column_text(statement, 19);
            
            NSString *serviceRowId = [[NSString alloc] initWithUTF8String:cserviceRowId];
            NSString *serviceType = [[NSString alloc] initWithUTF8String:cserviceType];
            NSString *serviceName = [[NSString alloc] initWithUTF8String:cserviceName];
            NSString *description = [[NSString alloc] initWithUTF8String:cdescription];
            
            NSString *requiredUnit = [[NSString alloc] initWithUTF8String:crequiredUnit];
            NSString *maxParticipants = [[NSString alloc] initWithUTF8String:cmaxParticipants];
            NSString *minDuration = [[NSString alloc] initWithUTF8String:cminDuration];
            NSString *chargePerHour = [[NSString alloc] initWithUTF8String:cchargePerUnit];
            
            NSString *editRuleDay = [[NSString alloc] initWithUTF8String:ceditRuleRuleDay];
            NSString *editRuleHour = [[NSString alloc] initWithUTF8String:ceditRuleRuleHour];
            NSString *cancelRuleDay = [[NSString alloc] initWithUTF8String:ccancelRuleRuleDay];
            NSString *cancelRuleHour = [[NSString alloc] initWithUTF8String:ccancelRuleRuleHour];
            
            NSString *termsAndConditions = [[NSString alloc] initWithUTF8String:ctermsAndConditions];
            
            NSString *removedFunnels = [[NSString alloc] initWithUTF8String:cremovedFunnels];
            NSString *assignedFunnels = [[NSString alloc] initWithUTF8String:cassignedFunnels];
            NSString *removedTags = [[NSString alloc] initWithUTF8String:cremovedTags];
            NSString *assignedTags = [[NSString alloc] initWithUTF8String:cassignedTags];
            
            NSString *notes = [[NSString alloc] initWithUTF8String:cnotes];
            NSString *section = [[NSString alloc] initWithUTF8String:csection];
            
            NSDictionary *service = [NSDictionary dictionaryWithObjectsAndKeys:serviceRowId, @"serviceRowId", serviceType, @"serviceType", serviceName, @"serviceName",
                                     description, @"description", requiredUnit, @"requiredUnit", maxParticipants, @"maxParticipants", minDuration, @"minDuration", chargePerHour, @"chargePerHour",
                                     editRuleDay, @"editRuleDay", editRuleHour, @"editRuleHour", cancelRuleDay, @"cancelRuleDay", cancelRuleHour, @"cancelRuleHour",
                                     termsAndConditions, @"termsAndConditions", removedFunnels, @"removedFunnels", assignedFunnels, @"assignedFunnels",
                                     removedTags, @"removedTags", assignedTags, @"assignedTags", notes, @"notes", nil];
            
            if (last == nil) {
                last = section;
                [temp addObject:service];
            } else if ([last isEqualToString:section]) {
                [temp addObject:service];
            } else {
                dic = [NSDictionary dictionaryWithObjectsAndKeys:temp, last, nil];
                [retVal addObject:dic];
                
                last = section;
                temp = [[NSMutableArray alloc] init];
                [temp addObject:service];
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

- (NSArray *)pwcServiceList
{
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    
    NSString *query = @"SELECT * FROM services ORDER BY section, serviceName";
    
    sqlite3_stmt *statement;
    
    if (sqlite3_prepare_v2(_services, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
        int i = 0;
        while (sqlite3_step(statement) == SQLITE_ROW) {
            //int uniqueId = sqlite3_column_int(statement, 0);
            char *cserviceRowId = (char *) sqlite3_column_text(statement, 1);
            char *cserviceType = (char *) sqlite3_column_text(statement, 2);
            char *cserviceName = (char *) sqlite3_column_text(statement, 3);
            char *cdescription = (char *) sqlite3_column_text(statement, 4);
            
            char *crequiredUnit = (char *) sqlite3_column_text(statement, 5);
            char *cmaxParticipants = (char *) sqlite3_column_text(statement, 6);
            char *cminDuration = (char *) sqlite3_column_text(statement, 7);
            char *cchargePerUnit = (char *) sqlite3_column_text(statement, 8);
            
            char *ceditRuleRuleDay = (char *) sqlite3_column_text(statement, 9);
            char *ceditRuleRuleHour = (char *) sqlite3_column_text(statement, 10);
            char *ccancelRuleRuleDay = (char *) sqlite3_column_text(statement, 11);
            char *ccancelRuleRuleHour = (char *) sqlite3_column_text(statement, 12);
            
            char *ctermsAndConditions = (char *) sqlite3_column_text(statement, 13);
            
            char *cremovedFunnels = (char *) sqlite3_column_text(statement, 14);
            char *cassignedFunnels = (char *) sqlite3_column_text(statement, 15);
            char *cremovedTags = (char *) sqlite3_column_text(statement, 16);
            char *cassignedTags = (char *) sqlite3_column_text(statement, 17);
            
            char *cnotes = (char *) sqlite3_column_text(statement, 18);
            //char *csection = (char *) sqlite3_column_text(statement, 19);
            
            NSString *serviceRowId = [[NSString alloc] initWithUTF8String:cserviceRowId];
            NSString *serviceType = [[NSString alloc] initWithUTF8String:cserviceType];
            NSString *serviceName = [[NSString alloc] initWithUTF8String:cserviceName];
            NSString *description = [[NSString alloc] initWithUTF8String:cdescription];
            
            NSString *requiredUnit = [[NSString alloc] initWithUTF8String:crequiredUnit];
            NSString *maxParticipants = [[NSString alloc] initWithUTF8String:cmaxParticipants];
            NSString *minDuration = [[NSString alloc] initWithUTF8String:cminDuration];
            NSString *chargePerHour = [[NSString alloc] initWithUTF8String:cchargePerUnit];
            
            NSString *editRuleDay = [[NSString alloc] initWithUTF8String:ceditRuleRuleDay];
            NSString *editRuleHour = [[NSString alloc] initWithUTF8String:ceditRuleRuleHour];
            NSString *cancelRuleDay = [[NSString alloc] initWithUTF8String:ccancelRuleRuleDay];
            NSString *cancelRuleHour = [[NSString alloc] initWithUTF8String:ccancelRuleRuleHour];
            
            NSString *termsAndConditions = [[NSString alloc] initWithUTF8String:ctermsAndConditions];
            
            NSString *removedFunnels = [[NSString alloc] initWithUTF8String:cremovedFunnels];
            NSString *assignedFunnels = [[NSString alloc] initWithUTF8String:cassignedFunnels];
            NSString *removedTags = [[NSString alloc] initWithUTF8String:cremovedTags];
            NSString *assignedTags = [[NSString alloc] initWithUTF8String:cassignedTags];
            
            NSString *notes = [[NSString alloc] initWithUTF8String:cnotes];
            //NSString *section = [[NSString alloc] initWithUTF8String:csection];
            
            NSDictionary *service = [NSDictionary dictionaryWithObjectsAndKeys:serviceRowId, @"serviceRowId", serviceType, @"serviceType", serviceName, @"serviceName",
                                     description, @"description", requiredUnit, @"requiredUnit", maxParticipants, @"maxParticipants", minDuration, @"minDuration", chargePerHour, @"chargePerHour",
                                     editRuleDay, @"editRuleDay", editRuleHour, @"editRuleHour", cancelRuleDay, @"cancelRuleDay", cancelRuleHour, @"cancelRuleHour",
                                     termsAndConditions, @"termsAndConditions", removedFunnels, @"removedFunnels", assignedFunnels, @"assignedFunnels",
                                     removedTags, @"removedTags", assignedTags, @"assignedTags", notes, @"notes", nil];
            

            [temp addObject:service];
            i++;
        }
        sqlite3_finalize(statement);
    }
    return temp;
}

- (NSString *)lastServiceId
{
    NSString *last = nil;
    
    NSString *query = @"SELECT serviceRowId FROM services";
    
    sqlite3_stmt *statement;
    
    if (sqlite3_prepare_v2(_services, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            char *cserviceRowId = (char *) sqlite3_column_text(statement, 0);
            
            NSString *serviceRowId = [[NSString alloc] initWithUTF8String:cserviceRowId];
            
            if (last == nil) {
                last = serviceRowId;
            } else if ([last intValue] < [serviceRowId intValue]) {
                last = serviceRowId;
            }
        }
        sqlite3_finalize(statement);
    }
    
    return last;
}


@end
