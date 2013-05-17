//
//  ForeignCalculatorView.m
//  SinaFinance
//
//  Created by shieh exbice on 12-5-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ForeignCalculatorView.h"
#import "ASIHTTPRequest.h"
#import "JSONKit.h"
#import "MyTool.h"
#import "CalculatorDefines.h"
#import "MyStockGroupView.h"
#import "JSONConfigDownloader.h"

#define ForeignRequstType_Basic @"forex_basic"
#define ForeignRequstType_Cross @"forex_cross"
#define ForeignRequstType_Other @"wh"

#define ForeignRequstTypeKey @"request_type"
#define ForeignFirstType @"first_type"
#define ForeignSecondType @"second_type"
#define ForeignInputNumber @"input_number"
#define ForeignInputString @"input_string"

#define ForeignNameKey @"name"
#define ForeignTypeKey @"type"

@interface ForeignCalculatorView ()
@property(nonatomic,retain)ASIHTTPRequest* curRequest;
@property(nonatomic,retain)NSMutableArray* coreData;
@property(nonatomic,retain)NSString *coreDataTime;
@property(nonatomic,retain)NSArray* configArray;
@property(nonatomic,retain)NSArray* firstTypeArray;
@property(nonatomic,retain)NSArray* secondTypeArray;
@property(nonatomic,retain)MyStockGroupView *mygroupView;

@end

@implementation ForeignCalculatorView
{
    NSArray* configArray;
    NSArray* firstTypeArray;
    NSInteger firstIndex;
    NSArray* secondTypeArray;
    NSInteger secondIndex;
    MyStockGroupView *mygroupView;
}
@synthesize totalView;
@synthesize input1,input2,inputback1,inputback2,coinCombo1,coinCombo2,coinComboBack1,coinComboBack2,resultBtn,coinComboBtn1,coinComboBtn2;
@synthesize curRequest;
@synthesize coreData;
@synthesize configArray;
@synthesize firstTypeArray,secondTypeArray;
@synthesize mygroupView;
@synthesize justNetwork;
@synthesize tipLabel;
@synthesize delegate;
@synthesize hideWhenFinish;
@synthesize coreDataTime;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        justNetwork = YES;
        hideWhenFinish = YES;
        [self initUI];
        [self initNotification];
        [self initConfig];
       
    }
    return self;
}

-(void)dealloc
{
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc removeObserver:self];
    [totalView release];
    [input1 release];
    [input2 release];
    [coinCombo1 release];
    [coinCombo2 release];
    [coinComboBack1 release];
    [coinComboBack2 release];
    [coinComboBtn1 release];
    [coinComboBtn2 release];
    [resultBtn release];
    [inputback1 release];
    [inputback2 release];
    if (curRequest) {
        [curRequest clearDelegatesAndCancel];
        self.curRequest = nil;
    }
    [coreData release];
    [configArray release];
    [firstTypeArray release];
    [secondTypeArray release];
    [mygroupView release];
    [tipLabel release];
    [coreDataTime release];
    
    [super dealloc];
}

-(void)initUI
{
    CGRect frame = self.frame;
    [[NSBundle mainBundle] loadNibNamed:@"ForeignCalculatorView" owner:self options:nil];
    self.input2.enabled = NO;
    totalView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    totalView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [self addSubview:totalView];
    self.userInteractionEnabled = YES;
    
    UIImage* backImage = [UIImage imageNamed:@"calculator_back.png"];
    backImage = [backImage stretchableImageWithLeftCapWidth:100.0 topCapHeight:60.0];
    UIImageView* backImageView = [[UIImageView alloc] initWithImage:backImage];
    backImageView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    backImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [self addSubview:backImageView];
    [self sendSubviewToBack:backImageView];
    [backImageView release];
    
    inputback1.backgroundColor = [UIColor clearColor];
    inputback2.backgroundColor = [UIColor clearColor];
    coinComboBack1.backgroundColor = [UIColor clearColor];
    coinComboBack2.backgroundColor = [UIColor clearColor];

}

-(void)initNotification
{
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    
}

-(BOOL)isFirstResponder
{
    if ([input1 isFirstResponder]||[input2 isFirstResponder]) {
        return YES;
    }
    else {
        return NO;
    }
}

