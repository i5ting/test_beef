//
//  ClickTableView.m
//  SinaNews
//
//  Created by shieh exbice on 11-12-12.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "ClickTableView.h"

@implementation ClickTableView
@synthesize clickedDelegate;

-(id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        // 单击的 Recognizer    
        UITapGestureRecognizer* singleRecognizer;    
        singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapFrom)];   
        singleRecognizer.numberOfTapsRequired = 1; 
        // 单击    
        //[self addGestureRecognizer:singleRecognizer];  
        [singleRecognizer release];
    }
    return self;
}

-(void)handleSingleTapFrom
{
    if ([clickedDelegate respondsToSelector:@selector(tableView: clicked:)]) {
        [clickedDelegate tableView:self clicked:YES];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    if ([clickedDelegate respondsToSelector:@selector(tableView: clicked:)]) {
        [clickedDelegate tableView:self clicked:YES];
    }
}

@end
