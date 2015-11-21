//
//  PWCReportFormData.h
//  PWC iPhone App
//
//  Created by Samiul Hoque on 10/10/12.
//  Copyright (c) 2012 Samiul Hoque. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PWCReportFormData : NSObject {
    NSArray *categoryList;
    NSArray *productList;
    NSArray *affiliateList;
}

@property (strong, nonatomic) NSArray *categoryList;
@property (strong, nonatomic) NSArray *productList;
@property (strong, nonatomic) NSArray *affiliateList;

- (void)resetData;
+(PWCReportFormData*)getReportFormData;

@end
