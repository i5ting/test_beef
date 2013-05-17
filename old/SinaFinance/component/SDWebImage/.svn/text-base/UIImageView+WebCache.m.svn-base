/*
 * This file is part of the SDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "UIImageView+WebCache.h"
#import "SDWebImageManager.h"

NSString*const WebCacheImageFailedNotification = @"WebCacheImageFailedNotification";
NSString*const WebCacheImageSuccessedNotification = @"WebCacheImageSuccessedNotification";


@interface WebCacheDataView : UIView
@property(nonatomic,retain)id data;
@end

@implementation WebCacheDataView
@synthesize data;

-(id)init
{
    self = [super init];
    if (self) {
        self.hidden = YES;
    }
    return self;
}

-(void)dealloc
{
    [data release];
    [super dealloc];
}

@end

@implementation UIImageView (WebCache)


- (void)setImageWithURL:(NSURL *)url
{
    [self setImageWithURL:url placeholderImage:nil];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder
{
    [self setImageWithURL:url placeholderImage:placeholder failedPlaceHoder:nil];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder failedPlaceHoder:(UIImage*)failedimage
{
    [self setImageWithURL:url placeholderImage:placeholder palceImageMode:UIViewContentModeCenter failedPlaceHoder:failedimage failImageMode:UIViewContentModeCenter];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder palceImageMode:(UIViewContentMode)mode1 failedPlaceHoder:(UIImage*)failedPlaceHoder failImageMode:(UIViewContentMode)mode2
{
    NSMutableDictionary* olddataDict = [self dataFromDataView];
    NSNumber* oldMode = (NSNumber*)[olddataDict valueForKey:@"oldmode"];
    NSMutableDictionary* dataDict = [[NSMutableDictionary alloc] initWithCapacity:0];
    [dataDict setValue:url forKey:@"url"];
    [dataDict setValue:placeholder forKey:@"placeholder"];
    [dataDict setValue:failedPlaceHoder forKey:@"failedimage"];
    if (oldMode) {
        [dataDict setValue:oldMode forKey:@"oldmode"];
    }
    else {
        [dataDict setValue:[NSNumber numberWithInt:self.contentMode] forKey:@"oldmode"];
    }
    [dataDict setValue:[NSNumber numberWithInt:mode1] forKey:@"palceimagemode"];
    [dataDict setValue:[NSNumber numberWithInt:mode2] forKey:@"failimagemode"];
    [dataDict setValue:[NSNumber numberWithInt:0] forKey:@"status"];
    [self setDataToDataView:dataDict];
    [dataDict release];
    
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    
    // Remove in progress downloader from queue
    [manager cancelForDelegate:self];
    
    CGSize placeholderSize = placeholder.size;
    CGSize boundSize =self.bounds.size;
    
    if (placeholderSize.width>boundSize.width&&placeholderSize.height>boundSize.height) {
        self.contentMode = UIViewContentModeScaleToFill;
    }
    else {
        self.contentMode = mode1;
    }
    
    self.image = placeholder;
    
    if (url)
    {
        [manager downloadWithURL:url delegate:self];
    }
}

-(WebCacheDataView*)addDataView
{
    NSArray* allsub = [self subviews];
    WebCacheDataView*  dataView = nil;
    for (UIView* oneSub in allsub) {
        if ([oneSub isKindOfClass:[WebCacheDataView class]]) {
            dataView = (WebCacheDataView*)oneSub;
            break;
        }
    }
    if (!dataView) {
        dataView = [[WebCacheDataView alloc] init];
        [self addSubview:dataView];
        [dataView release];
    }
    return dataView;
}

-(void)setDataToDataView:(id)newData
{
    WebCacheDataView* dataView = [self addDataView];
    dataView.data = newData;
}

-(id)dataFromDataView
{
    WebCacheDataView* dataView = [self addDataView];
    return dataView.data;
}

- (void)cancelCurrentImageLoad
{
    [[SDWebImageManager sharedManager] cancelForDelegate:self];
}

- (void)webImageManager:(SDWebImageManager *)imageManager didFinishWithImage:(UIImage *)image
{
    NSMutableDictionary* dataDict = [self dataFromDataView];
    NSNumber* oldmode = [dataDict valueForKey:@"oldmode"];
    if (oldmode) {
        self.contentMode = [oldmode intValue];
    }
    else
        self.contentMode = UIViewContentModeScaleToFill;
    self.image = image;
    [[NSNotificationCenter defaultCenter] postNotificationName:WebCacheImageSuccessedNotification object:self];
}

- (void)webImageManager:(SDWebImageManager *)imageManager didFailWithError:(NSError *)error
{
#ifdef DEBUG
    NSLog(@"imageload failed,error=%@",[error description]);
#endif
    NSMutableDictionary* dataDict = [self dataFromDataView];
    UIImage* failedimage = [dataDict valueForKey:@"failedimage"];
    if (failedimage) {
        NSNumber* mode = [dataDict valueForKey:@"failimagemode"];
        if (failedimage.size.width>self.bounds.size.width&&failedimage.size.height>self.bounds.size.height) {
            self.contentMode = UIViewContentModeScaleToFill;
        }
        else {
            self.contentMode = [mode intValue];
        }
        self.image = failedimage;
        
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:WebCacheImageFailedNotification object:self];
}

-(NSURL*)imageURL
{
    NSMutableDictionary* dataDict = [self dataFromDataView];
    return [dataDict valueForKey:@"url"];
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    NSMutableDictionary* dataDict = [self dataFromDataView];
    UIImage* failedimage = [dataDict valueForKey:@"failedimage"];
    UIImage* placeholder = [dataDict valueForKey:@"placeholder"];
    NSNumber* palceimagemode = (NSNumber*)[dataDict valueForKey:@"palceimagemode"];
    NSNumber* failimagemode = (NSNumber*)[dataDict valueForKey:@"failimagemode"];
    if (self.image&&self.image==failedimage) {
        if (failedimage.size.width>self.bounds.size.width&&failedimage.size.height>self.bounds.size.height) {
            self.contentMode = UIViewContentModeScaleToFill;
        }
        else
        {
            if (failimagemode) {
                self.contentMode = [failimagemode intValue];
            }
            
        }
    }
    else if(self.image&&self.image==placeholder)
    {
        if (placeholder.size.width>self.bounds.size.width&&placeholder.size.height>self.bounds.size.height) {
            self.contentMode = UIViewContentModeScaleToFill;
        }
        else {
            if (palceimagemode) {
                self.contentMode = [palceimagemode intValue];
            }
            
        }
    }
}

@end
