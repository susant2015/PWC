//
//  PWCiPhoneScheduleAddServiceViewController.m
//  PWC
//
//  Created by Samiul Hoque on 9/3/13.
//  Copyright (c) 2013 Premium Web Cart. All rights reserved.
//

#import "PWCiPhoneScheduleAddServiceViewController.h"
#import "PWCGlobal.h"
#import "PWCSelectedServiceData.h"
#import "Base64.h"
#import "PWCServices.h"

@interface PWCiPhoneScheduleAddServiceViewController ()

@end

@implementation PWCiPhoneScheduleAddServiceViewController

@synthesize serviceRowId;
@synthesize selectedButton;
@synthesize unitDecimal;
@synthesize unitFraction;
@synthesize unitMinutes;
@synthesize participants;
@synthesize serviceType;

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
    
    NSLog(@"Service row id = %@", self.serviceRowId);
    //NSLog(@"All Services = %@", [PWCServices services].pwcServiceList);
    
    if ([self.serviceRowId isEqualToString:@"0"]) {
        [[PWCSelectedServiceData selectedService] resetFields];
        self.navigationItem.title = @"Add Service";
    } else {
        [[PWCSelectedServiceData selectedService] resetFields];
        for (NSDictionary *d in [PWCServices services].pwcServiceList) {
            if ([[d objectForKey:@"serviceRowId"] isEqualToString:self.serviceRowId]) {
                [self fillServiceData:d];
                NSLog(@"Found = %@", [d objectForKey:@"serviceRowId"]);
            }
            NSLog(@"Check = %@", [d objectForKey:@"serviceRowId"]);
        }
        self.navigationItem.title = @"Edit Service";
    }
    
    [self updateDisplay];
    
    self.unitDecimal = [[NSMutableArray alloc] init];
    self.unitFraction = [[NSMutableArray alloc] init];
    self.unitMinutes = [[NSMutableArray alloc] init];
    self.participants = [[NSMutableArray alloc] init];
    self.serviceType = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < 101; i++) {
        [self.unitDecimal addObject:[NSString stringWithFormat:@"%d", i]];
    }
    
    [self.unitFraction addObject:@".00"];
    [self.unitFraction addObject:@".25"];
    [self.unitFraction addObject:@".50"];
    [self.unitFraction addObject:@".75"];
    
    [self.unitMinutes addObject:@"00"];
    [self.unitMinutes addObject:@"30"];
    
    [self.participants addObject:@"Unlimited"];
    for (int i = 1; i < 101; i++) {
        [self.participants addObject:[NSString stringWithFormat:@"%d", i]];
    }
    
    [self.serviceType addObject:@"Variable"];
    [self.serviceType addObject:@"Event"];
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.tableView addGestureRecognizer:gestureRecognizer];
}

