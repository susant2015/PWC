//
//  PWCMessageListCell.h
//  PWC
//
//  Created by jian on 12/20/13.
//  Copyright (c) 2013 Premium Web Cart. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PWCMessageListCell : UITableViewCell
{
}
@property(nonatomic, retain) IBOutlet UILabel*           m_lblSubject;
@property(nonatomic, retain) IBOutlet UILabel*           m_lblPostedBy;
@property(nonatomic, retain) IBOutlet UILabel*           m_lblPostedDate;

+ (PWCMessageListCell *)cellFromNibNamed:(NSString *)nibName;

@end
