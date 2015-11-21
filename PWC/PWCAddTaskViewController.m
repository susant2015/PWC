//
//  PWCAddTaskViewController.m
//  PWC
//
//  Created by JianJinHu on 11/7/13.
//  Copyright (c) 2013 Premium Web Cart. All rights reserved.
//

#import "PWCAddTaskViewController.h"
#import "PWCCRMRoleSelViewController.h"
#import "PWCGlobal.h"
#import "PWCAppDelegate.h"
#import "ASIFormDataRequest.h"
#import "JSON.h"

@interface PWCAddTaskViewController ()

@end

#define DUE_DATE            1
#define DUE_TIME            2

@implementation PWCAddTaskViewController
@synthesize m_strSelDate;

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
    
    [m_txtReason setInputAccessoryView: m_toolbar];
    m_arrCustomers = [[NSMutableArray alloc] init];
}

//==============================================================================================================
-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear: animated];
    if([PWCGlobal getTheGlobal].m_gSelectedAssignedName != nil)
    {
        m_lblAssignedTo.text = [PWCGlobal getTheGlobal].m_gSelectedAssignedName;
    }
    
    if([PWCGlobal getTheGlobal].m_gSelectedCustomerName != nil)
    {
        m_lblCustomer.text = [PWCGlobal getTheGlobal].m_gSelectedCustomerName;
    }
    
    if([PWCGlobal getTheGlobal].m_gSelectedTaskName != nil)
    {
        m_lblTask.text = [PWCGlobal getTheGlobal].m_gSelectedTaskName;
    }
}

//==============================================================================================================
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Picker Delegate.

//=================================================================================================================================
-(NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

//=================================================================================================================================
-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [m_arrCustomers count];
}

//=================================================================================================================================
- (UIView*) pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel* label = [[UILabel alloc] initWithFrame: CGRectMake(0, 0, 320, 30)];
    label.backgroundColor = [UIColor clearColor];
    [label setFont: [UIFont boldSystemFontOfSize: 20]];
    
    NSString* str = [m_arrCustomers objectAtIndex: row];
    label.text = str;
    label.textAlignment = NSTextAlignmentCenter;;
    return label;
}

//=================================================================================================================================
-(NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString* str = [m_arrCustomers objectAtIndex: row];
    return str;
}

//=================================================================================================================================
-(void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{

}

#pragma mark - 
#pragma mark UITextField Delegate.

//===============================================================================================================================
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    m_fScrollHeight = m_scrollView.contentSize.height;
    m_scrollView.contentSize = CGSizeMake(0, m_fScrollHeight + 300);
    [m_scrollView setContentOffset:CGPointMake(0, 300) animated: YES];
}

//===============================================================================================================================
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    m_scrollView.contentSize = CGSizeMake(0, m_fScrollHeight);
}

#pragma mark - 
#pragma mark Action Management.

//==============================================================================================================
-(IBAction) actionDone:(id)sender
{
    if([PWCGlobal getTheGlobal].m_gSelectedCustomerID <= 0)
    {
        [[PWCAppDelegate getDelegate] showMessage: @"Please Select A Customer"];
        return;
    }
    
    if([PWCGlobal getTheGlobal].m_gSelectedTaskID <= 0)
    {
        [[PWCAppDelegate getDelegate] showMessage: @"Please Select A Task"];
        return;
    }
    
    if([PWCGlobal getTheGlobal].m_gSelectedAssignedID <= 0)
    {
        [[PWCAppDelegate getDelegate] showMessage: @"Please Select A User"];
        return;
    }
    
    NSString* dueDate = m_lblDueDate.text;
    NSString* dueTime = m_lblDueTime.text;
    
    if(dueDate == nil || [dueDate length] <= 0)
    {
        [[PWCAppDelegate getDelegate] showMessage: @"Please Select Date"];
        return;
    }
    
    if(dueTime == nil || [dueTime length] <= 0)
    {
        [[PWCAppDelegate getDelegate] showMessage: @"Please Select Time"];
        return;
    }

    [SVProgressHUD showWithStatus:@"Loading ..." maskType:SVProgressHUDMaskTypeBlack];
    
    NSString* reason = m_txtReason.text;
    NSString* strURL = @"http://pwccrm.com/beta/api2/api/savetask";
    ASIFormDataRequest* request = [ASIFormDataRequest requestWithURL: [NSURL URLWithString: strURL]];
    [request setDelegate: self];
    [request setTimeOutSeconds: REQUEST_TIME_OUT];    
    [request setPostValue: [NSString stringWithFormat: @"%d", [PWCGlobal getTheGlobal].m_gSelectedCustomerID] forKey: @"customer_id"];
    [request setPostValue: [NSString stringWithFormat: @"%d", [PWCGlobal getTheGlobal].m_gSelectedTaskID] forKey: @"task_id"];
    [request setPostValue: [NSString stringWithFormat: @"%d", [PWCGlobal getTheGlobal].m_gSelectedAssignedID] forKey: @"admin_id"];
    [request setPostValue: self.m_strSelDate forKey: @"due_date"];
    [request setPostValue: dueTime forKey: @"due_time"];
    
    if(reason != nil && [reason length] > 0)
    {
        [request setPostValue: reason forKey: @"reason"];
    }
    
    [request setDidFinishSelector: @selector(finishedNewTask:)];
    [request setDidFailSelector: @selector(failedRequest:)];
    [request startAsynchronous];
}

