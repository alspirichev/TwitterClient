//
//  UIImage+Color.m
//  TwitterClient
//
//  Created by Alexander Spirichev on 06.10.15.
//  Copyright (c) 2015 Alexander Spirichev. All rights reserved.
//

#import "UIImage+Color.h"

@implementation UIImage (AddColor)

+ (UIImage *)imageWithColor:(UIColor *)color
{
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
