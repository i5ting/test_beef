//
//  WeiboTableViewCell.m
//  SinaNews
//
//  Created by shieh exbice on 11-11-22.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "WeiboTableViewCell.h"
#import "MyTool.h"
#import "UIImageView+WebCache.h"
#import <QuartzCore/QuartzCore.h>

#define kFullWeiboCell_title 121212
#define kFullWeiboCell_time 121213
#define kFullWeiboCell_clock 211210
#define kFullWeiboCell_content 121214
#define kFullWeiboCell_contentBtn 1212144
#define kFullWeiboCell_validate 121215
#define kFullWeiboCell_repostedMark 1212155
#define kFullWeiboCell_url 121216
#define kFullWeiboCell_repost 121217
#define kFullWeiboCell_comment 121218
#define kFullWeiboCell_favarite 121219
#define kFullWeiboCell_Avatar 133333
#define kFullWeiboCell_AvatarBack 1333330
#define kFullWeiboCell_Device 133334
#define kFullWeiboCell_Image 133335
#define kFullWeiboCell_ImageBack 1333350
#define kFullWeiboCell_ImageBtn 143335
#define kFullWeiboCell_repostImage 133336
#define kFullWeiboCell_commentImage 133337
#define kFullWeiboCell_favoriteImage 133338
#define kFullWeiboCell_repostBtn 143344
#define kFullWeiboCell_commentBtn 143345
#define kFullWeiboCell_favoriteBtn 143346


#define kFullWeibo_TitleFontSize 18.0
#define kFullWeibo_TimeFontSize 10.0
#define kFullWeibo_ContentFontSize 15.0
#define kFullWeibo_DeviceFontSize 10.0

@interface FullWeiboTableViewCell ()
-(void)initUI;
-(void)myLayoutSubviews;

@end

@implementation FullWeiboTableViewCell

@synthesize nameString,createDate,contentString,urlString,repostCount,commentCont,hasValidate,data,avatar,sourceDevice;
@synthesize delegate;
@synthesize repostedFeed;
@synthesize validateType;

-(void)dealloc
{
    [nameString release];
    [createDate release];
    [contentString release];
    [urlString release];
    [data release];
    [avatar release];
    [sourceDevice release];
    
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        hasInit = NO;
    }
    return self;
}

