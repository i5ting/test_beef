//
//  StockInfoViewController.h
//  SinaFinance
//
//  Created by shieh exbice on 12-4-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PushTixingAddViewController.h"

@class CommentDataList;

@interface SingleStockViewController : UIViewController<PushTixingAddViewControllerDelegate>
{
    NSDictionary* singleConfigDict;
    NSDictionary* listConfigDict;
    NSString* stockType;
    NSString* stockSymbol;
    NSString* stockName;
}

@property(nonatomic,retain)NSDictionary* singleConfigDict;
@property(nonatomic,retain)NSDictionary* listConfigDict;
@property(nonatomic,retain)NSString* stockType;
@property(nonatomic,retain)NSString* stockSymbol;
@property(nonatomic,retain)NSString* stockName;
@property(nonatomic,retain)PushTixingAddViewController* pushController;

+(NSString*)formatFloatString:(NSString*)sourceString style:(NSString*)style;

@end