-(void)initConfig
{
    if (!configArray) {
        configArray = [[self configArrayFromFileName:@"foreigncalculatorconfig.json"] retain];
    }
    if (!firstTypeArray) {
        NSDictionary* firstDict = nil;
        for (NSDictionary* tableDict in self.configArray) {
            NSString* tableType = [tableDict valueForKey:ForeignCalculator_type];
            if ([tableType isEqualToString:Value_ForeignCalculator_firsttable]) {
                firstDict = tableDict;
                break;
            }
        }
        NSArray* showList = [firstDict valueForKey:ForeignCalculator_showlist];
        NSArray* typeList = [firstDict valueForKey:ForeignCalculator_typelist];
        NSMutableArray* typeArray = [[NSMutableArray alloc] initWithCapacity:0];
        
        int defaultIndex = 0;
        for (int i=0; i<[typeList count]; i++) {
            NSString* oneType = [typeList objectAtIndex:i];
            NSString* oneName = oneType;
            if ([showList count]>i) {
                oneName = [showList objectAtIndex:i];
            }
            if ([oneName isEqualToString:@"人民币"]) {
                defaultIndex = i;
            }
            NSMutableDictionary* oneDict = [[NSMutableDictionary alloc] initWithCapacity:0];
            [oneDict setValue:oneName forKey:ForeignNameKey];
            [oneDict setValue:oneType forKey:ForeignTypeKey];
            [typeArray addObject:oneDict];
            [oneDict release];
        }
        self.firstTypeArray = typeArray;
        firstIndex = defaultIndex;
        [typeArray release];
        NSString* firstString = @"";
        if ([self.firstTypeArray count]>firstIndex) {
            NSDictionary* oneDict = [self.firstTypeArray objectAtIndex:firstIndex];
            firstString = [oneDict valueForKey:ForeignNameKey];
        }
        self.coinCombo1.text = firstString;
    }
    
    if (!secondTypeArray) {
        NSDictionary* secondDict = nil;
        for (NSDictionary* tableDict in self.configArray) {
            NSString* tableType = [tableDict valueForKey:ForeignCalculator_type];
            if ([tableType isEqualToString:Value_ForeignCalculator_secondtable]) {
                secondDict = tableDict;
                break;
            }
        }
        NSArray* showList = [secondDict valueForKey:ForeignCalculator_showlist];
        NSArray* typeList = [secondDict valueForKey:ForeignCalculator_typelist];
        NSMutableArray* typeArray = [[NSMutableArray alloc] initWithCapacity:0];
        
        for (int i=0; i<[typeList count]; i++) {
            NSString* oneType = [typeList objectAtIndex:i];
            NSString* oneName = oneType;
            if ([showList count]>i) {
                oneName = [showList objectAtIndex:i];
            }
            NSMutableDictionary* oneDict = [[NSMutableDictionary alloc] initWithCapacity:0];
            [oneDict setValue:oneName forKey:ForeignNameKey];
            [oneDict setValue:oneType forKey:ForeignTypeKey];
            [typeArray addObject:oneDict];
            [oneDict release];
        }
        self.secondTypeArray = typeArray;
        secondIndex = 0;
        [typeArray release];
        NSString* secondString = @"";
        if ([self.secondTypeArray count]>secondIndex) {
            NSDictionary* oneDict = [self.secondTypeArray objectAtIndex:secondIndex];
            secondString = [oneDict valueForKey:ForeignNameKey];
        }
        self.coinCombo2.text = secondString;
    }
    
    
}

-(NSArray*)configArrayFromFileName:(NSString*)fileName
{
    NSArray* commentArray = [[JSONConfigDownloader getInstance] jsonOjbectWithJSONConfigFile:fileName];
    return commentArray;
}

-(void)setHidden:(BOOL)hidden
{
    [super setHidden:hidden];
    if (hidden) {
        [self finish];
    }
}

-(void)finish
{
    if (hideWhenFinish) {
        [input1 resignFirstResponder];
        [input2 resignFirstResponder];
    }
    if ([delegate respondsToSelector:@selector(calculatorBackClicked:)]) {
        [delegate calculatorBackClicked:self];
    }
}

-(void)setJustNetwork:(BOOL)ajustNetwork
{
    justNetwork = ajustNetwork;
    if (ajustNetwork) {
        self.tipLabel.text = @"基于即时价格";
    }
    else {
        self.tipLabel.text = @"";
    }
}

-(void)setHideWhenFinish:(BOOL)bhideWhenFinish
{
    hideWhenFinish = bhideWhenFinish;
    if(!hideWhenFinish)
    {
        [input1 becomeFirstResponder];
    }
}


#pragma mark -
#pragma mark popview
- (void)myStockGroupBackViewDidClicked:(MyStockGroupBackView*)backView
{
    [self.mygroupView.superview removeFromSuperview];
}

