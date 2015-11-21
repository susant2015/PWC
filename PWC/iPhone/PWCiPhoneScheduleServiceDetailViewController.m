//
//  PWCiPhoneScheduleServiceDetailViewController.m
//  PWC
//
//  Created by Samiul Hoque on 7/24/13.
//  Copyright (c) 2013 Premium Web Cart. All rights reserved.
//

#import "PWCiPhoneScheduleServiceDetailViewController.h"
#import "Base64.h"
#import "PWCiPhoneScheduleAddServiceViewController.h"

@interface PWCiPhoneScheduleServiceDetailViewController ()

@end

@implementation PWCiPhoneScheduleServiceDetailViewController

@synthesize serviceInfo;

@synthesize serviceNameLbl;
@synthesize maxParticipantsLbl;
@synthesize minDurationLbl;
@synthesize reqUnitLbl;
@synthesize serviceTypeLbl;
@synthesize descriptionTxtView;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    NSLog(@"Service Data: %@", serviceInfo);
    
    self.serviceNameLbl.text = [serviceInfo objectForKey:@"serviceName"];
    
    if ([[serviceInfo objectForKey:@"maxParticipants"] isEqualToString:@"0"]) {
        self.maxParticipantsLbl.text = @"Unlimited";
    } else {
        self.maxParticipantsLbl.text = [serviceInfo objectForKey:@"maxParticipants"];
    }
    
    NSString *unit = @"Hour";
    if ([[serviceInfo objectForKey:@"minDuration"] floatValue] > 1.00) {
        unit = @"Hours";
    }
    self.minDurationLbl.text = [NSString stringWithFormat:@"%@ %@", [serviceInfo objectForKey:@"minDuration"], unit];
    
    unit = @"Unit";
    if ([[serviceInfo objectForKey:@"requiredUnit"] floatValue] > 1.00) {
        unit = @"Units";
    }
    self.reqUnitLbl.text = [NSString stringWithFormat:@"%@ %@", [serviceInfo objectForKey:@"requiredUnit"], unit];
    
    if ([[serviceInfo objectForKey:@"serviceType"] isEqualToString:@"2"]) {
        self.serviceTypeLbl.text = @"Fixed";
    } else {
        self.serviceTypeLbl.text = @"Variable";
    }
    
    self.descriptionTxtView.text = [[serviceInfo objectForKey:@"description"] base64DecodedString];
    
    self.chargePerUnitLbl.text = [NSString stringWithFormat:@"$%@", [serviceInfo objectForKey:@"chargePerHour"]];
    
    NSString *dayUnit = @"Day";
    if ([[serviceInfo objectForKey:@"editRuleDay"] floatValue] > 1.00) {
        dayUnit = @"Days";
    }
    NSString *hourUnit = @"Hour";
    if ([[serviceInfo objectForKey:@"editRuleHour"] floatValue] > 1.00) {
        hourUnit = @"Hours";
    }
    
    self.editRuleLbl.text = [NSString stringWithFormat:@"%@ %@ %@ %@", [serviceInfo objectForKey:@"editRuleDay"], dayUnit, [serviceInfo objectForKey:@"editRuleHour"], hourUnit];
    
    dayUnit = @"Day";
    if ([[serviceInfo objectForKey:@"cancelRuleDay"] floatValue] > 1.00) {
        dayUnit = @"Days";
    }
    hourUnit = @"Hour";
    if ([[serviceInfo objectForKey:@"cancelRuleHour"] floatValue] > 1.00) {
        hourUnit = @"Hours";
    }
    
    self.cancelRuleLbl.text = [NSString stringWithFormat:@"%@ %@ %@ %@", [serviceInfo objectForKey:@"cancelRuleDay"], dayUnit, [serviceInfo objectForKey:@"cancelRuleHour"], hourUnit];
    
    self.termsTxtView.text = [[serviceInfo objectForKey:@"termsAndConditions"] base64DecodedString];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"editServiceSegue"]) {
        PWCiPhoneScheduleAddServiceViewController *dest = segue.destinationViewController;
        dest.serviceRowId = [serviceInfo objectForKey:@"serviceRowId"];
    }
}

@end
