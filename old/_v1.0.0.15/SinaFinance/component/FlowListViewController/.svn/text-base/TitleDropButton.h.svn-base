//
//  TitleDropButton.h
//  SinaFinance
//
//  Created by shieh exbice on 12-3-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CALayer;

@interface TitleDropButton : UIView
{
    UILabel* titleLabel;
    UIButton* titleBtn;
    NSString* titleString;
    CALayer *_arrowImage;
    NSInteger spacerInt;
    CGSize arrowSize;
    BOOL selected;
    id delegate;
}
@property(nonatomic,retain)UIButton* titleBtn;
@property(nonatomic,retain)UILabel* titleLabel;
@property(nonatomic,retain)NSString* titleString;
@property(nonatomic,assign)BOOL selected;
@property(nonatomic,assign)id delegate;
@property(nonatomic,assign)BOOL hasImage;
@end

@protocol TitleDrop_Delegate <NSObject>

-(void)titleDropBtnClicked:(TitleDropButton*)btn;

@end