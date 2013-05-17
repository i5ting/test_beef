//
//  AddStockViewController.m
//  SinaFinance
//
//  Created by shieh exbice on 12-5-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AddStockRemindViewController.h"
#import "StockFuncPuller.h"
#import "ConfigFileManager.h"
#import "StockViewDefines.h"
#import "ShareData.h"
#import "StockListCell.h"
#import "StockListViewController2.h"
#import "MyTool.h"

@interface AddStockRemindViewController ()
@property(nonatomic,retain)NSDictionary* stockInfo;
@property(nonatomic,retain)NewsObject* configItem;
-(void)initNotification;
-(void)loadStockNameInfo;
-(UILabel*)titleLabelWithIndex:(NSInteger)index;

@end

@implementation AddStockRemindViewController
{
    NewsObject* configItem;
    NSDictionary* stockInfo;
    BOOL binited;
}
@synthesize stockNameL,stockInfo1L,stockInfo2L,stockInfo3L,indicator,titleView;
@synthesize stockSetting1L,stockSetting2L,stockSetting3L,stockSetting4L;
@synthesize stockFrequencyModeS;
@synthesize comfirmBtn,cancelBtn,backView;
@synthesize stockInfo;
@synthesize configItem;
@synthesize stockSymbolInfo;
@synthesize delegate;
@synthesize preSettting1,preSettting2,preSettting3,preSettting4;
@synthesize mode;
@synthesize data;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        CommentDataList* dataList = [[ConfigFileManager getInstance] stockListConfigDataList];
        NSArray* dataArray = [dataList contentsWithIDList:nil];
        for (NewsObject* oneObject in dataArray) {
            NSString* type = [oneObject valueForKey:Stockitem_type];
            if (type&&[type isEqualToString:Value_Stockitem_type_myGroup]) {
                self.configItem = oneObject; //自选股的配置信息
                break;
            }
        }
    }
    return self;
}

-(void)dealloc
{
    [stockNameL release];
    [stockInfo1L release];
    [stockInfo2L release];
    [stockInfo3L release];
    [stockSetting1L release];
    [stockSetting2L release];
    [stockSetting3L release];
    [stockSetting4L release];
    [stockFrequencyModeS release];
    [comfirmBtn release];
    [cancelBtn release];
    [backView release];
    [stockInfo release];
    [configItem release];
    [stockSymbolInfo release];
    [indicator release];
    [titleView release];
    [preSettting1 release];
    [preSettting2 release];
    [preSettting3 release];
    [preSettting4 release];
    [data release];
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    self.stockSetting1L.keyboardType =UIKeyboardTypeDecimalPad;
    self.stockSetting2L.keyboardType =UIKeyboardTypeDecimalPad;
    self.stockSetting3L.keyboardType =UIKeyboardTypeDecimalPad;
    self.stockSetting4L.keyboardType =UIKeyboardTypeDecimalPad;
    
    
    self.view.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.3];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    if (!binited) {
        binited = YES;
        [self initNotification];
        if (preSettting1) {
            self.stockSetting1L.text = preSettting1;
            self.stockSetting2L.text = preSettting2;
            self.stockSetting3L.text = preSettting3;
            self.stockSetting4L.text = preSettting4;
        }
    }
    UIImage* backImage = [UIImage imageNamed:@"push_add_back.png"];
    backImage = [backImage stretchableImageWithLeftCapWidth:100.0 topCapHeight:100.0];
    UIImageView* backImageView = [[UIImageView alloc] initWithImage:backImage];
    CGRect backRect = self.backView.bounds;
    backImageView.frame = CGRectMake(-10, 0, backRect.size.width+20, backRect.size.height);
    backImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [self.backView addSubview:backImageView];
    [self.backView sendSubviewToBack:backImageView];
    [backImageView release];

    [self.comfirmBtn setTitleColor:[UIColor colorWithRed:159/255.0 green:153/255.0 blue:153/255.0 alpha:1.0] forState:UIControlStateNormal];
    [self.comfirmBtn setTitleColor:[UIColor colorWithRed:61/255.0 green:105/255.0 blue:148/255.0 alpha:1.0] forState:UIControlStateHighlighted];
    [self.cancelBtn setTitleColor:[UIColor colorWithRed:159/255.0 green:153/255.0 blue:153/255.0 alpha:1.0] forState:UIControlStateNormal];
    [self.cancelBtn setTitleColor:[UIColor colorWithRed:61/255.0 green:105/255.0 blue:148/255.0 alpha:1.0] forState:UIControlStateHighlighted];
    
    [UIView beginAnimations:@"view flip" context:nil];
    [UIView setAnimationDuration:1];
    CGRect f = self.backView.frame;
    f.origin.y = 0;
    self.backView.frame = f;
    [UIView setAnimationTransition:UIViewAnimationOptionTransitionFlipFromTop forView:self.backView cache:YES];
    [UIView commitAnimations];
    
    [self.stockSetting1L becomeFirstResponder];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)setStockSymbolInfo:(NSDictionary *)astockInfo
{
    if (astockInfo!=stockSymbolInfo) {
        NSDictionary* oldStcokInfo = stockSymbolInfo;
        stockSymbolInfo = [astockInfo retain];
        [oldStcokInfo release];
    }
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(startStockInfoRequest) object:nil];
    [self performSelector:@selector(startStockInfoRequest) withObject:nil afterDelay:0.001];
}

