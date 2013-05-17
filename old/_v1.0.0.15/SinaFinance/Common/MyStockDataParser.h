//
//  MyStockDataParser.h
//  SinaFinance
//
//  Created by Du Dan on 11/22/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyStockDataParser : NSObject

+ (NSArray*)HKGroupDataParser:(NSString*)originalData;

@end
