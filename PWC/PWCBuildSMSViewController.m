//
//  PWCBuildSMSViewController.m
//  PWC
//
//  Created by JianJinHu on 7/29/13.
//  Copyright (c) 2013 Premium Web Cart. All rights reserved.
//

#import "PWCBuildSMSViewController.h"
#import "PWCCRMGlobal.h"
#import "PWCGlobal.h"
#import "DataManager.h"
#import "PWCAppDelegate.h"
#import "ASIFormDataRequest.h"
#import "JSON.h"

@interface PWCBuildSMSViewController ()

@end

@implementation PWCBuildSMSViewController
@synthesize m_strQueneAM;
@synthesize m_strQueneHour;
@synthesize m_strQueneMin;

//==============================================================================================================
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

//==============================================================================================================
- (void)viewDidLoad
{
    [super viewDidLoad];

    m_nAddToQuene = 0;
    m_nDatePickerType = -1;
    
    [m_txtMessage setInputAccessoryView: m_topToolBar];
    
    RadioButton *rb1 = [[RadioButton alloc] initWithGroupId:@"first group" index:1];
    rb1.frame = CGRectMake(10, 270, 22, 22);
    [self.view addSubview: rb1];
    
    RadioButton *rb2 = [[RadioButton alloc] initWithGroupId:@"first group" index:2];
    rb2.frame = CGRectMake(10, 293, 22, 22);
    [self.view addSubview: rb2];
    
    [RadioButton addObserverForGroupId:@"first group" observer:self];
    [self.view bringSubviewToFront: m_viewInput];
    
    m_txtMessage.layer.masksToBounds = YES;
    m_txtMessage.layer.borderWidth = 1.0f;
    m_txtMessage.layer.cornerRadius = 5.0f;
    m_txtMessage.layer.borderColor = [UIColor grayColor].CGColor;
    
    m_nAddToQuene = 1;
    [rb1 handleButtonTap: rb1];
}

//==============================================================================================================
-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear: animated];
    [self initMember];
}

//==============================================================================================================
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

//==============================================================================================================
-(void) initMember
{
    NSString* strMessage = [PWCGlobal getTheGlobal].m_gSelectedSMSSignature;
    if(strMessage != nil && [strMessage length] > 0)
    {
        m_txtMessage.text = strMessage;
    }
    
    m_lblLetters.text = [NSString stringWithFormat: @"%d", [m_txtMessage.text length]];
}

//==============================================================================================================
-(void)radioButtonSelectedAtIndex:(NSUInteger)index inGroup:(NSString *)groupId
{
    m_nAddToQuene = index;
}

//==============================================================================================================
-(void) handleSingleTap: (UITapGestureRecognizer*) recognizer
{
    m_viewInput.hidden = YES;
    [m_txtMessage resignFirstResponder];
}

#pragma mark -
#pragma mark Content List

//==============================================================================================================
-(void) getContentList
{
    NSString* strURL = [[NSString stringWithFormat: @"%@smsContentslist/%@", SERVER_BASE_URL, [PWCGlobal getTheGlobal].merchantId] stringByAddingPercentEscapesUsingEncoding: NSASCIIStringEncoding];
    [self fetchJSON: strURL index: GET_SMS_CONTENT];
}

//==============================================================================================================
-(void) updateContentList: (NSDictionary*) dicData
{
    [[DataManager sharedScoreManager] deleteAllSMSContents];
    
    NSLog(@"sms contents = %@", dicData);
    NSArray* arrContentList = [dicData objectForKey: @"contentslist"];
    for(int i = 0; i < [arrContentList count]; i++)
    {
        NSDictionary* dicRecord = [arrContentList objectAtIndex: i];
        NSString* strCatID = [dicRecord objectForKey: @"cat_id"];
        NSString* strCategory = [dicRecord objectForKey: @"category"];
        NSArray* arrContents = [dicRecord objectForKey: @"contents"];
        for(int j = 0; j < [arrContents count]; j++)
        {
            NSDictionary* dic = [arrContents objectAtIndex: j];
            NSString* strContentID = [dic objectForKey: @"id"];
            NSString* strSubject = [dic objectForKey: @"subject"];
            NSString* strSignature = [[PWCAppDelegate getDelegate] decodeBase64String: [dic objectForKey: @"signature"]];
            
            [[DataManager sharedScoreManager] insertSMSContent: strContentID
                                                         subject: strSubject
                                                       signature: strSignature
                                                          cat_id: strCatID
                                                        category: strCategory];
        }
    }
}

#pragma mark -
#pragma mark UITextView Delegate.

//==============================================================================================================
-(void) textViewDidBeginEditing:(UITextView *)textView
{
    m_fScrollHeight = m_scrollView.contentSize.height;
    m_scrollView.contentSize = CGSizeMake(0, m_fScrollHeight + 0);
    [m_scrollView setContentOffset:CGPointMake(0, 0) animated: YES];
}

//==============================================================================================================
-(void) textViewDidEndEditing:(UITextView *)textView
{
    m_scrollView.contentSize = CGSizeMake(0, m_fScrollHeight);
}

//==============================================================================================================
-(void) textViewDidChange:(UITextView *)textView
{
    m_lblLetters.text = [NSString stringWithFormat: @"%d", [textView.text length]];
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
        NSLog(@"json = %@", json);
        [SVProgressHUD showSuccessWithStatus:@"Syncing Successful."];
        if(json != nil)
        {
            switch (nIndex)
            {
                case GET_SMS_CONTENT:
                    [self updateContentList: json];
                    break;
                    
                default:
                    break;
            }
            
        }
    }
    
    @catch (NSException *exception)
    {
        NSLog(@"exception = %@", [exception description]);
        [SVProgressHUD dismissWithError:@"Syncing Failed. Try Again Later." afterDelay:1.0];
    }
    
    //turn off the network indicator in the status bar
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

