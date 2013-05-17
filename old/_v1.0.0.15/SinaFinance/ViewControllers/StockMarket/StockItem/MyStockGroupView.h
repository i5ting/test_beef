//
//  MyStockGroupView.h
//  SinaFinance
//
//  Created by Du Dan on 11/30/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MyStockGroupBackViewDelegate;

@interface MyStockGroupBackView : UIView
{
    
}

@property(nonatomic,assign)id<MyStockGroupBackViewDelegate> delegate;

-(id)initWithFrame:(CGRect)frame noclickFrame:(CGRect)aNoframe;

@end

@protocol MyStockGroupBackViewDelegate <NSObject>

- (void)myStockGroupBackViewDidClicked:(MyStockGroupBackView*)backView;

@end



@protocol MyStockGroupViewDelegate;


enum GroupViewState
{
    GroupViewState_Loading,
    GroupViewState_Finish,
    GroupViewState_Error
};
@interface MyStockGroupView : UIView <UITableViewDelegate,UITableViewDataSource>
{
    UITableView *myStockTable;
    NSMutableArray *myStockArray;
    id <MyStockGroupViewDelegate> delegate;
    UIActivityIndicatorView* indicatorView;
    UILabel* errorLabel;
}

@property(nonatomic,retain)id userInfo;
@property(nonatomic,assign) NSInteger loadState;
@property (nonatomic, retain) id <MyStockGroupViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame data:(NSArray*)dataArray;
-(void)setData:(NSArray*)dataArray;

@end

@protocol MyStockGroupViewDelegate <NSObject>

- (void)myStockGroupView:(MyStockGroupView*)groupView didSelectGroup:(NSDictionary*)dict;

@end
