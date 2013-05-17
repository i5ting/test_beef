//
//  MyStockGroupView.m
//  SinaFinance
//
//  Created by Du Dan on 11/30/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "MyStockGroupView.h"

@implementation MyStockGroupBackView
{
    CGRect noclickFrame;
    CGRect noframe;
}
@synthesize delegate;

-(id)initWithFrame:(CGRect)frame noclickFrame:(CGRect)aNoframe
{
    self = [super initWithFrame:frame];
    if (self) {
        noframe = aNoframe;
        [self initUI];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

-(void)initUI
{
    CGRect frame = self.frame;
    CGRect newBounds = noframe;
    if (newBounds.size.width>0.0&&newBounds.size.height>0.0) {
        newBounds.origin.x = noframe.origin.x - frame.origin.x;
        newBounds.origin.x = newBounds.origin.x>=0?newBounds.origin.x:0;
        newBounds.origin.y = noframe.origin.y - frame.origin.y;
        newBounds.origin.y = newBounds.origin.y>=0?newBounds.origin.y:0;
        newBounds.size.width = noframe.size.width+noframe.origin.x - newBounds.origin.x;
        newBounds.size.width = newBounds.size.width>0?newBounds.size.width:0;
        newBounds.size.height = noframe.size.height+noframe.origin.y - newBounds.origin.y;
        newBounds.size.height = newBounds.size.height>0?newBounds.size.height:0;
        noclickFrame = newBounds;
        
        CGRect btn1Rect = CGRectMake(0, 0, frame.size.width, newBounds.origin.y);
        UIButton* btn1 = [[UIButton alloc] initWithFrame:btn1Rect];
        btn1.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:0.4];
        [btn1 addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn1];
        [btn1 release];
        
        CGRect btn2Rect = CGRectMake(0, newBounds.origin.y+newBounds.size.height, frame.size.width, frame.size.height - (newBounds.origin.y+newBounds.size.height));
        UIButton* btn2 = [[UIButton alloc] initWithFrame:btn2Rect];
        btn2.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:0.4];
        [btn2 addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn2];
        [btn2 release];
        
        CGRect btn3Rect = CGRectMake(0, newBounds.origin.y, newBounds.origin.x, newBounds.size.height);
        UIButton* btn3 = [[UIButton alloc] initWithFrame:btn3Rect];
        btn3.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:0.4];
        [btn3 addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn3];
        [btn3 release];
        
        CGRect btn4Rect = CGRectMake(newBounds.origin.x+newBounds.size.width, newBounds.origin.y, frame.size.width - (newBounds.origin.x+newBounds.size.width), newBounds.size.height);
        UIButton* btn4 = [[UIButton alloc] initWithFrame:btn4Rect];
        btn4.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:0.4];
        [btn4 addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn4];
        [btn4 release];
    }
    else {
        CGRect btn3Rect = CGRectMake(0, 0, frame.size.width, frame.size.height);
        UIButton* btn3 = [[UIButton alloc] initWithFrame:btn3Rect];
        btn3.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:0.4];
        [btn3 addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn3];
        [btn3 release];
    }
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.userInteractionEnabled = YES;
}

-(void)btnClicked:(UIButton*)sender
{
    if ([delegate respondsToSelector:@selector(myStockGroupBackViewDidClicked:)]) {
        [delegate myStockGroupBackViewDidClicked:self];
    }
}

-(UIView*)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    if (self.hidden==NO) {
        UIView* rtval = nil;
        for (int i=[[self subviews] count]-1;i>=0;i--) {
            UIView* aSubView = [[self subviews] objectAtIndex:i];
            bool bInSubView = CGRectContainsPoint(aSubView.frame,point);   
            if (bInSubView) {
                CGPoint newPoint = [self convertPoint:point toView:aSubView];
                rtval = [aSubView hitTest:newPoint withEvent:event];
                
                break;
            }
        }
        return rtval;
    }
    else {
        return nil;
    }
}

@end

@interface MyStockGroupView ()
@property(nonatomic,retain)NSValue* sourceRectValue;
@property(nonatomic,retain)NSValue* destRectValue;
@end

@implementation MyStockGroupView

@synthesize delegate;
@synthesize loadState;
@synthesize userInfo;
@synthesize sourceRectValue,destRectValue;

- (id)initWithFrame:(CGRect)frame data:(NSArray*)dataArray
{
    self = [super initWithFrame:frame];
    if (self) {
        myStockArray = [[NSMutableArray alloc] initWithCapacity:0];
        if (dataArray) {
            [myStockArray addObjectsFromArray:dataArray];
        }
        
        UIImage* backImage = [UIImage imageNamed:@"coverlistback.png"];
        backImage = [backImage stretchableImageWithLeftCapWidth:80.0 topCapHeight:80.0];
        UIImageView* backImageView = [[UIImageView alloc] initWithImage:backImage];
        backImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        backImageView.frame  = CGRectMake(-5, -2, frame.size.width+10, frame.size.height+10);
        [self addSubview:backImageView];
        [backImageView release];
        
        myStockTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) style:UITableViewStylePlain];
        myStockTable.backgroundColor = [UIColor colorWithRed:211.0/255 green:211.0/255 blue:211.0/255 alpha:1.0];
        myStockTable.delegate = self;
        myStockTable.backgroundColor = [UIColor clearColor];
        myStockTable.dataSource = self;
        myStockTable.rowHeight  = 30;
        myStockTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:myStockTable];
        
        indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        CGRect indicatorRect = indicatorView.bounds;
        indicatorRect.origin.x = frame.size.width/2 - indicatorRect.size.width/2;
        indicatorRect.origin.y = frame.size.height/2 - indicatorRect.size.height/2;
        indicatorView.frame = indicatorRect;
        [self addSubview:indicatorView];
        
        CGRect errorRect = CGRectMake(0, 0, 120, 20);
        errorLabel = [[UILabel alloc] initWithFrame:errorRect];
        errorRect.origin.x = frame.size.width/2 - errorRect.size.width/2;
        errorRect.origin.y = frame.size.height/2 - errorRect.size.height/2;
        errorLabel.frame = errorRect;
        errorLabel.text = @"列表加载失败!";
        errorLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:errorLabel];
        self.loadState = dataArray==nil?GroupViewState_Loading:GroupViewState_Finish;
        
    }
    return self;
}

