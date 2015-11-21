//
//  PWCAccountViewController.h
//  PWC
//
//  Created by Samiul Hoque on 3/5/13.
//  Copyright (c) 2013 Premium Web Cart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import <sqlite3.h>

#define kEmailKey    @"email"
#define kPasswordKey @"password"
#define kTaxRate     @"taxRate"

@interface PWCAccountViewController : UITableViewController <UIActionSheetDelegate>
{
    sqlite3 *pwcDB;
    
    int                 m_nCurProjectIndex;
    int                 m_nTotalProjectCount;
}

@property (strong, nonatomic) IBOutlet UITableViewCell *defaultTaxRate;
@property (strong, nonatomic) NSString*                 m_strSelectedProject;

- (void)updateDefaultRate;

@end
