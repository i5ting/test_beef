//
//  OPMoviePlayController.m
//  NewsHD
//
//  Created by sgl on 12-9-17.
//  Copyright (c) 2012年 Sina. All rights reserved.
//

#import "OPMoviePlayController.h"
#import "ProjectLogUploader.h"
#import <QuartzCore/QuartzCore.h>

@interface MyMPMoviePlayerController : MPMoviePlayerController

@end

@implementation MyMPMoviePlayerController



@end

@interface OPMoviePlayController ()
- (void)initVideoPlayer;
@end

@implementation OPMoviePlayController
@synthesize videoURL = _videoURL;
@synthesize videoImage = _videoImage;
@synthesize playBtn = _playBtn;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithVideoID:(NSString *)videoID
{
    NSString *playurl = [NSString stringWithFormat:@"http://v.iask.com/v_play_ipad.php?vid=%@", videoID];
    return [self initWithURL:playurl];
}

- (id)initWithURL:(NSString *)playurl
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.videoURL = [NSURL URLWithString:playurl];
        [self initUI];
    }
    return self;
}

-(void)initUI
{
    self.view.clipsToBounds = NO;
    self.view.frame = CGRectMake(0, 0, 178, 142);
    
    UIImageView* imageContainView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"content_videoframe.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:20]];
    CGRect bounds = self.view.bounds;
    imageContainView.frame = CGRectMake(-11, -4, 200, 149);
    [self.view addSubview:imageContainView];
    [imageContainView release];
    OPImageView* imageView = [[OPImageView alloc] initWithFrame:self.view.bounds];
    imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:imageView];
    self.videoImage = imageView;
    [imageView release];
    
    UIButton* tempBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage* tempImage = [UIImage imageNamed:@"oparticle_play_btn.png"];
    [tempBtn setImage:tempImage forState:UIControlStateNormal];
    tempBtn.frame = CGRectMake(bounds.size.width/2-47/2, bounds.size.height/2-47/2, 47, 47);
    tempBtn.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin;
    [tempBtn addTarget:self action:@selector(playBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:tempBtn];
    self.playBtn = tempBtn;
}

- (void)initVideoPlayer
{
    player = [[MyMPMoviePlayerController alloc] init];
    player.view.frame = self.view.bounds;
    player.view.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:player.view];
    [self setupMoviePlayerListeners];
}

- (void)dealloc
{
    [_videoURL release];
    [_videoImage release];
    [self stopVideo];
    [player release];
    
    [_playBtn release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupMoviePlayerListeners {
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    
    [defaultCenter addObserver:self
                      selector:@selector(onMovieDurationAvailable:)
                          name:MPMovieDurationAvailableNotification
                        object:player];
    
    [defaultCenter addObserver:self
                      selector:@selector(onMovieLoadStateChanged:)
                          name:MPMoviePlayerLoadStateDidChangeNotification
                        object:player];
    
    [defaultCenter addObserver:self
                      selector:@selector(onMoviePlayerPlaybackDidFinish:)
                          name:MPMoviePlayerPlaybackDidFinishNotification object:player];
    [defaultCenter addObserver:self
                      selector:@selector(onMoviePlayerPlayWillEnterFullscreen:)
                          name:MPMoviePlayerDidEnterFullscreenNotification object:player];
    [defaultCenter addObserver:self
                      selector:@selector(onMoviePlayerPlayWillExitFullscreen:)
                          name:MPMoviePlayerWillExitFullscreenNotification object:player];
    
    
    
    //MPMoviePlayerPlaybackStateDidChangeNotification
    [defaultCenter addObserver:self
                      selector:@selector(onMoviePlayerPlaybackStateDidChange:)
                          name:MPMoviePlayerPlaybackStateDidChangeNotification object:player];
    

//    [defaultCenter addObserver:self
//                      selector:@selector(handleEnterFullScreen:)
//                          name:MPMoviePlayerWillEnterFullscreenNotification
//                        object:player];
//
//    [defaultCenter addObserver:self
//                      selector:@selector(handleExitFullScreen:)
//                          name:MPMoviePlayerWillExitFullscreenNotification
//                        object:player];
}

- (void)removeMovePlayerListeners
{
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    
    [defaultCenter removeObserver:self];
}

#pragma mark - MoviePlayer Notifications
- (void)onMovieDurationAvailable:(NSNotification *)notification
{
//    self.requestAsset.duration = [[notification object] duration];
//
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMovieDurationAvailableNotification object:self.moviePlayer];
}

- (void)onMovieLoadStateChanged:(NSNotification *)notification
{
    if (player.loadState == MPMovieLoadStatePlayable) {
//        [self showLoadingActivity:NO];
    }
    else if (MPMovieLoadStatePlaythroughOK == player.loadState) {
//        [self showLoadingActivity:NO];
    }
    CGRect playerRect = player.view.frame;
    playerRect.size.width += 0;
}

- (void)onMoviePlayerPlaybackDidFinish:(NSNotification *)notification
{
    BOOL bshow = NO;
    NSNumber* reason = [[notification userInfo] objectForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey];
    switch ([reason intValue]) {
        case MPMovieFinishReasonPlaybackEnded: {
            if (player.isFullscreen) {
                [player setFullscreen:NO animated:YES];
            }
            _videoImage.hidden = NO;
            _playBtn.hidden = NO;
            player.view.hidden = YES;
            break;
        }
        case MPMovieFinishReasonPlaybackError:
            bshow = YES;
//            [WDAlertView quickAlert:@"" msg:@"获取视频错误"];
            break;
        case MPMovieFinishReasonUserExited:
            break;
        default:
            break;
    }
}

- (void)onMoviePlayerPlaybackStateDidChange:(NSNotification *)notification
{
    if (MPMoviePlaybackStatePlaying == player.playbackState) {
        //        [self showLoadingActivity:NO];
    }
    if (MPMoviePlaybackStateSeekingForward == player.playbackState) {
        //[self showLoadingActivity:NO];
    }
    if (MPMoviePlaybackStateSeekingBackward == player.playbackState) {
        //[self showLoadingActivity:NO];
    }
}

- (void)onMoviePlayerPlayWillEnterFullscreen:(NSNotification *)notification
{
    
}


- (void)onMoviePlayerPlayWillExitFullscreen:(NSNotification *)notification
{
    
}

//- (void)handleEnterFullScreen:(NSNotification *)notification
//{
////    [UIApplication sharedApplication].statusBarHidden = YES;
////    self.navigationController.navigationBarHidden = YES;

//}
//
//- (void)handleExitFullScreen:(NSNotification *)notification
//{
////    [UIApplication sharedApplication].statusBarHidden = NO;
////    self.navigationController.navigationBarHidden = NO;
////    self.navigationController.view.frame = CGRectMake(20, 0, 1024, 768);
//}

- (void)viewDidUnload {
    [self setPlayBtn:nil];
    [super viewDidUnload];
}

- (IBAction)playBtnClicked:(id)sender
{
    [[ProjectLogUploader getInstance] writeDataString:@"Video_play"];
    if (player == nil) {
        [self initVideoPlayer];
    }

    _playBtn.hidden = YES;
    _videoImage.hidden = YES;
    player.contentURL = _videoURL;
    player.view.hidden = NO;
    [player prepareToPlay];
    [player play];
}

- (void)stopVideo
{
    if (player) {
        [player stop];
        [self removeMovePlayerListeners];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

@end
