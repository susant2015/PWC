//
//  UIImage+imageWithColor.m
//  PWC
//
//  Created by Samiul Hoque on 4/10/13.
//  Copyright (c) 2013 Premium Web Cart. All rights reserved.
//

#import "UIImage+imageWithColor.h"

@implementation UIImage (imageWithColor)

+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