//==============================================================================================================
-(void) finishedNewTask: (ASIFormDataRequest*) theRequest
{
    [SVProgressHUD showSuccessWithStatus:@"Syncing Successful."];
    NSString* strResponse = [theRequest responseString];
    NSDictionary* dic = [strResponse JSONValue];
    NSLog(@"Result = %@", dic);
}

//==============================================================================================================
-(void) failedRequest: (ASIFormDataRequest*) theRequest
{
    [SVProgressHUD showSuccessWithStatus:@"Syncing Failed."];
}

//==============================================================================================================
-(IBAction) actionCancel:(id)sender
{
    [self.navigationController popViewControllerAnimated: YES];
}

//==============================================================================================================
-(IBAction) actionTextDone:(id)sender
{
    [m_txtReason resignFirstResponder];
}

//==============================================================================================================
-(IBAction) actionInputDone:(id)sender
{
    m_viewInput.hidden = YES;
    switch (m_nItemSelectionIndex)
    {
        case DUE_DATE:
        {
            NSDate* date = m_datePicker.date;
            NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat: @"dd MMM YYYY"];
            NSString* strDate = [formatter stringFromDate: date];
            m_lblDueDate.text = strDate;
            
            [formatter setDateFormat: @"yyyy-MM-dd"];
            self.m_strSelDate = [formatter stringFromDate: date];
            NSLog(@"self.m_strSelDate = %@", self.m_strSelDate);
        }
            break;
            
        case DUE_TIME:
        {
            NSDate* date = m_datePicker.date;
            NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat: @"HH:mm a"];
            NSString* strDate = [formatter stringFromDate: date];
            m_lblDueTime.text = strDate;
        }
            break;
            
        default:
            break;
    }
}

//==============================================================================================================
-(IBAction) actionCustomer:(id)sender
{
    
}

//==============================================================================================================
-(IBAction) actionTask:(id)sender
{
//    if(!m_viewInput.hidden) return;
//    m_viewInput.hidden = NO;
//    m_datePicker.hidden = YES;
//    m_picker.hidden = NO;
}

//==============================================================================================================
-(IBAction) actionAsignedTo:(id)sender
{
}

//==============================================================================================================
-(IBAction) actionDueDate:(id)sender
{
    if(!m_viewInput.hidden) return;
    m_viewInput.hidden = NO;
    m_datePicker.hidden = NO;
    m_picker.hidden = YES;
    
    [m_datePicker setDatePickerMode: UIDatePickerModeDate];
    m_nItemSelectionIndex = DUE_DATE;
}

//==============================================================================================================
-(IBAction) actionDueTime:(id)sender
{
    if(!m_viewInput.hidden) return;    
    m_viewInput.hidden = NO;
    m_datePicker.hidden = NO;
    m_picker.hidden = YES;
    
    [m_datePicker setDatePickerMode: UIDatePickerModeTime];
    m_nItemSelectionIndex = DUE_TIME;
}

#pragma mark - 
#pragma mark Segue

//==============================================================================================================
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    PWCCRMRoleSelViewController *nextView = segue.destinationViewController;
    if([segue.identifier isEqualToString: @"customer_segue"])
    {
        nextView.m_nType = 4;
    }
    else if([segue.identifier isEqualToString: @"task_segue"])
    {
        nextView.m_nType = 5;
    }
    else
    {
        nextView.m_nType = 3;
    }

}

//==============================================================================================================
@end
