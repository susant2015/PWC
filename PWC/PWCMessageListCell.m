//
//  PWCMessageListCell.m
//  PWC
//
//  Created by jian on 12/20/13.
//  Copyright (c) 2013 Premium Web Cart. All rights reserved.
//

#import "PWCMessageListCell.h"

@implementation PWCMessageListCell

//==============================================================================================================
+ (PWCMessageListCell *)cellFromNibNamed:(NSString *)nibName {
    
    NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:nibName owner:self options:NULL];
    NSEnumerator *nibEnumerator = [nibContents objectEnumerator];
    PWCMessageListCell *xibBasedCell = nil;
    NSObject* nibItem = nil;
    
    while ((nibItem = [nibEnumerator nextObject]) != nil) {
        if ([nibItem isKindOfClass:[PWCMessageListCell class]]) {
            xibBasedCell = (PWCMessageListCell *)nibItem;
            break; // we have a winner
        }
    }
    
    return xibBasedCell;
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
