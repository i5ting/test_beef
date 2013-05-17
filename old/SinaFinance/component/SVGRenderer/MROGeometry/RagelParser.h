//
//  RagelParser.h
//
//  Created by Marcus Rohrmoser on 11.03.10.
//  Copyright 2010 Marcus Rohrmoser mobile Software. All rights reserved.
//

#define RAGEL_ERROR_DOMAIN  @"_RAGEL_ERROR_DOMAIN_"
#define RAGEL_ERROR_CODE    110

@interface RagelParser : NSObject {}

-(NSError *)parseError:(const char *)data position:(const char *)p;

@end