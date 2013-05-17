//
//  JSONConfigDownloader.h
//  SinaFinance
//
//  Created by shieh exbice on 12-6-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

/*
 使用方法:
 1.在- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions中添加[[JSONConfigDownloader getInstance] startup];
 2.在程序运行后的调试log中搜ConfigLocalSaver.json这个文件(保存程序Documents目录下的ConfigLocalSaver.json),把这个文件中的所有内容挂到服务器上去.
 3.修改在服务器的目录文件相应的添加一项配置信息。
 4.testMode为真对应http://m.sina.com.cn/iframe/config/catalog_test.json，否则对应http://m.sina.com.cn/iframe/config/catalog.json
 5.所有需要更新的配置文件都必须以以下方式取，内部做了如果document目录中存在指定的文件，如果当前版本与下载的配置文件当时的版本不匹配，就取bundle目录中的指定文件的逻辑，NSArray* jsonArray = [[JSONConfigDownloader getInstance] jsonOjbectWithJSONConfigFile:filename];
 注意内容:
 1.所有的配置文件必须以.json结尾。且配置文件必须是json格式.
 2.当本地配置文件更新后会发JSONConfigChangedNotification通告
 3.此模块的逻辑会将bundle下所有符合第一条的文件上传到服务器中，之后再下载到doucument目录中.
 */

#define JSONConfigChangedNotification @"JSONConfigChangedNotification"

#import <Foundation/Foundation.h>

@interface JSONConfigDownloader : NSObject
{
    BOOL testMode;
}

@property(nonatomic,assign)BOOL testMode;
+ (id)getInstance;

-(void)startup;
-(void)stop;
-(id)jsonOjbectWithJSONConfigFile:(NSString*)fileName;
-(id)mutableJsonOjbectWithJSONConfigFile:(NSString*)fileName;
-(NSString*)jsonStringWithJSONConfigFile:(NSString*)fileName;
@end
