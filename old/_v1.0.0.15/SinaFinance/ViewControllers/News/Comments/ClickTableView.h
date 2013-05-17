//
//  ClickTableView.h
//  SinaNews
//
//  Created by shieh exbice on 11-12-12.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ClickTableView;

@protocol ClickTableView_Delegate <NSObject>

-(void)tableView:(ClickTableView*)tableView clicked:(BOOL)clicked;

@end

@interface ClickTableView : UITableView

@property(nonatomic,assign)id<ClickTableView_Delegate> clickedDelegate;

@end