-(void)initUI
{
    self.userInteractionEnabled = YES;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];
    
    UIImage* imagebackImage = [UIImage imageNamed:@"cell_pic_mask.png"];
    
    UIImageView* avatarBackView = [[UIImageView alloc] init];
    avatarBackView.image = imagebackImage;
    avatarBackView.tag = kFullWeiboCell_AvatarBack;
    [self.contentView addSubview:avatarBackView];
    [avatarBackView release];
    
    UIImageView* avatarImageView = [[UIImageView alloc] init];
    avatarImageView.backgroundColor = [UIColor clearColor];
    avatarImageView.tag = kFullWeiboCell_Avatar; 
    [self.contentView addSubview:avatarImageView];
    [avatarImageView release];
    
    UILabel* titleLabel = [[UILabel alloc] init];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.tag = kFullWeiboCell_title;
    titleLabel.font = [UIFont systemFontOfSize:kFullWeibo_TitleFontSize];
    [self.contentView addSubview:titleLabel];
    [titleLabel release];
    
    UIImageView* vImageView = [[UIImageView alloc] init];
    vImageView.tag = kFullWeiboCell_validate;
    vImageView.image = [UIImage imageNamed:@"pic_vip.png"];
    [self.contentView addSubview:vImageView];
    [vImageView release];
    
    UIImageView* rMarkImageView = [[UIImageView alloc] init];
    rMarkImageView.tag = kFullWeiboCell_repostedMark;
    rMarkImageView.image = [UIImage imageNamed:@"weibo_reopst_mark.png"];
    [self.contentView addSubview:rMarkImageView];
    [rMarkImageView release];
    
    UIImageView* tImageView = [[UIImageView alloc] init];
    tImageView.tag = kFullWeiboCell_clock;
    tImageView.image = [UIImage imageNamed:@"pic_clock.png"];
    [self.contentView addSubview:tImageView];
    [tImageView release];
    
    UILabel* timeLabel = [[UILabel alloc] init];
    timeLabel.backgroundColor = [UIColor clearColor];
    timeLabel.tag = kFullWeiboCell_time;
    timeLabel.font = [UIFont systemFontOfSize:kFullWeibo_TimeFontSize];
    [self.contentView addSubview:timeLabel];
    [timeLabel release];
    

    UILabel* contentLabel = [[UILabel alloc] init];
    //contentLabel.dataDetectorEnabled = YES;
    contentLabel.backgroundColor = [UIColor clearColor];
    contentLabel.tag = kFullWeiboCell_content;
    contentLabel.numberOfLines = 0;
    contentLabel.font = [UIFont systemFontOfSize:kFullWeibo_ContentFontSize];
    [self.contentView addSubview:contentLabel];
    [contentLabel release];
    
    UIButton* contentBtn = [[UIButton alloc] init];
    contentBtn.tag = kFullWeiboCell_contentBtn;
    [contentBtn addTarget:self action:@selector(contentClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:contentBtn];
    [contentBtn release];
    
    UILabel* urlLabel = [[UILabel alloc] init];
    urlLabel.backgroundColor = [UIColor clearColor];
    urlLabel.tag = kFullWeiboCell_url;
    [self.contentView addSubview:urlLabel];
    [urlLabel release];
    
    UIImageView* imageViewBack = [[UIImageView alloc] init];
    imageViewBack.image = imagebackImage;
    imageViewBack.tag = kFullWeiboCell_ImageBack;
    [self.contentView addSubview:imageViewBack];
    [imageViewBack release];
    
    UIImageView* imageView = [[UIImageView alloc] init];
    imageView.tag = kFullWeiboCell_Image;
    [self.contentView addSubview:imageView];
    [imageView release];
    
    UIImage* clickBack = [UIImage imageNamed:@"clickback.png"];
    clickBack = [clickBack stretchableImageWithLeftCapWidth:4.0 topCapHeight:4.0];
    UIButton* imageViewBtn = [[UIButton alloc] init];
    imageViewBtn.tag = kFullWeiboCell_ImageBtn;
    [imageViewBtn setBackgroundImage:clickBack forState:UIControlStateHighlighted];
    [imageViewBtn addTarget:self action:@selector(imageClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:imageViewBtn];
    [imageViewBtn release];
    
    UILabel* deviceLabel = [[UILabel alloc] init];
    deviceLabel.backgroundColor = [UIColor clearColor];
    deviceLabel.tag = kFullWeiboCell_Device;
    deviceLabel.font = [UIFont systemFontOfSize:kFullWeibo_DeviceFontSize];
    deviceLabel.textColor = [UIColor colorWithRed:120/255.0 green:120/255.0 blue:120/255.0 alpha:1.0];
    [self.contentView addSubview:deviceLabel];
    [deviceLabel release];
    
    UILabel* repostLabel = [[UILabel alloc] init];
    repostLabel.backgroundColor = [UIColor clearColor];
    repostLabel.tag = kFullWeiboCell_repost;
    repostLabel.font = deviceLabel.font;
    [self.contentView addSubview:repostLabel];
    [repostLabel release];
    
    UILabel* commnetLabel = [[UILabel alloc] init];
    commnetLabel.backgroundColor = [UIColor clearColor];
    commnetLabel.tag = kFullWeiboCell_comment;
    commnetLabel.font = repostLabel.font;
    [self.contentView addSubview:commnetLabel];
    [commnetLabel release];
    
    UILabel* favariteLabel = [[UILabel alloc] init];
    favariteLabel.backgroundColor = [UIColor clearColor];
    favariteLabel.tag = kFullWeiboCell_favarite;
    favariteLabel.font = repostLabel.font;
    [self.contentView addSubview:favariteLabel];
    [favariteLabel release];
    
    UIImageView* repostView = [[UIImageView alloc] init];
    repostView.tag = kFullWeiboCell_repostImage;
    repostView.image = [UIImage imageNamed:@"btn_repost.png"];
    [self.contentView addSubview:repostView];
    [repostView release];
    
    UIImageView* commentView = [[UIImageView alloc] init];
    commentView.tag = kFullWeiboCell_commentImage;
    UIImage* tempImage = [UIImage imageNamed:@"btn_comment.png"];
    commentView.image = tempImage;
    [self.contentView addSubview:commentView];
    [commentView release];
    
    UIImageView* favoriteView = [[UIImageView alloc] init];
    favoriteView.tag = kFullWeiboCell_favoriteImage;
    favoriteView.image = [UIImage imageNamed:@"btn_store.png"];
    [self.contentView addSubview:favoriteView];
    [favoriteView release];
    
    UIButton* repostBtn = [[UIButton alloc] init];
    repostBtn.tag = kFullWeiboCell_repostBtn;
    [repostBtn addTarget:self action:@selector(repostClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [repostBtn setBackgroundImage:clickBack forState:UIControlStateHighlighted];
    [self.contentView addSubview:repostBtn];
    [repostBtn release]; 
    
    UIButton* commentBtn = [[UIButton alloc] init];
    commentBtn.tag = kFullWeiboCell_commentBtn;
    [commentBtn setBackgroundImage:clickBack forState:UIControlStateHighlighted];
    [commentBtn addTarget:self action:@selector(commentClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:commentBtn];
    [commentBtn release]; 
    
    UIButton* favoriteBtn = [[UIButton alloc] init];
    favoriteBtn.tag = kFullWeiboCell_favoriteBtn;
    [favoriteBtn setBackgroundImage:clickBack forState:UIControlStateHighlighted];
    [favoriteBtn addTarget:self action:@selector(favoriteClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:favoriteBtn];
    [favoriteBtn release]; 
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    UILabel* titleLabel = (UILabel*)[self.contentView viewWithTag:kFullWeiboCell_title];
    UILabel* createDateLabel = (UILabel*)[self.contentView viewWithTag:kFullWeiboCell_time];
    UILabel* contentLabel = (UILabel*)[self.contentView viewWithTag:kFullWeiboCell_content];
    UILabel* urlLabel = (UILabel*)[self.contentView viewWithTag:kFullWeiboCell_url];
    UILabel* repostLabel = (UILabel*)[self.contentView viewWithTag:kFullWeiboCell_repost];
    UILabel* commentLabel = (UILabel*)[self.contentView viewWithTag:kFullWeiboCell_comment];
    UILabel* favariteLabel = (UILabel*)[self.contentView viewWithTag:kFullWeiboCell_favarite];
    if (NO) {
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.textColor = [UIColor whiteColor];
        createDateLabel.textColor = [UIColor whiteColor];
        contentLabel.textColor = [UIColor whiteColor];
        urlLabel.textColor = [UIColor whiteColor];
        repostLabel.textColor = [UIColor whiteColor];
        commentLabel.textColor = [UIColor whiteColor];
        favariteLabel.textColor = [UIColor whiteColor];
        UIImage* backImage = [[UIImage imageNamed:@"tableselected.png"] stretchableImageWithLeftCapWidth:1.0 topCapHeight:40.0];
        UIImageView* backView = [[UIImageView alloc] initWithImage:backImage];
        self.backgroundView = backView;
        [backView release];
    }
    else
    {
        titleLabel.textColor = [UIColor blackColor];
        createDateLabel.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
        contentLabel.textColor = [UIColor blackColor];
        urlLabel.textColor = [UIColor blackColor];
        
        repostLabel.textColor = [UIColor colorWithRed:132/255.0 green:98/255.0 blue:25/255.0 alpha:1.0];
        commentLabel.textColor = [UIColor colorWithRed:132/255.0 green:98/255.0 blue:25/255.0 alpha:1.0];
        favariteLabel.textColor = [UIColor colorWithRed:132/255.0 green:98/255.0 blue:25/255.0 alpha:1.0];
        UIImage* backImage = [[UIImage imageNamed:@"wf_wiget_back.png"] stretchableImageWithLeftCapWidth:1.0 topCapHeight:40.0];
        UIImageView* backView = [[UIImageView alloc] initWithImage:backImage];
        self.backgroundView = backView;
        [backView release];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void)imageClicked:(UIButton*)sender
{
    if ([delegate respondsToSelector:@selector(cell:imageClicked:)]) {
        [delegate cell:self imageClicked:self.urlString];
    }
}

-(void)repostClicked:(UIButton*)sender
{
    if ([delegate respondsToSelector:@selector(cell:repostClicked:)]) {
        [delegate cell:self repostClicked:sender];
    }
}

-(void)commentClicked:(UIButton*)sender
{
    if ([delegate respondsToSelector:@selector(cell:commentClicked:)]) {
        [delegate cell:self commentClicked:sender];
    }
}

-(void)favoriteClicked:(UIButton*)sender
{
    if ([delegate respondsToSelector:@selector(cell:favoriteClicked:)]) {
        [delegate cell:self favoriteClicked:sender];
    }
}

-(void)contentClicked:(UIButton*)sender
{
    if ([delegate respondsToSelector:@selector(cell:contentClicked:)]) {
        [delegate cell:self contentClicked:sender];
    }
}


-(void)reloadData
{
    if (!hasInit) {
        hasInit = YES;
        [self initUI];
    }
    UIImageView* avatarView = (UIImageView*)[self.contentView viewWithTag:kFullWeiboCell_Avatar];
    UIImageView* avatarViewBack = (UIImageView*)[self.contentView viewWithTag:kFullWeiboCell_AvatarBack];
    if (avatar) {
        NSURL* url = [NSURL URLWithString:avatar];
        avatarView.hidden = NO;
        avatarViewBack.hidden = NO;
        UIImage* placeImage = [UIImage imageNamed:@"logo.png"];
        [avatarView setImageWithURL:url placeholderImage:placeImage];
    }
    else
    {
        avatarView.hidden = YES;
        avatarViewBack.hidden = YES;
    }
    
    UILabel* titleLabel = (UILabel*)[self.contentView viewWithTag:kFullWeiboCell_title];
    titleLabel.text = nameString;
    UIImageView* titleVImage = (UIImageView*)[self.contentView viewWithTag:kFullWeiboCell_validate];
    if(hasValidate)
    {
        titleVImage.hidden = NO;
    }
    else
    {
        titleVImage.hidden = YES;
    }
    if (validateType==0) {
        titleVImage.image = [UIImage imageNamed:@"pic_vip_yellow.png"];
    }
    else {
        titleVImage.image = [UIImage imageNamed:@"pic_vip.png"];
    }
    
    UIImageView* rMarkImageView = (UIImageView*)[self.contentView viewWithTag:kFullWeiboCell_repostedMark];
    if(repostedFeed&&avatar)
    {
        rMarkImageView.hidden = NO;
    }
    else
    {
        rMarkImageView.hidden = YES;
    }
    
    UILabel* createDateLabel = (UILabel*)[self.contentView viewWithTag:kFullWeiboCell_time];
    UIImageView* clockView = (UIImageView*)[self.contentView viewWithTag:kFullWeiboCell_clock];
    if (self.createDate) {
        NSString* dateStr = [MyTool humanizeDateFormatFromDate:self.createDate];
        createDateLabel.text = dateStr;
        clockView.hidden = NO;
    }
    else
    {
        createDateLabel.text = nil;
        clockView.hidden = YES;
    }
    
    UILabel* contentLabel = (UILabel*)[self.contentView viewWithTag:kFullWeiboCell_content];
    contentLabel.text = contentString;
    
    UILabel* urlLabel = (UILabel*)[self.contentView viewWithTag:kFullWeiboCell_url];
    if (urlString) {
        urlLabel.text = urlString;
    }
    else
    {
        urlLabel.text = nil;
    }
    
    UIImageView* imageView = (UIImageView*)[self.contentView viewWithTag:kFullWeiboCell_Image];
    UIImageView* imageViewBack = (UIImageView*)[self.contentView viewWithTag:kFullWeiboCell_ImageBack];
    UIButton* imageBtn = (UIButton*)[self.contentView viewWithTag:kFullWeiboCell_ImageBtn];
    if (urlString) {
        NSURL* url = [NSURL URLWithString:urlString];
        imageView.hidden = NO;
        imageBtn.hidden = NO;
        imageViewBack.hidden = NO;
        UIImage* placeImage = [UIImage imageNamed:@"logo.png"];
        [imageView setImageWithURL:url placeholderImage:placeImage];
    }
    else
    {
        imageView.image = nil;
        imageView.hidden = YES;
        imageViewBack.hidden = YES;
        imageBtn.hidden = YES;
    }
    
    UILabel* deviceLabel = (UILabel*)[self.contentView viewWithTag:kFullWeiboCell_Device];
    if (sourceDevice) {
        NSString* deviceStr = [NSString stringWithFormat:@"来自%@",sourceDevice];
        deviceLabel.text = deviceStr;
        
    }
    else
    {
        deviceLabel.text = nil;
    }
    
    UILabel* repostLabel = (UILabel*)[self.contentView viewWithTag:kFullWeiboCell_repost];
    repostLabel.text = [NSString stringWithFormat:@"%d",self.repostCount];
    
    UILabel* commentLabel = (UILabel*)[self.contentView viewWithTag:kFullWeiboCell_comment];
    commentLabel.text = [NSString stringWithFormat:@"%d",self.commentCont];
    
    UILabel* favariteLabel = (UILabel*)[self.contentView viewWithTag:kFullWeiboCell_favarite];
    favariteLabel.text = @"收藏";
}

-(void)reloadTimeString
{
    UILabel* createDateLabel = (UILabel*)[self.contentView viewWithTag:kFullWeiboCell_time];
    if (self.createDate) {
        NSString* dateStr = [MyTool humanizeDateFormatFromDate:self.createDate];
        createDateLabel.text = dateStr;
    }
    else
    {
        createDateLabel.text = nil;
    }
    [self myLayoutSubviews];
}

-(void)myLayoutSubviews
{
    CGRect mainRect = self.bounds;
    int borderMargin = 10;
    mainRect = CGRectMake(mainRect.origin.x + borderMargin, mainRect.origin.y + borderMargin, mainRect.size.width - 2*borderMargin, mainRect.size.height - 2*borderMargin);
    
    if (avatar) {
        UIImageView* avatarView = (UIImageView*)[self.contentView viewWithTag:kFullWeiboCell_Avatar];
        UIImageView* avatarViewBack = (UIImageView*)[self.contentView viewWithTag:kFullWeiboCell_AvatarBack];
        CGRect avatarRect = mainRect;
        avatarRect.size = CGSizeMake(40, 40);
        avatarView.frame =avatarRect;
        CGRect avatorBackRect = avatarRect;
        avatorBackRect.origin.x -= 2;
        avatorBackRect.origin.y -= 2;
        avatorBackRect.size.width += 2*2;
        avatorBackRect.size.height += 2*2;
        avatarViewBack.frame = avatorBackRect;
        int oldX = mainRect.origin.x;
        mainRect.origin.x = avatarRect.origin.x + avatarRect.size.width + 5;
        mainRect.size.width = mainRect.size.width - (mainRect.origin.x - oldX);
    }
    
    UILabel* titleLabel = (UILabel*)[self.contentView viewWithTag:kFullWeiboCell_title];
    [titleLabel sizeToFit];
    UILabel* createDateLabel = (UILabel*)[self.contentView viewWithTag:kFullWeiboCell_time];
    [createDateLabel sizeToFit];
    CGRect createDateRect = CGRectMake(mainRect.origin.x+mainRect.size.width - createDateLabel.frame.size.width, mainRect.origin.y + (titleLabel.frame.size.height/2 - createDateLabel.frame.size.height/2), createDateLabel.frame.size.width, createDateLabel.frame.size.height);
    createDateLabel.frame = createDateRect;
    
    UIImageView* clockImge = (UIImageView*)[self.contentView viewWithTag:kFullWeiboCell_clock];
    CGRect clockImgeRect = CGRectZero;
    clockImgeRect.size = CGSizeMake(10, 10);
    clockImgeRect.origin.x = createDateRect.origin.x - 18;
    clockImgeRect.origin.y = createDateRect.origin.y + createDateRect.size.height/2 - clockImgeRect.size.height/2;
    clockImge.frame = clockImgeRect;
    
    CGSize vSzie = CGSizeZero;
    int vMargin = 0;
    int vCount = 0;
    if (hasValidate||repostedFeed) 
    {
        //UIImageView* titleVImage = (UIImageView*)[self.contentView viewWithTag:kFullWeiboCell_validate];
        vSzie = CGSizeMake(15, 15);
        vMargin = 2;
        if (hasValidate) {
            vCount++;
        }
        if (repostedFeed) {
            vCount++;
        }
    }
    
    CGRect titleRect = mainRect;
    titleRect.size.width = clockImgeRect.origin.x - 3 - (vSzie.width + vMargin)*vCount - titleRect.origin.x;
    if (titleLabel.frame.size.width<titleRect.size.width) {
        titleRect.size.width = titleLabel.frame.size.width;
    }
    titleRect.size.height = titleLabel.frame.size.height;
    titleLabel.frame = titleRect;
    
    CGRect titleVImageRect = titleRect;
    titleVImageRect.origin.x = titleRect.origin.x + titleRect.size.width +vMargin;
    titleVImageRect.size = CGSizeZero;
    if (hasValidate) 
    {
        UIImageView* titleVImage = (UIImageView*)[self.contentView viewWithTag:kFullWeiboCell_validate];
        titleVImageRect.size = vSzie;
        titleVImageRect.origin.y = titleRect.origin.y + (titleRect.size.height/2 - titleVImageRect.size.height/2);
        titleVImage.frame = titleVImageRect;
    }
    CGRect rMarkRect = titleRect;
    if (hasValidate) {
        rMarkRect.origin.x = titleVImageRect.origin.x + titleVImageRect.size.width +vMargin;
    }
    else
    {
        rMarkRect.origin.x = titleRect.origin.x + titleRect.size.width +vMargin;
    }
    rMarkRect.size = CGSizeZero;
    if (self.repostedFeed) {
        UIImageView* rMarkImageView = (UIImageView*)[self.contentView viewWithTag:kFullWeiboCell_repostedMark];
        rMarkRect.size = vSzie;
        rMarkRect.origin.y = titleRect.origin.y + (titleRect.size.height/2 - rMarkRect.size.height/2);
        rMarkImageView.frame = rMarkRect;
        
    }
    
    int spacerW = 8;
    int spacerH = 2;
    UILabel* contentLabel = (UILabel*)[self.contentView viewWithTag:kFullWeiboCell_content];
    CGRect contentRect = CGRectMake(mainRect.origin.x, titleRect.origin.y + titleRect.size.height + spacerH, mainRect.size.width, mainRect.size.height);
    contentLabel.frame = contentRect;
    [contentLabel sizeToFit];
    contentRect.size = contentLabel.frame.size;
    
    UIButton* contentBtn = (UIButton*)[self.contentView viewWithTag:kFullWeiboCell_contentBtn]; 
    contentBtn.frame = contentRect;
    
    UILabel* urlLabel = (UILabel*)[self.contentView viewWithTag:kFullWeiboCell_url];
    int extraHeight = 0;
    if (NO) {
        CGRect urlRect = mainRect;
        urlRect.origin.y = contentRect.origin.y + contentRect.size.height + spacerH;
        [urlLabel sizeToFit];
        extraHeight = urlLabel.frame.size.height + spacerH;
    }
    
    if (urlString) {
        UIImageView* imageView = (UIImageView*)[self.contentView viewWithTag:kFullWeiboCell_Image];
        UIButton* imageBtn = (UIButton*)[self.contentView viewWithTag:kFullWeiboCell_ImageBtn];
        UIImageView* imageViewBack = (UIImageView*)[self.contentView viewWithTag:kFullWeiboCell_ImageBack];
        CGRect imageRect = CGRectMake(0, 0, 80, 80);
        imageRect.origin.y = contentRect.origin.y + contentRect.size.height + extraHeight + spacerH;
        imageRect.origin.x = mainRect.origin.x + (imageRect.size.width/2 - imageRect.size.width/2);
        imageView.frame = imageRect;
        imageBtn.frame = imageRect;
        CGRect imageBackRect = imageRect;
        imageBackRect.origin.x -= 2;
        imageBackRect.origin.y -= 2;
        imageBackRect.size.width += 2*2;
        imageBackRect.size.height += 2*2;
        imageViewBack.frame = imageBackRect;
        extraHeight += imageRect.size.height + spacerH;
    }
    
    int bottomSpacer = 15;
    CGRect bottomRect = CGRectMake(mainRect.origin.x, contentRect.origin.y+ contentRect.size.height + bottomSpacer + extraHeight, mainRect.size.width, mainRect.size.height);
    bottomRect.size.height = mainRect.origin.y + mainRect.size.height - bottomRect.origin.y;
    
    UILabel* favoriteLabel = (UILabel*)[self.contentView viewWithTag:kFullWeiboCell_favarite];
    [favoriteLabel sizeToFit];
    CGRect favoriteRect = bottomRect;
    favoriteRect.size = favoriteLabel.frame.size;
    favoriteRect.origin.x = bottomRect.origin.x + bottomRect.size.width - favoriteRect.size.width;
    favoriteLabel.frame = favoriteRect;
    
    UIImageView* favoriteView = (UIImageView*)[self.contentView viewWithTag:kFullWeiboCell_favoriteImage];
    CGRect favoriteImageRect = bottomRect;
    //commentImageRect.size = commentView.image.size;
    favoriteImageRect.size = CGSizeMake(15, 15);
    favoriteImageRect.origin.x = favoriteRect.origin.x - favoriteImageRect.size.width - 3;
    favoriteImageRect.origin.y = bottomRect.origin.y + (bottomRect.size.height/2 - favoriteImageRect.size.height/2);
    favoriteView.frame = favoriteImageRect;
    
    UIButton* favoriteBtn = (UIButton*)[self.contentView viewWithTag:kFullWeiboCell_favoriteBtn];
    int favoriteBtnY = favoriteImageRect.origin.y>favoriteRect.origin.y?favoriteRect.origin.y:favoriteImageRect.origin.y;
    int favoriteBtnHeight = favoriteImageRect.size.height>favoriteRect.size.height?favoriteImageRect.size.height:favoriteRect.size.height;
    int newFavoriteHeight = favoriteBtnHeight>25?favoriteBtnHeight:25;
    favoriteBtnY = favoriteBtnY - (newFavoriteHeight - favoriteBtnHeight)/2;
    favoriteBtnHeight = newFavoriteHeight;
    int favoriteBtnWidth = favoriteRect.origin.x+favoriteRect.size.width-favoriteImageRect.origin.x + spacerW;
    int favoriteBtnX = favoriteImageRect.origin.x - spacerW/2;
    CGRect favoriteBtnRect = CGRectMake(favoriteBtnX, favoriteBtnY, favoriteBtnWidth, favoriteBtnHeight);
    favoriteBtn.frame = favoriteBtnRect;
    
    
    UILabel* commentLabel = (UILabel*)[self.contentView viewWithTag:kFullWeiboCell_comment];
    [commentLabel sizeToFit];
    CGRect commentRect = bottomRect;
    commentRect.size = commentLabel.frame.size;
    commentRect.origin.x = favoriteImageRect.origin.x - commentRect.size.width - spacerW;
    commentLabel.frame = commentRect;
    
    UIImageView* commentView = (UIImageView*)[self.contentView viewWithTag:kFullWeiboCell_commentImage];
    CGRect commentImageRect = bottomRect;
    //commentImageRect.size = commentView.image.size;
    commentImageRect.size = CGSizeMake(15, 15);
    commentImageRect.origin.x = commentRect.origin.x - commentImageRect.size.width - 3;
    commentImageRect.origin.y = bottomRect.origin.y + (bottomRect.size.height/2 - commentImageRect.size.height/2);
    commentView.frame = commentImageRect;
    
    UIButton* commentBtn = (UIButton*)[self.contentView viewWithTag:kFullWeiboCell_commentBtn];
    int commentBtnY = commentImageRect.origin.y>commentRect.origin.y?commentRect.origin.y:commentImageRect.origin.y;
    int commentBtnHeight = commentImageRect.size.height>commentRect.size.height?commentImageRect.size.height:commentRect.size.height;
    int newCommentHeight = commentBtnHeight>25?commentBtnHeight:25;
    commentBtnY = commentBtnY - (newCommentHeight - commentBtnHeight)/2;
    commentBtnHeight = newCommentHeight;
    int commentBtnWidth = commentRect.origin.x+commentRect.size.width-commentImageRect.origin.x + spacerW;
    int commentBtnX = commentImageRect.origin.x - spacerW/2;
    CGRect commentBtnRect = CGRectMake(commentBtnX, commentBtnY, commentBtnWidth, commentBtnHeight);
    commentBtn.frame = commentBtnRect;
    
    UILabel* repostLabel = (UILabel*)[self.contentView viewWithTag:kFullWeiboCell_repost];
    CGRect repostRect = bottomRect;
    [repostLabel sizeToFit];
    repostRect.size = repostLabel.frame.size;
    repostRect.origin.x = commentImageRect.origin.x - repostRect.size.width - spacerW;
    repostLabel.frame = repostRect;

    UIImageView* repostView = (UIImageView*)[self.contentView viewWithTag:kFullWeiboCell_repostImage];
    CGRect repostImageRect = bottomRect;
    //repostImageRect.size = repostView.image.size;
    repostImageRect.size = CGSizeMake(15, 15);
    repostImageRect.origin.x = repostRect.origin.x - repostImageRect.size.width - 3;
    repostImageRect.origin.y = bottomRect.origin.y + (bottomRect.size.height/2 - repostImageRect.size.height/2);
    repostView.frame = repostImageRect;
    
    UIButton* repostBtn = (UIButton*)[self.contentView viewWithTag:kFullWeiboCell_repostBtn];
    int repostBtnY = repostImageRect.origin.y>repostRect.origin.y?repostRect.origin.y:repostImageRect.origin.y;
    int repostBtnHeight = repostImageRect.size.height>repostRect.size.height?repostImageRect.size.height:repostRect.size.height;
    int newRepostHeight = repostBtnHeight>25?repostBtnHeight:25;
    repostBtnY = repostBtnY - (newRepostHeight - repostBtnHeight)/2;
    repostBtnHeight = newRepostHeight;
    int repostBtnWidth = repostRect.origin.x+repostRect.size.width-repostImageRect.origin.x + spacerW;
    int repostBtnX = repostImageRect.origin.x - spacerW/2;
    CGRect repostBtnRect = CGRectMake(repostBtnX, repostBtnY, repostBtnWidth, repostBtnHeight);
    repostBtn.frame = repostBtnRect;
    
    UILabel* deviceLabel = (UILabel*)[self.contentView viewWithTag:kFullWeiboCell_Device];
    CGRect deviceRect = bottomRect;
    [deviceLabel sizeToFit];
    deviceRect.size.height = deviceLabel.frame.size.height;
    deviceRect.size.width = repostBtnRect.origin.x - 3 - deviceRect.origin.x;
    if (deviceRect.size.width>deviceLabel.frame.size.width) {
        deviceRect.size.width = deviceLabel.frame.size.width;
    }
    deviceLabel.frame = deviceRect;
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    if (!CGRectEqualToRect(frame, CGRectZero)) {
        [self myLayoutSubviews];
    }
}

-(CGSize)sizeThatFits:(CGSize)size
{
    CGRect mainRect = CGRectMake(0, 0, 320, 2000);
    int borderMargin = 10;
    mainRect = CGRectMake(mainRect.origin.x + borderMargin, mainRect.origin.y + borderMargin, mainRect.size.width - 2*borderMargin, mainRect.size.height - 2*borderMargin);

    if (avatar) {
        //UIImageView* avatarView = (UIImageView*)[self.contentView viewWithTag:kFullWeiboCell_Avatar];
        CGRect avatarRect = mainRect;
        avatarRect.size = CGSizeMake(40, 40);
        int oldX = mainRect.origin.x;
        mainRect.origin.x = avatarRect.origin.x + avatarRect.size.width + 5;
        mainRect.size.width = mainRect.size.width - (mainRect.origin.x - oldX);
    }

    //UILabel* titleLabel = (UILabel*)[self.contentView viewWithTag:kFullWeiboCell_title];
    CGRect titleRect = mainRect;
    titleRect.size = [nameString sizeWithFont:[UIFont systemFontOfSize:kFullWeibo_TitleFontSize]];

    int spacerW = 15;
    int spacerH = 2;
    //UILabel* contentLabel = (UILabel*)[self.contentView viewWithTag:kFullWeiboCell_content];
    CGRect contentRect = CGRectMake(mainRect.origin.x, titleRect.origin.y + titleRect.size.height + spacerH, mainRect.size.width, mainRect.size.height);
    contentRect.size = [contentString sizeWithFont:[UIFont systemFontOfSize:kFullWeibo_ContentFontSize] constrainedToSize:contentRect.size];

    int extraHeight = 0;
    /*
    UILabel* urlLabel = (UILabel*)[self.contentView viewWithTag:kFullWeiboCell_url];
    if (NO) {
        CGRect urlRect = mainRect;
        urlRect.origin.y = contentRect.origin.y + contentRect.size.height + spacerH;
        [urlLabel sizeToFit];
        extraHeight = urlLabel.frame.size.height + spacerH;
    }
     */
    
    if (urlString) {
        CGRect imageRect = CGRectMake(0, 0, 80, 80);
        imageRect.origin.y = contentRect.origin.y + contentRect.size.height + extraHeight + spacerH;
        imageRect.origin.x = mainRect.origin.x + (imageRect.size.width/2 - imageRect.size.width/2);
        extraHeight += imageRect.size.height + spacerH;
    }
    
    int bottomSpacer = 15;
    CGRect bottomRect = CGRectMake(mainRect.origin.x, contentRect.origin.y+ contentRect.size.height + bottomSpacer + extraHeight, mainRect.size.width, mainRect.size.height);
    
    //UILabel* repostLabel = (UILabel*)[self.contentView viewWithTag:kFullWeiboCell_repost];
    CGSize repostSize = (CGSize)[@" " sizeWithFont:[UIFont systemFontOfSize:kFullWeibo_DeviceFontSize]];
    bottomRect.size.height = repostSize.height;
    
    CGSize totalSize = CGSizeZero;
    totalSize.width = 320;
    totalSize.height = bottomRect.origin.y + bottomRect.size.height + borderMargin;
    return totalSize;
}

@end