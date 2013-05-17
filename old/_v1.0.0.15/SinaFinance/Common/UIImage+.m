//
//  UIImage+.m
//  SinaFinance
//
//  Created by sang alfred on 9/19/12.
//
//

#import "UIImage+.h"

@implementation UIImage (plus)


- (id) initWithName:(NSString *)name {
    NSString *path = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:name];
    return [self initWithContentsOfFile:path];
}

+ (UIImage *) imageWithName:(NSString *)name {
    NSString *path = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:name];
    return [UIImage imageWithContentsOfFile:path];
}


@end