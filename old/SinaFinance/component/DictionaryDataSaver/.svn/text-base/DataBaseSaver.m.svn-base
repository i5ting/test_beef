//
//  DataBaseSaver.m
//  SinaNews
//
//  Created by shieh exbice on 11-7-25.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "DataBaseSaver.h"
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"
#import "NewsObject.h"
#import "MyTool.h"

NSString* DataBaseIndex = @"DataBaseIndex";

static DataBaseSaver* s_databaseSaver = nil;


@interface DataBaseSaver ()
-(NSArray*)initTableWithTableName:(NSString*)tableName idList:(NSArray*)idList;

-(void)startLoadFromDisk;
-(void)realAddDataWithTable:(NSString*)tableName idList:(NSArray*)idList data:(NSArray*)dataArray;
-(NSArray*)initInfoTable;
-(NSDictionary*)loadInfoTableWithTableName:(NSString*)tableName idList:(NSArray*)idList threadLock:(BOOL)locked;
-(void)updateInfoTableWithTableName:(NSString*)tableName idList:(NSArray*)idList info:(NSDictionary*)info threadLock:(BOOL)locked;
-(void)updateInfoTableWithTableName:(NSString*)tableName idList:(NSArray*)idList info:(NSDictionary*)info threadLock:(BOOL)locked added:(BOOL)bAdded;
-(void)addInfoTableWithTableName:(NSString*)tableName idList:(NSArray*)idList info:(NSDictionary*)info threadLock:(BOOL)locked;
-(void)realRemoveAllDataWithTable:(NSString*)tableName idList:(NSArray*)idList;
-(void)realRemoveDataOfIndex:(NSInteger)index table:(NSString*)tableName idList:(NSArray*)idList;
@end

@implementation DataBaseSaver

@synthesize lock=mLock,database = mDatabase;


+ (id)getInstance
{
	if (s_databaseSaver == nil)
	{
		//没有创建则创建
		s_databaseSaver = [[DataBaseSaver alloc] init];
	}
	return s_databaseSaver;
}

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        mLock = [[NSLock alloc] init];
        [self startLoadFromDisk];
    }
    
    return self;
}

-(void)dealloc
{
    [mLock release];
    [mDatabase release];
    
    [super dealloc];
}

-(void)startLoadFromDisk
{
    NSArray* documentPathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString* documentPath = [documentPathArray objectAtIndex:0];
    documentPath = [documentPath stringByAppendingPathComponent:@"content.db"];
    [self.lock lock];
    self.database = [FMDatabase databaseWithPath:documentPath];
    
    if ([mDatabase open]) {
        // kind of experimentalish.
        [mDatabase setShouldCacheStatements:YES];
    }
    [self.lock unlock];
}

/**
 * 根据idList参数列表里的长度来判断是否使用md5
 * >32 则使用的是md5
 */
-(NSArray*)dealIDListWithIDList:(NSArray*)idList  //md5是32位
{
    BOOL needMD5 = NO;
    NSArray* oneArray = idList;
    for (NSString* oneID in idList) {
        if ([oneID length]>32) {
            needMD5 = YES;
            break;
        }
    }
    if (needMD5) {
        NSMutableArray* tempArray = [NSMutableArray arrayWithCapacity:0];
        for (NSString* oneID in idList) {
            if ([oneID length]>32) {
                NSString* md5String = [MyTool MD5DigestFromString:oneID];
                [tempArray addObject:md5String];
            }
            else {
                [tempArray addObject:oneID];
            }
        }
        oneArray = tempArray;
    }
    return oneArray;
}


