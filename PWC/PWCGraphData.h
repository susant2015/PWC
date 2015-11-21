//
//  PWCGraphData.h
//  PWC iPhone App
//
//  Created by Samiul Hoque on 9/26/12.
//  Copyright (c) 2012 Samiul Hoque. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PWCGraphData : NSObject {
    NSArray *xValues;
    NSArray *yValues;
    float totalVal;
}

@property (strong, nonatomic) NSArray *xValues;
@property (strong, nonatomic) NSArray *yValues;
@property (assign, nonatomic) float totalVal;

- (NSArray *)graphXValues;
- (NSArray *)graphYValues;
- (float)totalValue;
+(PWCGraphData*)getGraphData;

@end
