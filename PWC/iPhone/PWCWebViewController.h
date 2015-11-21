//
//  PWCWebViewController.h
//  PWC
//
//  Created by Samiul Hoque on 3/19/13.
//  Copyright (c) 2013 Premium Web Cart. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PWCWebViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIWebView *theWebView;
@property (nonatomic, assign) BOOL webViewDidFinishLoadBool;
@property (nonatomic, assign) BOOL loadFailedBool;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *theWebPageGoBack;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *theWebPageGoForward;
@property (strong, nonatomic) NSString *webViewTitle;
@property (strong, nonatomic) NSURL *webViewUrl;

- (void)checkWebViewStatus;

@end
