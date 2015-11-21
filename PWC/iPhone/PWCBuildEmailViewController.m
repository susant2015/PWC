//
//  PWCBuildEmailViewController.m
//  PWC
//
//  Created by JianJinHu on 7/25/13.
//  Copyright (c) 2013 Premium Web Cart. All rights reserved.
//

#import "PWCBuildEmailViewController.h"
#import "PWCEmailProfileViewController.h"
#import "PWCGlobal.h"
#import "NSData+Base64.h"
#import "PWCCRMGlobal.h"
#import "DataManager.h"
#import "ASIFormDataRequest.h"
#import "PWCAppDelegate.h"
#import "JSON.h"
#import <QuartzCore/QuartzCore.h>

@interface PWCBuildEmailViewController ()

@end

@implementation PWCBuildEmailViewController
@synthesize m_strQueneAM;
@synthesize m_strQueneHour;
@synthesize m_strQueneMin;

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
-(void) initMember
{
    m_nAddToQuene = 0;
    m_nDatePickerType = -1;
    
    RadioButton *rb1 = [[RadioButton alloc] initWithGroupId:@"first group" index:1];
    rb1.frame = CGRectMake(10, 345, 22, 22);
    [m_scrollView addSubview: rb1];

    RadioButton *rb2 = [[RadioButton alloc] initWithGroupId:@"first group" index:2];
    rb2.frame = CGRectMake(10, 366, 22, 22);
    [m_scrollView addSubview: rb2];

    [RadioButton addObserverForGroupId:@"first group" observer:self];
    m_nAddToQuene = 1;
    [rb1 handleButtonTap: rb1];
    
    [m_txtFrom setInputAccessoryView: m_topToolBar];
    [m_txtMessage setInputAccessoryView: m_topToolBar];
    [m_txtReplyTo setInputAccessoryView: m_topToolBar];
    [m_txtSubject setInputAccessoryView: m_topToolBar];
    
    m_txtMessage.layer.masksToBounds = YES;
    m_txtMessage.layer.borderWidth = 1.0f;
    m_txtMessage.layer.cornerRadius = 5.0f;
    m_txtMessage.layer.borderColor = [UIColor grayColor].CGColor;
    
    [m_scrollView setContentSize: CGSizeMake(m_scrollView.contentSize.width, 600)];
}

//==============================================================================================================
-(void)radioButtonSelectedAtIndex:(NSUInteger)index inGroup:(NSString *)groupId
{
    NSLog(@"changed to %d in %@",index,groupId);
    m_nAddToQuene = index;
}

//==============================================================================================================
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//==============================================================================================================
-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear: animated];
    NSString* strFrom = [PWCGlobal getTheGlobal].m_gSelectedFrom;
    NSString* strReply = [PWCGlobal getTheGlobal].m_gSelectedReplyTo;
    NSString* strSubject = [PWCGlobal getTheGlobal].m_gSelectedSubject;
    NSString* strSignature = [PWCGlobal getTheGlobal].m_gSelectedSignature;
    
    if(strFrom != nil && [strFrom length] > 0)
    {
        m_txtFrom.text = strFrom;
    }

    if(strReply != nil && [strReply length] > 0)
    {
        m_txtReplyTo.text = strReply;
    }
    
    if(strSubject != nil && [strSubject length] > 0)
    {
        m_txtSubject.text = strSubject;
    }
    
    if(strSignature != nil && [strSignature length] > 0)
    {
//        m_txtMessage.text = strSignature;
        NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[strSignature dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
        m_txtMessage.attributedText = attributedString;
    }
}

#pragma mark -
#pragma mark UITextField Delegate.

//==============================================================================================================
-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}

#pragma mark -
#pragma mark UITextField Delegate.

//==============================================================================================================
-(void) textViewDidBeginEditing:(UITextView *)textView
{
    m_fScrollHeight = m_scrollView.contentSize.height;
    m_scrollView.contentSize = CGSizeMake(0, m_fScrollHeight + 200);
    [m_scrollView setContentOffset:CGPointMake(0, 200) animated: YES];
}

//==============================================================================================================
-(void) textViewDidEndEditing:(UITextView *)textView
{
    m_scrollView.contentSize = CGSizeMake(0, m_fScrollHeight);
    [m_scrollView setContentOffset: CGPointZero animated: YES];
}

#pragma mark - 
#pragma mark Action Management.

