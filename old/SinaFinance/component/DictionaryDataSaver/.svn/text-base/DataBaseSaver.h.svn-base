//
//  DataBaseSaver.h
//  SinaNews
//
//  Created by shieh exbice on 11-7-25.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FMDatabase;
@class NewsObject;

@interface DataBaseSaver : NSObject
{
    FMDatabase* mDatabase;
    NSLock* mLock;
}

@property(retain)FMDatabase* database;
@property(retain)NSLock* lock;

+ (id)getInstance;

-(void)addDataWithTable:(NSString*)tableName idList:(NSArray*)idList data:(NSArray*)dataArray;
-(void)refreshDataWithTable:(NSString*)tableName idList:(NSArray*)idList data:(NSArray*)dataArray;
-(void)removeAllDataWithTable:(NSString*)tableName idList:(NSArray*)idList;
-(void)removeDataOfIndex:(NSInteger)index table:(NSString*)tableName idList:(NSArray*)idList;
-(void)updateDataWithTable:(NSString*)tableName oneData:(NewsObject*)oneObject idList:(NSArray*)idList row:(NSInteger)row;
-(NSArray*)loadDataWithTable:(NSString*)tableName idList:(NSArray*)idList;
-(void)updateInfoTableWithTableName:(NSString*)tableName idList:(NSArray*)idList info:(NSDictionary*)info;
-(void)addInfoTableWithTableName:(NSString*)tableName idList:(NSArray*)idList info:(NSDictionary*)info;
-(NSDictionary*)loadInfoTableWithTableName:(NSString*)tableName idList:(NSArray*)idList;

-(void)dropTable:(NSString*)tableName;

@end