/**
 * 根据idList是索引字段

 传进来的是idList，这里的名字是无意义的，只是生成对应【字段】名称。
 
 比如数组idList[0]     , idList[1]     , idList[2]     , idList[3]，生成对应的DataBaseIndex0, DataBaseIndex1, DataBaseIndex2, DataBaseIndex3字段
 另外增加2个字段：rowid int, data blob
 
 顺序：
 DataBaseIndex0, DataBaseIndex1, DataBaseIndex2, DataBaseIndex3
 idList[0]     , idList[1]     , idList[2]     , idList[3] 
 
 
 
 CommentDataList里的tablename=testTb
 idList=[@"股价提醒",@"StockRemindHistoryKey",@"3019974995"]
 
 
 #scorfold
 create table if not exists %@ (%@ rowid int, data blob)
 
 ＃detail
 create table if not exists testTb (DataBaseIndex0 varchar(35), DataBaseIndex1 varchar(35), DataBaseIndex2 varchar(35), rowid int, data blob)
 
 说明：
 -  varchar(35) 对应的是宏DataBaseIndex的字符长度，如果定义的太长是有问题的。
 -  所有服务器响应信息都存在data里
 -  没有主键，索引！                （效率）
 -  rowid竟然不是自增的！           （效率）
 
 */
-(NSArray*)initTableWithTableName:(NSString*)tableName idList:(NSArray*)idList
{
    NSMutableArray* rtval = nil;
    if (idList&&[idList count]>0) {
        rtval = [[[NSMutableArray alloc] initWithCapacity:[idList count]] autorelease];
        
        NSString* idString = @"";
        for (int i =0; i< [idList count]; i++) {
            NSString* idname = [NSString stringWithFormat:@"%@%d",DataBaseIndex,i];
            [rtval addObject:idname];
            idString = [idString stringByAppendingFormat:@"%@ varchar(35),",idname];
        }
        
        NSString* updateSql = [NSString stringWithFormat:@"create table if not exists %@ (%@ rowid int, data blob)",tableName,idString];
        BOOL ret = [mDatabase executeUpdate:updateSql,nil];
        if (!ret) {
            NSLog(@"create   table(%@)error!",tableName);
            NSLog(@"lastErrorMessage=%@",mDatabase.lastErrorMessage);
        }
    }
    return rtval;
}

/**
 * 拼接select条件（即where后面的）
 *
 * 如果参数名和列表个数不一样就抛弃？不处理？
 *
 sql注入是挡不住的，尽管这里没有多少可能
 */
-(NSString*)searchKeyStringWithIDList:(NSArray*)idList nameList:(NSArray*)nameList
{
    NSString* dataBaseSearchKey = nil;//为什么是nil？这样判断很难读，换成if i==0
    if ([nameList count]==[idList count]) {
        for (int i=0; i<[idList count]; i++) {
            NSString* nameString = [nameList objectAtIndex:i];
            NSString* idString = [idList objectAtIndex:i];
            if (!dataBaseSearchKey) {
                dataBaseSearchKey = @"";
                dataBaseSearchKey = [dataBaseSearchKey stringByAppendingFormat:@"%@=%@",nameString,@"?"];
            }
            else
            {
                dataBaseSearchKey = [dataBaseSearchKey stringByAppendingFormat:@" and %@=%@",nameString,@"?"];
            }
        }

    }
    return dataBaseSearchKey;
}


/**
 * 根据参数idList删除数据
 *
 *
    这里的参数 idList=[@"股价提醒",@"StockRemindHistoryKey",@"3019974995"]  类似，而不是指表的字段。
 
    草，删除成功不成功都不管么？
 
 *
 */
-(void)removeDataWithTable:(NSString*)tableName idList:(NSArray*)idList
{
    // 不管存在与否都执行init  ？？？？？效率呢？    
    NSArray* dataBaseNameList = [self initTableWithTableName:tableName idList:idList];
    // 拼接select条件（即where后面的）
    NSString* keyWord = [self searchKeyStringWithIDList:idList nameList:dataBaseNameList];
    if (tableName&&idList&&[idList count]>0) {
        NSString* updateSql = [NSString stringWithFormat:@"Delete from %@ where %@",tableName,keyWord];
        BOOL ret = [mDatabase executeUpdate:updateSql withArgumentsInArray:idList];
        if (!ret) {
            NSLog(@"delete table error!sqlword=%@",updateSql);
            NSLog(@"lastErrorMessage=%@",mDatabase.lastErrorMessage);
        }
    }
}

/**
 TODO:没看出何为real？
 
 除了用占位符，有别的区别么？
 
 ("delete from tb where a=?","param")
 */
