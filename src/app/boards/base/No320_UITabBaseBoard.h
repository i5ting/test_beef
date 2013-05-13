//
//  No320_UITabBaseBoard.h
//  sinafinance
//
//  Created by sang on 5/9/13.
//
//

#import "Bee_UIBoard.h"
#import "Lesson2Board.h"
#import "Bee_UITopTab.h"



@interface No320_UITabBaseBoard : BeeUIBoard
{
    Lesson2View1 *	_innerView;
    Bee_UITopTab *  _topTabView;
}


- (void)addTopTabView;




- (NSMutableArray *)get_top_tab_data_source;


/**
 * 内部日志
 */
-(void)log:(NSString *)str;




@end