-(void)initMyGroupView:(UIButton*)sender
{
    CGRect addStockRect = sender.frame;
    addStockRect = [self.superview convertRect:addStockRect fromView:sender.superview];
    CGRect suggestRect = addStockRect;
    suggestRect.origin.y = addStockRect.origin.y + addStockRect.size.height+3;
    suggestRect.size.width = addStockRect.size.width; 
    suggestRect.origin.x = addStockRect.origin.x;
    suggestRect.size.height = 100;
    if (self.mygroupView) {
        self.mygroupView = nil;
    }
    if(mygroupView == nil){
        mygroupView = [[MyStockGroupView alloc] initWithFrame:suggestRect data:nil];
        mygroupView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        mygroupView.delegate = self;
        MyStockGroupBackView* backView = [[MyStockGroupBackView alloc] initWithFrame:self.superview.bounds];
        backView.delegate = self;
        backView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [backView addSubview:mygroupView];
        [self.superview addSubview:backView];
        [backView release];
    }
    else {
        mygroupView.frame = suggestRect;
        self.mygroupView.superview.hidden = NO;
    }
    if (sender==coinComboBtn1) {
        [mygroupView setData:self.firstTypeArray];
        mygroupView.userInfo = self.firstTypeArray;
    }
    else {
        [mygroupView setData:self.secondTypeArray];
        mygroupView.userInfo = self.secondTypeArray;
    }
    
}

- (void)myStockGroupView:(MyStockGroupView*)groupView didSelectGroup:(NSDictionary*)dict
{
    [self.mygroupView.superview removeFromSuperview];
    NSArray* userInfo = groupView.userInfo;
    NSInteger index = [userInfo indexOfObject:dict];
    if (userInfo==self.firstTypeArray) {
        firstIndex = index;
        NSString* name = [dict valueForKey:ForeignNameKey];
        self.coinCombo1.text = name;
    }
    else if(userInfo==self.secondTypeArray)
    {
        secondIndex = index;
        NSString* name = [dict valueForKey:ForeignNameKey];
        self.coinCombo2.text = name;
    }
    self.input2.text = @"";
    
}


#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField==input1) {
        input2.text = @"";
        if (!justNetwork) {
            self.tipLabel.text = @"";
        }
    }
    else if(textField==input2)
    {
        input1.text = @"";
    }
    if ([delegate respondsToSelector:@selector(calculatorBecomeFirstResponse:)]) {
        [delegate calculatorBecomeFirstResponse:self];
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self resultClicked:nil];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    self.input2.text  = @"";
    if (textField.text.length>14) {
        return NO;
    }
    else {
        return YES;
    }
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    self.input2.text = @"";
    return YES;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(IBAction)backClicked:(id)sender
{
    [self finish];
}

-(void)coinCombo1Clicked:(id)sender
{
    [self initMyGroupView:sender];
}

-(void)coinCombo2Clicked:(id)sender
{
    [self initMyGroupView:sender];
}

-(void)resultClicked:(id)sender
{
    [self finish];
    NSString* input1Text = input1.text;
    NSString* input2Text = input2.text;
    NSString* resultString = nil;
    NSInteger modeIndex = 0;
    if (input1Text&&![input1Text isEqualToString:@""]) {
        resultString = input1Text;
        modeIndex = 0;
    }
    else if(input2Text&&![input2Text isEqualToString:@""])
    {
        resultString = input2Text;
        modeIndex = 1;
    }
    
    if (resultString) {
        if ([MyTool isDigtal:resultString]) {
            NSNumber* inputNumber = [NSNumber numberWithFloat:[resultString floatValue]];
            NSMutableDictionary* infoDict = [[NSMutableDictionary alloc] initWithCapacity:0];
            [infoDict setValue:ForeignRequstType_Basic forKey:ForeignRequstTypeKey];
            [infoDict setValue:inputNumber forKey:ForeignInputNumber];
            [infoDict setValue:resultString forKey:ForeignInputString];
            NSDictionary* firstDict = [self.firstTypeArray objectAtIndex:firstIndex];
            NSString* type1 = [firstDict valueForKey:ForeignTypeKey];
            [infoDict setValue:type1 forKey:ForeignFirstType];
            NSDictionary* secondDict = [self.secondTypeArray objectAtIndex:secondIndex];
            NSString* type2 = [secondDict valueForKey:ForeignTypeKey];
            [infoDict setValue:type2 forKey:ForeignSecondType];
            [self startRequestWithInfo:infoDict];
            [infoDict release];
        }
        else {
            UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"" message:@"输入的内容无效!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil] autorelease];
            [alert show];
        }
    }
}

