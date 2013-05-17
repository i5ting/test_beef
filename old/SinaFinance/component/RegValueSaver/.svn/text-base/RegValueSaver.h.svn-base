//
//  RegValueSaver.h
//  SinaNews
//
//  Created by shieh exbice on 11-7-19.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RegValueSaver : NSObject
{
    @private
    NSMutableDictionary* mAccountDict;
    NSString* mCurrrentUserID;
}

@property(retain)NSString* currrentUserID;

+ (id)getInstance;

-(void)saveSystemInfoValue:(id)data forKey:(NSString*)oneKey encryptString:(BOOL)bEncrypt;
-(id)readSystemInfoForKey:(NSString*)oneKey;
-(void)saveUserInfoValue:(id)data forKey:(NSString*)oneKey userID:(NSString*)mid encryptString:(BOOL)bEncrypt;
-(void)saveUserInfoValue:(id)data forKey:(NSString*)oneKey userID:(NSString*)mid accountType:(NSString*)accountType encryptString:(BOOL)bEncrypt;
-(id)readUserInfoForKey:(NSString*)oneKey userID:(NSString*)mid;
-(id)readUserInfoForKey:(NSString*)oneKey userID:(NSString*)mid accountType:(NSString*)accountType;

/////extend
-(NSDictionary*)readAccountDict;
-(NSDictionary*)readAccountDictWithAccountType:(NSString*)accountType;
-(void)saveAccountDictValue:(NSString*)uid forKey:(NSString*)accountName;
-(void)saveAccountDictValue:(NSString*)uid forKey:(NSString*)accountName accountType:(NSString*)accountType;
-(NSString*)findUIDFromAccount:(NSString*)accountName;
-(NSString*)findUIDFromAccount:(NSString*)accountName accountType:(NSString*)accountType;

@end
