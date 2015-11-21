//
//  PWCPMAddMessageViewController.m
//  PWC
//
//  Created by jian on 12/20/13.
//  Copyright (c) 2013 Premium Web Cart. All rights reserved.
//

#import "PWCPMAddMessageViewController.h"
#import "DataManager.h"
#import "SSCheckBoxView.h"
#import <AVFoundation/AVFoundation.h>
#import "PWCAppDelegate.h"
#import "ASIFormDataRequest.h"
#import "JSON.h"

@interface PWCPMAddMessageViewController ()

@end

@implementation PWCPMAddMessageViewController
@synthesize m_strProjectID;

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
    m_bPrivate = NO;
    
    m_arrPeopleCheckBox = [[NSMutableArray alloc] init];
    m_arrAttachedImages = [[NSMutableArray alloc] init];
    m_arrAttachedVideos = [[NSMutableArray alloc] init];

    [m_txtContent setInputAccessoryView: m_topToolBar];
    m_txtContent.layer.masksToBounds = YES;
    m_txtContent.layer.borderWidth = 1.0f;
    m_txtContent.layer.cornerRadius = 5.0f;
    m_txtContent.layer.borderColor = [UIColor grayColor].CGColor;
    [m_txtSubject setInputAccessoryView: m_topToolBar];
    
    float fy = m_txtContent.frame.origin.y + m_txtContent.frame.size.height + 10.0f;
    SSCheckBoxView* checkPrivate = [[SSCheckBoxView alloc] initWithFrame: CGRectMake(0, fy, 280, 30)
                                                          style: 2
                                                        checked: NO];
    [checkPrivate setStateChangedTarget:self
                      selector:@selector(checkPrivate:)];
 
    [checkPrivate setText: @"Make This Message Private"];
    [m_scrollView addSubview: checkPrivate];
    
    fy += 35;
    
    m_viewAttach.hidden = YES;
    /*
    m_viewAttach.frame = CGRectMake(m_viewAttach.frame.origin.x, fy, m_viewAttach.frame.size.width, m_viewAttach.frame.size.height);
    m_scrollAttachFiles.layer.masksToBounds = YES;
    m_scrollAttachFiles.layer.borderWidth = 1.0f;
    m_scrollAttachFiles.layer.borderColor = [UIColor grayColor].CGColor;
*/
    
    NSArray* arrUserList = [[DataManager sharedScoreManager] getAllPMTaskUserListByProjectID: self.m_strProjectID];
    if(arrUserList != nil && [arrUserList count] > 0)
    {
        [self updateUserList: arrUserList];
    }
}

//==============================================================================================================
-(void) checkPrivate: (SSCheckBoxView*) box
{
    m_bPrivate = !m_bPrivate;
}

//==============================================================================================================
-(void) updateUserList: (NSArray*) arrUserList
{
    [m_arrPeopleCheckBox removeAllObjects];
    
    if(arrUserList != nil && [arrUserList count] > 0)
    {
        float fy1 = 0;
        
        for(int i = 0; i < [arrUserList count]; i++)
        {
            NSDictionary* dicCompany = [arrUserList objectAtIndex: i];
            SSCheckBoxView *cbv = [[SSCheckBoxView alloc] initWithFrame: CGRectMake(0, fy1, 280, 30)
                                                                  style: 2
                                                                checked: NO];
            [cbv setText: [dicCompany valueForKey: @"tc_companyname"]];
            cbv.tag = [[dicCompany valueForKey: @"tc_comapnyid"] intValue];
            [cbv setStateChangedTarget:self
                              selector:@selector(checkCompanyChanged:)];
            [m_viewUsers addSubview: cbv];
            
            fy1 += 30;
            
            NSString* people = [dicCompany valueForKey: @"people"];
            if(people != nil && [people length] > 0)
            {
                NSArray* arrPeople = [people componentsSeparatedByString: @","];
                if(arrPeople != nil && [arrPeople count] > 0)
                {
                    for(int j = 0; j < [arrPeople count]; j++)
                    {
                        NSString* strPeopleID = [arrPeople objectAtIndex: j];
                        NSDictionary* dicPeople = [[DataManager sharedScoreManager] getPMTaskPeopleByTPID: strPeopleID];
                        SSCheckBoxView *cbv = [[SSCheckBoxView alloc] initWithFrame: CGRectMake(30, fy1, 200, 30)
                                                                              style: 2
                                                                            checked: NO];
                        [cbv setText: [NSString stringWithFormat: @"%@ %@", [dicPeople valueForKey: @"tp_firstname"], [dicPeople valueForKey: @"tp_lastname"]]];
                        [cbv setSubTextStyle];
                        cbv.tag = [strPeopleID intValue];
                        [m_arrPeopleCheckBox addObject: cbv];
                        [m_viewUsers addSubview: cbv];
                    }
                    
                    fy1 += 30;
                }
            }
        }
        
        m_viewUsers.frame = CGRectMake(m_viewUsers.frame.origin.x,
                                       m_viewAttach.frame.origin.y + 40.0f,
                                       m_viewUsers.frame.size.width,
                                       fy1);
        float fy = m_viewUsers.frame.origin.y + m_viewUsers.frame.size.height + 20;
        fy += 100;
        [m_scrollView setContentSize: CGSizeMake(m_scrollView.contentSize.width, fy)];
    }
}