#pragma mark -
#pragma mark Action Management.

//==============================================================================================================
-(IBAction) actionInputDone: (id) sender
{
    NSLog(@"Input");
    m_viewInput.hidden = YES;
    [m_txtMessage resignFirstResponder];
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    NSDate* date = m_datePicker.date;
    
    if(m_nDatePickerType == 1)
    {
        [formatter setDateFormat: @"dd-MM-yyyy"];
        NSString* str = [formatter stringFromDate: date];
        [m_btnDate setTitle: str forState: UIControlStateNormal];
    }
    else if(m_nDatePickerType == 2)
    {
        [formatter setDateFormat: @"HH:mm a"];
        NSString* str = [formatter stringFromDate: date];
        [m_btnTime setTitle: str forState: UIControlStateNormal];
        
        [formatter setDateFormat: @"HH"];
        m_strQueneHour = [formatter stringFromDate: date];
        
        [formatter setDateFormat: @"mm"];
        m_strQueneMin = [formatter stringFromDate: date];
        
        [formatter setDateFormat: @"a"];
        m_strQueneAM = [formatter stringFromDate: date];
    }
    
    m_nDatePickerType = -1;
}


//==============================================================================================================
-(IBAction) actionDate:(id)sender
{
    if(m_nAddToQuene != 2) return;
    m_datePicker.datePickerMode = UIDatePickerModeDate;
    m_viewInput.hidden = NO;
    m_nDatePickerType = 1;
}

//==============================================================================================================
-(IBAction) actionTime:(id)sender
{
    if(m_nAddToQuene != 2) return;
    m_datePicker.datePickerMode = UIDatePickerModeTime;
    m_viewInput.hidden = NO;
    m_nDatePickerType = 2;
}

//==============================================================================================================
-(IBAction) actionRefresh:(id)sender
{
    [self getContentList];
}

//==============================================================================================================
-(IBAction) actionSubmit:(id)sender
{
    NSString* strContentID = [PWCGlobal getTheGlobal].m_gSelectedSMSContentID;
    NSString* strMessage = m_txtMessage.text;
    NSString* strQueneDate = m_btnDate.titleLabel.text;
    
    if(m_nAddToQuene == 0)
    {
        [[PWCAppDelegate getDelegate] showMessage: @"You will have to select Schedule"];
        return;
    }
    
    if(m_nAddToQuene == 2)
    {
        if(strQueneDate == nil || [strQueneDate length] <= 0)
        {
            [[PWCAppDelegate getDelegate] showMessage: @"You will have to select the Queue Date"];
            return;
        }
        
        if(m_strQueneHour == nil || [m_strQueneHour length] <= 0)
        {
            [[PWCAppDelegate getDelegate] showMessage: @"You will have to select the Queue Time"];
            return;
        }
    }
    
    if(strContentID == nil || [strContentID length] <= 0)
    {
        [[PWCAppDelegate getDelegate] showMessage: @"You will have to select SMS Content"];
        return;
    }
    
    if(strMessage == nil || [strMessage length] <= 0)
    {
        [[PWCAppDelegate getDelegate] showMessage: @"You will have to select Message"];
        return;
    }
    
    [SVProgressHUD showWithStatus:@"Loading ..." maskType:SVProgressHUDMaskTypeBlack];
    NSString* strURL = [NSString stringWithFormat: @"%@sendsms", SERVER_BASE_URL];
    ASIFormDataRequest* request = [ASIFormDataRequest requestWithURL: [NSURL URLWithString: strURL]];
    [request setDelegate: self];
    [request setTimeOutSeconds: REQUEST_TIME_OUT];    
    [request setPostValue: strContentID forKey: @"content_id"];
    [request setPostValue: strMessage forKey: @"email_message"];
    [request setPostValue: [PWCGlobal getTheGlobal].userHash forKey: @"userhash"];
    [request setPostValue: [NSString stringWithFormat: @"%d", m_nAddToQuene] forKey: @"add_to_quene"];
    
    if(m_nAddToQuene == 2)
    {
        [request setPostValue: strQueneDate forKey: @"quene_date"];
        [request setPostValue: m_strQueneHour forKey: @"quene_hour"];
        [request setPostValue: m_strQueneMin forKey: @"quene_min"];
        [request setPostValue: m_strQueneAM forKey: @"quene_ampm"];
    }
    
    [request setDidFinishSelector: @selector(finishedSendSMS:)];
    [request setDidFailSelector: @selector(failedLogin:)];
    [request startAsynchronous];
}

//==============================================================================================================
-(IBAction) actionTextViewDone:(id)sender
{
    [m_txtMessage resignFirstResponder];
}

//==============================================================================================================
-(void) finishedSendSMS: (ASIFormDataRequest*) theRequest
{
    [SVProgressHUD showSuccessWithStatus:@"Syncing Successful."];
    NSString* strResponse = [theRequest responseString];
    NSDictionary* dic = [strResponse JSONValue];
    NSLog(@"Result = %@", dic);
    
    NSString* status = [dic valueForKey: @"status"];
    if([status isEqualToString: @"Error"])
    {
        [[PWCAppDelegate getDelegate] showMessage: @"Sorry! Could Not Process The SMS Request"];
        return;
    }
    else
    {
        [self.navigationController popViewControllerAnimated: YES];
    }
}

//==============================================================================================================
-(void) failedLogin: (ASIFormDataRequest*) theRequest
{
    [SVProgressHUD showSuccessWithStatus:@"Syncing Failed."];
}

//==============================================================================================================
@end
