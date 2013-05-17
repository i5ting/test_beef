//
//  ComposeWeiboViewController.h
//  SinaNews
//
//  Created by shieh exbice on 11-12-6.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

enum ComposeType
{
    ComposeType_publish,
    ComposeType_repost,
    ComposeType_comment,
    ComposeType_repostNews
};

@class NewsObject;
@class PageControllerView;
@class MyCustomToolbar;

@interface ComposeWeiboViewController : UIViewController
{
    IBOutlet UITextView* inputView;
    IBOutlet UILabel* tipLabel;
    IBOutlet UIView* backView;
    IBOutlet PageControllerView* emotionView;
    NSInteger curCountLeft;
	MyCustomToolbar *topToolbar;
    BOOL bInited;
    BOOL bNowordValid;
}

@property(nonatomic,retain)UITextView* inputView;
@property(nonatomic,retain)UILabel* tipLabel;
@property(nonatomic,retain)UIView* backView;
@property(nonatomic,retain)PageControllerView* emotionView;
@property(nonatomic,assign)NSInteger type;
@property(nonatomic,retain)NSString* preString;
@property(nonatomic,retain)NSString* mid;
@property(nonatomic,assign)BOOL isSnap;

-(IBAction)emotionClicked:(id)sender;
-(IBAction)topicClicked:(id)sender;
-(IBAction)mentionedClicked:(id)sender;

@end
