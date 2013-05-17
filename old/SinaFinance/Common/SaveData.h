//
//  SaveData.h
//  CubeGame
//
//  Created by BeiZ  on 11/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.


@interface SaveData : NSObject {

}

+ (void)saveDataForKey:(NSString*)keyValue data:(NSObject*)savedData;
+ (NSObject*)getDataForKey:(NSString*)keyValue;

@end
