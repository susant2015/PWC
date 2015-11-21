//
//  PWCPendingQueneCellView.h
//  PWC
//
//  Created by JianJinHu on 7/30/13.
//  Copyright (c) 2013 Premium Web Cart. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PWCPendingQueneCellViewDelegate
@optional
-(void)didSendClickAtIndex: (int)broadcast_id type: (NSString*) type;
@end

@interface PWCPendingQueneCellView : UIView
{
    id <PWCPendingQueneCellViewDelegate> delegate;
}

@property (nonatomic, assign) int broadcat_id;
@property (nonatomic, retain) NSString* type;

@property (nonatomic, retain) id <PWCPendingQueneCellViewDelegate> delegate;

-(void) createTitleCell;
-(void) createInfo: (int) nId subject: (NSString*) strSubject date: (NSString*) strDate type: (NSString*) strType;

@end
