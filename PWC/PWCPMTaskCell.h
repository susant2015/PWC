//
//  PWCPMTaskCell.h
//  PWC
//
//  Created by JianJinHu on 11/30/13.
//  Copyright (c) 2013 Premium Web Cart. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PWCPMTaskCell : UITableViewCell
{
}

@property(nonatomic, retain) IBOutlet UILabel*           m_lblTaskTitle;
@property(nonatomic, retain) IBOutlet UILabel*           m_lblAssigned;
@property(nonatomic, retain) IBOutlet UILabel*           m_lblSprint;

+ (PWCPMTaskCell *)cellFromNibNamed:(NSString *)nibName;
@end
