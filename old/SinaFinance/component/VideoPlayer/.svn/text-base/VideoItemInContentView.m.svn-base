//
//  VideoItemInContentView.m
//  SinaNewsHD
//
//  Created by duzhe on 11-4-7.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "VideoItemInContentView.h"
#import "UIImageView+WebCache.h"

#define placeholder_photo	@"placeholder_logo.png"
#define placeholder_photo_length	160

@implementation VideoData

@synthesize imageURL,videoURL;

-(void)dealloc
{
    [imageURL release];
    [videoURL release];
    
    [super dealloc];
}


@end

@implementation VideoItemInContentView

@synthesize moviePlayController,videoData;

- (id)initWithFrame:(CGRect)frame
{
	if (self = [super initWithFrame:frame])
	{
		self.backgroundColor = [UIColor clearColor];
		imageContainView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"ContentImageBorder.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:20]];
		imageContainView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
		[self addSubview:imageContainView];
		[imageContainView release];
		
		playImageView = [[UIImageView alloc] initWithFrame:CGRectMake(6, 6, imageContainView.bounds.size.width - 12, imageContainView.bounds.size.height - 12)];
		playImageView.backgroundColor = [UIColor grayColor];
		[imageContainView addSubview:playImageView];
		[playImageView release];
		
		float minL = 10000.0;
        minL = MIN(frame.size.height, frame.size.width);
        minL = MIN(placeholder_photo_length, minL);
        if (minL > 1) {
            iconView = [[UIImageView alloc] initWithFrame:CGRectMake((frame.size.width - minL)/2.0, (frame.size.height - minL)/2.0, minL, minL)];
            [iconView setImage:[UIImage imageNamed:placeholder_photo]];
            [imageContainView addSubview:iconView];
            [iconView release];
            
        }

		
		playholderView = [[UIImageView alloc] initWithFrame:CGRectMake((imageContainView.bounds.size.width - 94) / 2, (imageContainView.bounds.size.height - 94) / 2, 94, 94)];
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
    NSURL* url = [NSURL URLWithString:videoData.imageURL];
    [playImageView setImageWithURL:url];
}

-(void)setVideoData:(VideoData *)aVideoData
{
    if (videoData!=aVideoData) {
        [videoData release];
        videoData = aVideoData;
        [videoData retain];
    }
    [self sendImageRequst];
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
    //NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"http://v.iask.com/v_play_ipad.php?vid=%@",videoData.videoURL]];
    NSURL* url = [NSURL URLWithString:videoData.videoURL];
    MPMoviePlayerController* movieController = [[MPMoviePlayerController alloc] initWithContentURL:url];
	self.moviePlayController= movieController;
    [movieController release];
	
	if (moviePlayController)                      
	{
		[[NSNotificationCenter defaultCenter] 
		 addObserver:self
		 selector:@selector(movieFinishedCallback:)
		 name:MPMoviePlayerPlaybackDidFinishNotification
		 object:moviePlayController];
		moviePlayController.view.frame = CGRectMake(6, 6, imageContainView.bounds.size.width - 12, imageContainView.bounds.size.height - 12);
		moviePlayController.view.backgroundColor = [UIColor clearColor];
		[self addSubview:moviePlayController.view];
		[moviePlayController prepareToPlay];
		[moviePlayController play];	
		
	}
	
}

-(void)clear
{
    [self releaseMovieController];
	[[NSNotificationCenter defaultCenter] 
	 removeObserver:self
	 name:MPMoviePlayerPlaybackDidFinishNotification
	 object:nil];
    self.videoData = nil;
}

- (void)dealloc
{
	[self releaseMovieController];
	[[NSNotificationCenter defaultCenter] 
	 removeObserver:self
	 name:MPMoviePlayerPlaybackDidFinishNotification
	 object:nil];
    [videoData release];
    
    
	[super dealloc];
}
@end
