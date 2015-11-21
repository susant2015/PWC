//
//  PWCiPhoneMainViewController.m
//  PWC
//
//  Created by Samiul Hoque on 2/11/13.
//  Copyright (c) 2013 Premium Web Cart. All rights reserved.
//

#import "PWCiPhoneMainViewController.h"
#import "PWCGlobal.h"
#import "PWCWebRequest.h"
#import "UIImage+imageWithColor.h"
#import "PWCDashboardViewController.h"

@interface PWCiPhoneMainViewController ()

@end

@implementation PWCiPhoneMainViewController

//==============================================================================================================
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

//==============================================================================================================
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [[PWCGlobal getTheGlobal] copyDatabaseIfNeeded];
    
    [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:48.0/255.0 green:77.0/255.0 blue:132.0/255.0 alpha:1.0]];
    [[UISearchBar appearance] setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:48.0/255.0 green:77.0/255.0 blue:132.0/255.0 alpha:1.0]]];
    [[UIToolbar appearance] setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:48.0/255.0 green:77.0/255.0 blue:132.0/255.0 alpha:1.0]] forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *email = [defaults objectForKey:kEmailKey];
    NSString *password = [defaults objectForKey:kPasswordKey];
    
    //NSLog(@"BEFORE MAIN CHECK: %@", [PWCGlobal getTheGlobal].merchantId);
    
    // TODO: Check the email/password
    PWCWebRequest *pwc = [[PWCWebRequest alloc] init];
    [pwc validateLogin:email userPassword:password];
    
    PWCDashboardViewController* nextView = [[PWCDashboardViewController alloc] initWithNibName: @"PWCDashboardViewController" bundle: nil];
    [self setViewControllers: @[nextView] animated: YES];
}

//==============================================================================================================
- (void)viewDidAppear:(BOOL)animated
{
    NSLog(@"ROOT CONTROLLER APPEARED");
    if (![PWCGlobal getTheGlobal].isAuthenticated) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
        UIViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"loginScreen"];
        
        //NSLog(@"login push: %@", loginViewController);
        [self presentViewController:loginViewController animated:YES completion:nil];
        //NSLog(@"done push");
    }
}

//==============================================================================================================
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//==============================================================================================================
@end
