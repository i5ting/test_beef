//
//  KLineViewController.h
//  SinaFinance
//
//  Created by shieh exbice on 12-4-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NewsObject;

@interface KLineViewController : UIViewController
{
    NSDictionary* subConfigDict;
    NSString* stockType;
    NSString* stockSymbol;
    NSString* stockName;
    NSString* subType;
}

@property(nonatomic,retain)NSDictionary* subConfigDict;
@property(nonatomic,retain)NewsObject* singleStockData;
@property(nonatomic,retain)NSString* stockType;
@property(nonatomic,retain)NSString* stockSymbol;
@property(nonatomic,retain)NSString* stockName;
@property(nonatomic,retain)NSString* subType;
@property(nonatomic,retain)NSString* curStatus;

@property(nonatomic,retain)id delegate;

-(void)exit;
-(void)reloadData;

@end

@protocol KLineViewController_Delegate <NSObject>

-(void)controllerBackClicked:(KLineViewController*)controller;

@end
