//
//  PWCPendingQueneViewController.m
//  PWC
//
//  Created by JianJinHu on 7/30/13.
//  Copyright (c) 2013 Premium Web Cart. All rights reserved.
//

#import "PWCPendingQueneViewController.h"
#import "PWCGlobal.h"
#import "PWCCRMGlobal.h"
#import "PWCAppDelegate.h"
#import "ASIFormDataRequest.h"
#import "JSON.h"
#import "DataManager.h"

@interface PWCPendingQueneViewController ()

@end

@implementation PWCPendingQueneViewController

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
    [self initMember];
}

//==============================================================================================================
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//==============================================================================================================
-(void) initMember
{
    m_arrInfo = [[NSMutableArray alloc] init];
    NSArray* arr = [[DataManager sharedScoreManager] getAllBroadcasts];
    if(arr == nil || [arr count] <= 0)
    {
        [self getPendingQuene];
    }
    else
    {
        for(int i = 0; i < [arr count]; i++)
        {
            [m_arrInfo addObject: [arr objectAtIndex: i]];
        }
    }
    
    
    [self updateContent];
}

//==============================================================================================================
-(void) updateContent
{
    for(UIView* view in m_scrollView.subviews)
    {
        [view removeFromSuperview];
    }
    
    PWCPendingQueneCellView* cell = [[PWCPendingQueneCellView alloc] initWithFrame: CGRectMake(0, 0, 320, 40)];
    [cell createTitleCell];
    [m_scrollView addSubview: cell];
    
    
    float fy = 40;
    for(int i = 0; i < [m_arrInfo count]; i++)
    {
        NSDictionary* dicRecord = [m_arrInfo objectAtIndex: i];
        NSString* strSubject = [dicRecord objectForKey: @"broadcast_subject"];
        NSString* strType = [dicRecord objectForKey: @"type"];
        NSString* strDate = [dicRecord objectForKey: @"broadcast_date"];
        int nBroadcastID = [[dicRecord objectForKey: @"broadcast_id"] intValue];
        
        PWCPendingQueneCellView* cell = [[PWCPendingQueneCellView alloc] initWithFrame: CGRectMake(0, fy, 320, 50)];
        [cell createInfo: nBroadcastID subject: strSubject date: strDate type: strType];
        
        cell.delegate = self;
        [m_scrollView addSubview: cell];
        
        fy += 50;
    }
    
    [m_scrollView setContentSize: CGSizeMake(m_scrollView.contentSize.width, fy)];
}

//==============================================================================================================
-(void) getPendingQuene
{
    NSString* strURL = [[NSString stringWithFormat: @"%@pendingqueue/%@/%@", SERVER_PENDNG_BASE_URL, [PWCGlobal getTheGlobal].merchantId, [PWCGlobal getTheGlobal].userHash] stringByAddingPercentEscapesUsingEncoding: NSASCIIStringEncoding];
    NSLog(@"pending = %@", strURL);
    
    [self fetchJSON: strURL index: GET_PENDING_QUENE];
}

//==============================================================================================================
-(void) updatePendingQuene: (NSDictionary*) json
{
    [[DataManager sharedScoreManager] deleteAllBroadcasts];
    [m_arrInfo removeAllObjects];
    
    NSArray* arrBroadCast = [json objectForKey: @"broadcast"];
    for(int i = 0; i < [arrBroadCast count]; i++)
    {
        NSDictionary* dicRecord = [arrBroadCast objectAtIndex: i];
        NSString* strSubject = [dicRecord objectForKey: @"broadcast_subject"];
        NSString* strType = [dicRecord objectForKey: @"type"];
        NSString* strDate = [dicRecord objectForKey: @"broadcast_date"];
        int nBroadcastID = [[dicRecord objectForKey: @"broadcast_id"] intValue];
        
        [[DataManager sharedScoreManager] insertBroadcast: nBroadcastID
                                                     type: strType
                                           broadcast_date: strDate
                                        broadcast_subject: strSubject];
    }
    
    NSArray* arr = [[DataManager sharedScoreManager] getAllBroadcasts];
    if(arr == nil) return;
    for(int i = 0; i < [arr count]; i++)
    {
        [m_arrInfo addObject: [arr objectAtIndex: i]];
    }
    
    [self updateContent];
}

//==============================================================================================================
-(void) didSendClickAtIndex:(int)broadcast_id type:(NSString *)type
{
    [SVProgressHUD showWithStatus:@"Loading ..." maskType:SVProgressHUDMaskTypeBlack];
    NSString* strURL = [NSString stringWithFormat: @"%@sendqueue", SERVER_PENDNG_BASE_URL];
    NSLog(@"strURL = %@", strURL);
    NSLog(@"broadcast_id = %d", broadcast_id);
    NSLog(@"type = %@", type);
    
    ASIFormDataRequest* request = [ASIFormDataRequest requestWithURL: [NSURL URLWithString: strURL]];
    [request setDelegate: self];
    [request setTimeOutSeconds: REQUEST_TIME_OUT];    
    [request setPostValue: [NSString stringWithFormat: @"%d", broadcast_id] forKey: @"broadcast_id"];
    [request setPostValue: type forKey: @"type"];
    [request setDidFinishSelector: @selector(finishedSendNotification:)];
    [request setDidFailSelector: @selector(failedRequest:)];
    [request startAsynchronous];
}

//==============================================================================================================
-(void) finishedSendNotification: (ASIFormDataRequest*) theRequest
{
    [SVProgressHUD showSuccessWithStatus:@"Syncing successful."];
    NSString* strResponse = [theRequest responseString];
    NSDictionary* dic = [strResponse JSONValue];
    NSLog(@"Result = %@", dic);
    
    [self.navigationController popViewControllerAnimated: YES];
}

//==============================================================================================================
-(void) failedRequest: (ASIFormDataRequest*) theRequest
{
    [SVProgressHUD showSuccessWithStatus:@"Syncing Failed."];
}


#pragma mark -
#pragma mark Update

//==============================================================================================================
-(void)fetchJSON: (NSString*) strURL index: (int) nIndex
{
    [SVProgressHUD showWithStatus:@"Loading ..." maskType:SVProgressHUDMaskTypeBlack];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData* kivaData = [NSData dataWithContentsOfURL:
                            [NSURL URLWithString:strURL]
                            ];
        NSArray* json = nil;
        if (kivaData)
        {
            json = [NSJSONSerialization JSONObjectWithData:kivaData options:kNilOptions error:nil];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self updateUIWithDictionary: (NSDictionary*) json index: nIndex];
        });
    });
}

//==============================================================================================================
-(void)updateUIWithDictionary:(NSDictionary*)json index: (int) nIndex
{
    @try
    {
        [SVProgressHUD showSuccessWithStatus:@"Syncing successful."];
        if(json != nil)
        {
            switch (nIndex)
            {
                case GET_PENDING_QUENE:
                    [self updatePendingQuene: json];
                    break;
                    
                default:
                    break;
            }
            
        }
    }
    
    @catch (NSException *exception)
    {
        NSLog(@"exception = %@", [exception description]);
        [SVProgressHUD dismissWithError:@"Syncing failed. Try again later." afterDelay:1.0];
    }
    
    //turn off the network indicator in the status bar
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

//==============================================================================================================
-(IBAction) actionSync:(id)sender
{
    [self getPendingQuene];
}

//==============================================================================================================
@end
