//
//  PWCCRMData.m
//  PWC
//
//  Created by Samiul Hoque on 7/9/13.
//  Copyright (c) 2013 Premium Web Cart. All rights reserved.
//

#import "PWCCRMData.h"

@implementation PWCCRMData

@synthesize salesPathData = _salesPathData;
@synthesize tagsData = _tagsData;

static PWCCRMData* _crm = nil;

+(PWCCRMData *)crm
{
    @synchronized([PWCCRMData class])
    {
        if (!_crm) {
            _crm = [[self alloc] init];
        }
        return _crm;
    }
    return nil;
}

+(id)alloc
{
    @synchronized([PWCCRMData class])
    {
        NSAssert(_crm == nil, @"Attempted to allocate a second instance of a singleton.");
        _crm = [super alloc];
        return _crm;
    }
    return nil;
}

-(id)init
{
    self = [super init];
    if (self != nil) {
        // initialize stuff here
        self.salesPathData = [self randomData:@"Funnel"];
        self.tagsData = [self randomData:@"Tag Type"];
    }
    return self;
}

- (NSArray *)randomData:(NSString *)type
{
    NSMutableArray *retArr = [[NSMutableArray alloc] init];
    NSString *last = nil;
    NSDictionary *dic = nil;
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    
    int i = 1;
    for (; i <= 30; i++) {
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",i], @"id", [self genRandStringLength:5], @"name", nil];
        NSString *section = nil;
        
        if (i < 4) {
            section = [NSString stringWithFormat:@"%@ 1", type];
        } else if (i < 10) {
            section = [NSString stringWithFormat:@"%@ 2", type];
        } else if (i < 12) {
            section = [NSString stringWithFormat:@"%@ 3", type];
        } else if (i < 17) {
            section = [NSString stringWithFormat:@"%@ 4", type];
        } else if (i < 20) {
            section = [NSString stringWithFormat:@"%@ 5", type];
        } else if (i < 21) {
            section = [NSString stringWithFormat:@"%@ 6", type];
        } else if (i < 24) {
            section = [NSString stringWithFormat:@"%@ 7", type];
        } else {
            section = [NSString stringWithFormat:@"%@ 8", type];
        }

        if (last == nil) {
            last = section;
            [temp addObject:dict];
        } else if ([last isEqualToString:section]) {
            [temp addObject:dict];
        } else {
            dic = [NSDictionary dictionaryWithObjectsAndKeys:temp, last, nil];
            [retArr addObject:dic];
            
            last = section;
            temp = [[NSMutableArray alloc] init];
            [temp addObject:dict];
        }
        //NSLog(@"%d", i);
    }
    
    if (i > 0) {
        dic = [NSDictionary dictionaryWithObjectsAndKeys:temp, last, nil];
        [retArr addObject:dic];
    }
    
    //NSLog(@"%@", retArr);
    return retArr;
}

-(NSString *) genRandStringLength: (int) len
{
    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    
    for (int i=0; i<len; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random() % [letters length]]];
    }
    
    return randomString;
}

@end
