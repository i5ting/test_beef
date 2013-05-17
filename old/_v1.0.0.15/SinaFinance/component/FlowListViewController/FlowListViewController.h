//
//  FlowListViewController.h
//  SinaFinance
//
//  Created by shieh exbice on 12-3-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FlowListViewController : UIViewController
{
    NSArray* listNames;
    NSArray* separateList;
    id delegate;
    CGPoint hotPoint;
    NSInteger selectedIndex;
    BOOL seletedInvalid;
}

@property(nonatomic,assign)id delegate;
@property(nonatomic,retain)NSArray* listNames;
@property(nonatomic,retain)NSArray* separateList;
@property(nonatomic,assign)NSInteger selectedIndex;


-(id)initWithSelectedIndex:(NSInteger)index;
-(void)show:(CGPoint)point boxSize:(CGSize)boxSize;
-(void)dismiss:(BOOL)animate;

@end

@protocol FlowList_Delegate <NSObject>

-(void)controller:(FlowListViewController*)controller didSelectIndex:(NSInteger)index byBtn:(BOOL)byBtn;
-(void)controllerHidenWithController:(FlowListViewController*)controller;

@end