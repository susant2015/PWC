//
//  PWCSelectedServiceData.h
//  PWC
//
//  Created by Samiul Hoque on 9/3/13.
//  Copyright (c) 2013 Premium Web Cart. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PWCSelectedServiceData : NSObject {
    NSString *_serviceRowId;
    
    NSString *_serviceName;
    NSString *_reqUnitDecimal;
    NSString *_reqUnitFraction;
    NSString *_maxParticipants;
    NSString *_unitCost;
    NSString *_minDurationDecimal;
    NSString *_minDurationFraction;
    NSString *_serviceType;
    NSString *_description;
    
    NSString *_editRuleDay;
    NSString *_editRuleHour;
    NSString *_cancelRuleDay;
    NSString *_cancelRuleHour;
    NSString *_termsAndConditions;
    
    NSMutableArray *_assignedFunnels;
    
    NSMutableArray *_removedFunnels;
    
    NSMutableArray *_assignedTags;
    
    NSMutableArray *_removedTags;
}

@property (nonatomic, strong) NSString *serviceRowId;

@property (nonatomic, strong) NSString *serviceName;
@property (nonatomic, strong) NSString *reqUnitDecimal;
@property (nonatomic, strong) NSString *reqUnitFraction;
@property (nonatomic, strong) NSString *maxParticipants;
@property (nonatomic, strong) NSString *unitCost;
@property (nonatomic, strong) NSString *minDurationDecimal;
@property (nonatomic, strong) NSString *minDurationFraction;
@property (nonatomic, strong) NSString *serviceType;
@property (nonatomic, strong) NSString *description;

@property (nonatomic, strong) NSString *editRuleDay;
@property (nonatomic, strong) NSString *editRuleHour;
@property (nonatomic, strong) NSString *cancelRuleDay;
@property (nonatomic, strong) NSString *cancelRuleHour;
@property (nonatomic, strong) NSString *termsAndConditions;

@property (nonatomic, strong) NSMutableArray *assignedFunnels;

@property (nonatomic, strong) NSMutableArray *removedFunnels;

@property (nonatomic, strong) NSMutableArray *assignedTags;

@property (nonatomic, strong) NSMutableArray *removedTags;

+ (PWCSelectedServiceData*)selectedService;
- (void)resetFields;

@end
