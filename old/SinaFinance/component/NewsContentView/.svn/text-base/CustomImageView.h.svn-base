//
//  CustomImageView.h
//  SinaNewsHD
//
//  Created by du zhe on 10-10-29.
//  Copyright 2010 sina. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CustomImageView;
@protocol CustomImageView_Delegate <NSObject>

-(void)CustomImageViewClicked:(CustomImageView*)view;
@optional
-(void)CustomImageViewFinishLoading:(CustomImageView*)view size:(CGSize)imageSize;
@end

@interface CustomImageView : UIImageView{
	BOOL isNeedBorder;
	int border;
    NSString* imageURL;
    UIImage* contentImage;
}

@property (nonatomic,retain) NSString* imageURL;
@property (nonatomic,retain) UIImage* contentImage;
@property (nonatomic,assign) id<CustomImageView_Delegate> delegate;
@property (nonatomic,assign) BOOL isNeedBorder;
@property (nonatomic,assign) int border;
- (void)setSubstituteImageWithFrame:(CGRect)imageFrame;

- (void)setContentImageWithFrame:(CGRect)imageFrame;
- (void)setContentImageWithFrame:(CGRect)imageFrame image:(UIImage *)contentImage;

- (void)setContentImageWithFrame:(CGRect)imageFrame imageURL:(NSString *)contentImageURL placeImage:(UIImage*)placeImage;

- (void) sendImageRequest:(NSString *)url;

@end
