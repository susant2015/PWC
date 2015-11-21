//
//  PWCAppDelegate.m
//  PWC
//
//  Created by Samiul Hoque on 2/7/13.
//  Copyright (c) 2013 Premium Web Cart. All rights reserved.
//

#import "PWCAppDelegate.h"
#import "PWCGlobal.h"
#import <sqlite3.h>
#import "AFNetworking.h"
#import <objc/runtime.h>
#import "PWCDashboardViewController.h"
#import "NSData+Base64.h"

@implementation PWCAppDelegate

@synthesize devToken;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    //#warning MUST un-comment before run in device
	[[UIApplication sharedApplication] registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    
    if (launchOptions != nil) {
        NSDictionary *notifications = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        
        //for (id key in notifications) {
        //    NSLog(@"key: %@, value: %@", key, [notifications objectForKey:key]);
        //}
        
        NSDictionary *params = [notifications objectForKey:@"appData"];
        NSLog(@"params = %@", params);
        
        CGFloat width = [UIScreen mainScreen].currentMode.size.width;
        
        if (width == 320 || width == 640) {
            // its an iPhone/iPod
            
            UINavigationController *navCon = (UINavigationController *)self.window.rootViewController;
            [navCon popToViewController:[navCon.childViewControllers objectAtIndex:0] animated:NO];
            [SVProgressHUD  showWithStatus:@"Loading ..." maskType:SVProgressHUDMaskTypeBlack];
            
            if ([[params objectForKey:@"type"] isEqualToString:@"2"]) {
                [PWCGlobal getTheGlobal].notificationType = @"order";
                [PWCGlobal getTheGlobal].notificationParam = [params objectForKey:@"param"];
                [[navCon.childViewControllers objectAtIndex:0] doOrderProcessForPush];
            } else if ([[params objectForKey:@"type"] isEqualToString:@"7"]) {
                [PWCGlobal getTheGlobal].notificationType = @"schedule";
                [PWCGlobal getTheGlobal].notificationParam = [params objectForKey:@"param"];
                [[navCon.childViewControllers objectAtIndex:0] doBookingSummaryPush];
            }

        } else if (width == 768 || width == 1024 || width == 1536 || width == 2048) {
            // its an iPad/iPad Mini
            //UISplitViewController *splitView = (UISplitViewController *)self.window.rootViewController;
            //UINavigationController *nav = [splitView.childViewControllers objectAtIndex:0];
            
            //[PWCGlobal getTheGlobal].webViewTitle = [params objectForKey:@"type"];
            //[PWCGlobal getTheGlobal].webViewUrl = [params objectForKey:@"param"];
            
            //[[nav.childViewControllers objectAtIndex:0] performSegueWithIdentifier:@"" sender:self];
        }
        
        [self clearNotifications];
    }
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void) clearNotifications {
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 0];
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
	self.devToken = [[[[NSString stringWithFormat:@"%@",deviceToken] stringByReplacingOccurrencesOfString:@" " withString:@""] stringByReplacingOccurrencesOfString:@"<" withString:@""] stringByReplacingOccurrencesOfString:@">" withString:@""];
    
    SEL backSel = @selector(sendDeviceTokenInBackground);
    [self performSelectorInBackground:backSel withObject:self];
    //NSLog(@"%@",self.devToken);
}

