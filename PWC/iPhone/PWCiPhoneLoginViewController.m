//
//  PWCiPhoneLoginViewController.m
//  PWC
//
//  Created by Samiul Hoque on 2/11/13.
//  Copyright (c) 2013 Premium Web Cart. All rights reserved.
//

#import "PWCiPhoneLoginViewController.h"
#import "PWCGlobal.h"
//#import "PWCWebRequest.h"
#import "AFNetworking.h"
#import "PWCDashboardViewController.h"
#import "PWCiPhoneMainViewController.h"
#import "PWCAppDelegate.h"

@interface PWCiPhoneLoginViewController (){
    IBOutlet UITextField *txtEmail;
    IBOutlet UITextField *txtPassword;
}

@end

@implementation PWCiPhoneLoginViewController


@synthesize emailValue;
@synthesize passValue;

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
    
    CGFloat height = [UIScreen mainScreen].currentMode.size.height;
    UIColor *background = nil;
    
    if ( height == 1136 )
    {
        // iPhone 5
        UIImage *tmpImage = [UIImage imageNamed:@"LoginBackground-568h@2x.png"];
        UIImage *backgroundImage = [UIImage imageWithCGImage:[tmpImage CGImage]
                                                       scale:2.0
                                                 orientation:UIImageOrientationUp];
        background = [[UIColor alloc] initWithPatternImage:backgroundImage];
        //NSLog(@"1136");
    }
    else if (height == 960)
    {
        // iPhone 4, 4S
        UIImage *tmpImage = [UIImage imageNamed:@"LoginBackground@2x.png"];
        UIImage *backgroundImage = [UIImage imageWithCGImage:[tmpImage CGImage]
                                                       scale:2.0
                                                 orientation:UIImageOrientationUp];
        background = [[UIColor alloc] initWithPatternImage:backgroundImage];
        //NSLog(@"960");
    }
    else if (height == 480)
    {
        // iPhone 3GS, 3G
        background = [[UIColor alloc] initWithPatternImage:
                      [UIImage imageNamed:@"LoginBackground.png"]];
        //NSLog(@"480");
    }
    
    self.view.backgroundColor = background;
    
    /*NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL coachLogin = [[defaults objectForKey:kCoachLogin] boolValue];
    [self.coachLoginSwitch setOn:coachLogin animated:YES];*/
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidDisappear:(BOOL)animated
{
    [self.presentingViewController viewDidAppear:animated];
}

/*- (IBAction)changeCoachLogin:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (self.coachLoginSwitch.isOn) {
        [defaults setBool:YES forKey:kCoachLogin];
    } else {
        [defaults setBool:NO forKey:kCoachLogin];
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}
*/
- (IBAction)textFieldDoneEditing:(id)sender
{
    [sender resignFirstResponder];
}

- (IBAction)backgroundTap:(id)sender
{
    [txtEmail resignFirstResponder];
    [txtPassword resignFirstResponder];
}

- (IBAction)nextTextField:(id)sender
{
    [txtEmail resignFirstResponder];
    [txtPassword becomeFirstResponder];
}

- (IBAction)forgotPassword:(id)sender
{
    NSURL *url = [NSURL URLWithString:@"https://www.secureinfossl.com/signup/showRetrievePassword.html"];
    
    if (![[UIApplication sharedApplication] openURL:url]) {
        NSString *msg = @"Cannot load the site now! Please try later!";
        [self showAlertWithTitle:nil andMessage:msg];
    }
}

- (IBAction)signUp:(id)sender
{
    NSURL *url = [NSURL URLWithString:@"http://www.premiumwebcart.com/try-it-today.html"];
    NSLog(@"The Url is:%@",url);
    if (![[UIApplication sharedApplication] openURL:url]) {
        NSString *msg = @"Cannot load the site now! Please try later!";
        
        [self showAlertWithTitle:nil andMessage:msg];
        
    }
}

#pragma mark
#pragma mark Login
#pragma mark

- (IBAction)processLogin:(id)sender
{
    [SVProgressHUD showWithStatus:@"Please wait ..." maskType:SVProgressHUDMaskTypeBlack];
    
    SEL backSel = @selector(doProcess);
    
    [self backgroundTap:self];
    [self performSelectorInBackground:backSel withObject:self];
    //[self doProcess];
}

