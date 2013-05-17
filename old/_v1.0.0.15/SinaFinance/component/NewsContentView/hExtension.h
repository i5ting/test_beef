//
//  KExtension.h
//  NightClub
//
//  Created by iwind on 6/10/09.
//  Copyright 2009 Bokan Tech. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface UIView(Avatar)

- (void) removeAllSubViews;

@end




@interface NSData (Avatar)

// gzip compression utilities
- (NSData *)gzipInflate;
- (NSData *)gzipDeflate;

@end









