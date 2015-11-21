//
//  PWCChangeStatusViewController.m
//  PWC
//
//  Created by JianJinHu on 8/3/13.
//  Copyright (c) 2013 Premium Web Cart. All rights reserved.
//

#import "PWCChangeStatusViewController.h"
#import "PWCAppDelegate.h"
#import "PWCGlobal.h"
#import "PWCCRMGlobal.h"
#import "JSON.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"

@interface PWCChangeStatusViewController ()

@end

@implementation PWCChangeStatusViewController
@synthesize task_id;
@synthesize task_status;

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
}

//==============================================================================================================
-(void) initMember
{
    task_status = 0;
    m_rectReassign = m_viewReassignedTo.frame;
    m_rectReschedule = m_viewReschedule.frame;
}

#pragma mark - 
#pragma mark Action Management.

//==============================================================================================================
-(IBAction) actionInputViewDone:(id)sender
{
    m_viewInputView.hidden = YES;
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat: @"yyyy-MM-dd"];
    
    NSDate* date = m_datePicker.date;
    NSString* strDate = [formatter stringFromDate: date];
    if(m_nDateType == 0)
    {
        [m_btnDateFrom setTitle: strDate forState: UIControlStateNormal];
    }
    else
    {
        [m_btnDateTo setTitle: strDate forState: UIControlStateNormal];
    }
}

//==============================================================================================================
-(IBAction) actionDone:(id)sender
{
    if(task_status == nil || [task_status length] <= 0)
    {
        [[PWCAppDelegate getDelegate] showMessage: @"You have to select the status"];
        return;
    }
    
    int reassigned_id = 0;
    if([task_status isEqualToString: @"Reassign and Reschedule"] || [task_status isEqualToString: @"Reassign"])
    {
        if([PWCGlobal getTheGlobal].m_gSelectedAdminID <= 0)
        {
            [[PWCAppDelegate getDelegate] showMessage: @"You have to select the reassigned user."];
            return;
        }
        
        reassigned_id = [PWCGlobal getTheGlobal].m_gSelectedAdminID;
        [PWCGlobal getTheGlobal].m_gUpdatedReasiggnedUserId = [NSString stringWithFormat: @"%d", reassigned_id];
    }
    
    if([task_status isEqualToString: @"Reassign and Reschedule"] || [task_status isEqualToString: @"Reschedule"])
    {
        [PWCGlobal getTheGlobal].m_gUpdatedRescheduleFromDate = m_btnDateFrom.titleLabel.text;
        [PWCGlobal getTheGlobal].m_gUpdatedRescheduleToDate = m_btnDateTo.titleLabel.text;

    }

    [PWCGlobal getTheGlobal].m_gUpdatedTaskStatus = task_status;
    NSLog(@"[PWCGlobal getTheGlobal].m_gUpdatedTaskStatus = %@", [PWCGlobal getTheGlobal].m_gUpdatedTaskStatus);
    [self.navigationController popViewControllerAnimated: YES];
}

//==============================================================================================================
-(IBAction) actionStatus
{
    UIActionSheet* sheet = [[UIActionSheet alloc] initWithTitle: nil
                                                       delegate: self
                                              cancelButtonTitle: @"Cancel"
                                         destructiveButtonTitle: nil
                                              otherButtonTitles: @"Reassign", @"Reschedule", @"Reassign and Reschedule", @"Completed", @"Close", nil];
    [sheet showInView: self.view];
}

//==============================================================================================================
-(IBAction) actionDate: (UIButton*) btn
{
    m_nDateType = btn.tag;
    m_viewInputView.hidden = NO;
}

#pragma mark - 
#pragma mark UIActionSheet Delegate.

//==============================================================================================================
-(IBAction) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"button Index = %d", buttonIndex);
    switch (buttonIndex)
    {
        //Reassign
        case 0:
            [m_btnStatus setTitle: @"Reassign" forState: UIControlStateNormal];
            m_viewReassignedTo.frame = m_rectReassign;
            m_viewReassignedTo.hidden = NO;
            m_viewReschedule.hidden = YES;
            task_status = @"Reassign";
            break;

        //Reschedule
        case 1:
            [m_btnStatus setTitle: @"Reschedule" forState: UIControlStateNormal];
            m_viewReschedule.frame = CGRectMake(m_viewReassignedTo.frame.origin.x, m_viewReassignedTo.frame.origin.y,
                                                m_viewReschedule.frame.size.width, m_viewReschedule.frame.size.height);
            m_viewReassignedTo.hidden = YES;
            m_viewReschedule.hidden = NO;
            task_status = @"Reschedule";
            break;

        //Reassign and Reschedule
        case 2:
            [m_btnStatus setTitle: @"Reassign and Reschedule" forState: UIControlStateNormal];
            m_viewReassignedTo.frame = m_rectReassign;
            m_viewReschedule.frame = m_rectReschedule;
            m_viewReassignedTo.hidden = NO;
            m_viewReschedule.hidden = NO;
            task_status = @"Reassign and Reschedule";
            break;

        //Completed
        case 3:
            [m_btnStatus setTitle: @"Completed" forState: UIControlStateNormal];
            m_viewReassignedTo.hidden = YES;
            m_viewReschedule.hidden = YES;
            task_status = @"Completed";
            break;

         //Closed
        case 4:
            [m_btnStatus setTitle: @"Closed" forState: UIControlStateNormal];
            m_viewReassignedTo.hidden = YES;
            m_viewReschedule.hidden = YES;
            task_status = @"Closed";
            break;

        default:
            break;
    }
}

//==============================================================================================================
@end