//==============================================================================================================
-(void) checkCompanyChanged: (SSCheckBoxView *)cbv
{
    NSString* companyid = [NSString stringWithFormat: @"%d", cbv.tag];
    NSDictionary* dicCompany = [[DataManager sharedScoreManager] getPMTaskUserListById: companyid project_id: self.m_strProjectID];
    NSString* people = [dicCompany valueForKey: @"people"];
    if(people != nil && [people length] > 0)
    {
        NSArray* arrPeople = [people componentsSeparatedByString: @","];
        if(arrPeople != nil && [arrPeople count] > 0)
        {
            for(int j = 0; j < [arrPeople count]; j++)
            {
                int nPeopleID = [[arrPeople objectAtIndex: j] intValue];
                for(int k = 0; k < [m_arrPeopleCheckBox count]; k++)
                {
                    SSCheckBoxView* checkBox = [m_arrPeopleCheckBox objectAtIndex: k];
                    
                    if(checkBox.tag == nPeopleID)
                    {
                        [checkBox setChecked: cbv.checked];
                    }
                }
            }
        }
    }
}

#pragma mark -
#pragma Action Sheet Delegate.

//==============================================================================================================
-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
            //Take Photo
        case 0:
            [self takePhoto];
            break;
            
            //Select Photo
        case 1:
            [self selectPhoto];
            break;
            
            //Take Video
        case 2:
            [self takeVideo];
            break;
            
            //Select Video.
        case 3:
            [self selectVideo];
            break;
            
        default:
            break;
    }
}

//==============================================================================================================
-(void) takePhoto
{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                              message:@"Device has no camera"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles: nil];
        
        [myAlertView show];
        return;
    }
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    m_bPhotoFlag = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

//==============================================================================================================
-(void) takeVideo
{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                              message:@"Device has no camera"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles: nil];
        
        [myAlertView show];
        return;
    }
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    m_bPhotoFlag = NO;
    picker.mediaTypes = [[NSArray alloc] initWithObjects:(NSString *)kUTTypeMovie, nil];
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

//==============================================================================================================
-(void) selectPhoto
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    m_bPhotoFlag = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:NULL];
}

//==============================================================================================================
-(void) selectVideo
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    m_bPhotoFlag = NO;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.mediaTypes = [[NSArray alloc] initWithObjects:(NSString *)kUTTypeMovie, nil];
    [self presentViewController:picker animated:YES completion:NULL];
}

//==============================================================================================================
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if(m_bPhotoFlag)
    {
        [m_arrAttachedImages addObject: [info objectForKey:UIImagePickerControllerEditedImage]];
    }
    else
    {
        [m_arrAttachedVideos addObject: [info objectForKey:UIImagePickerControllerMediaURL]];
    }
    
    [self updateAttachedView];
    [picker dismissViewControllerAnimated: YES completion:NULL];
}


//==============================================================================================================
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

//==============================================================================================================
-(void) updateAttachedView
{
    for(UIView* view in m_scrollAttachFiles.subviews)
    {
        [view removeFromSuperview];
    }
    
    float fx = 5;
    float fy = 10;
    float fw = 100;
    float fh = 100;
    
    for(int i = 0; i < [m_arrAttachedImages count]; i++)
    {
        UIImageView* imgThumb = [[UIImageView alloc] initWithImage: [m_arrAttachedImages objectAtIndex: i]];
        imgThumb.layer.masksToBounds = YES;
        imgThumb.contentMode = UIViewContentModeScaleAspectFill;
        imgThumb.frame = CGRectMake(fx, fy, fw, fh);
        fx += fw + 10;
        [m_scrollAttachFiles addSubview: imgThumb];
    }
    
    for(int i = 0; i < [m_arrAttachedVideos count]; i++)
    {
        NSURL* url = [m_arrAttachedVideos objectAtIndex: i];
        UIImage* thumbNail = [self thumbnailImageForVideo: url atTime: 0.1f];
        
        UIImageView* imgThumb = [[UIImageView alloc] initWithImage: thumbNail];
        imgThumb.layer.masksToBounds = YES;
        imgThumb.contentMode = UIViewContentModeScaleAspectFill;
        imgThumb.frame = CGRectMake(fx, fy, fw, fh);
        fx += fw + 10;
        [m_scrollAttachFiles addSubview: imgThumb];
    }
    
    [m_scrollAttachFiles setContentSize: CGSizeMake(fx, m_scrollAttachFiles.contentSize.height)];
}

