//
//  MyWebViewController.h
//  SinaFinance
//
//  Created by Du Dan on 12/21/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyWebViewController : UIViewController
{
    NSURL *myURL;
    NSString *myTitle;
    UIWebView *myWebView;
}

- (id)initWithURL:(NSString*)urlString title:(NSString*)title;

@end