- (void)fillServiceData:(NSDictionary *)service
{
    [PWCSelectedServiceData selectedService].serviceRowId = [service objectForKey:@"serviceRowId"];
    
    [PWCSelectedServiceData selectedService].serviceName = [service objectForKey:@"serviceName"];
    NSArray *twoVal = [[service objectForKey:@"requiredUnit"] componentsSeparatedByString:@"."];
    [PWCSelectedServiceData selectedService].reqUnitDecimal = [twoVal objectAtIndex:0];
    [PWCSelectedServiceData selectedService].reqUnitFraction = [NSString stringWithFormat:@".%@", [twoVal objectAtIndex:1]];
    [PWCSelectedServiceData selectedService].maxParticipants = [service objectForKey:@"maxParticipants"];
    [PWCSelectedServiceData selectedService].unitCost = [service objectForKey:@"chargePerHour"];
    twoVal = [[service objectForKey:@"minDuration"] componentsSeparatedByString:@"."];
    [PWCSelectedServiceData selectedService].minDurationDecimal = [twoVal objectAtIndex:0];
    [PWCSelectedServiceData selectedService].minDurationFraction = [twoVal objectAtIndex:1];
    [PWCSelectedServiceData selectedService].serviceType = [service objectForKey:@"serviceType"];
    [PWCSelectedServiceData selectedService].description = [service objectForKey:@"description"];
    
    [PWCSelectedServiceData selectedService].editRuleDay = [service objectForKey:@"editRuleDay"];
    [PWCSelectedServiceData selectedService].editRuleHour = [service objectForKey:@"editRuleHour"];
    [PWCSelectedServiceData selectedService].cancelRuleDay = [service objectForKey:@"cancelRuleDay"];
    [PWCSelectedServiceData selectedService].cancelRuleHour = [service objectForKey:@"cancelRuleHour"];
    [PWCSelectedServiceData selectedService].termsAndConditions = [service objectForKey:@"termsAndConditions"];
    
    //Assigned Funnels
    NSString *temp = [service objectForKey:@"assignedFunnels"];
    if (temp != nil && [temp length] > 2) {
        temp = [temp substringToIndex:[temp length] - 1];
        temp = [temp substringFromIndex:1];
        NSArray *tmp = [temp componentsSeparatedByString:@"|"];
        for (NSString *s in tmp) {
            [[PWCSelectedServiceData selectedService].assignedFunnels addObject:s];
        }
    }

    //Removed Funnels
    temp = [service objectForKey:@"removedFunnels"];
    if (temp != nil && [temp length] > 2) {
        temp = [temp substringToIndex:[temp length] - 1];
        temp = [temp substringFromIndex:1];
        NSArray *tmp = [temp componentsSeparatedByString:@"|"];
        for (NSString *s in tmp) {
            [[PWCSelectedServiceData selectedService].removedFunnels addObject:s];
        }
    }
    
    //Assigned Tags
    temp = [service objectForKey:@"assignedTags"];
    if (temp != nil && [temp length] > 2) {
        temp = [temp substringToIndex:[temp length] - 1];
        temp = [temp substringFromIndex:1];
        NSArray *tmp = [temp componentsSeparatedByString:@"|"];
        for (NSString *s in tmp) {
            [[PWCSelectedServiceData selectedService].assignedTags addObject:s];
        }
    }
    
    //Removed Tags
    temp = [service objectForKey:@"removedTags"];
    if (temp != nil && [temp length] > 2) {
        temp = [temp substringToIndex:[temp length] - 1];
        temp = [temp substringFromIndex:1];
        NSArray *tmp = [temp componentsSeparatedByString:@"|"];
        for (NSString *s in tmp) {
            [[PWCSelectedServiceData selectedService].removedTags addObject:s];
        }
    }
}

- (void)updateDisplay
{
    self.serviceNameTxt.text = [PWCSelectedServiceData selectedService].serviceName;
    [self.reqUnitDecimalBtn setTitle:[PWCSelectedServiceData selectedService].reqUnitDecimal forState:UIControlStateNormal];
    [self.reqUnitFractionBtn setTitle:[PWCSelectedServiceData selectedService].reqUnitFraction forState:UIControlStateNormal];
    
    if ([[PWCSelectedServiceData selectedService].maxParticipants isEqualToString:@"0"]) {
        [self.maxParticipantsBtn setTitle:@"Unlimited" forState:UIControlStateNormal];
    } else {
        [self.maxParticipantsBtn setTitle:[PWCSelectedServiceData selectedService].maxParticipants forState:UIControlStateNormal];
    }
    
    [self.minDurationDecimalBtn setTitle:[PWCSelectedServiceData selectedService].minDurationDecimal forState:UIControlStateNormal];
    [self.minDurationFractionBtn setTitle:[PWCSelectedServiceData selectedService].minDurationFraction forState:UIControlStateNormal];
    
    if ([[PWCSelectedServiceData selectedService].serviceType isEqualToString:@"2"]) {
        [self.serviceTypeBtn setTitle:@"Event" forState:UIControlStateNormal];
    } else {
        [self.serviceTypeBtn setTitle:@"Variable" forState:UIControlStateNormal];
    }
    
    if ([[PWCSelectedServiceData selectedService].description length] > 0) {
        self.descriptionTxt.text = [[PWCSelectedServiceData selectedService].description base64DecodedString];
    } else {
        self.descriptionTxt.text = @"";
    }
}

