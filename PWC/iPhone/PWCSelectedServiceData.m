//
//  PWCSelectedServiceData.m
//  PWC
//
//  Created by Samiul Hoque on 9/3/13.
//  Copyright (c) 2013 Premium Web Cart. All rights reserved.
//

#import "PWCSelectedServiceData.h"

@implementation PWCSelectedServiceData

@synthesize serviceRowId = _serviceRowId;

@synthesize serviceName = _serviceName;
@synthesize reqUnitDecimal = _reqUnitDecimal;
@synthesize reqUnitFraction = _reqUnitFraction;
@synthesize maxParticipants = _maxParticipants;
@synthesize unitCost = _unitCost;
@synthesize minDurationDecimal = _minDurationDecimal;
@synthesize minDurationFraction = _minDurationFraction;
@synthesize serviceType = _serviceType;
@synthesize description = _description;

@synthesize editRuleDay = _editRuleDay;
@synthesize editRuleHour = _editRuleHour;
@synthesize cancelRuleDay = _cancelRuleDay;
@synthesize cancelRuleHour = _cancelRuleHour;
@synthesize termsAndConditions = _termsAndConditions;

@synthesize assignedFunnels = _assignedFunnels;

@synthesize removedFunnels = _removedFunnels;

@synthesize assignedTags = _assignedTags;

@synthesize removedTags = _removedTags;

static PWCSelectedServiceData* _selectedService = nil;

+(PWCSelectedServiceData*)selectedService
{
    @synchronized([PWCSelectedServiceData class])
    {
        if (!_selectedService) {
            _selectedService = [[self alloc] init];
        }
        return _selectedService;
    }
    return nil;
}

+(id)alloc
{
    @synchronized([PWCSelectedServiceData class])
    {
        NSAssert(_selectedService == nil, @"Attempted to allocate a second instance of a singleton.");
        _selectedService = [super alloc];
        return _selectedService;
    }
    return nil;
}

-(id)init
{
    self = [super init];
    if (self != nil) {
        // initialize stuff here
        self.serviceRowId = @"0";
        
        self.serviceName = @"";
        self.reqUnitDecimal = @"0";
        self.reqUnitFraction = @".00";
        self.maxParticipants = @"0";
        self.unitCost = @"10";
        self.minDurationDecimal = @"0";
        self.minDurationFraction = @"00";
        self.serviceType = @"1";
        self.description = @"";
        
        self.editRuleDay = @"0";
        self.editRuleHour = @"0";
        self.cancelRuleDay = @"0";
        self.cancelRuleHour = @"0";
        self.termsAndConditions = @"";
        
        self.assignedFunnels = [[NSMutableArray alloc] init];
        self.removedFunnels = [[NSMutableArray alloc] init];
        self.assignedTags = [[NSMutableArray alloc] init];
        self.removedTags = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)resetFields
{
    self.serviceRowId = @"0";
    
    self.serviceName = @"";
    self.reqUnitDecimal = @"0";
    self.reqUnitFraction = @".00";
    self.maxParticipants = @"0";
    self.unitCost = @"10";
    self.minDurationDecimal = @"0";
    self.minDurationFraction = @"00";
    self.serviceType = @"1";
    self.description = @"";
    
    self.editRuleDay = @"0";
    self.editRuleHour = @"0";
    self.cancelRuleDay = @"0";
    self.cancelRuleHour = @"0";
    self.termsAndConditions = @"";
    
    self.assignedFunnels = [[NSMutableArray alloc] init];
    self.removedFunnels = [[NSMutableArray alloc] init];
    self.assignedTags = [[NSMutableArray alloc] init];
    self.removedTags = [[NSMutableArray alloc] init];
}

@end