-(void)initNotification
{
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self 
           selector:@selector(StockObjectAdded:) 
               name:StockObjectAddedNotification 
             object:nil];
    
    [nc addObserver:self 
           selector:@selector(StockObjectFailed:) 
               name:StockObjectFailedNotification
             object:nil];
}

-(IBAction)comfirmClicked:(id)sender
{

    if ([stockSetting1L.text length]>0&&
        [stockSetting2L.text length]>0&&
        [stockSetting3L.text length]>0&&
        [stockSetting4L.text length]>0) {
        
        self.view.hidden = YES;
        if ([delegate respondsToSelector:@selector(addStockRemindComfirm:)]) {
            [delegate addStockRemindComfirm:self];
        }
        [self backviewClicked:nil];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"消息提示" message:@"您所填写的信息有误，请重新填写" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];;
        [alert show];
        [alert release];
    }
  
}

-(IBAction)cancelClicked:(id)sender
{
    self.view.hidden = YES;
    if ([delegate respondsToSelector:@selector(addStockRemindCancel:)]) {
        [delegate addStockRemindCancel:self];
    }
    [self backviewClicked:nil];
}

-(IBAction)backgroundClicked:(id)sender
{
    [UIView beginAnimations:@"view flip" context:nil];
    [UIView setAnimationDuration:1];
    CGRect f = self.backView.frame;
    f.origin.y = 46;
    self.backView.frame = f;
    [UIView setAnimationTransition:UIViewAnimationOptionTransitionFlipFromTop forView:self.backView cache:YES];
    [UIView commitAnimations];
    [self backviewClicked:nil];
}

-(IBAction)backviewClicked:(id)sender
{
    [stockSetting1L resignFirstResponder];
    [stockSetting2L resignFirstResponder];
    [stockSetting3L resignFirstResponder];
    [stockSetting4L resignFirstResponder];
}

-(void)startStockInfoRequest
{
    self.titleView.hidden = YES;
    [self.indicator startAnimating];
    self.indicator.hidden = NO;
    NSString* stockSymbol = [self.stockSymbolInfo valueForKey:StockFunc_RemindStockInfo_symbol];
    NSString* stockType = [self.stockSymbolInfo valueForKey:StockFunc_RemindStockInfo_type];
    [[StockFuncPuller getInstance] startOneStockInfoWithSender:self type:stockType symbol:stockSymbol args:nil dataList:nil userInfo:nil];
}

