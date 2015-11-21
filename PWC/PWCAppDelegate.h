//
//  PWCAppDelegate.h
//  PWC
//
//  Created by Samiul Hoque on 2/7/13.
//  Copyright (c) 2013 Premium Web Cart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PWCGlobal.h"

@interface PWCAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain) NSString *devToken;

-(void) showMessage: (NSString*) strMessage;
+(PWCAppDelegate*) getDelegate;
-(NSString*) decodeBase64String: (NSString*) strBase;
- (BOOL) isIPad;
- (BOOL) isIPhone4;
- (BOOL) isIPhone5;
@end
