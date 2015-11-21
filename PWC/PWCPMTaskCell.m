//
//  PWCPMTaskCell.m
//  PWC
//
//  Created by JianJinHu on 11/30/13.
//  Copyright (c) 2013 Premium Web Cart. All rights reserved.
//

#import "PWCPMTaskCell.h"

@implementation PWCPMTaskCell
@synthesize m_lblAssigned;
@synthesize m_lblSprint;
@synthesize m_lblTaskTitle;

//==============================================================================================================
+ (PWCPMTaskCell *)cellFromNibNamed:(NSString *)nibName {
    
    NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:nibName owner:self options:NULL];
    NSEnumerator *nibEnumerator = [nibContents objectEnumerator];
    PWCPMTaskCell *xibBasedCell = nil;
    NSObject* nibItem = nil;
    
    while ((nibItem = [nibEnumerator nextObject]) != nil) {
        if ([nibItem isKindOfClass:[PWCPMTaskCell class]]) {
            xibBasedCell = (PWCPMTaskCell *)nibItem;
            break; // we have a winner
        }
    }
    
    return xibBasedCell;
}

//==============================================================================================================
-(NSString *) reuseIdentifier {
    return @"TableCellWithNumberCellIdentifier";
}

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
