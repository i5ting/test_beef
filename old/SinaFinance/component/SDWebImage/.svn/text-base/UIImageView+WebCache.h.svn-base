/*
 * This file is part of the SDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "SDWebImageCompat.h"
#import "SDWebImageManagerDelegate.h"

extern NSString *const WebCacheImageFailedNotification;
extern NSString *const WebCacheImageSuccessedNotification;

@interface UIImageView (WebCache) <SDWebImageManagerDelegate>

- (void)setImageWithURL:(NSURL *)url;
- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder;
- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder failedPlaceHoder:(UIImage*)failedPlaceHoder;
- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder palceImageMode:(UIViewContentMode)mode1 failedPlaceHoder:(UIImage*)failedPlaceHoder failImageMode:(UIViewContentMode)mode2;
- (void)cancelCurrentImageLoad;
-(NSURL*)imageURL;

@end
