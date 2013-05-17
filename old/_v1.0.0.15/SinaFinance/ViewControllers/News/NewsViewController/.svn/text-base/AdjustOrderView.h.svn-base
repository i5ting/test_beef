//
//  AdjustOrderView.h
//  SinaFinance
//
//  Created by shieh exbice on 12-5-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AdjustOrderView : UIView
{
    id delegate;
    id data;
}

@property(nonatomic,assign)id delegate;
@property(nonatomic,retain)id data;
@property(nonatomic,assign)BOOL immediateWorked;

-(void)setDataArray:(NSArray*)aDataArray;
-(void)setFinished:(BOOL)bFinished;

@end

@protocol AdjustOrderView_Delegate <NSObject>

-(void)view:(AdjustOrderView*)view adjustFinished:(NSArray*)dataArray;
@property(nonatomic,retain)id data;

-(void)setDataArray:(NSArray*)aDataArray;

@end
