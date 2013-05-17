//
//  NewsFavoritePuller.h
//  SinaFinance
//
//  Created by shieh exbice on 12-3-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeiboLoginManager.h"
#import "CommentDataList.h"

#define NewsFavoriteObjectAddedNotification @"NewsFavoriteObjectAddedNotification"
#define NewsFavoriteObjectFailedNotification @"NewsFavoriteObjectFailedNotification"

enum FavoriteStage
{
    Stage_Request_FavoriteNews,
    Stage_Request_RemoveFavoriteNews,
    Stage_Request_FavoriteNewsList
};

@class ASINetworkQueue;

@interface NewsFavoritePuller : NSObject
{
    ASINetworkQueue* mDownloadQueue;
}

@property(retain)ASINetworkQueue* downloadQueue;

+ (id)getInstance;

-(void)startFavoriteNewsWithSender:(id)sender newsurl:(NSString*)newsurl title:(NSString*)title videoImg:(NSString*)videoImg videoURL:(NSString*)videoURL;
-(void)startRemoveFavoriteNewsWithSender:(id)sender idstr:(NSString*)idstr inBack:(BOOL)bInBack;
-(void)startFavariteListNews:(NSInteger)nPage args:(NSArray*)args dataList:(CommentDataList*)dataList bInback:(BOOL)bInback;

@end
