//
//  PWCDashboardCell.h
//  PWC
//
//  Created by Samiul Hoque on 2/15/13.
//  Copyright (c) 2013 Premium Web Cart. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PWCDashboardCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UILabel *notification;
@property (strong, nonatomic) IBOutlet UIImageView *image;
@property (strong, nonatomic) IBOutlet UILabel *name;

@end
