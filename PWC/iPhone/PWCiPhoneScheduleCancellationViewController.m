//
//  PWCiPhoneScheduleCancellationViewController.m
//  PWC
//
//  Created by Samiul Hoque on 9/4/13.
//  Copyright (c) 2013 Premium Web Cart. All rights reserved.
//

#import "PWCiPhoneScheduleCancellationViewController.h"
#import "PWCSelectedServiceData.h"
#import "Base64.h"

@interface PWCiPhoneScheduleCancellationViewController ()

@end

@implementation PWCiPhoneScheduleCancellationViewController

@synthesize selectedButton;
@synthesize unitDay;
@synthesize unitHour;

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
    
    self.unitDay = [[NSMutableArray alloc] init];
    self.unitHour = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < 100; i++) {
        [self.unitDay addObject:[NSString stringWithFormat:@"%d", i]];
    }
    
    for (int i = 0; i < 24; i++) {
        [self.unitHour addObject:[NSString stringWithFormat:@"%d", i]];
    }
    
    [self updateDisplay];
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.tableView addGestureRecognizer:gestureRecognizer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)hideKeyboard
{
    [self.termsTxtView resignFirstResponder];
    [self updateValues];
}

- (void)updateDisplay
{
    [self.editRuleDayBtn setTitle:[PWCSelectedServiceData selectedService].editRuleDay forState:UIControlStateNormal];
    [self.editRuleHourBtn setTitle:[PWCSelectedServiceData selectedService].editRuleHour forState:UIControlStateNormal];
    
    [self.cancelRuleDayBtn setTitle:[PWCSelectedServiceData selectedService].cancelRuleDay forState:UIControlStateNormal];
    [self.cancelRuleHourBtn setTitle:[PWCSelectedServiceData selectedService].cancelRuleHour forState:UIControlStateNormal];
    
    if ([[PWCSelectedServiceData selectedService].termsAndConditions length] > 0) {
        self.termsTxtView.text = [[PWCSelectedServiceData selectedService].termsAndConditions base64DecodedString];
    } else {
        self.termsTxtView.text = @"";
    }
    
}

- (void)updateValues
{
    [PWCSelectedServiceData selectedService].editRuleDay = self.editRuleDayBtn.titleLabel.text;
    [PWCSelectedServiceData selectedService].editRuleHour = self.editRuleHourBtn.titleLabel.text;
    
    [PWCSelectedServiceData selectedService].cancelRuleDay = self.cancelRuleDayBtn.titleLabel.text;
    [PWCSelectedServiceData selectedService].cancelRuleHour = self.cancelRuleHourBtn.titleLabel.text;
    
    if ([self.termsTxtView.text length] > 0) {
        [PWCSelectedServiceData selectedService].termsAndConditions = [self.termsTxtView.text base64EncodeString];
    } else {
        [PWCSelectedServiceData selectedService].termsAndConditions = @"";
    }
}

- (void)createActionSheet
{
    [self hideKeyboard];
    
    if ([self.selectedButton isEqualToString:@"editDay"]) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Select day"
                                                                 delegate:self
                                                        cancelButtonTitle:nil
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:nil];
        
        for (NSString *s in self.unitDay) {
            [actionSheet addButtonWithTitle:s];
        }
        
        [actionSheet addButtonWithTitle:@"Cancel"];
        actionSheet.cancelButtonIndex = actionSheet.numberOfButtons - 1;
        
        [actionSheet showInView:[self.view superview]];
    } else if ([self.selectedButton isEqualToString:@"editHour"]) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Select hour"
                                                                 delegate:self
                                                        cancelButtonTitle:nil
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:nil];
        
        for (NSString *s in self.unitHour) {
            [actionSheet addButtonWithTitle:s];
        }
        
        [actionSheet addButtonWithTitle:@"Cancel"];
        actionSheet.cancelButtonIndex = actionSheet.numberOfButtons - 1;
        
        [actionSheet showInView:[self.view superview]];
    } else if ([self.selectedButton isEqualToString:@"cancelDay"]) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Select day"
                                                                 delegate:self
                                                        cancelButtonTitle:nil
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:nil];
        
        for (NSString *s in self.unitDay) {
            [actionSheet addButtonWithTitle:s];
        }
        
        [actionSheet addButtonWithTitle:@"Cancel"];
        actionSheet.cancelButtonIndex = actionSheet.numberOfButtons - 1;
        
        [actionSheet showInView:[self.view superview]];
    } else if ([self.selectedButton isEqualToString:@"cancelHour"]) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Select hour"
                                                                 delegate:self
                                                        cancelButtonTitle:nil
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:nil];
        
        for (NSString *s in self.unitHour) {
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
    
    if ([self.selectedButton isEqualToString:@"editDay"]) {
        [PWCSelectedServiceData selectedService].editRuleDay = [self.unitDay objectAtIndex:buttonIndex];
    } else if ([self.selectedButton isEqualToString:@"editHour"]) {
        [PWCSelectedServiceData selectedService].editRuleHour = [self.unitHour objectAtIndex:buttonIndex];
    } else if ([self.selectedButton isEqualToString:@"cancelDay"]) {
        [PWCSelectedServiceData selectedService].cancelRuleDay = [self.unitDay objectAtIndex:buttonIndex];
    } else if ([self.selectedButton isEqualToString:@"cancelHour"]) {
        [PWCSelectedServiceData selectedService].cancelRuleHour = [self.unitHour objectAtIndex:buttonIndex];
    }
    
    self.selectedButton = @"";
    [self updateDisplay];
}

- (IBAction)editRuleDayClick:(id)sender {
    self.selectedButton = @"editDay";
    [self createActionSheet];
}

- (IBAction)editRuleHourClick:(id)sender {
    self.selectedButton = @"editHour";
    [self createActionSheet];
}

- (IBAction)cancelRuleDayClick:(id)sender {
    self.selectedButton = @"cancelDay";
    [self createActionSheet];
}

- (IBAction)cancelRuleHourClick:(id)sender {
    self.selectedButton = @"cancelHour";
    [self createActionSheet];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [self updateValues];
}

@end
