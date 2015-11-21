//
//  PWCTaskListCell.h
//  PWC
//
//  Created by jian on 2/17/14.
//  Copyright (c) 2014 Premium Web Cart. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PWCTaskListCell : UITableViewCell
{
    
}
@property(nonatomic, retain) IBOutlet UILabel*           m_lblTask;
@property(nonatomic, retain) IBOutlet UILabel*           m_lblCustomer;
@property(nonatomic, retain) IBOutlet UILabel*           m_lblDueDate;
@end