- (void)doProcess
{
    NSCharacterSet *set = [NSCharacterSet URLQueryAllowedCharacterSet];
    self.emailValue = [txtEmail.text stringByAddingPercentEncodingWithAllowedCharacters:set];
    self.passValue = [txtPassword.text stringByAddingPercentEncodingWithAllowedCharacters:set];
    
    //NSLog(@"Email: %@ | Password: %@", emailValue, passValue);
    
    NSURL *url = [NSURL URLWithString:[PWCGlobal getTheGlobal].loginUrl];
    NSString *path = @"/api/authenticateiPhoneApp.html";
    
    /*if (self.coachLoginSwitch.isOn) {
        url = [NSURL URLWithString:@"https://www.secureinfossl.com"];
        path = @"/scheduleapi/authenticateGymApp";
    }*/
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [httpClient setDefaultHeader:@"Accept" value:@"application/json"];

    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            [PWCGlobal getTheGlobal].applicationApiKey, @"apikey",
                            self.emailValue, @"email",
                            self.passValue, @"password",
                                @"json", @"return",
                            nil];
    NSLog(@"Param %@", params);
    
    NSLog(@"PATH: %@", path);
    
    
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST" path:path parameters:params];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON)
    {
                //NSLog(@"Success");
                NSLog(@"DATA: %@", JSON);
                //NSLog(@"Response: %@", response);
                
                int result = [[JSON objectForKey:@"result"] intValue];
                
                if (result == 1) {
                    [PWCGlobal getTheGlobal].isAuthenticated = YES;
                    [PWCGlobal getTheGlobal].account_id = [JSON objectForKey: @"account_id"];
                    [PWCGlobal getTheGlobal].status = [JSON objectForKey:@"status"];
                    [PWCGlobal getTheGlobal].merchantId = [JSON objectForKey:@"merchantid"];
                    [PWCGlobal getTheGlobal].firstName = [JSON objectForKey:@"firstname"];
                    [PWCGlobal getTheGlobal].lastName = [JSON objectForKey:@"lastname"];
                    [PWCGlobal getTheGlobal].company = [JSON objectForKey:@"company"];
                    [PWCGlobal getTheGlobal].email = [JSON objectForKey:@"email"];
                    [PWCGlobal getTheGlobal].packageId = [[JSON objectForKey:@"packageid"] intValue];
                    [PWCGlobal getTheGlobal].subscriptionType = [[JSON objectForKey:@"subscriptiontype"] intValue];
                    //#warning incomplete
                    [PWCGlobal getTheGlobal].hashKey = [JSON objectForKey:@"hashkey"];
                    [PWCGlobal getTheGlobal].userHash = [JSON objectForKey:@"userhash"];
                    [PWCGlobal getTheGlobal].userType = [JSON objectForKey:@"usertype"];
                    [PWCGlobal getTheGlobal].userLevel = [JSON objectForKey:@"userlevel"];
                    
                    if ([JSON objectForKey:@"coach_row_id"] != nil) {
                        [PWCGlobal getTheGlobal].coachRowId = [JSON objectForKey:@"coach_row_id"];
                    }
                } else {
                    [PWCGlobal getTheGlobal].isAuthenticated = NO;
                    [PWCGlobal getTheGlobal].errorCode = [[JSON objectForKey:@"errorcode"] intValue];
                    [PWCGlobal getTheGlobal].errorText = [JSON objectForKey:@"errortext"];
                    
                }
                
                if ([PWCGlobal getTheGlobal].isAuthenticated) {
                    // SUCCESS
                    [SVProgressHUD dismiss];
                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                    [defaults setValue:self.emailValue forKey:kEmailKey];
                    [defaults setValue:self.passValue forKey:kPasswordKey];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
                } else {
                    // ERROR
                    [SVProgressHUD dismissWithError:[[PWCGlobal getTheGlobal] errorMessage] afterDelay:3.0];
                }
        
            } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                //NSLog(@"Failure");
                //NSLog(@"Request: %@",JSON);
                [PWCGlobal getTheGlobal].isAuthenticated = NO;
                [PWCGlobal getTheGlobal].errorCode = 0;
                [PWCGlobal getTheGlobal].errorText = @"Error in network connection. Please try later.";
                [SVProgressHUD dismissWithError:[[PWCGlobal getTheGlobal] errorMessage] afterDelay:3.0];
            }];
    [operation start];
    [operation waitUntilFinished];
    
    }

@end
