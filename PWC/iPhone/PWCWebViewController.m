//
//  PWCWebViewController.m
//  PWC
//
//  Created by Samiul Hoque on 3/19/13.
//  Copyright (c) 2013 Premium Web Cart. All rights reserved.
//

#import "PWCWebViewController.h"
#import "PWCGlobal.h"
#import "SVProgressHUD.h"

@interface PWCWebViewController ()

@end

@implementation PWCWebViewController

@synthesize theWebView;
@synthesize webViewDidFinishLoadBool;
@synthesize loadFailedBool;
@synthesize theWebPageGoBack;
@synthesize theWebPageGoForward;
@synthesize webViewTitle;
@synthesize webViewUrl;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationItem.title = self.webViewTitle;
    NSURLRequest *request = [NSURLRequest requestWithURL:self.webViewUrl cachePolicy:NSURLCacheStorageAllowed timeoutInterval:30];
    [self.theWebView loadRequest:request];
    NSLog(@"Link: %@",self.webViewUrl);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.toolbarHidden = NO;
}

- (void)viewDidDisappear:(BOOL)animated
{
    self.navigationController.toolbarHidden = YES;
    [SVProgressHUD dismiss];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    webViewDidFinishLoadBool = NO;
    loadFailedBool = NO;
    [SVProgressHUD showWithStatus:@"Loading ..." maskType:SVProgressHUDMaskTypeNone];
    
    [self checkWebViewStatus];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    loadFailedBool = YES;
    [self checkWebViewStatus];
    [SVProgressHUD dismiss];
    
    NSString *msg = @"Cannot load the site now! Please try later!";
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error loading"
                                                    message:msg
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    if (!loadFailedBool) {
        webViewDidFinishLoadBool = YES;
    } else {
        NSString *msg = @"Cannot load the site now! Please try later!";
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error loading"
                                                        message:msg
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    [SVProgressHUD dismiss];
    [self checkWebViewStatus];
}

- (void)checkWebViewStatus
{
    if ([theWebView canGoBack]) {
        theWebPageGoBack.enabled = YES;
    } else {
        theWebPageGoBack.enabled = NO;
    }
    
    if ([theWebView canGoForward]) {
        theWebPageGoForward.enabled = YES;
    } else {
        theWebPageGoForward.enabled = NO;
    }
}

@end
