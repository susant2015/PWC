//
//  PWCPendingQueneCellView.m
//  PWC
//
//  Created by JianJinHu on 7/30/13.
//  Copyright (c) 2013 Premium Web Cart. All rights reserved.
//

#import "PWCPendingQueneCellView.h"

@implementation PWCPendingQueneCellView
@synthesize delegate;
@synthesize broadcat_id;
@synthesize type;

//==============================================================================================================
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

//==============================================================================================================
-(void) createTitleCell
{
    self.backgroundColor = [UIColor colorWithRed: 203.0f/255.0f green: 222.0f/255.0f blue: 239.0f/255.0f alpha: 1.0f];
    
    UILabel* lblSubject = [[UILabel alloc] initWithFrame: CGRectMake(10, 7, 150, 30)];
    lblSubject.font = [UIFont boldSystemFontOfSize: 12.0f];
    lblSubject.backgroundColor = [UIColor clearColor];
    lblSubject.text = @"Subject";
    [self addSubview: lblSubject];
    
    UILabel* lblType = [[UILabel alloc] initWithFrame: CGRectMake(193, 7, 150, 30)];
    lblType.font = [UIFont boldSystemFontOfSize: 12.0f];
    lblType.backgroundColor = [UIColor clearColor];
    lblType.text = @"Type";
    [self addSubview: lblType];
    
    UILabel* lblStatus = [[UILabel alloc] initWithFrame: CGRectMake(260, 7, 150, 30)];
    lblStatus.font = [UIFont boldSystemFontOfSize: 12.0f];
    lblStatus.backgroundColor = [UIColor clearColor];
    lblStatus.text = @"Status";
    [self addSubview: lblStatus];
    
    UIImageView* imgLine = [[UIImageView alloc] initWithFrame: CGRectMake(0, 39, self.frame.size.width, 1)];
    [imgLine setBackgroundColor: [UIColor whiteColor]];
    [self addSubview: imgLine];
    
}

//==============================================================================================================
-(void) createInfo: (int) nId subject: (NSString*) strSubject date: (NSString*) strDate type: (NSString*) strType
{
    self.broadcat_id = nId;
    self.type = strType;
    
    self.backgroundColor = [UIColor colorWithRed: 233.0f/255.0f green: 241.0f/255.0f blue: 249.0f/255.0f alpha: 1.0f];
    
    UILabel* lblSubject = [[UILabel alloc] initWithFrame: CGRectMake(10, 0, 150, 25)];
    lblSubject.font = [UIFont systemFontOfSize: 12.0f];
    lblSubject.backgroundColor = [UIColor clearColor];
    lblSubject.text = strSubject;
    [self addSubview: lblSubject];
    
    UILabel* lblDate = [[UILabel alloc] initWithFrame: CGRectMake(10, 22, 150, 30)];
    lblDate.font = [UIFont systemFontOfSize: 12.0f];
    lblDate.backgroundColor = [UIColor clearColor];
    lblDate.text = strDate;
    [self addSubview: lblDate];
    
    NSString* strIcon;
    if([strType isEqualToString: @"email"])
    {
        strIcon = @"icon_email.png";
        
        UIImage* imgIcon = [UIImage imageNamed: strIcon];
        UIImageView* imgViewIcon = [[UIImageView alloc] initWithImage: imgIcon];
        imgViewIcon.frame = CGRectMake(200, 20, imgIcon.size.width, imgIcon.size.height);
        [self addSubview: imgViewIcon];
    }
    else if([strType isEqualToString: @"sms"])
    {
        strIcon = @"icon_phone.png";
        UIImage* imgIcon = [UIImage imageNamed: strIcon];
        UIImageView* imgViewIcon = [[UIImageView alloc] initWithImage: imgIcon];
        imgViewIcon.frame = CGRectMake(200, 20, imgIcon.size.width, imgIcon.size.height);
        [self addSubview: imgViewIcon];
    }
    else
    {
        strIcon = @"icon_email.png";
        UIImage* imgIcon = [UIImage imageNamed: strIcon];
        UIImageView* imgViewIcon = [[UIImageView alloc] initWithImage: imgIcon];
        imgViewIcon.frame = CGRectMake(193, 20, imgIcon.size.width, imgIcon.size.height);
        [self addSubview: imgViewIcon];
        
        strIcon = @"icon_phone.png";
        UIImage* imgIcon1 = [UIImage imageNamed: strIcon];
        UIImageView* imgViewIcon1 = [[UIImageView alloc] initWithImage: imgIcon1];
        imgViewIcon1.frame = CGRectMake(215, 18, imgIcon1.size.width, imgIcon1.size.height);
        [self addSubview: imgViewIcon1];
    }
    
    UIButton* btn = [[UIButton alloc] initWithFrame: CGRectMake(260, 15, 48, 19)];
    [btn setImage: [UIImage imageNamed: @"icon_send.png"] forState: UIControlStateNormal];
    [btn addTarget: self action: @selector(actionSelect:) forControlEvents: UIControlEventTouchUpInside];
    [self addSubview: btn];
    
    UIImageView* imgLine = [[UIImageView alloc] initWithFrame: CGRectMake(0, 49, self.frame.size.width, 1)];
    [imgLine setBackgroundColor: [UIColor whiteColor]];
    [self addSubview: imgLine];
}

//==============================================================================================================
-(void) actionSelect: (id) sender
{
    if ([(id)delegate respondsToSelector:@selector(didSendClickAtIndex:type:)])
    {
        [delegate didSendClickAtIndex: self.broadcat_id type: self.type];
    }
}

//==============================================================================================================
@end
