//
//  PWCPendingQueneViewController.h
//  PWC
//
//  Created by JianJinHu on 7/30/13.
//  Copyright (c) 2013 Premium Web Cart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PWCPendingQueneCellView.h"

@interface PWCPendingQueneViewController : UIViewController<PWCPendingQueneCellViewDelegate>
{
    IBOutlet UIScrollView*          m_scrollView;
    NSMutableArray*                 m_arrInfo;
}
@end
