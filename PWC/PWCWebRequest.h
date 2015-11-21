//
//  PWCWebRequest.h
//  PWC iPhone App
//
//  Created by Samiul Hoque on 9/6/12.
//  Copyright (c) 2012 Samiul Hoque. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PWCWebRequest : NSObject

//@property (strong, nonatomic) NSString *APIKey;
@property (strong, nonatomic) NSString *requestURL;

- (void)validateLogin:(NSString *)emailAddress userPassword:(NSString *)password;

@end
