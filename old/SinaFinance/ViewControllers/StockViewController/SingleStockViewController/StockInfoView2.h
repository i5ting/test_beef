//
//  StockInfoView.h
//  SinaFinance
//
//  Created by shieh exbice on 12-4-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

//enum StockInfoViewType
//{
//    ViewType_Info = 0,
//    ViewType_titleItem0,
//    ViewType_titleItem1
//};
//
//@interface StockInfoOneColumnData : NSObject
//{
//    BOOL justName;
//    NSString* name;
//    NSString* preName;
//    UIColor* fontColor;
//}
//@property(nonatomic,assign)BOOL justName;
//@property(nonatomic,retain)NSString* name;
//@property(nonatomic,retain)NSString* preName;
//@property(nonatomic,retain)UIColor* fontColor;
//
//@end
//
// 
//
//@interface StockInfoCellData : NSObject
//{
//    NSMutableArray* columnData;
//}
//@property(nonatomic,retain)NSMutableArray* columnData;

//@end

@interface StockInfoView2 : UIView
{
    NSArray* dataArray;
    NSArray* widthArray;
}

@property(nonatomic,retain)NSArray* dataArray;
@property(nonatomic,retain)NSArray* widthArray;
@property(nonatomic,retain)NSDictionary* widthArrayForRows;
@property(nonatomic,assign)NSInteger viewType;
@property(nonatomic,assign)NSInteger leftMargin;
@property(nonatomic,retain)UIFont* titleFont;
@property(nonatomic,retain)NSArray* fontSizeArray;
@property(nonatomic,assign)NSInteger cellType;

-(void)reloadData;

@end

