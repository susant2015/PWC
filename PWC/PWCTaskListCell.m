//
//  PWCTaskListCell.m
//  PWC
//
//  Created by jian on 2/17/14.
//  Copyright (c) 2014 Premium Web Cart. All rights reserved.
//

#import "PWCTaskListCell.h"

@implementation PWCTaskListCell
@synthesize m_lblCustomer;
@synthesize m_lblDueDate;
@synthesize m_lblTask;

//==============================================================================================================
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

//==============================================================================================================
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//==============================================================================================================
@end
