//
//  PWCDashboardViewController.h
//  PWC
//
//  Created by Samiul Hoque on 2/15/13.
//  Copyright (c) 2013 Premium Web Cart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@interface PWCDashboardViewController : UIViewController
{
    IBOutlet UIScrollView*              m_scrollView;
    
    sqlite3 *pwcDB;
}

@property (strong, nonatomic) NSMutableArray *dashboardItems;

@property (strong, nonatomic) NSString *webTitle;
@property (strong, nonatomic) NSString *webUrl;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *refreshCollectionViewButton;

- (IBAction)refreshButtonClicked:(id)sender;
//- (void)updateCollectionView;
- (void)doOrderProcessForPush;
- (void)doBookingSummaryPush;

@end