-(void)realRemoveAllDataWithTable:(NSString*)tableName idList:(NSArray*)idList
{
    NSArray* dataBaseNameList = [self initTableWithTableName:tableName idList:idList];
    NSString* idStirng = @"";
    //每个里面都这样拼，为啥不独立方法？
    for (int i=0; i<[dataBaseNameList count]; i++) {
        if (i==0) {
            NSString* key = (NSString*)[dataBaseNameList objectAtIndex:i];
            idStirng = [idStirng stringByAppendingFormat:@"%@ = ?",key];
        }
        else
        {
            NSString* key = (NSString*)[dataBaseNameList objectAtIndex:i];
            idStirng = [idStirng stringByAppendingFormat:@"and %@ = ?",key];
        }
    }
    
    NSString* updateSql = [NSString stringWithFormat:@"delete from %@ where %@",tableName,idStirng];
    NSMutableArray* updateArray = [[NSMutableArray alloc] initWithArray:idList];
    BOOL ret = [mDatabase executeUpdate:updateSql withArgumentsInArray:updateArray];
    if (!ret) {
        NSLog(@"executeUpdate removeall database table error!sql=%@",updateSql);
        NSLog(@"lastErrorMessage=%@",mDatabase.lastErrorMessage);
    }
    [updateArray release];
}


/*
 根据index删除。
*/
-(void)realRemoveDataOfIndex:(NSInteger)index table:(NSString*)tableName idList:(NSArray*)idList
{
    NSArray* dataBaseNameList = [self initTableWithTableName:tableName idList:idList];
    NSString* idStirng = @"";
    for (int i=0; i<[dataBaseNameList count]; i++) {
        if (i==0) {
            NSString* key = (NSString*)[dataBaseNameList objectAtIndex:i];
            idStirng = [idStirng stringByAppendingFormat:@"%@ = ?",key];
        }
        else
        {
            NSString* key = (NSString*)[dataBaseNameList objectAtIndex:i];
            idStirng = [idStirng stringByAppendingFormat:@"and %@ = ?",key];
        }
    }
    
    idStirng = [idStirng stringByAppendingString:@"and rowid = ?"];
    
    NSString* updateSql = [NSString stringWithFormat:@"delete from %@ where %@",tableName,idStirng];
    NSMutableArray* updateArray = [[NSMutableArray alloc] initWithArray:idList];
    [updateArray addObject:[NSNumber numberWithInt:index]];
    BOOL ret = [mDatabase executeUpdate:updateSql withArgumentsInArray:updateArray];
    if (!ret) {
        NSLog(@"executeUpdate removeindex database table error!sql=%@",updateSql);
        NSLog(@"lastErrorMessage=%@",mDatabase.lastErrorMessage);
    }
    [updateArray release];
}

/**
    增加数据。
 
 TODO:
 
 
 
 */
-(void)realAddDataWithTable:(NSString*)tableName idList:(NSArray*)idList data:(NSArray*)dataArray
{
    NSArray* dataBaseNameList = [self initTableWithTableName:tableName idList:idList];
    NSString* nameStirng = [dataBaseNameList componentsJoinedByString:@","];
    NSString* idStirng = @"";
    for (int i=0; i<[idList count]; i++) {
        if (i==0) {
            idStirng = [idStirng stringByAppendingString:@"?"];
        }
        else
            idStirng = [idStirng stringByAppendingString:@",?"];
    }
    
    NSString* updateSql = nil;
    NSMutableArray* updateArray = [[NSMutableArray alloc] initWithCapacity:0];
    int dataCount = [dataArray count];
    if (dataCount>0) {
        for (int i=0; i<dataCount; i++) {
            if (dataCount>1) {
                if (!updateSql) {
                    updateSql = [NSString stringWithFormat:@"insert into %@ (%@, rowid, data) select %@,?,?",tableName,nameStirng,idStirng];
                }
                else {
                    updateSql = [updateSql stringByAppendingFormat:@"union select %@,?,?",idStirng];
                }
            }
            else {
                updateSql = [NSString stringWithFormat:@"insert into %@ (%@, rowid, data) values (%@,?,?)",tableName,nameStirng,idStirng];
            }
            [updateArray addObjectsFromArray:idList];
            [updateArray addObject:[NSNumber numberWithInt:i]];
            NewsObject* oneObject = [dataArray objectAtIndex:i];
            NSData* oneData = [NSKeyedArchiver archivedDataWithRootObject:oneObject];
            //NSData* oneData = oneObject.data;
            [updateArray addObject:oneData];
        }
        BOOL ret = [mDatabase executeUpdate:updateSql withArgumentsInArray:updateArray];
        if (!ret) {
            NSLog(@"executeUpdate insert database table error!sql=%@",updateSql);
            NSLog(@"lastErrorMessage=%@",mDatabase.lastErrorMessage);
        }
    }
    
    [updateArray release];
}

