//
//  PWCCRMData.h
//  PWC
//
//  Created by Samiul Hoque on 7/9/13.
//  Copyright (c) 2013 Premium Web Cart. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PWCCRMData : NSObject {
    NSArray *_salesPathData;
    NSArray *_tagsData;
}

@property (retain, nonatomic) NSArray *salesPathData;
@property (retain, nonatomic) NSArray *tagsData;

+ (PWCCRMData *)crm;

@end
