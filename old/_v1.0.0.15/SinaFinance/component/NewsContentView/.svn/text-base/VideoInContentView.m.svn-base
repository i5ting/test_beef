//
//  VideoItemInContentView.m
//  SinaNewsHD
//
//  Created by duzhe on 11-4-7.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "VideoInContentView.h"
#import "NewsContentVariable.h"
#import "UIImageView+WebCache.h"

@implementation SImageModel

@synthesize inDiskValue,fullPath,url,heightValue,widthValue,title;

-(id)init
{
    self = [super init];
    if (self) {
        ;
    }
    return self;
}

-(void)dealloc
{
    [fullPath release];
    [url release];
    [title release];
    [super dealloc];
}

@end

@implementation SVideoModel

@synthesize thumb,vid;

-(void)dealloc
{
    [thumb release];
    [vid release];
    [super dealloc];
}

@end


@implementation VideoInContentView

@synthesize myModel;
@synthesize moviePlayController;

- (id)initWithFrame:(CGRect)frame model:(SVideoModel *)model
{
	if (self = [super initWithFrame:frame])
	{
		self.myModel = model;
		self.backgroundColor = [UIColor clearColor];
		imageContainView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"content_videoframe.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:20]];
        CGRect bounds = self.bounds;
		imageContainView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
		[self addSubview:imageContainView];
		[imageContainView release];
		
		playImageView = [[UIImageView alloc] initWithFrame:CGRectMake(11, 4, imageContainView.bounds.size.width - 22, imageContainView.bounds.size.height - 7)];
		playImageView.backgroundColor = [UIColor grayColor];
		[imageContainView addSubview:playImageView];
		[playImageView release];
		
		if (myModel.thumb.inDiskValue)
		{
            NSURL* url = [NSURL URLWithString:myModel.thumb.fullPath];
			[playImageView setImageWithURL:url placeholderImage:[UIImage imageNamed:placeholder_photo]];
		}
		else {
			NSURL* url = [NSURL URLWithString:myModel.thumb.url];
			[playImageView setImageWithURL:url placeholderImage:[UIImage imageNamed:placeholder_photo]];
            
//			float minL = 10000.0;
//			minL = MIN(frame.size.height, frame.size.width);
//			minL = MIN(placeholder_photo_length, minL);
//			if (minL > 1) {
//				iconView = [[UIImageView alloc] initWithFrame:CGRectMake((frame.size.width - minL)/2.0, (frame.size.height - minL)/2.0, minL, minL)];
//				[iconView setImage:[UIImage imageNamed:placeholder_photo]];
//				[imageContainView addSubview:iconView];
//				[iconView release];
//				
//			}
//			[self sendImageRequst];
		}

		
		playholderView = [[UIImageView alloc] initWithFrame:CGRectMake((imageContainView.bounds.size.width - 47) / 2, (imageContainView.bounds.size.height - 47) / 2, 47, 47)];
		playholderView.image = [UIImage imageNamed:@"contentPlayHolder.png"];
		[imageContainView addSubview:playholderView];
		[playholderView release];
		
		playButton = [UIButton buttonWithType:UIButtonTypeCustom];
		playButton.frame = CGRectMake(6, 6, imageContainView.bounds.size.width - 12, imageContainView.bounds.size.height - 12);
		playButton.backgroundColor = [UIColor clearColor];
		[playButton addTarget:self action:@selector(playVideo) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:playButton];
		
	}
	return self;
}

- (void)sendImageRequst
{
    ;
}

- (void)recoverToBegin
{
	if (playholderView)
	{
		playholderView.hidden = NO;
	}
	
	if (playImageView)
	{
		playImageView.alpha = 1.0;
	}
	if (activityView)
	{
		[activityView stopAnimating];
		[activityView removeFromSuperview];
		activityView = nil;
	}
}

- (void)releaseMovieController
{
	if (moviePlayController)
	{
		[moviePlayController stop];
		[moviePlayController.view removeFromSuperview];
		[moviePlayController release];
		moviePlayController = nil;
	}
}
- (void) movieFinishedCallback:(NSNotification*) aNotification {
	[self recoverToBegin];
    [[NSNotificationCenter defaultCenter] 
	 removeObserver:self
	 name:MPMoviePlayerPlaybackDidFinishNotification
	 object:nil];
	
    [self releaseMovieController];
	
}

- (void)prepareForPlay
{
	if (playholderView)
	{
		playholderView.hidden = YES;
	}
	
	if (playImageView)
	{
		playImageView.alpha = 0.5;
	}
	
	if (!activityView)
	{
		activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
		activityView.frame = CGRectMake((self.bounds.size.width - 50) /2 , (self.bounds.size.height - 50) /2 , 50, 50);
		[self addSubview:activityView];
		[activityView startAnimating];
		[activityView release];
	
	}
}

- (void)playVideo
{
	//playButton.userInteractionEnabled = NO;

	[self prepareForPlay];
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"http://v.iask.com/v_play_ipad.php?vid=%@",myModel.vid]];
    MPMoviePlayerController* tempPlayer = [[MPMoviePlayerController alloc] initWithContentURL:url];
	self.moviePlayController=tempPlayer;
	[tempPlayer release];
	if (moviePlayController)                      
	{
		[[NSNotificationCenter defaultCenter] 
		 addObserver:self
		 selector:@selector(movieFinishedCallback:)
		 name:MPMoviePlayerPlaybackDidFinishNotification
		 object:moviePlayController];
		moviePlayController.view.frame = CGRectMake(11, 4, imageContainView.bounds.size.width - 22, imageContainView.bounds.size.height - 7);
		moviePlayController.view.backgroundColor = [UIColor clearColor];
		[self addSubview:moviePlayController.view];
		[moviePlayController prepareToPlay];
		[moviePlayController play];	
		
	}
	
}

- (void)dealloc
{
	self.myModel = nil;
	[self releaseMovieController];
	[[NSNotificationCenter defaultCenter] 
	 removeObserver:self
	 name:MPMoviePlayerPlaybackDidFinishNotification
	 object:nil];
	[super dealloc];
}
@end
