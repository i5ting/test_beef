//
//  UIImage+ImageScale.m
//  SinaEntertainment
//
//  Created by Sun Guanglei on 12-8-7.
//  Copyright (c) 2012年 SwordsMobile. All rights reserved.
//

#import "UIImage+ImageScale.h"

@implementation UIImage (ImageScale)

- (UIImage *)subImage:(CGRect)rect;
{
    CGImageRef subImageRef = CGImageCreateWithImageInRect(self.CGImage, rect);  
    CGRect smallBounds = CGRectMake(0, 0, CGImageGetWidth(subImageRef), CGImageGetHeight(subImageRef));  
    
    UIGraphicsBeginImageContext(smallBounds.size);  
    CGContextRef context = UIGraphicsGetCurrentContext();  
    CGContextDrawImage(context, smallBounds, subImageRef);  
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];  
    UIGraphicsEndImageContext();  
    
    return smallImage;  
}

@end