-(void)removeAllDataWithTable:(NSString*)tableName idList:(NSArray*)idList
{
    idList = [self dealIDListWithIDList:idList];
    tableName = [tableName stringByAppendingFormat:@"_%d",[idList count]];
    [self.lock lock];
    [self realRemoveAllDataWithTable:tableName idList:idList];
    [self.lock unlock];
}

-(void)removeDataOfIndex:(NSInteger)index table:(NSString*)tableName idList:(NSArray*)idList
{
    idList = [self dealIDListWithIDList:idList];
    tableName = [tableName stringByAppendingFormat:@"_%d",[idList count]];
    [self.lock lock];
    [self realRemoveDataOfIndex:index table:tableName idList:idList];
    [self.lock unlock];
}

-(void)addDataWithTable:(NSString*)tableName idList:(NSArray*)idList data:(NSArray*)dataArray
{
    idList = [self dealIDListWithIDList:idList];
    tableName = [tableName stringByAppendingFormat:@"_%d",[idList count]];
    [self.lock lock];
    [self realAddDataWithTable:tableName idList:idList data:dataArray];
    [self.lock unlock];
}

-(void)refreshDataWithTable:(NSString*)tableName idList:(NSArray*)idList data:(NSArray*)dataArray
{
    idList = [self dealIDListWithIDList:idList];
    tableName = [tableName stringByAppendingFormat:@"_%d",[idList count]];
    [self.lock lock];
    [self removeDataWithTable:tableName idList:idList];
    [self realAddDataWithTable:tableName idList:idList data:dataArray];
    [self.lock unlock];
}

-(void)realUpdateDataWithTable:(NSString*)tableName idList:(NSArray*)idList data:(NewsObject*)oneObject row:(NSInteger)row
{
    NSArray* dataBaseNameList = [self initTableWithTableName:tableName idList:idList];
    NSString* keyWord = [self searchKeyStringWithIDList:idList nameList:dataBaseNameList];
    if (keyWord&&![keyWord isEqualToString:@""]) {
        NSString* updateSql = [NSString stringWithFormat:@"update %@ set data = ? where %@ and rowid = ?",tableName,keyWord];
        NSData* data = [NSKeyedArchiver archivedDataWithRootObject:oneObject];
        NSMutableArray* updateArray = [[NSMutableArray alloc] initWithCapacity:0];
        [updateArray addObject:data];
        [updateArray addObjectsFromArray:idList];
        [updateArray addObject:[NSNumber numberWithInt:row]];
        
        BOOL ret = [mDatabase executeUpdate:updateSql withArgumentsInArray:updateArray];
        if (!ret) {
            NSLog(@"executeUpdate update database table error!sql=%@",updateSql);
            NSLog(@"lastErrorMessage=%@",mDatabase.lastErrorMessage);
        }
        [updateArray release];
    }
}

-(void)updateDataWithTable:(NSString*)tableName oneData:(NewsObject*)oneObject idList:(NSArray*)idList row:(NSInteger)row
{
    tableName = [tableName stringByAppendingFormat:@"_%d",[idList count]];
    [self.lock lock];
    [self realUpdateDataWithTable:tableName idList:idList data:oneObject row:row];
    [self.lock unlock];
}

/**
 tablename后加数字，数字是idList的个数，好奇怪
 
 
 只返回data字段，

 */
