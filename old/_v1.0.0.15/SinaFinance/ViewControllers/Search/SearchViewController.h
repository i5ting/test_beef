//
//  SearchViewController.h
//  SinaFinance
//
//  Created by Du Dan on 12/7/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum SearchViewControllerGroupViewType
{
	GroupViewType_Search = 0,
    GroupViewType_AddMyStock=1,
 
}SearchViewControllerGroupViewType;

@interface SearchViewController : UIViewController <UITextFieldDelegate,OPCustomKeyboardDelegate>
{

}

@property(retain,atomic,readwrite) OPCustomKeyboard *keyboard;
@end