-(void)loadStockNameInfo
{
    NSArray* typeItem = (NSArray*)[configItem valueForKey:Stockitem_layout_typeitem];
    NSInteger curIndex = -1;
    NSString* curType = [stockSymbolInfo valueForKey:StockFunc_RemindStockInfo_type];
    if (curType) {
        for (int i=0; i<[typeItem count]; i++) {
            NSString* oneType = [typeItem objectAtIndex:i];
            if ([[oneType lowercaseString] isEqualToString:[curType lowercaseString]]) {
                curIndex = i;
            }
        }
    }
    
    if (curIndex>=0) {
        NSString* bRedSize = [configItem valueForKey:Stockitem_layout_redrise];
        if ([bRedSize isKindOfClass:[NSArray class]]) {
            if (curIndex<[(NSArray*)bRedSize count]) {
                bRedSize = [(NSArray*)bRedSize objectAtIndex:curIndex];
            }
        }
        NSInteger colorType = 0;
        if ([bRedSize intValue]>0) {
            colorType = kSHZhangDie;
        }
        NSString* stockName = nil;
        NSArray* configArray = nil;
        NSArray* layoutKeys = (NSArray*)[configItem valueForKey:Stockitem_request_layoutkey];
        if (curIndex<[layoutKeys count]) {
            NSString* layoutKey = [layoutKeys objectAtIndex:curIndex];
            configArray = (NSArray*)[configItem valueForKey:layoutKey];
        }
        UIColor* decideColor = nil;
        NSString* ReplacedZeroNull = nil;
        NSMutableArray* decideColorArray = nil;
        NSMutableArray* decideNullArray = nil;
        for (int i=0;i<[configArray count];i++) {
            NSDictionary* configDict = [configArray objectAtIndex:i];
            NSString* codevalue = [configDict valueForKey:Stockitem_layout_codevalue];
            NSString* stringStyle =  [configDict valueForKey:Stockitem_layout_stringstyle];
            NSString* bDecideColor =  [configDict valueForKey:Stockitem_layout_decidecolor];
            NSString* bDecidenull =  [configDict valueForKey:Stockitem_layout_decidenull];
            NSString* bJustname =  [configDict valueForKey:Stockitem_layout_justname];
            NSString* value = [stockInfo valueForKey:codevalue];
            if (i==0) {
                stockName = value;
            }
            UILabel* oneLabel = [self titleLabelWithIndex:i];
            if (!(bJustname&&[bJustname intValue]>0)) {
                if (bDecidenull&&[bDecidenull isKindOfClass:[NSString class]]&&[bDecidenull intValue]>0) {
                    if([value isKindOfClass:[NSNull class]]||[value floatValue]==0.0)
                    {
                        ReplacedZeroNull = @"--";
                    }
                }
                else if(bDecidenull&&[bDecidenull isKindOfClass:[NSArray class]])
                {
                    if([value isKindOfClass:[NSNull class]]||[value floatValue]==0.0)
                    {
                        ReplacedZeroNull = @"--";
                        if (!decideNullArray) {
                            decideNullArray = [NSMutableArray arrayWithCapacity:0];
                            for (int j=0; j<[configArray count]; j++) {
                                [decideNullArray addObject:[NSNull null]];
                            }
                        }
                        for (NSString* oneRow in (NSArray*)bDecidenull) {
                            if ([oneRow intValue]<[decideNullArray count]) {
                                [decideNullArray replaceObjectAtIndex:[oneRow intValue] withObject:ReplacedZeroNull];
                            }
                        }
                    }
                    
                }
                if ([value isKindOfClass:[NSString class]]) {
                    NSString* formatValue = [StockListViewController2 formatFloatString:value style:stringStyle];
                    oneLabel.text = formatValue;
                }
                else {
                    oneLabel.text = @"--";
                }
                if (bDecideColor&&[bDecideColor isKindOfClass:[NSString class]]&&[bDecideColor intValue]>0) {
                    decideColor = [[ShareData sharedManager] textColorWithValue:[value floatValue] marketType:colorType];
                }
                else if(bDecideColor&&[bDecideColor isKindOfClass:[NSArray class]])
                {
                    decideColor = [[ShareData sharedManager] textColorWithValue:[value floatValue] marketType:colorType];
                    if (!decideColorArray) {
                        decideColorArray = [NSMutableArray arrayWithCapacity:0];
                        for (int j=0; j<[configArray count]; j++) {
                            [decideColorArray addObject:[NSNull null]];
                        }
                    }
                    for (NSString* oneRow in (NSArray*)bDecideColor) {
                        if ([oneRow intValue]<[decideColorArray count]) {
                            [decideColorArray replaceObjectAtIndex:[oneRow intValue] withObject:decideColor];
                        }
                    }
                }
            }
            else {
                if ([value isKindOfClass:[NSString class]]) {
                    oneLabel.text = value;
                }
                else {
                    oneLabel.text = @"--";
                }
            }
            if (!decideColor&&i==[configArray count]-1) {
                decideColor = [[ShareData sharedManager] textColorWithValue:[value floatValue] marketType:colorType];
            }
        }
        for (int i=0;i<[configArray count];i++)
        {
            NSDictionary* configDict = [configArray objectAtIndex:i];
            NSString* bJustname =  [configDict valueForKey:Stockitem_layout_justname];
            UILabel* oneLabel = [self titleLabelWithIndex:i];
            if (!(bJustname&&[bJustname intValue]>0))
            {
                if (decideColor) {
                    if (decideColorArray&&[decideColorArray count]>0) {
                        UIColor* oneColor = [decideColorArray objectAtIndex:i];
                        if (![oneColor isKindOfClass:[NSNull class]]) {
                            oneLabel.textColor = oneColor;
                            if (oneColor==[UIColor whiteColor]) {
                                oneLabel.textColor = [UIColor colorWithRed:0/255.0 green:60/255.0 blue:118/255.0 alpha:1.0]; //特殊需求
                            }
                        }
                        else {
                            oneLabel.textColor = [UIColor whiteColor];
                            oneLabel.textColor = [UIColor colorWithRed:0/255.0 green:60/255.0 blue:118/255.0 alpha:1.0]; //特殊需求
                        }
                    }
                    else
                    {
                        oneLabel.textColor = decideColor;
                        if (decideColor==[UIColor whiteColor]) {
                            oneLabel.textColor = [UIColor colorWithRed:0/255.0 green:60/255.0 blue:118/255.0 alpha:1.0]; //特殊需求
                        }
                    }
                }
                else {
                    oneLabel.textColor = [UIColor whiteColor];
                    oneLabel.textColor = [UIColor colorWithRed:0/255.0 green:60/255.0 blue:118/255.0 alpha:1.0]; //特殊需求
                }
                if (ReplacedZeroNull) {
                    if (decideNullArray&&[decideNullArray count]>0) {
                        NSString* oneString = [decideNullArray objectAtIndex:i];
                        if (![oneString isKindOfClass:[NSNull class]]) {
                            oneLabel.text = oneString;
                        }
                    }
                    else
                    {
                        oneLabel.text =ReplacedZeroNull;
                    }
                }
            }
            else {
                oneLabel.textColor = [UIColor whiteColor];
                oneLabel.textColor = [UIColor colorWithRed:0/255.0 green:60/255.0 blue:118/255.0 alpha:1.0]; //特殊需求
            }
        }
    }
    
}