- (void)dealloc
{
    [delegate release];
    [myStockArray release];
    [myStockTable release];
    [indicatorView release];
    [errorLabel release];
    [userInfo release];
    [sourceRectValue release];
    [destRectValue release];
    [super dealloc];
}

-(void)setData:(NSArray*)dataArray
{
    if (dataArray) {
        [myStockArray removeAllObjects];
        [myStockArray addObjectsFromArray:dataArray];
    }
    else
    {
        [myStockArray removeAllObjects];
    }
    self.loadState = dataArray==nil?GroupViewState_Loading:GroupViewState_Finish;
}

-(void)setLoadState:(NSInteger)aLoadState
{
    loadState = aLoadState;
    if (aLoadState==GroupViewState_Loading) {
        [myStockTable reloadData];
        [indicatorView startAnimating];
        errorLabel.hidden = YES;
    }
    else if(aLoadState==GroupViewState_Finish)
    {
        [myStockTable reloadData];
        [indicatorView stopAnimating];
        if (myStockArray&&[myStockArray count]>0) {
            errorLabel.hidden = YES;
        }
        else {
            errorLabel.text = @"无内容";
            [errorLabel sizeToFit];
            errorLabel.hidden = NO;
            [self realFrameChanged];
        }
    }
    else if(aLoadState==GroupViewState_Error)
    {
        [myStockArray removeAllObjects];
        [myStockTable reloadData];
        [indicatorView stopAnimating];
        errorLabel.text = @"列表加载失败!";
        [errorLabel sizeToFit];
        errorLabel.hidden = NO;
        [self realFrameChanged];
    }
    
}

#pragma mark
#pragma mark UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return myStockArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        UIImage* lineImage = [[UIImage imageNamed:@"mystock_line.png"] stretchableImageWithLeftCapWidth:20.0 topCapHeight:1.0];
        UIImageView *line = [[[UIImageView alloc] initWithImage:lineImage] autorelease];
        line.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin;
        CGRect cellRect = cell.frame;
        cellRect.origin.x = 10;
        cellRect.size.width -= 10*2;
        cellRect.origin.y = cellRect.size.height - 1;
        cellRect.size.height = 1;
        line.frame = cellRect;
        [cell addSubview:line];
        cell.textLabel.textColor = [UIColor colorWithRed:61.0/255 green:61.0/255 blue:61.0/255 alpha:1.0];
        cell.textLabel.font = [UIFont fontWithName:@"Arial" size:14];
        cell.textLabel.textColor = [UIColor colorWithRed:121/255.0 green:121/255.0 blue:121/255.0 alpha:1.0];
    }
    
    NSDictionary *dict = [myStockArray objectAtIndex:indexPath.row];
    //    NSLog(@"group name: %@", [dict objectForKey:@"name"] );
    cell.textLabel.text = [[dict objectForKey:@"name"] isEqualToString:@""]?[dict objectForKey:@"symbol"]:[dict objectForKey:@"name"];
    
    //cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [delegate myStockGroupView:self didSelectGroup:[myStockArray objectAtIndex:indexPath.row]];
}

-(void)setFrame:(CGRect)frame
{
    CGRect sourceRect = self.frame;
    [super setFrame:frame];
    
    NSValue* sourceValue = [NSValue valueWithCGRect:sourceRect];
    NSValue* destValue = [NSValue valueWithCGRect:frame];
    if (!sourceRectValue) {
        self.sourceRectValue = sourceValue;
    }
    self.destRectValue = destValue;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(frameChanged) object:nil];
    [self performSelector:@selector(frameChanged) withObject:nil afterDelay:0.001];
}

-(void)frameChanged
{
    if (self.destRectValue&&self.sourceRectValue) {
        CGRect frame = [self.destRectValue CGRectValue];
        CGRect sourceRect = [self.sourceRectValue CGRectValue];
        if (!CGRectEqualToRect(frame, CGRectZero)&&!CGRectEqualToRect(frame, sourceRect))
        {
            [self realFrameChanged];
        }
    }
    self.sourceRectValue = nil;
    self.destRectValue = nil;
}

-(void)realFrameChanged
{
    myStockTable.frame = self.bounds;
    
    CGRect indicatorRect = indicatorView.bounds;
    indicatorRect.origin.x = self.bounds.size.width/2 - indicatorRect.size.width/2;
    indicatorRect.origin.y = self.bounds.size.height/2 - indicatorRect.size.height/2;
    indicatorView.frame = indicatorRect;
    
    CGRect errorRect = errorLabel.frame;
    errorRect.origin.x = self.bounds.size.width/2 - errorRect.size.width/2;
    errorRect.origin.y = self.bounds.size.height/2 - errorRect.size.height/2;
    errorLabel.frame = errorRect;
}

@end
