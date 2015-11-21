//
//  PWCPMAddTaskViewController.m
//  PWC
//
//  Created by jian on 12/16/13.
//  Copyright (c) 2013 Premium Web Cart. All rights reserved.
//

#import "PWCPMAddTaskViewController.h"
#import "PWCGlobal.h"
#import <QuartzCore/QuartzCore.h>
#import <AVFoundation/AVFoundation.h>
#import "ASIFormDataRequest.h"
#import "JSON.h"
#import "DataManager.h"
#import "SSCheckBoxView.h"
#import "PWCPMNotificationToViewController.h"
#import "PWCGlobal.h"
#import "PWCAppDelegate.h"

@interface PWCPMAddTaskViewController ()

@end

@implementation PWCPMAddTaskViewController
@synthesize m_strProjectID;
@synthesize m_strTitleID;

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
    [PWCGlobal getTheGlobal].m_gPMAddTaskSelectedAssignedTo = nil;
    
    if([self.m_strTitleID intValue] != -100)
    {
        m_bAddNewList = NO;
        m_viewNewListName.hidden = YES;
        m_viewMain.frame = CGRectMake(m_viewMain.frame.origin.x, m_viewNewListName.frame.origin.y, m_viewMain.frame.size.width, m_viewMain.frame.size.height);
        [m_scrollView setContentSize: CGSizeMake(m_scrollView.contentSize.width, 530)];
    }
    else
    {
        m_bAddNewList = YES;
        [m_scrollView setContentSize: CGSizeMake(m_scrollView.contentSize.width, 600)];
    }
    
    m_bPhotoFlag = YES;
    m_arrAttachedImages = [[NSMutableArray alloc] init];
    m_arrAttachedVideos = [[NSMutableArray alloc] init];
    
    m_nSelectedDayDuration = 0;
    m_nSelectedHourDuration = 0;
    m_nSelectedMinuteDuration = 0;
    m_nDateType = 0;
    m_nInputType = 0;
    
    [m_txtFullDescription setInputAccessoryView: m_topToolBar];
    m_txtFullDescription.layer.masksToBounds = YES;
    m_txtFullDescription.layer.borderWidth = 1.0f;
    m_txtFullDescription.layer.cornerRadius = 5.0f;
    m_txtFullDescription.layer.borderColor = [UIColor grayColor].CGColor;
    [m_txtTask setInputAccessoryView: m_topToolBar];
    [m_txtNewListName setInputAccessoryView: m_topToolBar];
    
    m_scrollAttachFiles.layer.masksToBounds = YES;
    m_scrollAttachFiles.layer.borderWidth = 1.0f;
    m_scrollAttachFiles.layer.borderColor = [UIColor grayColor].CGColor;
    
    m_arrAssignUser = [[NSMutableArray alloc] init];
    NSArray* arrUserList = [[DataManager sharedScoreManager] getAllPMTaskUserListByProjectID: self.m_strProjectID];
    if(arrUserList != nil && [arrUserList count] > 0)
    {
        for(int i = 0; i < [arrUserList count]; i++)
        {
            NSDictionary* dicUser = [arrUserList objectAtIndex: i];
            NSString* people = [dicUser valueForKey: @"people"];
            NSArray* arrPeple = [people componentsSeparatedByString: @","];
            if(arrPeple != nil)
            {
                for(int j = 0; j < [arrPeple count]; j++)
                {
                    NSString* tp_id = [arrPeple objectAtIndex: j];
                    NSArray* arrTemp = [[DataManager sharedScoreManager] getPMTaskPeopleByID: tp_id];
                    if(arrTemp != nil && [arrTemp count] > 0)
                    {
                        NSDictionary* dicRecord = [arrTemp objectAtIndex: 0];
                        [m_arrAssignUser addObject: dicRecord];
                    }
                }
            }
        }
    }
    m_arrPriority = [[NSMutableArray alloc] initWithObjects: @"Highest", @"High", @"Normal", @"Low", @"Lowest", nil];
}

//==============================================================================================================
-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    NSLog(@"[PWCGlobal getTheGlobal].m_gPMAddTaskSelectedAssignedTo = %@", [PWCGlobal getTheGlobal].m_gPMAddTaskSelectedAssignedTo);
    
    if([PWCGlobal getTheGlobal].m_gPMAddTaskSelectedAssignedTo != nil && [[PWCGlobal getTheGlobal].m_gPMAddTaskSelectedAssignedTo length] > 0)
    {
        NSArray* arrTemp = [[DataManager sharedScoreManager] getPMTaskPeopleByID: [PWCGlobal getTheGlobal].m_gPMAddTaskSelectedAssignedTo];
        if(arrTemp != nil && [arrTemp count] > 0)
        {
            NSDictionary* dicRecord = [arrTemp objectAtIndex: 0];
            [m_btnAssignedTo setTitle: [NSString stringWithFormat: @"%@ %@", [dicRecord valueForKey: @"tp_firstname"], [dicRecord valueForKey: @"tp_lastname"]]
                             forState: UIControlStateNormal];
        }
    }
}

