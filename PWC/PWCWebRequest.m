//
//  PWCWebRequest.m
//  PWC iPhone App
//
//  Created by Samiul Hoque on 9/6/12.
//  Copyright (c) 2012 Samiul Hoque. All rights reserved.
//

#import "PWCWebRequest.h"
#import "AFNetworking.h"
#import "PWCGlobal.h"
//#import "PWCAppDelegate.h"

@implementation PWCWebRequest

//@synthesize APIKey;
@synthesize requestURL;

- (id)init
{
    self = [super init];
    
    //self.APIKey = @"A3NdT43yDiH4hGzXy89her38aAfGd458=";
    self.requestURL = @"https://www.secureinfossl.com/api/authenticateiPhoneApp.html";
    
    return self;
}

- (void)validateLogin:(NSString *)emailAddress userPassword:(NSString *)password
{
    //[PWCGlobal getTheGlobal].firstLoad = NO;
    NSCharacterSet *set = [NSCharacterSet URLQueryAllowedCharacterSet];
    NSString *strEmailaddress= [emailAddress stringByAddingPercentEncodingWithAllowedCharacters:set];
    NSString *strPassword = [password stringByAddingPercentEncodingWithAllowedCharacters:set];

    NSURL *url = [NSURL URLWithString:self.requestURL];
    NSString *path = @"/api/authenticateiPhoneApp.html";
    
    /*NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL coachLogin = [[defaults objectForKey:@"coachLogin"] boolValue];
    
    if (coachLogin) {
        url = [NSURL URLWithString:@"http://www.secureinfossl.com"];
        path = @"/scheduleapi/authenticateGymApp";
    }*/
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [httpClient setDefaultHeader:@"Accept" value:@"application/json"];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            [PWCGlobal getTheGlobal].applicationApiKey, @"apikey",
                            strEmailaddress, @"email",
                            strPassword, @"password",
                            @"json", @"return",
                            nil];
    
    NSLog(@"PATH: %@", path);
    
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST" path:path parameters:params];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                                            //NSLog(@"Success");
                                                                                            NSLog(@"DATA: %@", JSON);
                                                                                            NSLog(@"Response: %@", response);
                                                                                            
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
                                                                                                
                                                                                                if ([[PWCGlobal getTheGlobal].currencySymbol length] < 1 || [PWCGlobal getTheGlobal].currencySymbol == nil) {
                                                                                                    [PWCGlobal getTheGlobal].currencySymbol = @"$";
                                                                                                }
                                                                                            } else {
                                                                                                [PWCGlobal getTheGlobal].isAuthenticated = NO;
                                                                                                [PWCGlobal getTheGlobal].errorCode = [[JSON objectForKey:@"errorcode"] intValue];
                                                                                                [PWCGlobal getTheGlobal].errorText = [JSON objectForKey:@"errortext"];
                                                                                            }

                                                                                        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                                            NSLog(@"Failure");
                                                                                            NSLog(@"Request: %@",JSON);
                                                                                            [PWCGlobal getTheGlobal].isAuthenticated = NO;
                                                                                            [PWCGlobal getTheGlobal].errorCode = 0;
                                                                                            [PWCGlobal getTheGlobal].errorText = @"Error in network connection. Please try later.";
                                                                                        }];
    [operation start];
    [operation waitUntilFinished];
    
    /*
    
    ASIFormDataRequest *asirequest = [ASIFormDataRequest requestWithURL:url];
    [asirequest setPostValue:[PWCGlobal getTheGlobal].applicationApiKey forKey:@"apikey"];
    [asirequest setPostValue:[emailAddress stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"email"];
    [asirequest setPostValue:[password stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"password"];
    [asirequest setPostValue:@"json" forKey:@"return"];
    [asirequest setTimeOutSeconds:40];
    [asirequest setDelegate:self];
    [asirequest startSynchronous];

    NSString *responseString = [asirequest responseString];
    
    // Unsuccessful:
    // {"result":0,"errorcode":"2004","errortext":"Required field is missing (Password)"}
    
    // Successful:
    // {"result":1, "status":"Approved", "merchantid":"MER-00002", "firstname":"Alauddin", "lastname":"Husain", "company":"Premium Web Cart", "email":"alauddin@pwcart.com", "packageid":"23", "subscriptiontype":"1"}
    
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSDictionary *jsonObject = [parser objectWithString:responseString error:NULL];
    int result = [[jsonObject objectForKey:@"result"] intValue];
    
    if (result == 1) {
        [PWCGlobal getTheGlobal].isAuthenticated = YES;
        [PWCGlobal getTheGlobal].status = [jsonObject objectForKey:@"status"];
        [PWCGlobal getTheGlobal].merchantId = [jsonObject objectForKey:@"merchantid"];
        [PWCGlobal getTheGlobal].firstName = [jsonObject objectForKey:@"firstname"];
        [PWCGlobal getTheGlobal].lastName = [jsonObject objectForKey:@"lastname"];
        [PWCGlobal getTheGlobal].company = [jsonObject objectForKey:@"company"];
        [PWCGlobal getTheGlobal].email = [jsonObject objectForKey:@"email"];
        [PWCGlobal getTheGlobal].packageId = [[jsonObject objectForKey:@"packageid"] intValue];
        [PWCGlobal getTheGlobal].subscriptionType = [[jsonObject objectForKey:@"subscriptiontype"] intValue];
//#warning incomplete
        [PWCGlobal getTheGlobal].hashKey = [jsonObject objectForKey:@"hashkey"];
    } else {
        [PWCGlobal getTheGlobal].isAuthenticated = NO;
        [PWCGlobal getTheGlobal].errorCode = [[jsonObject objectForKey:@"errorcode"] intValue];
        [PWCGlobal getTheGlobal].errorText = [jsonObject objectForKey:@"errortext"];
    }
     */
}

@end
