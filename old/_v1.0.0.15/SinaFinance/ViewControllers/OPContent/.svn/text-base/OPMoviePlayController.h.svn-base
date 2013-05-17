//
//  OPMoviePlayController.h
//  NewsHD
//
//  Created by sgl on 12-9-17.
//  Copyright (c) 2012年 Sina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "OPImageView.h"

@interface OPMoviePlayController : UIViewController {
    MPMoviePlayerController *player;
}

@property (nonatomic, strong) NSURL *videoURL;
@property (nonatomic, strong) OPImageView *videoImage;
@property (retain, nonatomic) UIButton *playBtn;

- (id)initWithVideoID:(NSString *)videoID;
- (id)initWithURL:(NSString *)playurl;

- (IBAction)playBtnClicked:(id)sender;
- (void)stopVideo;

@end
