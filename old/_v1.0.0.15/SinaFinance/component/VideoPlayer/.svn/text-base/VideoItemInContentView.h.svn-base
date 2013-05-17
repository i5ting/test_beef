//
//  VideoItemInContentView.h
//  SinaNewsHD
//
//  Created by duzhe on 11-4-7.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface  VideoData: NSObject

@property(retain)NSString* imageURL;
@property(retain)NSString* videoURL;


@end

@interface VideoItemInContentView : UIView {
	UIImageView *imageContainView;
	UIImageView *playImageView;
	UIImageView *iconView;
	UIImageView *playholderView ;
	UIActivityIndicatorView *activityView;
	
	UIButton *playButton;
	
	MPMoviePlayerController* moviePlayController;

}

@property (nonatomic,retain)VideoData* videoData;
@property (nonatomic,retain)MPMoviePlayerController* moviePlayController;

- (void)playVideo;
-(void)clear;

@end
