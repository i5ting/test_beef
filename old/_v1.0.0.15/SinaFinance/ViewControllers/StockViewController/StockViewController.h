//
//  StockViewController.h
//  SinaFinance
//
//  Created by shieh exbice on 12-3-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchViewController.h"

@interface StockViewController : UIViewController<OPCustomKeyboardDelegate>
{
    
}

@property(retain,atomic,readwrite) OPCustomKeyboard *keyboard;

@end