-(UILabel*)titleLabelWithIndex:(NSInteger)index
{
    if (index==0) {
        return stockNameL;
    }
    else if(index==1)
    {
        return stockInfo1L;
    }
    else if(index==2)
    {
        return stockInfo2L;
    }
    else if(index==3)
    {
        return stockInfo3L;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString* text = textField.text;
    NSInteger textLen = text.length;
    NSRange dotRange = [text rangeOfString:@"."];
    if (string.length==0&&range.location!=NSNotFound) {
        return YES;
    }
    else {
        if ((dotRange.location!=NSNotFound&&(NSInteger)dotRange.location>=(textLen-3))||(dotRange.location==NSNotFound)) 
        {
            if ([MyTool isDigtal:string]) {
                return YES;
            }
            else {
                if ([text rangeOfString:@"."].location==NSNotFound&&[string isEqualToString:@"."]&&[text length]>0) {
                    return YES;
                }
                else {
                    return NO;
                }
            }
        }
        else {
            return NO;
        }
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [UIView beginAnimations:@"view flip" context:nil];
    [UIView setAnimationDuration:1];
    CGRect f = self.backView.frame;
    f.origin.y = 46;
    self.backView.frame = f;
    [UIView setAnimationTransition:UIViewAnimationOptionTransitionFlipFromTop forView:self.backView cache:YES];
    [UIView commitAnimations];
    
    [textField resignFirstResponder];
    return YES;
}


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (self.backView.frame.origin.y == 46) {
        [UIView beginAnimations:@"view flip" context:nil];
        [UIView setAnimationDuration:1];
        CGRect f = self.backView.frame;
        f.origin.y = -22;
        self.backView.frame = f;
        [UIView setAnimationTransition:UIViewAnimationOptionTransitionFlipFromTop forView:self.backView cache:YES];
        [UIView commitAnimations];
        
        [textField becomeFirstResponder];
    }

}

- (void)textFieldDidEndEditing:(UITextField *)textField{
//    [UIView beginAnimations:@"view flip" context:nil];
//    [UIView setAnimationDuration:1];
//    CGRect f = self.backView.frame;
//    f.origin.y = 46;
//    self.backView.frame = f;
//    [UIView setAnimationTransition:UIViewAnimationOptionTransitionFlipFromTop forView:self.backView cache:YES];
//    [UIView commitAnimations];
//    
//    [textField resignFirstResponder];
}
#pragma mark -
#pragma mark networkCallback
-(void)StockObjectAdded:(NSNotification*)notify
{
    NSDictionary* userInfo = notify.userInfo;
    NSNumber* senderNumber = [userInfo valueForKey:RequsetSender];
    if ([senderNumber intValue]==(int)self) {
        NSNumber* stageNumber = [userInfo valueForKey:RequsetStage];
        if ([stageNumber intValue]==Stage_Request_OneStockInfo) 
        {
            NSNumber* pageNumber = [userInfo valueForKey:RequsetPage];
            NSArray* array = [userInfo valueForKey:RequsetArray];
            NewsObject* oneObject = [array lastObject];
            self.stockInfo = oneObject.newsData;
            [self loadStockNameInfo];
            self.titleView.hidden = NO;
            [self.indicator stopAnimating];
            self.indicator.hidden = YES;
        }
    }
}

-(void)StockObjectFailed:(NSNotification*)notify
{
    NSDictionary* userInfo = notify.userInfo;
    NSNumber* senderNumber = [userInfo valueForKey:RequsetSender];
    if ([senderNumber intValue]==(int)self) {
        NSNumber* stageNumber = [userInfo valueForKey:RequsetStage];
        if([stageNumber intValue]==Stage_Request_OneStockInfo)
        {
            NSArray* args = [userInfo valueForKey:RequsetArgs];
            self.titleView.hidden = NO;
            [self.indicator stopAnimating];
            self.indicator.hidden = YES;
        }
    }
}

@end
