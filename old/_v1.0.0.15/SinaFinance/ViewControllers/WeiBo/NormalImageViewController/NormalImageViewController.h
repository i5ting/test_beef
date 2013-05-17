//
//  NormalImageViewController.h
//  SinaNews
//
//  Created by shieh exbice on 11-12-7.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "BCViewController.h"

@class PicNewsContentView;

@interface NormalImageViewController : BCViewController
{
    BOOL bFullShowed;
    PicNewsContentView* picContentView;
    BOOL bInited;
}

@property(nonatomic,retain)NSArray* imageObjectList;
@property(nonatomic,assign)BOOL loading;
@property(nonatomic,assign,readonly)BOOL playing;

@end