-(void)startRequestWithInfo:(NSDictionary*)info
{
    NSString* hostString = nil;
    NSString* type = [info valueForKey:ForeignRequstTypeKey];
    if ([type isEqualToString:ForeignRequstType_Other]) {
        NSString* noDataKeys = @"MYRCNY,NZDJPY";
        hostString = @"http://stock.finance.sina.com.cn/iphone/api/json.php/HqService.getHqList";
        hostString = [hostString stringByAppendingFormat:@"?type=%@&symbol=%@",type,noDataKeys];
    }
    else {
        hostString = @"http://stock2.finance.sina.com.cn/iphone/api/json.php/HqService.getList";
        hostString = [hostString stringByAppendingFormat:@"?type=%@",type];
    }
    
    NSURL* url = [NSURL URLWithString:hostString];
    
    if (curRequest) {
        [curRequest clearDelegatesAndCancel];
        self.curRequest = nil;
    }
    curRequest = [[ASIHTTPRequest alloc] initWithURL:url];
    curRequest.delegate = self;
    curRequest.userInfo = info;
    
    [curRequest startAsynchronous];
}

-(void)requestFinished:(ASIHTTPRequest*)request
{
    NSString* resultString = [[NSString alloc] initWithData:request.responseData encoding:NSUTF8StringEncoding];
    if (!resultString) {
        resultString = [request.responseString retain];
    }
    NSString* newString = [MyTool formatlizeJSonStringWith:resultString];
    NSDictionary* jsonDict = [newString objectFromJSONString];
    if (jsonDict&&[jsonDict isKindOfClass:[NSDictionary class]]) {
        NSNumber* codeNumber = [jsonDict objectForKey:@"code"];
        if ([codeNumber isKindOfClass:[NSString class]]) {
            codeNumber = [NSNumber numberWithInt:[(NSString*)codeNumber intValue]];
        }
        if (([codeNumber isKindOfClass:[NSNumber class]]&&[codeNumber intValue]==0)||[codeNumber isKindOfClass:[NSNull class]]) 
        {
            NSArray* dataArray = [jsonDict valueForKey:@"data"];
            NSMutableDictionary* userInfo = (NSMutableDictionary*)request.userInfo;
            NSString* request_type = [userInfo valueForKey:ForeignRequstTypeKey];
            if (request_type&&[request_type isEqualToString:ForeignRequstType_Basic]) {
                if (!coreData) {
                    coreData = [[NSMutableArray alloc] initWithCapacity:0];
                }
                else {
                    [coreData removeAllObjects];
                }
            }
            [coreData addObjectsFromArray:dataArray];
            if (request_type&&[request_type isEqualToString:ForeignRequstType_Basic])
            {
                [userInfo setValue:ForeignRequstType_Cross forKey:ForeignRequstTypeKey];
                [self startRequestWithInfo:userInfo];
            }
            else {
                NSDate* curDate = [NSDate date];
                NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
                formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
                self.coreDataTime = [formatter stringFromDate:curDate];
                if (!justNetwork) {
                    [MyTool writeToDocument:coreData folder:@"calculator" fileName:@"coredata"];
                    [MyTool writeToDocument:coreDataTime folder:@"calculator" fileName:@"coredatatime"];
                }
                [self startCalculatorWithDict:userInfo];
                if (justNetwork) {
                    self.tipLabel.text = @"基于即时价格";
                }
                else {
                    NSString* tipString = [NSString stringWithFormat:@"%@的汇率",self.coreDataTime];
                    self.tipLabel.text = tipString;
                }
            }
        }
        else
        {
            [self requestFailed:request];
        }
    }
    else
    {
        [self requestFailed:request];
    }
    [resultString release];
}

