//
//  PWCReportFormData.m
//  PWC iPhone App
//
//  Created by Samiul Hoque on 10/10/12.
//  Copyright (c) 2012 Samiul Hoque. All rights reserved.
//

#import "PWCReportFormData.h"

@implementation PWCReportFormData

@synthesize categoryList;
@synthesize productList;
@synthesize affiliateList;

static PWCReportFormData* _getReportFormData = nil;

+(PWCReportFormData*)getReportFormData
{
    @synchronized([PWCReportFormData class])
    {
        if (!_getReportFormData) {
            _getReportFormData = [[self alloc] init];
        }
        return _getReportFormData;
    }
    return nil;
}

+(id)alloc
{
    @synchronized([PWCReportFormData class])
    {
        NSAssert(_getReportFormData == nil, @"Attempted to allocate a second instance of a singleton.");
        _getReportFormData = [super alloc];
        return _getReportFormData;
    }
    return nil;
}

-(id)init
{
    self = [super init];
    if (self != nil) {
        // initialize stuff here
        
    }
    return self;
}

- (void)resetData
{
    self.categoryList = nil;
    self.productList = nil;
    self.affiliateList = nil;
}

@end