//==============================================================================================================
-(void) updateUserList: (NSArray*) arrUserList
{
    /*
    NSLog(@"arrUserList = %@", arrUserList);
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
                        int nSelect = [[dicPeople valueForKey: @"selected"] intValue];
                        BOOL bSelect = YES;
                        if(nSelect == 0)
                        {
                            bSelect = NO;
                        }
                        SSCheckBoxView *cbv = [[SSCheckBoxView alloc] initWithFrame: CGRectMake(30, fy1, 200, 30)
                                                                              style: 2
                                                                            checked: bSelect];
                        [cbv setText: [NSString stringWithFormat: @"%@ %@", [dicPeople valueForKey: @"tp_firstname"], [dicPeople valueForKey: @"tp_lastname"]]];
                        [cbv setSubTextStyle];
                        
                        [m_viewUsers addSubview: cbv];
                    }
                    
                    fy1 += 30;
                }
            }
        }
        
        m_viewUsers.frame = CGRectMake(m_viewUsers.frame.origin.x,
                                       m_viewUsers.frame.origin.y,
                                       m_viewUsers.frame.size.width,
                                       fy1);
        float fy = m_viewUsers.frame.origin.y + m_viewUsers.frame.size.height + 20;
     
        fy += 130;

        [m_scrollView setContentSize: CGSizeMake(m_scrollView.contentSize.width, fy)];
    }
     */
//    [m_scrollView setContentSize: CGSizeMake(m_scrollView.contentSize.width, m_viewMain.frame.origin.y + m_viewMain.frame.size.height)];
}