- (void)updateValues
{
    [PWCSelectedServiceData selectedService].serviceName = self.serviceNameTxt.text;
    [PWCSelectedServiceData selectedService].reqUnitDecimal = self.reqUnitDecimalBtn.titleLabel.text;
    [PWCSelectedServiceData selectedService].reqUnitFraction = self.reqUnitFractionBtn.titleLabel.text;
    
    if ([self.maxParticipantsBtn.titleLabel.text isEqualToString:@"Unlimited"]) {
        [PWCSelectedServiceData selectedService].maxParticipants = @"0";
    } else {
        [PWCSelectedServiceData selectedService].maxParticipants = self.maxParticipantsBtn.titleLabel.text;
    }
    
    [PWCSelectedServiceData selectedService].minDurationDecimal = self.minDurationDecimalBtn.titleLabel.text;
    [PWCSelectedServiceData selectedService].minDurationFraction = self.minDurationFractionBtn.titleLabel.text;
    
    if ([self.serviceTypeBtn.titleLabel.text isEqualToString:@"Event"]) {
        [PWCSelectedServiceData selectedService].serviceType  = @"2";
    } else {
        [PWCSelectedServiceData selectedService].serviceType = @"1";
    }
    
    if ([self.descriptionTxt.text length] > 0) {
        [PWCSelectedServiceData selectedService].description = [self.descriptionTxt.text base64EncodeString];
    } else {
        [PWCSelectedServiceData selectedService].description = @"";
    }
    
    /*
    NSLog(@"");
    NSLog(@"Updated values:");
    NSLog(@"Service Name: %@", [PWCSelectedServiceData selectedService].serviceName);
    NSLog(@"Req Decimal: %@", [PWCSelectedServiceData selectedService].reqUnitDecimal);
    NSLog(@"Req Fraction: %@", [PWCSelectedServiceData selectedService].reqUnitFraction);
    NSLog(@"Max Participants: %@", [PWCSelectedServiceData selectedService].maxParticipants);
    NSLog(@"Min Decimal: %@", [PWCSelectedServiceData selectedService].minDurationDecimal);
    NSLog(@"Min Fraction: %@", [PWCSelectedServiceData selectedService].minDurationFraction);
    NSLog(@"Service Type: %@", [PWCSelectedServiceData selectedService].serviceType);
     */
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createActionSheet
{
    [self hideKeyboard];
    
    if ([self.selectedButton isEqualToString:@"reqUnitDec"]) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Select required units"
                                                                 delegate:self
                                                        cancelButtonTitle:nil
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:nil];
        
        for (NSString *s in self.unitDecimal) {
            [actionSheet addButtonWithTitle:s];
        }
        
        [actionSheet addButtonWithTitle:@"Cancel"];
        actionSheet.cancelButtonIndex = actionSheet.numberOfButtons - 1;
        
        [actionSheet showInView:[self.view superview]];
    } else if ([self.selectedButton isEqualToString:@"reqUnitFrac"]) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Select required units"
                                                                 delegate:self
                                                        cancelButtonTitle:nil
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:nil];
        
        for (NSString *s in self.unitFraction) {
            [actionSheet addButtonWithTitle:s];
        }
        
        [actionSheet addButtonWithTitle:@"Cancel"];
        actionSheet.cancelButtonIndex = actionSheet.numberOfButtons - 1;
        
        [actionSheet showInView:[self.view superview]];
    } else if ([self.selectedButton isEqualToString:@"maxPart"]) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Select maxumum participants"
                                                                 delegate:self
                                                        cancelButtonTitle:nil
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:nil];
        
        for (NSString *s in self.participants) {
            [actionSheet addButtonWithTitle:s];
        }
        
        [actionSheet addButtonWithTitle:@"Cancel"];
        actionSheet.cancelButtonIndex = actionSheet.numberOfButtons - 1;
        
        [actionSheet showInView:[self.view superview]];
    } else if ([self.selectedButton isEqualToString:@"minDurDec"]) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Select hours"
                                                                 delegate:self
                                                        cancelButtonTitle:nil
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:nil];
        
        for (NSString *s in self.unitDecimal) {
            [actionSheet addButtonWithTitle:s];
        }
        
        [actionSheet addButtonWithTitle:@"Cancel"];
        actionSheet.cancelButtonIndex = actionSheet.numberOfButtons - 1;
        
        [actionSheet showInView:[self.view superview]];
    } else if ([self.selectedButton isEqualToString:@"minDurFrac"]) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Select minutes"
                                                                 delegate:self
                                                        cancelButtonTitle:nil
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:nil];
        
        NSLog(@"%@",self.unitMinutes);
        for (NSString *s in self.unitMinutes) {
            [actionSheet addButtonWithTitle:s];
        }
        
        [actionSheet addButtonWithTitle:@"Cancel"];
        actionSheet.cancelButtonIndex = actionSheet.numberOfButtons - 1;
        
        [actionSheet showInView:[self.view superview]];
    } else if ([self.selectedButton isEqualToString:@"servType"]) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Select service type"
                                                                 delegate:self
                                                        cancelButtonTitle:nil
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:nil];
        
        for (NSString *s in self.serviceType) {
            [actionSheet addButtonWithTitle:s];
        }
        
        [actionSheet addButtonWithTitle:@"Cancel"];
        actionSheet.cancelButtonIndex = actionSheet.numberOfButtons - 1;
        
        [actionSheet showInView:[self.view superview]];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == actionSheet.cancelButtonIndex) {
        self.selectedButton = @"";
        return;
    }
    
    if ([self.selectedButton isEqualToString:@"reqUnitDec"]) {
        [PWCSelectedServiceData selectedService].reqUnitDecimal = [self.unitDecimal objectAtIndex:buttonIndex];
    } else if ([self.selectedButton isEqualToString:@"reqUnitFrac"]) {
        [PWCSelectedServiceData selectedService].reqUnitFraction = [self.unitFraction objectAtIndex:buttonIndex];
    } else if ([self.selectedButton isEqualToString:@"maxPart"]) {
        [PWCSelectedServiceData selectedService].maxParticipants = [NSString stringWithFormat:@"%d", buttonIndex];
    } else if ([self.selectedButton isEqualToString:@"minDurDec"]) {
        [PWCSelectedServiceData selectedService].minDurationDecimal = [self.unitDecimal objectAtIndex:buttonIndex];
    } else if ([self.selectedButton isEqualToString:@"minDurFrac"]) {
        [PWCSelectedServiceData selectedService].minDurationFraction = [self.unitMinutes objectAtIndex:buttonIndex];
    } else if ([self.selectedButton isEqualToString:@"servType"]) {
        [PWCSelectedServiceData selectedService].serviceType = [NSString stringWithFormat:@"%d", (buttonIndex+1)];
    }
    
    self.selectedButton = @"";
    [self updateDisplay];
}

- (void)hideKeyboard
{
    [self.serviceNameTxt resignFirstResponder];
    [self.descriptionTxt resignFirstResponder];
    
    [self updateValues];
}

- (IBAction)reqUnitDecClick:(id)sender {
    self.selectedButton = @"reqUnitDec";
    [self createActionSheet];
}

- (IBAction)reqUnitFracClick:(id)sender {
    self.selectedButton = @"reqUnitFrac";
    [self createActionSheet];
}

- (IBAction)maxPartClick:(id)sender {
    self.selectedButton = @"maxPart";
    [self createActionSheet];
}

- (IBAction)minDurDecClick:(id)sender {
    self.selectedButton = @"minDurDec";
    [self createActionSheet];
}

- (IBAction)minDurFracClick:(id)sender {
    self.selectedButton = @"minDurFrac";
    [self createActionSheet];
}

- (IBAction)servTypeClick:(id)sender {
    self.selectedButton = @"servType";
    [self createActionSheet];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [self updateValues];
}

@end
