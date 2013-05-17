//
//  OPCoreTextView.h
//  OPCoreText
//
//  Created by Sun Guanglei on 12-9-12.
//  Copyright (c) 2012年 Sina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>

@interface OPCoreTextView : UIScrollView

@property (nonatomic, strong) NSAttributedString *contentString;
@property (retain, nonatomic) NSMutableArray* images;
@property (assign, nonatomic) id imageDelegate;
@property (assign, nonatomic) BOOL nightMode;

@end

@protocol OPCoreTextView_Delegate <NSObject>

-(UIView*)coreTextView:(OPCoreTextView*)view viewWithURLString:(NSString*)urlString bounds:(CGRect)bounds;

@end
