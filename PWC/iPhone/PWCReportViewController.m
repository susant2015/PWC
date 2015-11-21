//
//  PWCReportViewController.m
//  PWC
//
//  Created by Samiul Hoque on 3/14/13.
//  Copyright (c) 2013 Premium Web Cart. All rights reserved.
//

#import "PWCReportViewController.h"
#import "PWCReportFormData.h"
#import "PWCGraphData.h"
#import "PWCGlobal.h"
#import "PWCGraphViewController.h"
#import "AFNetworking.h"

@interface PWCReportViewController ()

@end

@implementation PWCReportViewController

@synthesize reportDays;

// dropdowns
@synthesize secondDropdown;
@synthesize thirdDropdown;
@synthesize fourthDropdown;

// array to populate actionsheet
@synthesize selectionButton;

// arrays for each dropdowns
@synthesize secondDropdownList;
@synthesize thirdDropdownList;
@synthesize fourthDropdownList;

// tag to trac current button
@synthesize currentButtonTag;

// selected values
@synthesize categoryValue;
@synthesize productValue;
@synthesize affiliateValue;


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
    
    if ([reportDays isEqualToString:@"today"]) {
        self.navigationItem.title = @"Today's Sales Report";
    } else {
        self.navigationItem.title = @"7 Days Sales Report";
    }
    
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    
    int i = 0;
    for (NSDictionary *dct in [PWCReportFormData getReportFormData].categoryList) {
        if (i == 0) {
            self.categoryValue = [dct objectForKey:@"value"];
            [self.secondDropdown setTitle:[dct objectForKey:@"name"] forState:UIControlStateNormal];
        }
        i++;
        NSString *val = [dct objectForKey:@"name"];
        [tempArray addObject:val];
    }
    self.secondDropdownList = tempArray;

    // Third Item
    tempArray = nil;
    tempArray = [[NSMutableArray alloc] init];
    
    i = 0;
    for (NSDictionary *dct in [PWCReportFormData getReportFormData].productList) {
        if (i == 0) {
            self.productValue = [dct objectForKey:@"value"];
            [self.thirdDropdown setTitle:[dct objectForKey:@"name"] forState:UIControlStateNormal];
        }
        i++;
        NSString *val = [dct objectForKey:@"name"];
        [tempArray addObject:val];
    }
    self.thirdDropdownList = tempArray;
    
    // Fourth Item
    tempArray = nil;
    tempArray = [[NSMutableArray alloc] init];
    
    i = 0;
    for (NSDictionary *dct in [PWCReportFormData getReportFormData].affiliateList) {
        if (i == 0) {
            self.affiliateValue = [dct objectForKey:@"value"];
            [self.fourthDropdown setTitle:[dct objectForKey:@"name"] forState:UIControlStateNormal];
        }
        i++;
        NSString *val = [dct objectForKey:@"name"];
        [tempArray addObject:val];
    }
    self.fourthDropdownList = tempArray;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)viewSelection:(id)sender {
    currentButtonTag = [(UIButton *)sender tag];
    NSString *title = [[NSString alloc] init];
    
    if (currentButtonTag == 111) {
        // Category
        selectionButton = secondDropdownList;
        title = @"Select Category";
    } else if (currentButtonTag == 112) {
        // Product
        selectionButton = thirdDropdownList;
        title = @"Select Product";
    } else if (currentButtonTag == 113) {
        // Affiliate
        selectionButton = fourthDropdownList;
        title = @"Select Affiliate";
    }
    
    UIActionSheet *sheet = [[UIActionSheet alloc]
                            initWithTitle:title
                            delegate:self
                            cancelButtonTitle:nil
                            destructiveButtonTitle:nil
                            otherButtonTitles:nil];
    
    for (NSString *item in selectionButton) {
        [sheet addButtonWithTitle:item];
    }
    
    [sheet addButtonWithTitle:@"Cancel"];
	// Set cancel button index to the one we just added so that we know which one it is in delegate call
	// NB - This also causes this button to be shown with a black background
	sheet.cancelButtonIndex = sheet.numberOfButtons - 1;
    
    //[sheet showInView:self.view];
    [sheet showInView:[UIApplication sharedApplication].keyWindow];
	//[sheet showFromTabBar:self.parentViewController.tabBarController.tabBar];
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == actionSheet.cancelButtonIndex) { return; }
	
    UIButton *clickedButton = (UIButton *)[self.view viewWithTag:currentButtonTag];
    //clickedButton.titleLabel.text = [selectionButton objectAtIndex:buttonIndex];
    [clickedButton setTitle:[selectionButton objectAtIndex:buttonIndex] forState:UIControlStateNormal];
    
    // get the values for selected button
    if (currentButtonTag == 111) {
        NSDictionary *dct = [[PWCReportFormData getReportFormData].categoryList objectAtIndex:buttonIndex];
        categoryValue = [dct objectForKey:@"value"];
    }
    
    if (currentButtonTag == 112) {
        NSArray *temp = [PWCReportFormData getReportFormData].productList;
        NSDictionary *dct = [temp objectAtIndex:buttonIndex];
        productValue = [dct objectForKey:@"value"];
    }
    
    if (currentButtonTag == 113) {
        NSArray *temp = [PWCReportFormData getReportFormData].affiliateList;
        NSDictionary *dct = [temp objectAtIndex:buttonIndex];
        affiliateValue = [dct objectForKey:@"value"];
    }
}

