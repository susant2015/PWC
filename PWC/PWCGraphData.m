//
//  PWCGraphData.m
//  PWC iPhone App
//
//  Created by Samiul Hoque on 9/26/12.
//  Copyright (c) 2012 Samiul Hoque. All rights reserved.
//

#import "PWCGraphData.h"

@implementation PWCGraphData
@synthesize xValues;
@synthesize yValues;
@synthesize totalVal;

static PWCGraphData* _getGraphData = nil;

+(PWCGraphData*)getGraphData
{
    @synchronized([PWCGraphData class])
    {
        if (!_getGraphData) {
            _getGraphData = [[self alloc] init];
        }
        return _getGraphData;
    }
    return nil;
}

+(id)alloc
{
    @synchronized([PWCGraphData class])
    {
        NSAssert(_getGraphData == nil, @"Attempted to allocate a second instance of a singleton.");
        _getGraphData = [super alloc];
        return _getGraphData;
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

- (NSArray *)graphXValues
{
    /*
    static NSArray *xVal = nil;
    
    if (!xVal) {
        xVal = [NSArray arrayWithObjects:
                   @"Jan", @"Feb", @"Mar", @"Apr",
                   @"May", @"Jun", @"Jul", @"Aug",
                   @"Sep", @"Oct", @"Nov", @"Dec",
                   nil];
    }
    
    return xVal;
    */
    return self.xValues;
}

- (NSArray *)graphYValues
{
    /*
    static NSArray *yVal = nil;
    
    if (!yVal) {
        yVal = [NSArray arrayWithObjects:
                   [NSDecimalNumber numberWithFloat:1097.60],
                   [NSDecimalNumber numberWithFloat:5680.27],
                   [NSDecimalNumber numberWithFloat:107.12],
                   [NSDecimalNumber numberWithFloat:7101.76],
                   [NSDecimalNumber numberWithFloat:311.07],
                   [NSDecimalNumber numberWithFloat:2174.66],
                   [NSDecimalNumber numberWithFloat:513.54],
                   [NSDecimalNumber numberWithFloat:229.70],
                   [NSDecimalNumber numberWithFloat:183.70],
                   [NSDecimalNumber numberWithFloat:3133.87],
                   [NSDecimalNumber numberWithFloat:9010.10],
                   [NSDecimalNumber numberWithFloat:7145.76],
                   nil];
    }
    
    return yVal;
    */
    return self.yValues;
}

- (float)totalValue
{
    /*
    float total = 0.0;
    
    for (NSDecimalNumber *num in [self graphYValues]) {
        total += [num floatValue];
    }
    */
    return self.totalVal;
}


@end