-(NSArray*)loadDataWithTable:(NSString*)tableName idList:(NSArray*)idList
{
    idList = [self dealIDListWithIDList:idList];
    tableName = [tableName stringByAppendingFormat:@"_%d",[idList count]];
    NSMutableArray* rtval = nil;
    [self.lock lock];
    NSArray* dataBaseNameList = [self initTableWithTableName:tableName idList:idList];
    NSString* keyWord = [self searchKeyStringWithIDList:idList nameList:dataBaseNameList];
    if (keyWord&&![keyWord isEqualToString:@""]) {
        NSString* updateSql = [NSString stringWithFormat:@"select data from %@ where %@",tableName,keyWord];
        FMResultSet *rs = [mDatabase executeQuery:updateSql withArgumentsInArray:idList];
        while ([rs next]) {
            if (!rtval) {
                rtval = [NSMutableArray arrayWithCapacity:0];
            }
            NSData* data = [rs dataForColumnIndex:0];
            if (data) {
                NewsObject* oneObject = [NSKeyedUnarchiver unarchiveObjectWithData:data];
                //NewsObject* oneObject = [[NewsObject alloc] initWithNewsData:data];
                [rtval addObject:oneObject];
                //[oneObject release];
            }
            
        }
        [rs close];
    }
    [self.lock unlock];
    return rtval;
}

/**
 上面有现成的，重复  建表方法
 
 */
-(NSArray*)initInfoTable
{
    NSMutableArray* rtval = nil;
    
    NSString* infotable = @"_infotable";
    NSString* tableID1 = @"tablename";
    NSString* tableID2 = @"idstring";
    NSString* tableID3 = @"info";
    
    NSString* updateSql = [NSString stringWithFormat:@"create table if not exists %@ (%@ text, %@ text, %@ blob)",infotable,tableID1,tableID2,tableID3];
    BOOL ret = [mDatabase executeUpdate:updateSql,nil];
    if (!ret) {
        NSLog(@"create infotable error!");
        NSLog(@"lastErrorMessage=%@",mDatabase.lastErrorMessage);
    }
    else
    {
        rtval = [NSMutableArray arrayWithCapacity:0];
        [rtval addObject:infotable];
        [rtval addObject:tableID1];
        [rtval addObject:tableID2];
        [rtval addObject:tableID3];
    }
    return rtval;
}

-(void)updateInfoTableWithTableName:(NSString*)tableName idList:(NSArray*)idList info:(NSDictionary*)info
{
    idList = [self dealIDListWithIDList:idList];
    tableName = [tableName stringByAppendingFormat:@"_%d",[idList count]];
    [self updateInfoTableWithTableName:tableName idList:idList info:info threadLock:YES];
}

-(void)addInfoTableWithTableName:(NSString*)tableName idList:(NSArray*)idList info:(NSDictionary*)info
{
    idList = [self dealIDListWithIDList:idList];
    tableName = [tableName stringByAppendingFormat:@"_%d",[idList count]];
    [self addInfoTableWithTableName:tableName idList:idList info:info threadLock:YES];
}

-(NSDictionary*)loadInfoTableWithTableName:(NSString*)tableName idList:(NSArray*)idList
{
    idList = [self dealIDListWithIDList:idList];
    tableName = [tableName stringByAppendingFormat:@"_%d",[idList count]];
    return [self loadInfoTableWithTableName:tableName idList:idList threadLock:YES];
}

-(void)updateInfoTableWithTableName:(NSString*)tableName idList:(NSArray*)idList info:(NSDictionary*)info threadLock:(BOOL)locked
{
    [self updateInfoTableWithTableName:tableName idList:idList info:info threadLock:YES added:NO];
}

-(void)addInfoTableWithTableName:(NSString*)tableName idList:(NSArray*)idList info:(NSDictionary*)info threadLock:(BOOL)locked
{
    [self updateInfoTableWithTableName:tableName idList:idList info:info threadLock:YES added:YES];
}