-(void)requestFailed:(ASIHTTPRequest*)request
{
    if (justNetwork) {
        NSString* result = @"网络错误";
        self.input2.text = result;
    }
    else {
        if (!self.coreData) {
            NSArray* documentPathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString* bandlePath = [[NSBundle mainBundle] bundlePath];
            NSString* documentPath = [documentPathArray objectAtIndex:0];
            NSString* calculator = [documentPath stringByAppendingPathComponent:@"calculator"];
            NSString* calculatorTime = [calculator stringByAppendingPathComponent:@"coredatatime"];
            NSString* calculatorData = [calculator stringByAppendingPathComponent:@"coredata"];
            while (![[NSFileManager defaultManager] fileExistsAtPath:calculatorTime]||![[NSFileManager defaultManager] fileExistsAtPath:calculatorData]) {
                calculatorTime = [bandlePath stringByAppendingPathComponent:@"coredatatime"];
                calculatorData = [bandlePath stringByAppendingPathComponent:@"coredata"];
            }
            self.coreData = [NSArray arrayWithContentsOfFile:calculatorData];
            self.coreDataTime = [NSString stringWithContentsOfFile:calculatorTime encoding:NSUTF8StringEncoding error:nil];
        }
        NSDictionary* dict = request.userInfo;
        [self startCalculatorWithDict:dict];
        NSString* tipString = [NSString stringWithFormat:@"%@的汇率",self.coreDataTime];
        self.tipLabel.text = tipString;
    }
}

