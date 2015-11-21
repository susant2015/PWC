//
//  PWCCRMSaveNewLeadViewController.m
//  PWC
//
//  Created by JianJinHu on 8/13/13.
//  Copyright (c) 2013 Premium Web Cart. All rights reserved.
//

#import "PWCCRMSaveNewLeadViewController.h"
#import "PWCGlobal.h"
#import "ASIFormDataRequest.h"
#import "PWCCRMGlobal.h"
#import "JSON.h"
#import "PWCiPhoneScheduleCustomersViewController.h"

@interface PWCCRMSaveNewLeadViewController ()

@end

@implementation PWCCRMSaveNewLeadViewController
@synthesize m_newLead;

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
    [self submitNewLead];
}

//==============================================================================================================
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//==============================================================================================================
-(void) submitNewLead
{
    [SVProgressHUD showWithStatus:@"Loading ..." maskType:SVProgressHUDMaskTypeBlack];
    NSString* strURL = [NSString stringWithFormat: @"%@savenewlead", SERVER_PENDNG_BASE_URL];
    NSLog(@"general_country = %@", m_newLead.general_country);
    NSLog(@"general_title = %@", m_newLead.general_title);
    NSLog(@"general_first_name = %@", m_newLead.general_first_name);
    NSLog(@"general_last_name = %@", m_newLead.general_last_name);
    NSLog(@"general_phone = %@", m_newLead.general_phone);
    NSLog(@"general_mobile = %@", m_newLead.general_mobile);
    NSLog(@"general_email = %@", m_newLead.general_email);
    
    //
    NSLog(@"business_country = %@", m_newLead.business_country);
    NSLog(@"business_company_name = %@", m_newLead.business_company_name);
    NSLog(@"business_job_title = %@", m_newLead.business_job_title);
    NSLog(@"business_company_phone = %@", m_newLead.business_company_phone);
    NSLog(@"business_address = %@", m_newLead.business_address);
    NSLog(@"business_city = %@", m_newLead.business_city);
    NSLog(@"business_zip = %@", m_newLead.business_zip);
    NSLog(@"business_state = %@", m_newLead.business_state);
    NSLog(@"business_fax = %@", m_newLead.business_fax);
    NSLog(@"business_website = %@", m_newLead.business_website);
    
    NSLog(@"home_country = %@", m_newLead.home_country);
    NSLog(@"home_phone = %@", m_newLead.home_phone);
    NSLog(@"home_address = %@", m_newLead.home_address);
    NSLog(@"home_city = %@", m_newLead.home_city);
    NSLog(@"home_zip = %@", m_newLead.home_zip);
    NSLog(@"home_state = %@", m_newLead.home_state);

    NSLog(@"isportalcustomer = %@", m_newLead.isportalcustomer);    
    NSLog(@"unitint = %@", m_newLead.unitint);
    NSLog(@"unitdec = %@", m_newLead.unitdec);
    
    NSLog(@"salespaths = %@", m_newLead.salespaths);
    NSLog(@"tags = %@", m_newLead.tags);

    NSLog(@"primary_role_id = %@", m_newLead.primary_role_id);
    NSLog(@"secondary_role_id = %@", m_newLead.secondary_role_id);
    NSLog(@"support_role_id = %@", m_newLead.support_role_id);
    NSLog(@"assignedto_role_id = %@", m_newLead.assignedto_role_id);
    
    
    ASIFormDataRequest* request = [ASIFormDataRequest requestWithURL: [NSURL URLWithString: strURL]];
    [request setDelegate: self];
    [request setTimeOutSeconds: REQUEST_TIME_OUT];    
    [request setPostValue: m_newLead.general_country forKey: @"general_country"];
    [request setPostValue: m_newLead.general_title forKey: @"general_title"];
    [request setPostValue: m_newLead.general_first_name forKey: @"general_first_name"];
    [request setPostValue: m_newLead.general_last_name forKey: @"general_last_name"];
    [request setPostValue: m_newLead.general_phone forKey: @"general_phone"];
    [request setPostValue: m_newLead.general_mobile forKey: @"general_mobile"];
    [request setPostValue: m_newLead.general_email forKey: @"general_email"];
    
    [request setPostValue: m_newLead.business_country forKey: @"business_country"];
    [request setPostValue: m_newLead.business_company_name forKey: @"business_company_name"];
    [request setPostValue: m_newLead.business_job_title forKey: @"business_job_title"];
    [request setPostValue: m_newLead.business_company_phone forKey: @"business_company_phone"];
    [request setPostValue: m_newLead.business_address forKey: @"business_address"];
    [request setPostValue: m_newLead.business_city forKey: @"business_city"];
    [request setPostValue: m_newLead.business_zip forKey: @"business_zip"];
    [request setPostValue: m_newLead.business_state forKey: @"business_state"];
    [request setPostValue: m_newLead.business_fax forKey: @"business_fax"];
    [request setPostValue: m_newLead.business_website forKey: @"business_website"];
    
    [request setPostValue: m_newLead.home_country forKey: @"home_country"];
    [request setPostValue: m_newLead.home_phone forKey: @"home_phone"];
    [request setPostValue: m_newLead.home_address forKey: @"home_address"];
    [request setPostValue: m_newLead.home_city forKey: @"home_city"];
    [request setPostValue: m_newLead.home_zip forKey: @"home_zip"];
    [request setPostValue: m_newLead.home_state forKey: @"home_state"];
    
    [request setPostValue: m_newLead.salespaths forKey: @"salespaths"];
    [request setPostValue: m_newLead.tags forKey: @"tags"];
    
    [request setPostValue: m_newLead.primary_role_id forKey: @"primary_role_id"];
    [request setPostValue: m_newLead.secondary_role_id forKey: @"secondary_role_id"];
    [request setPostValue: m_newLead.support_role_id forKey: @"support_role_id"];
    [request setPostValue: m_newLead.assignedto_role_id forKey: @"assignedto_role_id"];

    [request setPostValue: m_newLead.isportalcustomer forKey: @"isportalcustomer"];
    [request setPostValue: m_newLead.unitint forKey: @"unitint"];
    [request setPostValue: m_newLead.unitdec forKey: @"unitdec"];
    
    [request setPostValue: [PWCGlobal getTheGlobal].coachRowId forKey: @"coach_row_id"];
    [request setPostValue: [PWCGlobal getTheGlobal].merchantId forKey: @"merchantid"];
    [request setPostValue: @"C3ndt46Ydjh4ghsdy74hfh38rbchdfy7=" forKey: @"apikey"];
    
    [request setDidFinishSelector: @selector(finishedSubmitNewLead:)];
    [request setDidFailSelector: @selector(failedRequest:)];
    [request startAsynchronous];
}

//==============================================================================================================
-(void) finishedSubmitNewLead: (ASIFormDataRequest*) theRequest
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
-(IBAction) actionBackCustomer:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated: YES];

//    PWCiPhoneScheduleCustomersViewController* nextView = [self.storyboard instantiateViewControllerWithIdentifier: @"customer_list"];
//    [self.navigationController pushViewController: nextView animated: YES];
}

//==============================================================================================================

@end