- (IBAction)showReport:(id)sender
{
    [SVProgressHUD showWithStatus:@"Loading ..." maskType:SVProgressHUDMaskTypeBlack];
    
    SEL aSelector = @selector(processRequest);
    [self performSelectorInBackground:aSelector withObject:self];
}

- (void)processRequest
{
    // do all the work
    NSString *reqUrl = @"http://www.secureinfossl.com";
    //NSLog(@"%@",reqUrl);
    NSURL *url = [NSURL URLWithString:reqUrl];
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [httpClient setDefaultHeader:@"Accept" value:@"application/json"];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            categoryValue, @"cid",
                            productValue, @"pid",
                            affiliateValue, @"affid",
                            nil];
    
    //NSLog(@"PARAM: %@", params);
    NSString *path = [NSString stringWithFormat:@"/app/getAccess/%@/salesreport%@/%@",[PWCGlobal getTheGlobal].merchantId, self.reportDays, [PWCGlobal getTheGlobal].hashKey];
    
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST" path:path parameters:params];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                                            //NSLog(@"Success");
                                                                                            //NSLog(@"DATA: %@", JSON);
                                                                                            //NSLog(@"Response: %@", response);
                                                                                            
                                                                                            float tVal = [[JSON objectForKey:@"totalsales"] floatValue];
                                                                                            
                                                                                            if (tVal == 0) {
                                                                                                [SVProgressHUD dismiss];
                                                                                                [SVProgressHUD showSuccessWithStatus:@"No Data found."];
                                                                                            } else {
                                                                                                //NSLog(@"%@",jsonData);
                                                                                                NSArray *result = [JSON objectForKey:@"saleslist"];
                                                                                                //NSLog(@"%@",result);
                                                                                                
                                                                                                NSMutableArray *xV = [[NSMutableArray alloc] init];
                                                                                                NSMutableArray *yV = [[NSMutableArray alloc] init];
                                                                                                
                                                                                                for (NSDictionary *obj in result) {
                                                                                                    NSString *strX = [obj objectForKey:@"day"];
                                                                                                    NSString *strY = [obj objectForKey:@"value"];
                                                                                                    [xV addObject:strX];
                                                                                                    [yV addObject:[NSDecimalNumber numberWithFloat:[strY floatValue]]];
                                                                                                }
                                                                                                
                                                                                                [PWCGraphData getGraphData].xValues = xV;
                                                                                                [PWCGraphData getGraphData].yValues = yV;
                                                                                                [PWCGraphData getGraphData].totalVal = tVal;
                                                                                                
                                                                                                // perform segue
                                                                                                [self performSegueWithIdentifier:@"viewGraph" sender:self];
                                                                                            }
                                                                                            
                                                                                        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                                            //NSLog(@"Failure");
                                                                                            [SVProgressHUD dismiss];
                                                                                            [SVProgressHUD showSuccessWithStatus:@"No Data found."];
                                                                                        }];
    [operation start];
    [operation waitUntilFinished];
    /*
    ASIFormDataRequest *asirequest = [ASIFormDataRequest requestWithURL:url];
    //[asirequest setRequestMethod:@"POST"];
    [asirequest setPostValue:categoryValue forKey:@"cid"];
    [asirequest setPostValue:productValue forKey:@"pid"];
    [asirequest setPostValue:affiliateValue forKey:@"affid"];
    [asirequest setPostValue:numberOfAffiliateValue forKey:@"numaff"];
    [asirequest setDelegate:self];
    [asirequest startSynchronous];
     */
    
    /*
    //NSLog(@"%@",asirequest);
    NSString *resString = [asirequest responseString];
    //NSLog(@"%@",resString);
    
    SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
    NSDictionary *jsonData = [jsonParser objectWithString:resString error:nil];
    
    float tVal = [[jsonData objectForKey:@"totalsales"] floatValue];
    if (tVal == 0) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showSuccessWithStatus:@"No Data found."];
    } else {
        //NSLog(@"%@",jsonData);
        NSArray *result = [jsonData objectForKey:@"saleslist"];
        //NSLog(@"%@",result);
        
        NSMutableArray *xV = [[NSMutableArray alloc] init];
        NSMutableArray *yV = [[NSMutableArray alloc] init];
        
        for (NSDictionary *obj in result) {
            NSString *strX = [obj objectForKey:@"day"];
            NSString *strY = [obj objectForKey:@"value"];
            [xV addObject:strX];
            [yV addObject:[NSDecimalNumber numberWithFloat:[strY floatValue]]];
        }
        
        [PWCGraphData getGraphData].xValues = xV;
        [PWCGraphData getGraphData].yValues = yV;
        [PWCGraphData getGraphData].totalVal = tVal;
        
        // perform segue
        [self performSegueWithIdentifier:@"viewGraph" sender:self];
    }
     */
    //[SVProgressHUD dismiss];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    PWCGraphViewController *dest = segue.destinationViewController;
    dest.graphViewTitle = self.navigationItem.title;
    
    [SVProgressHUD dismiss];
}

@end
