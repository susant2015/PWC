//
//  PWCReportViewController.h
//  PWC
//
//  Created by Samiul Hoque on 3/14/13.
//  Copyright (c) 2013 Premium Web Cart. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PWCReportViewController : UIViewController <UIActionSheetDelegate>

@property (strong, nonatomic) NSString *reportDays;

@property (strong, nonatomic) IBOutlet UIButton *secondDropdown;
@property (strong, nonatomic) IBOutlet UIButton *thirdDropdown;
@property (strong, nonatomic) IBOutlet UIButton *fourthDropdown;

@property (strong, nonatomic) NSArray *selectionButton;

@property (strong, nonatomic) NSArray *secondDropdownList;
@property (strong, nonatomic) NSArray *thirdDropdownList;
@property (strong, nonatomic) NSArray *fourthDropdownList;
@property (assign, nonatomic) NSInteger currentButtonTag;

@property (strong, nonatomic) NSString *categoryValue;
@property (strong, nonatomic) NSString *productValue;
@property (strong, nonatomic) NSString *affiliateValue;

- (IBAction)viewSelection:(id)sender;
- (IBAction)showReport:(id)sender;
- (void)processRequest;

@end