//==============================================================================================================
-(IBAction) actionInputDone:(id)sender
{
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
-(IBAction) actionSubmit:(id)sender
{
    NSString* strProfileID = [PWCGlobal getTheGlobal].m_gSelectedProfileID;
    NSString* strContentID = [PWCGlobal getTheGlobal].m_gSelectedContentID;
    NSString* strFromEmail = m_txtFrom.text;
    NSString* strReplayTo = m_txtReplyTo.text;
    NSString* strEmailSubject = m_txtSubject.text;
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
    
    if(strProfileID == nil || [strProfileID length] <= 0)
    {
        [[PWCAppDelegate getDelegate] showMessage: @"You will have to select Email Profile"];
        return;
    }

    if(strContentID == nil || [strContentID length] <= 0)
    {
        [[PWCAppDelegate getDelegate] showMessage: @"You will have to select Email Content"];
        return;
    }

    if(strFromEmail == nil || [strFromEmail length] <= 0)
    {
        [[PWCAppDelegate getDelegate] showMessage: @"You will have to select the From Address"];
        return;
    }

    if(strReplayTo == nil || [strReplayTo length] <= 0)
    {
        [[PWCAppDelegate getDelegate] showMessage: @"You will have to select the Reply Address"];
        return;
    }

    if(strEmailSubject == nil || [strEmailSubject length] <= 0)
    {
        [[PWCAppDelegate getDelegate] showMessage: @"You will have to Provide Subject"];
        return;
    }

    if(strMessage == nil || [strMessage length] <= 0)
    {
        [[PWCAppDelegate getDelegate] showMessage: @"You will have to Provide Message"];
        return;
    }

    [SVProgressHUD showWithStatus:@"Loading ..." maskType:SVProgressHUDMaskTypeBlack];
    NSString* strURL = [NSString stringWithFormat: @"%@sendemail", SERVER_BASE_URL];
    ASIFormDataRequest* request = [ASIFormDataRequest requestWithURL: [NSURL URLWithString: strURL]];
    
    NSLog(@"URL where sending build email:%@",strURL);
    [request setDelegate: self];
    [request setTimeOutSeconds: REQUEST_TIME_OUT];    
    [request setPostValue: strProfileID forKey: @"profile_id"];
    [request setPostValue: strContentID forKey: @"content_id"];
    [request setPostValue: strFromEmail forKey: @"from_email"];
    [request setPostValue: strReplayTo forKey: @"reply_to"];
    [request setPostValue: strEmailSubject forKey: @"email_subject"];
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
    
    [request setDidFinishSelector: @selector(finishedSendEmail:)];
    [request setDidFailSelector: @selector(failedLogin:)];
    [request startAsynchronous];
}

//==============================================================================================================
-(void) finishedSendEmail: (ASIFormDataRequest*) theRequest
{
    [SVProgressHUD showSuccessWithStatus:@"Syncing Successful."];    
    NSString* strResponse = [theRequest responseString];
    NSDictionary* dic = [strResponse JSONValue];
    NSLog(@"dic = %@", dic);
    
    NSString* status = [dic valueForKey: @"status"];
    if([status isEqualToString: @"Error"])
    {
        [[PWCAppDelegate getDelegate] showMessage: @"Sorry! Could Not Process The Broadcast Request"];
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
-(IBAction) actionTextViewDone:(id)sender
{
    [m_txtFrom resignFirstResponder];
    [m_txtReplyTo resignFirstResponder];
    [m_txtSubject resignFirstResponder];
    [m_txtMessage resignFirstResponder];
}

//==============================================================================================================
-(IBAction) actionRefresh:(id)sender
{
    [self getProfileList];
}

#pragma mark -
#pragma mark Sync Logic.

//==============================================================================================================
-(void) getProfileList
{
    NSString* strURL = [[NSString stringWithFormat: @"%@profileslist/%@", SERVER_BASE_URL, [PWCGlobal getTheGlobal].merchantId] stringByAddingPercentEscapesUsingEncoding: NSASCIIStringEncoding];
    [self fetchJSON: strURL index: GET_EMAIL_PROFILES];
}

//==============================================================================================================
-(void) updateProfileList: (NSDictionary*) dicData
{
    [[DataManager sharedScoreManager] deleteAllEmailProfiles];
    
    NSArray* arrProfiles = [dicData objectForKey: @"profiles"];
    for(int i = 0; i < [arrProfiles count]; i++)
    {
        NSDictionary* dicRecord = [arrProfiles objectAtIndex: i];
        NSString* strProfileID = [dicRecord objectForKey: @"profile_id"];
        NSString* strProfileName = [[PWCAppDelegate getDelegate] decodeBase64String: [dicRecord objectForKey: @"profile_name"]];
        NSString* strReplyToEmail = [dicRecord objectForKey: @"reply_to_email"];
        NSString* strProfileFromName = [dicRecord objectForKey: @"profile_from_name"];

        [[DataManager sharedScoreManager] insertEmailProfile: strProfileID
                                                profile_name: strProfileName
                                           profile_from_name: strProfileFromName
                                              reply_to_email: strReplyToEmail];
    }
}

//==============================================================================================================
-(void) getContentList
{
    NSString* strURL = [[NSString stringWithFormat: @"%@contentslist/%@", SERVER_BASE_URL, [PWCGlobal getTheGlobal].merchantId] stringByAddingPercentEscapesUsingEncoding: NSASCIIStringEncoding];
    [self fetchJSON: strURL index: GET_EMAIL_CONTENT];
}

//==============================================================================================================
-(void) updateContentList: (NSDictionary*) dicData
{
    [[DataManager sharedScoreManager] deleteAllEmailContents];
    
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
            NSString* strLibrary_name = [[PWCAppDelegate getDelegate] decodeBase64String: [dic objectForKey: @"library_name"]];
            NSString* strSignature = [[PWCAppDelegate getDelegate] decodeBase64String: [dic objectForKey: @"signature"]];
            
            [[DataManager sharedScoreManager] insertEmailContent: strContentID
                                                         subject: strSubject
                                                    library_name: strLibrary_name
                                                       signature: strSignature
                                                          cat_id: strCatID
                                                        category: strCategory];
        }
    }
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
        [SVProgressHUD showSuccessWithStatus:@"Syncing successful."];
        if(json != nil)
        {
            switch (nIndex)
            {
                case GET_EMAIL_PROFILES:
                    [self updateProfileList: json];
                    [self getContentList];
                    break;
                    
                case GET_EMAIL_CONTENT:
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
        [SVProgressHUD dismissWithError:@"Syncing failed. Try again later." afterDelay:1.0];
    }
    
    //turn off the network indicator in the status bar
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

//==============================================================================================================
@end