- (void)sendDeviceTokenInBackground
{
    // SAVE IN DB
    [PWCGlobal getTheGlobal].deviceToken = self.devToken;
    
    // SEND TO SERVER
    NSURL *url = [NSURL URLWithString:@"http://www.secureinfossl.com"];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [httpClient setDefaultHeader:@"Accept" value:@"application/json"];
    
    NSString *path = [NSString stringWithFormat:@"/app/getAccess/%@/%@/%@", [PWCGlobal getTheGlobal].merchantId, @"devToken", [PWCGlobal getTheGlobal].hashKey];
    
    NSString *deviceTokenType = nil;
    
    CGFloat width = [UIScreen mainScreen].currentMode.size.width;
    
    if (width == 320 || width == 640) {
        deviceTokenType = @"deviceTokeniPhone";
    } else if (width == 768 || width == 1024 || width == 1536 || width == 2048) {
        deviceTokenType = @"deviceTokeniPad";
    }
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:self.devToken, deviceTokenType,nil];
    
    //NSLog(@"Send DevToken PATH: %@", path);
    
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST" path:path parameters:params];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                                            //NSLog(@"Success Send DevToken");
                                                                                            
                                                                                        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                                            //NSLog(@"Failure Send DevToken");
                                                                                            //NSLog(@"Request: %@",JSON);
                                                                                            
                                                                                        }];
    [operation start];
    [operation waitUntilFinished];
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
	//NSLog(@"Failed to get token, error: %@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    /*
     NSLog(@"didReceiveRemoteNotification");
     for (id key in userInfo) {
     NSLog(@"key: %@, value: %@", key, [userInfo objectForKey:key]);
     }
     */
    
    NSDictionary *params = [userInfo objectForKey:@"appData"];
    
    CGFloat width = [UIScreen mainScreen].currentMode.size.width;
    
    if (width == 320 || width == 640) {
        // its an iPhone/iPod
        
        UINavigationController *navCon = (UINavigationController *)self.window.rootViewController;
        [navCon popToViewController:[navCon.childViewControllers objectAtIndex:0] animated:NO];
        [SVProgressHUD  showWithStatus:@"Loading ..." maskType:SVProgressHUDMaskTypeBlack];
        
        if ([[params objectForKey:@"type"] isEqualToString:@"2"]) {
            [PWCGlobal getTheGlobal].notificationType = @"order";
            [PWCGlobal getTheGlobal].notificationParam = [params objectForKey:@"param"];
            [[navCon.childViewControllers objectAtIndex:0] doOrderProcessForPush];
        } else if ([[params objectForKey:@"type"] isEqualToString:@"7"]) {
            [PWCGlobal getTheGlobal].notificationType = @"schedule";
            [PWCGlobal getTheGlobal].notificationParam = [params objectForKey:@"param"];
            [[navCon.childViewControllers objectAtIndex:0] doBookingSummaryPush];
        }
    
    } else if (width == 768 || width == 1024 || width == 1536 || width == 2048) {
        // its an iPad/iPad Mini
        //UISplitViewController *splitView = (UISplitViewController *)self.window.rootViewController;
        //UINavigationController *nav = [splitView.childViewControllers objectAtIndex:0];
        
        //[PWCGlobal getTheGlobal].webViewTitle = [params objectForKey:@"type"];
        //[PWCGlobal getTheGlobal].webViewUrl = [params objectForKey:@"param"];
        
        //[[nav.childViewControllers objectAtIndex:0] performSegueWithIdentifier:@"" sender:self];
    }
    
    [self clearNotifications];
}

//=================================================================================================================================
+(PWCAppDelegate*) getDelegate
{
	return (PWCAppDelegate*) [[UIApplication sharedApplication] delegate];
}

//=================================================================================================================================
-(void) showMessage: (NSString*) strMessage
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle: nil
                                                    message: strMessage
                                                   delegate: self
                                          cancelButtonTitle: @"Ok"
                                          otherButtonTitles: nil, nil];
    [alert show];
}

//=================================================================================================================================
-(NSString*) decodeBase64String: (NSString*) strBase
{
    NSData* data = [NSData dataFromBase64String: strBase];
    NSString* strRealProfileName = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
    
    return strRealProfileName;
}

//=================================================================================================================================
- (BOOL) isIPad
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return YES;
    }
    return NO;
}

//=================================================================================================================================
- (BOOL) isIPhone4
{
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        if (screenSize.height > 480.0f) {
            
        }
        else{
            return YES;
        }
    }

    return NO;
}

//=================================================================================================================================
- (BOOL) isIPhone5
{
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        if (screenSize.height > 480.0f)
        {
            return YES;
        }
    }
    
    return NO;
}

//=================================================================================================================================
@end
