//
//  ZXBoard.h
//  sinafinance
//
//  Created by sang on 5/9/13.
//
//

#import "No320_UITabBaseBoard.h"
#import "ZXBoard_Message.h"
#import "ZX_UITabItemBoard.h"

typedef enum {
	ZXBoard_ITEM_VIEW_HS = 0,
	ZXBoard_ITEM_VIEW_HK = 1,
	ZXBoard_ITEM_VIEW_US = 2
} ZXBOARD_ITEM_VIEW;


@interface ZXBoard : No320_UITabBaseBoard
{
    HSUITabItemView *  _hs_tab_item_view;
    HKUITabItemView *  _hk_tab_item_view;
    USUITabItemView *  _us_tab_item_view;
}

@end