-(void)updateInfoTableWithTableName:(NSString*)tableName idList:(NSArray*)idList info:(NSDictionary*)info threadLock:(BOOL)locked added:(BOOL)bAdded
{    
    if (locked) {
        [self.lock lock];
    }
    NSDictionary* oldInfo = [self loadInfoTableWithTableName:tableName idList:idList threadLock:NO];
    NSArray* tableKeys = [self initInfoTable];
    if (tableKeys&&[tableKeys count]>0) {
        if (oldInfo) {
            NSString* updateSql = [NSString stringWithFormat:@"update %@ set %@ = ? where %@ = ? and %@ = ?",[tableKeys objectAtIndex:0],[tableKeys objectAtIndex:3],[tableKeys objectAtIndex:1],[tableKeys objectAtIndex:2]];
            NSData* data = nil;
            if (bAdded) {
                NSMutableDictionary* newDict = [[NSMutableDictionary alloc] initWithDictionary:oldInfo];
                [newDict addEntriesFromDictionary:info];
                data = [NSKeyedArchiver archivedDataWithRootObject:newDict];
            }
            else
            {
                data = [NSKeyedArchiver archivedDataWithRootObject:info];
            }
            NSString* idString = [idList componentsJoinedByString:@"{_}"];
            NSMutableArray* updateArray = [[NSMutableArray alloc] initWithCapacity:3];
            [updateArray addObject:data];
            [updateArray addObject:tableName];
            [updateArray addObject:idString];
            
            BOOL ret = [mDatabase executeUpdate:updateSql withArgumentsInArray:updateArray];
            if (!ret) {
                NSLog(@"executeUpdate update database _infotable error!sql=%@",updateSql);
                NSLog(@"lastErrorMessage=%@",mDatabase.lastErrorMessage);
            }
            [updateArray release];
        }
        else
        {
            NSString* updateSql = [NSString stringWithFormat:@"insert into %@ (%@, %@,%@) values (?,?,?)",[tableKeys objectAtIndex:0],[tableKeys objectAtIndex:1],[tableKeys objectAtIndex:2],[tableKeys objectAtIndex:3]];
            NSMutableArray* updateArray = [[NSMutableArray alloc] initWithCapacity:3];
            NSData* data = [NSKeyedArchiver archivedDataWithRootObject:info];
            NSString* idString = [idList componentsJoinedByString:@"{_}"];
            [updateArray addObject:tableName];
            [updateArray addObject:idString];
            [updateArray addObject:data];
            
            BOOL ret = [mDatabase executeUpdate:updateSql withArgumentsInArray:updateArray];
            if (!ret) {
                NSLog(@"executeUpdate insert _infotable error!sql=%@",updateSql);
                NSLog(@"lastErrorMessage=%@",mDatabase.lastErrorMessage);
            }
            [updateArray release];
        }
    }
    if (locked) {
        [self.lock unlock];
    }
}

-(NSDictionary*)loadInfoTableWithTableName:(NSString*)tableName idList:(NSArray*)idList threadLock:(BOOL)locked
{
    NSDictionary* rtval = nil;
    if (locked) {
        [self.lock lock];
    }
    NSArray* tableKeys = [self initInfoTable];
    if (tableKeys&&[tableKeys count]>0) {
        NSString* updateSql = [NSString stringWithFormat:@"select %@ from %@ where %@ = ? and %@ = ?",[tableKeys objectAtIndex:3],[tableKeys objectAtIndex:0],[tableKeys objectAtIndex:1],[tableKeys objectAtIndex:2]];
        NSMutableArray* updateArray = [[NSMutableArray alloc] initWithCapacity:2];
        [updateArray addObject:tableName];
        NSString* idString = [idList componentsJoinedByString:@"{_}"];
        [updateArray addObject:idString];
        
        FMResultSet *rs = [mDatabase executeQuery:updateSql withArgumentsInArray:updateArray];
        while ([rs next]) {
            NSData* data = [rs dataForColumnIndex:0];
            if (data) {
                rtval = [NSKeyedUnarchiver unarchiveObjectWithData:data];
                if ([rtval isKindOfClass:[NSString class]]) {
                    ;
                }
            }
            break;
        }
        [rs close];
        [updateArray release];
    }
    if (locked) {
        [self.lock unlock];
    }
    return rtval;
}

@end