//========================================================================================================================================
- (UIImage *)thumbnailImageForVideo:(NSURL *)videoURL
                             atTime:(NSTimeInterval)time
{
    
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
    NSParameterAssert(asset);
    AVAssetImageGenerator *assetIG =
    [[AVAssetImageGenerator alloc] initWithAsset:asset];
    assetIG.appliesPreferredTrackTransform = YES;
    assetIG.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
    
    CGImageRef thumbnailImageRef = NULL;
    CFTimeInterval thumbnailImageTime = time;
    NSError *igError = nil;
    thumbnailImageRef =
    [assetIG copyCGImageAtTime:CMTimeMake(thumbnailImageTime, 60)
                    actualTime:NULL
                         error:&igError];
    
    if (!thumbnailImageRef)
        NSLog(@"thumbnailImageGenerationError %@", igError );
    
    UIImage *thumbnailImage = thumbnailImageRef ? [[UIImage alloc] initWithCGImage:thumbnailImageRef]: nil;
    
    return thumbnailImage;
}

//==============================================================================================================
-(IBAction) actionInputDone: (id) sender
{
    [m_txtSubject resignFirstResponder];
    [m_txtContent resignFirstResponder];
}

//==============================================================================================================
-(IBAction) actionAttach:(id)sender
{
    UIActionSheet* sheet = [[UIActionSheet alloc] initWithTitle: @"File Attach"
                                                       delegate: self
                                              cancelButtonTitle: @"Cancel"
                                         destructiveButtonTitle: nil
                                              otherButtonTitles: @"Take Photo", @"Select Photo", @"Take Video", @"Select Video", nil];
    [sheet showInView: self.view];
}

//==============================================================================================================
-(IBAction) actionSubmit:(id)sender
{
    NSString* msgsubject = m_txtSubject.text;
    if(msgsubject == nil || [msgsubject length] <= 0)
    {
        [[PWCAppDelegate getDelegate] showMessage: @"Please Input Valid Message Subject."];
        return;
    }
    
    NSString* msgdescription = m_txtContent.text;
    if(msgdescription == nil || [msgdescription length] <= 0)
    {
        [[PWCAppDelegate getDelegate] showMessage: @"Please Input Valid Message Content."];
        return;
    }
    
    NSString* msgprivate = @"0";
    if(m_bPrivate) msgprivate = @"1";
    NSString* checksuperadmin = @"1";
    NSString* people;
    for(int i = 0; i < [m_arrPeopleCheckBox count]; i++)
    {
        SSCheckBoxView* box = [m_arrPeopleCheckBox objectAtIndex: i];
        if(box.checked)
        {
            NSString* peopleID = [NSString stringWithFormat: @"%d", box.tag];
            if(people == nil || [people length] <= 0)
            {
                people = peopleID;
            }
            else
            {
                people = [people stringByAppendingString: [NSString stringWithFormat: @",%@", peopleID]];
            }
        }
    }
    
    NSLog(@"people = %@", people);
    
    [SVProgressHUD showWithStatus:@"Loading ..." maskType:SVProgressHUDMaskTypeBlack];
    NSString* strURL = [@"https://pwcproject.com/v2/mobilepm/api/addnewmessage" stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    
    ASIFormDataRequest* request = [ASIFormDataRequest requestWithURL: [NSURL URLWithString: strURL]];
    [request setDelegate: self];
    [request setTimeOutSeconds: REQUEST_TIME_OUT];    
    [request setPostValue: [PWCGlobal getTheGlobal].account_id forKey: @"account_id"];
    [request setPostValue: [PWCGlobal getTheGlobal].hashKey forKey: @"userhash"];
    [request setPostValue: self.m_strProjectID forKey: @"project_id"];
    [request setPostValue: msgsubject forKey: @"msgsubject"];
    [request setPostValue: msgdescription forKey: @"msgdescription"];
    [request setPostValue: msgprivate forKey: @"msgprivate"];
    [request setPostValue: checksuperadmin forKey: @"checksuperadmin"];
    [request setPostValue: people forKey: @"people"];
    
    for(int i = 0; i < [m_arrAttachedImages count]; i++)
    {
        UIImage* img = [m_arrAttachedImages objectAtIndex: i];
        NSData* imgData = UIImageJPEGRepresentation(img, 1.0f);
        [request setPostValue: imgData forKey: @"msgattachedfile[]"];
    }
    
    [request setDidFinishSelector: @selector(finishedAddNewMessage:)];
    [request setDidFailSelector: @selector(failedSync:)];
    [request startAsynchronous];
}

//==============================================================================================================
-(void) finishedAddNewMessage: (ASIFormDataRequest*) theRequest
{
    [SVProgressHUD showSuccessWithStatus:@"Syncing Successful."];
    
    NSString* strResponse = [theRequest responseString];
    NSLog(@"strResponse = %@", strResponse);
    
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle: nil
                                                    message: strResponse
                                                   delegate: self
                                          cancelButtonTitle: @"OK"
                                          otherButtonTitles: nil, nil];
    [alert show];
    return;
}

//==============================================================================================================
-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [[DataManager sharedScoreManager] deleteAllPMMessageListByProjectID: self.m_strProjectID];
    [self.navigationController popViewControllerAnimated: YES];
}

//==============================================================================================================
-(void) failedSync: (ASIFormDataRequest*) theRequest
{
    [SVProgressHUD showSuccessWithStatus:@"Syncing Failed."];
}

//==============================================================================================================
@end
