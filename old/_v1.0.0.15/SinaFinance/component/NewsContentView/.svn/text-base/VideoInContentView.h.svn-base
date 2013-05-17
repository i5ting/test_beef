//
//  VideoItemInContentView.h
//  SinaNewsHD
//
//  Created by duzhe on 11-4-7.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface SImageModel : NSObject {
@private
    BOOL inDiskValue;
    NSString *fullPath;
    NSString *url;
    CGFloat heightValue;
    CGFloat widthValue;
    NSString *title;
}
@property BOOL inDiskValue;
@property (nonatomic, retain) NSString *fullPath;
@property (nonatomic, retain) NSString *url;
@property(nonatomic,assign)CGFloat heightValue;
@property(nonatomic,assign)CGFloat widthValue;
@property (nonatomic, retain) NSString *title;
@end

@interface SVideoModel : NSObject {
@private
    SImageModel* thumb;
    NSString *vid;
}
@property (nonatomic, retain) SImageModel* thumb;
@property (nonatomic, retain) NSString *vid;
@end


@interface VideoInContentView : UIView{
	UIImageView *imageContainView;
	UIImageView *playImageView;
	UIImageView *iconView;
	UIImageView *playholderView ;
	UIActivityIndicatorView *activityView;
	
	UIButton *playButton;
	
	SVideoModel *myModel;
	
	MPMoviePlayerController* moviePlayController;

}
@property (nonatomic,retain)SVideoModel *myModel;
@property (nonatomic,retain)MPMoviePlayerController* moviePlayController;

- (id)initWithFrame:(CGRect)frame model:(SVideoModel *)model;
- (void)sendImageRequst;
- (void)playVideo;

@end
