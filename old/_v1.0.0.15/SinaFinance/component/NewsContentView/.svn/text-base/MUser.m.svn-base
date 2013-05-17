//
//  TypesetTestAppDelegate.h
//  TypesetTest
//
//  Created by huangdx on 9/15/10.
//  Copyright hdx 2010. All rights reserved.
//

#import "MUser.h"

@implementation MUser

@synthesize isEnterFromOtherChannel;
@synthesize enterSlideViewChannelIndex;
@synthesize networkIsReachable;
@synthesize isOfflineViewOpened;

+ (MUser *) sharedUser {
	static MUser *user;
	if (!user) {
		user = [[MUser alloc] init];
		
	}
	return user;
}

- (id) init
{
	self = [super init];
	if (self != nil) {
		session = [[NSMutableDictionary alloc] init];
		currentOrientation = UIInterfaceOrientationPortrait;
		currentChannelNumber = 0;
		PreviousChannelNumber = 0;
        isEnterFromOtherChannel = NO;
        networkIsReachable = NO;
        isOfflineViewOpened = NO;
	}
	return self;
}

-(void)setOrientation:(UIInterfaceOrientation)newOrientation
{
	currentOrientation = newOrientation;
}

-(UIInterfaceOrientation)getOrientation
{
	return currentOrientation;
}

-(BOOL)isPortrait
{
	if (currentOrientation == UIInterfaceOrientationPortraitUpsideDown || currentOrientation == UIInterfaceOrientationPortrait) {
		return YES;
	}
	else {
		return NO;
	}

}

-(NSString*)getOrientationString
{
	switch (currentOrientation) {
		case UIInterfaceOrientationLandscapeLeft:
		case UIInterfaceOrientationLandscapeRight:
			return @"landscape";
			break;
		case UIInterfaceOrientationPortraitUpsideDown:
		case UIInterfaceOrientationPortrait:
		default:
			return @"portrait";
			break;
	}
}

- (void) setAttr:(id) value forKey:(NSString *) key {
	[session setObject:value forKey:key];
}

- (id) attr:(NSString *) key {
	return [session objectForKey:key];
}

- (void) removeAttr:(NSString *) key {
	[session removeObjectForKey:key];
}

- (NSDictionary *) attrs {
	return session;
}

-(void)exit
{
	[self synchronize];
	exit(0);
}
-(void)synchronize
{
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	[prefs synchronize];
}

- (void) setAppAttr:(id) value forKey:(NSString *) key {
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	[prefs setObject:value forKey:key];
}

- (id)  appAttr:(NSString *) key {
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	return [prefs objectForKey:key];
}

- (void) removeAppAttr:(NSString *) key {
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	[prefs removeObjectForKey:key];
}

-(BOOL)getDownloadImg
{
	NSNumber* a = [self appAttr:@"DownloadImg"];
	if (!a) {
		[self setAppAttr:[NSNumber numberWithBool:YES] forKey:@"DownloadImg"];
		return YES;
	}
	else {
		return [a boolValue];
	}

}
-(void)setDownloadImg:(BOOL)newFlag
{
	[self setAppAttr:[NSNumber numberWithBool:newFlag] forKey:@"DownloadImg"];
}

-(void)ChangeOrentation
{
	NSNumber* toOrientation = [self attr:@"ToInterfaceOrientation"];
	switch ([toOrientation intValue]) {
			/*
		case UIDeviceOrientationLandscapeLeft:
		case UIDeviceOrientationLandscapeRight:
			m_window_width = 1024;
			m_window_height = 768;
			m_screen_content_width = 1024 -60 - 83;
			m_screen_content_height = 660 - 60 - 56;
			m_content_startx = 60;
			m_content_starty = 60;
			m_content_parentView_width = 1024;
			m_content_parentView_height = 660;
			break;	
		case UIDeviceOrientationPortrait:
		case UIDeviceOrientationPortraitUpsideDown:
		case UIDeviceOrientationUnknown:
		case UIDeviceOrientationFaceUp:
		case UIDeviceOrientationFaceDown:
		default:
#ifdef __dev_iphone__
			m_window_width = 320;
			m_window_height = 480;
			m_screen_content_width = 320;
			m_screen_content_height = 372;
			m_content_startx = 0;
			m_content_starty = 0;
			m_content_parentView_width = 320;
			m_content_parentView_height = 372;
#else
			m_window_width = 768;
			m_window_height = 1024;
			m_screen_content_width = 625;
			m_screen_content_height = 800;
			m_content_startx = 60;
			m_content_starty = 60;
			m_content_parentView_width = 768;
			m_content_parentView_height = 916;
#endif
			
			break;*/
	}
}

-(void)changeDataWhenRotate
{
	//hLog(-1200, @"MUser changeDataWhenRotate");
	windowHeight = 0;
	windowWidth = 0;
	switch (currentOrientation) {
		case UIInterfaceOrientationLandscapeLeft:
		case UIInterfaceOrientationLandscapeRight:
			windowHeight = 768-20;
			windowWidth = 1024;
			break;
		case UIInterfaceOrientationPortraitUpsideDown:
		case UIInterfaceOrientationPortrait:
		default:
			windowWidth = 768;
			windowHeight = 1024-20;
			break;
	}

}


-(CGFloat)getWindowHeight
{
	return	windowHeight;
}

-(CGFloat)getWindowWidth
{
	return	windowWidth;
}

-(void)setCurrentChannelNumber:(unsigned int)newNumber
{
	PreviousChannelNumber = currentChannelNumber;
	currentChannelNumber = newNumber;
}

-(unsigned int)getCurrentChannelNumber
{
	return currentChannelNumber;
}

-(unsigned int)getPreviousChannelNumber
{
	return PreviousChannelNumber;
}

- (void) dealloc {
	[session release];
	[super dealloc];
}

#pragma mark Check Dictionary Size
- (unsigned long long int)folderSize:(NSString *)folderPath {
    NSArray *filesArray = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:folderPath error:nil];
    NSEnumerator *filesEnumerator = [filesArray objectEnumerator];
    NSString *fileName;
    unsigned long long int fileSize = 0;
    
    while ((fileName = [filesEnumerator nextObject])) {
        NSDictionary *fileDictionary = [[NSFileManager defaultManager] attributesOfItemAtPath:[folderPath stringByAppendingPathComponent:fileName] error:nil];
        fileSize += [fileDictionary fileSize];
    }
    
    return fileSize;
}

@end
