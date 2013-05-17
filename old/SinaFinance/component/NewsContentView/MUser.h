//
//  TypesetTestAppDelegate.h
//  TypesetTest
//
//  Created by huangdx on 9/15/10.
//  Copyright hdx 2010. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MUser : NSObject {
	unsigned int PreviousChannelNumber;
	unsigned int currentChannelNumber;
	CGFloat windowHeight;
	CGFloat windowWidth;
    
    BOOL isEnterFromOtherChannel;
    unsigned int enterSlideViewChannelIndex;
    
    BOOL networkIsReachable;
    BOOL isOfflineViewOpened;//Added for condition checking when orientation changed
@private	
	NSMutableDictionary *session;
	UIInterfaceOrientation currentOrientation;
}

@property (nonatomic, assign) BOOL isEnterFromOtherChannel;
@property (nonatomic, assign) unsigned int enterSlideViewChannelIndex;
@property (nonatomic, assign) BOOL networkIsReachable;
@property (nonatomic, assign) BOOL isOfflineViewOpened;

+ (MUser *) sharedUser;

-(BOOL)getDownloadImg;
-(void)setDownloadImg:(BOOL)newFlag;

-(BOOL)isPortrait;
-(void)setOrientation:(UIInterfaceOrientation)newOrientation;
-(UIInterfaceOrientation)getOrientation;
-(NSString*)getOrientationString;

- (void) setAttr:(id) value forKey:(NSString *) key;
- (id) attr:(NSString *) key;
- (void) removeAttr:(NSString *) key;
- (NSDictionary *) attrs;

- (void) setAppAttr:(id) value forKey:(NSString *) key;
- (id)  appAttr:(NSString *) key;
- (void) removeAppAttr:(NSString *) key;

-(void)exit;
-(void)synchronize;
-(void)ChangeOrentation;

-(void)changeDataWhenRotate;
-(CGFloat)getWindowHeight;
-(CGFloat)getWindowWidth;

-(void)setCurrentChannelNumber:(unsigned int)newNumber;
-(unsigned int)getCurrentChannelNumber;
-(unsigned int)getPreviousChannelNumber;

- (unsigned long long int)folderSize:(NSString *)folderPath;

@end