//==============================================================================================================
-(void) getUserList
{
    [SVProgressHUD showWithStatus:@"Loading ..." maskType:SVProgressHUDMaskTypeBlack];
    NSString* strURL = [@"https://pwcproject.com/v2/mobilepm/api/userlist" stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    
    NSLog(@"account_id = %@", [PWCGlobal getTheGlobal].account_id);
    NSLog(@"userhash = %@", [PWCGlobal getTheGlobal].hashKey);
    NSLog(@"project_id = %@", self.m_strProjectID);
    
    ASIFormDataRequest* request = [ASIFormDataRequest requestWithURL: [NSURL URLWithString: strURL]];
    [request setDelegate: self];
    [request setTimeOutSeconds: REQUEST_TIME_OUT];
    [request setPostValue: [PWCGlobal getTheGlobal].account_id forKey: @"account_id"];
    [request setPostValue: [PWCGlobal getTheGlobal].hashKey forKey: @"userhash"];
    [request setPostValue: self.m_strProjectID forKey: @"project_id"];
    
    [request setDidFinishSelector: @selector(finishedGetUserList:)];
    [request setDidFailSelector: @selector(failedSync:)];
    [request startAsynchronous];
}

//==============================================================================================================
-(void) finishedGetUserList: (ASIFormDataRequest*) theRequest
{
    [SVProgressHUD showSuccessWithStatus:@"Syncing Successful."];
    NSString* strResponse = [theRequest responseString];
    NSDictionary* dicList = [strResponse JSONValue];
    
    if(dicList != nil && [dicList isKindOfClass: [NSDictionary class]])
    {
        NSArray* arrList = [dicList allValues];
        NSString* people = @"";
        if(arrList != nil && [arrList count] > 0)
        {
            for(int i = 0; i < [arrList count]; i++)
            {
                NSDictionary* dicUser = [arrList objectAtIndex: i];
                if([[dicUser valueForKey: @"people"] isKindOfClass: [NSArray class]])
                {
                    NSArray* arrPeople = [dicUser valueForKey: @"people"];
                    if(arrPeople != nil && [arrPeople count] > 0)
                    {
                        for(int j = 0; j < [arrPeople count]; j++)
                        {
                            NSDictionary* dicPeople = [arrPeople objectAtIndex: j];
                            NSArray* arrTemp = [dicPeople allValues];
                            NSDictionary* dicTemp = [arrTemp objectAtIndex: 0];
                            [[DataManager sharedScoreManager] insertPMTaskPeople: [dicTemp valueForKey: @"tc_companyname"]
                                                                           tc_id: [dicTemp valueForKey: @"tc_id"]
                                                                     tc_ismaster: [dicTemp valueForKey: @"tc_ismaster"]
                                                                         tc_type: [dicTemp valueForKey: @"tc_type"]
                                                                    tp_firstname: [dicTemp valueForKey: @"tp_firstname"]
                                                                           tp_id: [dicTemp valueForKey: @"tp_id"]
                                                                     tp_lastname: [dicTemp valueForKey: @"tp_lastname"]
                                                                        selected: @"0"];
                            
                            if(people == nil || [people length] <=0 )
                            {
                                people = [dicTemp valueForKey: @"tp_id"];
                            }
                            else
                            {
                                people = [people stringByAppendingString: [NSString stringWithFormat: @",%@", [dicTemp valueForKey: @"tp_id"]]];
                            }
                        }
                        
                    }
                }
                else
                {
                    NSDictionary* dicPeople = [dicUser valueForKey: @"people"];
                    NSArray* arrTemp = [dicPeople allValues];
                    NSDictionary* dicTemp = [arrTemp objectAtIndex: 0];
                    [[DataManager sharedScoreManager] insertPMTaskPeople: [dicTemp valueForKey: @"tc_companyname"]
                                                                   tc_id: [dicTemp valueForKey: @"tc_id"]
                                                             tc_ismaster: [dicTemp valueForKey: @"tc_ismaster"]
                                                                 tc_type: [dicTemp valueForKey: @"tc_type"]
                                                            tp_firstname: [dicTemp valueForKey: @"tp_firstname"]
                                                                   tp_id: [dicTemp valueForKey: @"tp_id"]
                                                             tp_lastname: [dicTemp valueForKey: @"tp_lastname"]
                                                                selected: @"0"];
                    
                    if(people == nil || [people length] <=0 )
                    {
                        people = [dicTemp valueForKey: @"tp_id"];
                    }
                    else
                    {
                        people = [people stringByAppendingString: [NSString stringWithFormat: @",%@", [dicTemp valueForKey: @"tp_id"]]];
                    }
                }
                
                NSLog(@"people = %@", people);
                [[DataManager sharedScoreManager] insertPMTaskUserList: [dicUser valueForKey: @"tc_comapnyid"]
                                                        tc_companyname: [dicUser valueForKey: @"tc_companyname"]
                                                           tc_ismaster: [dicUser valueForKey: @"tc_ismaster"]
                                                               tc_type: [dicUser valueForKey: @"tc_type"]
                                                                people: people
                                                            project_id: self.m_strProjectID];
                
            }
        }
    }
}

//==============================================================================================================
-(void) failedSync: (ASIFormDataRequest*) theRequest
{
    [SVProgressHUD showSuccessWithStatus:@"Syncing Failed."];
}

//==============================================================================================================
-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear: animated];
    if([PWCGlobal getTheGlobal].m_gSelectedPriority != nil && [[PWCGlobal getTheGlobal].m_gSelectedPriority length] > 0)
    {
        [m_btnPriority setTitle: [PWCGlobal getTheGlobal].m_gSelectedPriority forState: UIControlStateNormal];
    }
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

#pragma mark -
#pragma mark UIPicker Delegate.

//==============================================================================================================
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if(m_nInputType == TASK_DURATION_INPUT_TYPE)
    {
        return 3;
    }

    return 1;
}

//==============================================================================================================
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent: (NSInteger)component
{
    if(m_nInputType == TASK_DURATION_INPUT_TYPE)
    {
        switch (component) {
            case 0:
                return 366;
                break;
                
            case 1:
                return 25;
                break;
                
            case 2:
                return 61;
                break;
                
            default:
                break;
        }
    }
    else if(m_nInputType == ASSIGN_TO_INPUT_TYPE)
    {
        return [m_arrAssignUser count];
    }
    else
    {
        return [m_arrPriority count];
    }
    
    return 0;
}

//==============================================================================================================
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if(m_nInputType == TASK_DURATION_INPUT_TYPE)
    {
        switch (component)
        {
            case 0:
                m_nSelectedDayDuration = row;
                break;
                
            case 1:
                m_nSelectedHourDuration = row;
                break;
                
            case 2:
                m_nSelectedMinuteDuration = row;
                break;
                
            default:
                break;
        }
        NSString* strDuration = [NSString stringWithFormat: @"%02i:%02i:%02i", m_nSelectedDayDuration, m_nSelectedHourDuration, m_nSelectedMinuteDuration];
        [m_btnTaskDuration setTitle: strDuration forState: UIControlStateNormal];
    }
    else if(m_nInputType == ASSIGN_TO_INPUT_TYPE)
    {
        NSDictionary* dicUser = [m_arrAssignUser objectAtIndex: row];
        NSString* strName = [NSString stringWithFormat: @"%@ %@", [dicUser valueForKey: @"tp_firstname"], [dicUser valueForKey: @"tp_lastname"]];
        [m_btnAssignedTo setTitle: strName forState: UIControlStateNormal];
    }
    else
    {
        [m_btnPriority setTitle: [m_arrPriority objectAtIndex: row] forState: UIControlStateNormal];
    }
}