-(void)startCalculatorWithDict:(NSDictionary*)dict
{
    NSString* result = @"无数据";
    NSNumber* inputNumber = [dict valueForKey:ForeignInputNumber];
    NSString* inputString = [dict valueForKey:ForeignInputString];
    NSString* firstType = [dict valueForKey:ForeignFirstType];
    NSString* secondType = [dict valueForKey:ForeignSecondType];
    
    NSString* nowInputString = self.input1.text;
    NSDictionary* firstDict = [self.firstTypeArray objectAtIndex:firstIndex];
    NSString* type1 = [firstDict valueForKey:ForeignTypeKey];
    NSDictionary* secondDict = [self.secondTypeArray objectAtIndex:secondIndex];
    NSString* type2 = [secondDict valueForKey:ForeignTypeKey];
    if (nowInputString&&type1&&type2&&[nowInputString isEqualToString:inputString]&&[type1 isEqualToString:firstType]&&[type2 isEqualToString:secondType]) {
        if (![firstType isEqualToString:secondType]) {
            NSDictionary* callDict = nil;
            for (NSDictionary* oneDict in self.configArray) {
                NSString* tableType = [oneDict valueForKey:ForeignCalculator_type];
                if ([tableType isEqualToString:Value_ForeignCalculator_calltable]) {
                    callDict = oneDict;
                    break;
                }
            }
            NSArray* callDataArray = [callDict valueForKey:ForeignCalculator_data];
            NSArray* callOrderArray = nil;
            BOOL bReverseCall = NO;
            for (NSDictionary* oneDict in callDataArray) {
                NSString* oneFirstType = [oneDict valueForKey:ForeignCalculator_firsttype];
                NSString* oneSecondType = [oneDict valueForKey:ForeignCalculator_secondtype];
                NSArray* oneCallOrderArray = [oneDict valueForKey:ForeignCalculator_callorder];
                if ([oneFirstType isEqualToString:firstType]&&[oneSecondType isEqualToString:secondType]) {
                    callOrderArray = oneCallOrderArray;
                    break;
                }
                else if([oneFirstType isEqualToString:secondType]&&[oneSecondType isEqualToString:firstType])
                {
                    bReverseCall = YES;
                    callOrderArray = oneCallOrderArray;
                    break;
                }
            }
            
            if (!callOrderArray) {
                NSMutableArray* newOrderArray = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
                [newOrderArray addObject:firstType];
                [newOrderArray addObject:secondType];
                callOrderArray = newOrderArray;
            }
            
            BOOL hasError = NO;
            float rate = 1.0;
            if (callOrderArray&&[callOrderArray count]>1) {
                NSDictionary* dataTableDict = nil;
                for (NSDictionary* oneDict in self.configArray) {
                    NSString* tableType = [oneDict valueForKey:ForeignCalculator_type];
                    if ([tableType isEqualToString:Value_ForeignCalculator_datatable]) {
                        dataTableDict = oneDict;
                        break;
                    }
                }
                NSArray* realDataArray = [dataTableDict valueForKey:ForeignCalculator_data]; 
                NSArray* realCodesArray = [dataTableDict valueForKey:ForeignCalculator_codes];
                NSString* symbolKey = [dataTableDict valueForKey:ForeignCalculator_symbolkey];
                NSString* priceKey = [dataTableDict valueForKey:ForeignCalculator_pricekey];
                int pairIndex = 1;
                while([callOrderArray count]>pairIndex&&!hasError) 
                {
                    NSString* call_first = [callOrderArray objectAtIndex:pairIndex-1];
                    NSString* call_second = [callOrderArray objectAtIndex:pairIndex];
                    pairIndex++;
                    NSString* exchangeCode = nil;
                    BOOL thisStageReverse = NO;
                    for (NSDictionary* oneRealData in realDataArray) {
                        NSString* onefirsttype = [oneRealData valueForKey:ForeignCalculator_firsttype];
                        NSString* onesecondtype = [oneRealData valueForKey:ForeignCalculator_secondtype];
                        NSString* oneexchangecode = [oneRealData valueForKey:ForeignCalculator_exchangecode];
                        if ([onefirsttype isEqualToString:call_first]&&[onesecondtype isEqualToString:call_second]) {
                            exchangeCode = oneexchangecode;
                            break;
                        }
                        else if([onefirsttype isEqualToString:call_second]&&[onesecondtype isEqualToString:call_first])
                        {
                            thisStageReverse = YES;
                            exchangeCode = oneexchangecode;
                            break;
                        }
                    }
                    if (exchangeCode) {
                        NSString* price = nil;
                        for (NSDictionary* oneCoreData in coreData) {
                            NSString* oneSymbol = [oneCoreData valueForKey:symbolKey];
                            if (oneSymbol&&[[oneSymbol lowercaseString] isEqualToString:[exchangeCode lowercaseString]]) {
                                NSString* onePrice = [oneCoreData valueForKey:priceKey];
                                price = onePrice;
                                break;
                            }
                        }
                        if (price&&[MyTool isDigtal:price]) {
                            if (thisStageReverse) {
                                rate = rate/[price floatValue];
                            }
                            else {
                                rate = rate*[price floatValue];
                            }
                        }
                        else {
                            hasError = YES;
                            break;
                        }
                    }
                    else {
                        int retryCount = 2;
                        BOOL findResult = NO;
                        for (int i=0; i<retryCount; i++) {
                            NSString* firstCode = nil;
                            NSString* secondCode = nil;
                            for (NSDictionary* oneDict in realCodesArray) {
                                NSString* oneMoneyType = [oneDict valueForKey:ForeignCalculator_moneytype];
                                NSString* oneMoneyCode = [oneDict valueForKey:ForeignCalculator_moneycode];
                                if ([[oneMoneyType lowercaseString] isEqualToString:[call_first lowercaseString]]) {
                                    firstCode = oneMoneyCode;
                                }
                                else if ([[oneMoneyType lowercaseString] isEqualToString:[call_second lowercaseString]])
                                {
                                    secondCode = oneMoneyCode;
                                }
                                if (firstCode&&secondCode) {
                                    break;
                                }
                            }
                            if (firstCode&&secondCode) {
                                if (i==0) {
                                    exchangeCode = [NSString stringWithFormat:@"%@%@",firstCode,secondCode];
                                }
                                else {
                                    thisStageReverse = YES;
                                    exchangeCode = [NSString stringWithFormat:@"%@%@",secondCode,firstCode];
                                }
                            }
                            if (exchangeCode) {
                                NSString* price = nil;
                                for (NSDictionary* oneCoreData in coreData) {
                                    NSString* oneSymbol = [oneCoreData valueForKey:symbolKey];
                                    if (oneSymbol&&[[oneSymbol lowercaseString] isEqualToString:[exchangeCode lowercaseString]]) {
                                        findResult = YES;
                                        NSString* onePrice = [oneCoreData valueForKey:priceKey];
                                        price = onePrice;
                                        break;
                                    }
                                }
                                if (findResult) {
                                    if (price&&[MyTool isDigtal:price]) {
                                        if (thisStageReverse) {
                                            rate = rate/[price floatValue];
                                        }
                                        else {
                                            rate = rate*[price floatValue];
                                        } 
                                    }
                                    else {
                                        hasError = YES;
                                    }
                                    break;
                                }
                            }
                        }
                        if (!findResult) {
                            hasError = YES;
                            break;
                        }
                    }
                    
                    if (!exchangeCode) {
                        hasError = YES;
                        break;
                    }
                }
            }
            else {
                hasError = YES;
            }
            if (!hasError) {
                float inputfloat = [inputNumber floatValue];
                float resultfloat = 0.0;
                if (!bReverseCall) {
                    resultfloat = inputfloat*rate;
                }
                else {
                    resultfloat = inputfloat/rate;
                }
                self.input2.text = [NSString stringWithFormat:@"%.1f",resultfloat];
            }
            else {
                self.input2.text = result;
            }
        }
        else {
            self.input2.text = inputString;
        }
    }
}

@end
