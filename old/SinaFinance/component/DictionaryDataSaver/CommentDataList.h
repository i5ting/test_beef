//
//  CommentDataList.h
//  SinaNews
//
//  Created by shieh exbice on 11-11-28.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NewsObject.h"

enum AdjustOrderType
{
    AdjustOrderType_abled,
    AdjustOrderType_disabled
};

@interface AdjustOrderData : NSObject
{
    NSInteger type;
    NSString* key;
    NSString* value;
    BOOL movable;
    NSMutableArray* subArray;
}
@property(nonatomic,assign)NSInteger type;
@property(nonatomic,retain)NSString* key;
@property(nonatomic,retain)NSString* value;
@property(nonatomic,assign)BOOL movable;
@property(nonatomic,retain)NSMutableArray* subArray;

+(AdjustOrderData*)dataWithData:(NSData*)savableData;
-(NSData*)savableData;

@end

@interface CommentDataList : NSObject
{
    NSMutableArray* mCellObjects;  //此数组中第一级dictionary存导航选择的索引和data共3值
    NSLock* mLock;
    NSMutableArray* mShowedObjects;
    NSLock* mShowedLock;
    NSLock* mNameLock;
    NSLock* mDataBaseLock;
    NSLock* mOrderLock;
    BOOL hasFirstIndex;
    
    NSArray* mNameList;
    NSString* mDataTableName;
    NSMutableArray* mLoadedList;
    NSMutableDictionary* mListInfo;
    NSMutableArray* mShowableOrderArray;
    NSMutableArray* mTotalOrderArray;
    NSInteger orderLayer;
    
    NSMutableArray* reloadedIDArray;
    NSLock* reloadedLock;
}
@property(retain)NSString* dataTableName;
@property(assign)NSInteger countPerPage;

+(NSArray*)convertStringToNumber:(NSArray*)array createNewArray:(BOOL)created;
+(NSArray*)convertNumberToString:(NSArray*)array createNewArray:(BOOL)created;
+(BOOL)checkNumberArrayEqualWithFirstArray:(NSArray*)first secondArray:(NSArray*)second;//比较selectid数组

-(id)initWithFileName:(NSString*)aFileName;
-(id)initWithJsonString:(NSString*)jsonString;
-(id)initWithJsonArray:(NSArray*)jsonArray;
-(void)replaceNameListWithTypeIndex:(NSInteger)index DataArray:(NSArray*)dataArray;//重置tabar中的关键数组内容
-(NSArray*)subCommentNamelistAtRowColumns:(NSArray*)columns;//tabbar中的名字数组
-(NSArray*)curCommentAPICodeAtRowColumns:(NSArray*)columns;//用于请求的api数组
-(NSArray*)nameKeysWithIDList:(NSArray*)IDList;//用于保存数据的关键字数组selectid返回对应的列表名数组.
-(NSArray*)IDListWithNameKeys:(NSArray*)nameKeys;//列表名数组返回用于保存数据的关键字数组selectid
-(void)setOrderArray:(NSArray*)orderArray atIndex:(NSInteger)index; //调整顺序后重设回数组,index代表第几个type字典
-(NSMutableArray*)orderArrayOfIndex:(NSInteger)index;//取得调整顺序数组,index代表第几个type字典

-(BOOL)needReloadShowedDataWithIDList:(NSArray*)IDList;
-(void)reloadShowedDataWithIDList:(NSArray*)IDList;
-(NSInteger)contentsCountWithIDList:(NSArray*)IDList;
-(void)addCommnetContents:(NSArray*)objects IDList:(NSArray*)IDList;
-(void)refreshCommnetContents:(NSArray*)objects IDList:(NSArray*)IDList;
-(void)refreshCommnetContents:(NSArray*)objects IDList:(NSArray*)IDList dateUpdate:(BOOL)updateDate;
-(void)refreshDataBaseWithOneCommnetContent:(NewsObject*)oneObject dataIDList:(NSArray*)dataIDArray row:(NSInteger)row;
-(void)removeOfIndex:(NSInteger)index IDList:(NSArray*)IDList;
-(void)removeAllWithIDList:(NSArray*)IDList;
-(NewsObject*)oneObjectWithIndex:(NSInteger)index IDList:(NSArray*)IDList;
-(NSArray*)contentsWithIDList:(NSArray*)IDList;
-(NewsObject*)lastObjectWithIDList:(NSArray*)IDList;
-(void)setInfoWithIDList:(NSArray*)IDList value:(id)value forKey:(NSString*)key;
-(id)infoValueWithIDList:(NSArray*)IDList ForKey:(NSString *)key;
-(NSDate*)dateInfoWithIDList:(NSArray*)IDList;
-(BOOL)pageEndInfoWithIDList:(NSArray*)IDList;
-(void)setPageEndInfoWithIDList:(NSArray*)IDList value:(BOOL)pageEnd;
-(NSInteger)loadedStateInfoWithIDList:(NSArray*)IDList;
-(void)setLoadedStateInfoWithIDList:(NSArray*)IDList value:(NSInteger)loadedState;

@end