//==============================================================================================================
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row   forComponent:(NSInteger)component
{
    if(m_nInputType == TASK_DURATION_INPUT_TYPE)
    {
        switch (component)
        {
            case 0:
                return [NSString stringWithFormat: @"%d Day(s)", row];
                break;
                
            case 1:
                return [NSString stringWithFormat: @"%d Hour(s)", row];
                break;
                
            case 2:
                return [NSString stringWithFormat: @"%d Min(s)", row];
                break;
                
            default:
                break;
        }
    }
    else if(m_nInputType == ASSIGN_TO_INPUT_TYPE)
    {
        NSDictionary* dicUser = [m_arrAssignUser objectAtIndex: row];
        NSString* strName = [NSString stringWithFormat: @"%@ %@", [dicUser valueForKey: @"tp_firstname"], [dicUser valueForKey: @"tp_lastname"]];
        return strName;
    }
    else
    {
        return [m_arrPriority objectAtIndex: row];
    }
    
    return @"";
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

#pragma mark -
#pragma mark Action Management.


//==============================================================================================================
-(IBAction) actionTaskDuration:(id)sender
{
    m_viewInput.hidden = NO;
    m_pickerDuration.hidden = NO;
    m_datePicker.hidden = YES;
    m_nInputType = TASK_DURATION_INPUT_TYPE;
    [m_pickerDuration reloadAllComponents];
    [m_pickerDuration selectRow:0 inComponent:0 animated:YES];
}

//==============================================================================================================
-(IBAction) actionAssignTo:(id)sender
{
    m_viewInput.hidden = NO;
    m_pickerDuration.hidden = NO;
    m_datePicker.hidden = YES;
    m_nInputType = ASSIGN_TO_INPUT_TYPE;
    [m_pickerDuration reloadAllComponents];
    [m_pickerDuration selectRow:0 inComponent:0 animated:YES];
}

//==============================================================================================================
-(IBAction) actionPriority:(id)sender
{
    m_viewInput.hidden = NO;
    m_pickerDuration.hidden = NO;
    m_datePicker.hidden = YES;
    m_nInputType = PRIORITY_INPUT_TYPE;
    [m_pickerDuration reloadAllComponents];
    [m_pickerDuration selectRow:0 inComponent:0 animated:YES];
}

//==============================================================================================================
-(IBAction) actionStartDate:(id)sender
{
    m_viewInput.hidden = NO;
    m_pickerDuration.hidden = YES;
    m_datePicker.hidden = NO;
    m_nDateType = 0;
    m_nInputType = DATE_INPUT_TYPE;
}

//==============================================================================================================
-(IBAction) actionEndDate:(id)sender
{
    m_viewInput.hidden = NO;
    m_pickerDuration.hidden = YES;
    m_datePicker.hidden = NO;
    m_nDateType = 1;
    m_nInputType = DATE_INPUT_TYPE;
}

//==============================================================================================================
-(IBAction) actionInputDone: (id) sender
{
    [m_txtNewListName resignFirstResponder];
    [m_txtFullDescription resignFirstResponder];
    [m_txtTask resignFirstResponder];
}

//==============================================================================================================
-(IBAction) actionDone:(id)sender
{
    m_viewInput.hidden = YES;
    if(m_nInputType == 1)
    {
        NSDate* date = m_datePicker.date;
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat: @"dd MMM, YYYY"];
        NSString* strDate = [formatter stringFromDate: date];
        
        if(m_nDateType == 0)
        {
            [m_btnStartDate setTitle: strDate forState: UIControlStateNormal];
        }
        else
        {
            [m_btnEndDate setTitle: strDate forState: UIControlStateNormal];
        }
    }
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
    NSString* newtasktitle = m_txtNewListName.text;
    NSString* tasktitle = m_txtTask.text;
    NSString* taskdescription = m_txtFullDescription.text;
    NSString* pathId = @"";
    NSString* taskduration = m_btnTaskDuration.titleLabel.text;
    NSString* taskstartdt = m_btnStartDate.titleLabel.text;
    NSString* taskenddt = m_btnEndDate.titleLabel.text;
    NSString* taskassignedto = [PWCGlobal getTheGlobal].m_gPMAddTaskSelectedAssignedTo;
    NSString* taskpriorityid = [self convertPriorityValue: [PWCGlobal getTheGlobal].m_gSelectedPriority];
    NSString* taskremind = @"";
    
    
    //Checking Validate.
    if(m_bAddNewList)
    {
        if(newtasktitle == nil || [newtasktitle length] <= 0)
        {
            [[PWCAppDelegate getDelegate] showMessage: @"Please Input New List Name."];
            return;
        }
    }
    
    if(tasktitle == nil || [tasktitle length] <= 0)
    {
        [[PWCAppDelegate getDelegate] showMessage: @"Please Input Task Title."];
        return;
    }

    if(taskdescription == nil || [taskdescription length] <= 0)
    {
        [[PWCAppDelegate getDelegate] showMessage: @"Please Input Task Description."];
        return;
    }

    if(taskassignedto == nil || [taskassignedto length] <= 0)
    {
        [[PWCAppDelegate getDelegate] showMessage: @"Please Assign this Task to proceed."];
        return;
    }
    
    if(taskpriorityid == nil || [taskpriorityid length] <= 0 || [taskpriorityid isEqualToString: @"0"])
    {
        [[PWCAppDelegate getDelegate] showMessage: @"Please Input Task Priority."];
        return;
    }
    
    NSLog(@"taskassignedto = %@", taskassignedto);
    
    [SVProgressHUD showWithStatus:@"Loading ..." maskType:SVProgressHUDMaskTypeBlack];
    NSString* strURL = [@"https://pwcproject.com/v2/mobilepm/api/addnewtask" stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    
    ASIFormDataRequest* request = [ASIFormDataRequest requestWithURL: [NSURL URLWithString: strURL]];
    [request setDelegate: self];
    [request setTimeOutSeconds: REQUEST_TIME_OUT];    
    [request setPostValue: [PWCGlobal getTheGlobal].account_id forKey: @"account_id"];
    [request setPostValue: [PWCGlobal getTheGlobal].hashKey forKey: @"userhash"];
    [request setPostValue: self.m_strProjectID forKey: @"project_id"];
    
    if(!m_bAddNewList)
    {
        [request setPostValue: self.m_strTitleID forKey: @"tasktitleId"];
    }
    else
    {
        [request setPostValue: newtasktitle forKey: @"newtasktitle"];
    }

    [request setPostValue: tasktitle forKey: @"tasktitle"];
    [request setPostValue: taskdescription forKey: @"taskdescription"];
    [request setPostValue: pathId forKey: @"pathId"];
    
    if(taskduration != nil && [taskduration length] > 0)
    {
        [request setPostValue: taskduration forKey: @"taskduration"];
    }
    
    if(taskstartdt != nil && [taskstartdt length] > 0)
    {
        [request setPostValue: taskstartdt forKey: @"taskstartdt"];
    }
    
    if(taskenddt != nil && [taskenddt length] > 0)
    {
        [request setPostValue: taskenddt forKey: @"taskenddt"];
    }
    
    [request setPostValue: taskassignedto forKey: @"taskasssigntoString"];
    [request setPostValue: taskpriorityid forKey: @"taskpriorityId"];
    [request setPostValue: taskremind forKey: @"taskremind"];
    
    [request setDidFinishSelector: @selector(finishedAddTask:)];
    [request setDidFailSelector: @selector(failedSync:)];
    [request startAsynchronous];
}

//==============================================================================================================
-(void) finishedAddTask: (ASIFormDataRequest*) theRequest
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
    [PWCGlobal getTheGlobal].m_gPMAddTaskSelectedAssignedTo = nil;
    
    [[DataManager sharedScoreManager] deleteAllPMTaskTitleByProjectID: self.m_strProjectID];
    [[DataManager sharedScoreManager] deleteAllPMTaskListsByProjectID: self.m_strProjectID title_id: self.m_strTitleID];
    [self.navigationController popViewControllerAnimated: YES];
}

//==============================================================================================================
-(NSString*) convertPriorityValue: (NSString*) strPriority
{
    if(strPriority == nil) return @"0";
        
    if([strPriority isEqualToString: @"Highest"])
    {
        return @"1";
    }
    if([strPriority isEqualToString: @"High"])
    {
        return @"2";
    }
    if([strPriority isEqualToString: @"Normal"])
    {
        return @"3";
    }
    if([strPriority isEqualToString: @"Low"])
    {
        return @"4";
    }
    if([strPriority isEqualToString: @"Lowest"])
    {
        return @"5";
    }

    return @"0";
}

//==============================================================================================================
@end
