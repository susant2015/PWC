//
//  PWCiPhoneScheduleBookingsViewController.h
//  BackUpFiles
//
//  Created by Samiul Hoque on 6/13/13.
//  Copyright (c) 2013 Premium Web Cart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TapkuLibrary/TapkuLibrary.h>

@interface PWCiPhoneScheduleBookingsViewController : UIViewController <TKCalendarMonthViewDelegate, TKCalendarMonthViewDataSource>
{
    TKCalendarMonthView *_calendar;
}

@property (nonatomic, retain) TKCalendarMonthView *calendar;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *today;
@property (strong, nonatomic) IBOutlet UILabel *selectedDate;

@property (strong, nonatomic) NSDate *showedDate;
@property (strong, nonatomic) NSString *showedMonth;
@property (strong, nonatomic) NSString *showedYear;
@property (strong, nonatomic) NSMutableArray *bookingData;

- (IBAction)gotoTodaysDate:(id)sender;

@end
