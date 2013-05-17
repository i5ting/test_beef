//
//  UrlParserView.m
//  SinaNews
//
//  Created by shieh exbice on 12-1-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UrlParserController.h"
#import "RegexKitLite.h"

@interface UrlParserController()
+(NSArray*)searchNetworkString:(NSString*)str;
@end

@implementation UrlParserController
@synthesize table;
@synthesize delegate,parseString,parsedRangeArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)loadView
{
    [super loadView];
    CGRect mainBounds = [[UIScreen mainScreen] bounds];
    UIView* mainView = [[UIView alloc] initWithFrame:mainBounds];
    mainView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    self.view = mainView;
    [mainView release];
    mainView.backgroundColor = [UIColor clearColor];
    UIButton* backBtn = [[UIButton alloc] initWithFrame:mainBounds];
    [backBtn addTarget:self action:@selector(backClicked:) forControlEvents:UIControlEventTouchUpInside];
    backBtn.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.6];
    backBtn.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    [mainView addSubview:backBtn];
    [backBtn release];
    
    UITableView* tempTable = [[UITableView alloc] initWithFrame:CGRectMake(40, 80, 240, 320) style:UITableViewStyleGrouped];
    tempTable.scrollEnabled = NO;
    backBtn.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    tempTable.backgroundColor = [UIColor clearColor];
    tempTable.delegate = self;
    tempTable.dataSource = self;
    self.table = tempTable;
    [mainView addSubview:tempTable];
    [tempTable release];
    
}

-(void)dealloc
{
    [mTable release];
    [parsedRangeArray release];
    [parseString release];
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

-(void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)setURLString:(NSString*)urlString
{
    self.parseString = urlString;
    NSArray* searchArray = [UrlParserController searchNetworkString:urlString];
    self.parsedRangeArray = searchArray;
}

-(void)adjustTableRect
{
    int rangeCount = [self.parsedRangeArray count];
    CGRect tableRect = CGRectMake(40, 220, 240, 20);
    tableRect.size.height = tableRect.size.height + rangeCount* 44;
    tableRect.origin.y = self.view.bounds.size.height/2 - tableRect.size.height/2;
    self.table.frame = tableRect;
}

-(BOOL)show
{
    BOOL rtval = NO;
    if (self.parsedRangeArray&&[self.parsedRangeArray count]>0) {
        [[UIApplication sharedApplication].keyWindow addSubview:self.view];
        self.view.alpha = 1.0;
        rtval = YES;
        [self adjustTableRect];
        [self.table reloadData];
    }
    return rtval;
}
+(NSArray*)componetBySearchNetworkString:(NSString*)str
{
    NSMutableArray* rtval = nil;
    NSArray* componet = [self searchNetworkString:str];
    for (NSValue* rangeValue in componet) {
        NSString* subString = [str substringWithRange:[rangeValue rangeValue]];
        if (!rtval) {
            rtval = [NSMutableArray arrayWithCapacity:0];
        }
        [rtval addObject:subString];
    }
    return rtval;
}

+(NSArray*)searchNetworkString:(NSString*)str
{
    NSMutableArray* rtval = nil;
    if(str!=nil&&[str length]>0)
    {
        NSString* aSystemVersion = [[UIDevice currentDevice] systemVersion];
        if ([aSystemVersion floatValue]>=3.0) {
            //NSString *regex = @"([/w-]+/.)+[/w-]+.([^a-z])(/[/w- ./?%&=]*)?|[a-zA-Z0-9/-/.][/w-]+.([^a-z])(/[/w- ./?%&=]*)?";   
            //NSString* regex = @"([/w-]+/.)+[/w-]+.([^a-z])(/[/w-: ./?%&=]*)?|[a-zA-Z0-9/-/.][/w-]+.([^a-z])(/[/w-: ./?%&=]*)?";
            NSString* regex = @"(www\\.[!-~]+)|(https?://[!-~]+)";
            //NSString* regex = @"\\b(?:(?:(?:https?|ftp|file)://|www\\.|ftp\\.)[-A-Z0-9+&@#/%?=~_|$!:,.;]*[-A-Z0-9+&@#/%=~_|$]|((?:mailto:)?[A-Z0-9._%+-]+@[A-Z0-9._%-]+\\.[A-Z]{2,4})\\b)|\"(?:(?:https?|ftp|file)://|www\\.|ftp\\.)[^\"\\r\\n]+\"?|\'(?:(?:https?|ftp|file)://|www\\.|ftp\\.)[^\'\\r\\n]+\'?";
            NSRange matchedRange = NSMakeRange(NSNotFound, 0UL);  
            NSRange searchRange = NSMakeRange(0, [str length]);
            NSError  *error        = NULL;  
            while (searchRange.length>0) {
                matchedRange = [str rangeOfRegex:regex options:RKLCaseless inRange:searchRange capture:2L error:&error];  
                //NSString* aaa = [str stringByMatching:regex];
                if(matchedRange.location!=NSNotFound)
                {
                    NSValue* matchedRangeValue = [NSValue valueWithRange:matchedRange];
                    if (rtval==nil) {
                        rtval = [NSMutableArray arrayWithCapacity:0];
                    }
                    [rtval addObject:matchedRangeValue];
                    searchRange.location = matchedRange.length + matchedRange.location;
                    searchRange.length = [str length] - searchRange.location;
                }
                else
                {
                    searchRange.location += matchedRange.length;
                    searchRange.length = 0;
                }
                
            }
        }
        else
        {
            NSError  *error        = NULL;  
            NSString* regex = @"\\b(?:(?:(?:https?|ftp|file)://|www\\.|ftp\\.)[-A-Z0-9+&@#/%?=~_|$!:,.;]*[-A-Z0-9+&@#/%=~_|$]|((?:mailto:)?[A-Z0-9._%+-]+@[A-Z0-9._%-]+\\.[A-Z]{2,4})\\b)|\"(?:(?:https?|ftp|file)://|www\\.|ftp\\.)[^\"\\r\\n]+\"?|\'(?:(?:https?|ftp|file)://|www\\.|ftp\\.)[^\'\\r\\n]+\'?";
            //NSString* regex = @"\\b(?:(?:https?|ftp|file)://|www\\.|ftp\\.)[-A-Z0-9+&@#/%=~_|$?!:,.]*[A-Z0-9+&@#/%=~_|$]";
            NSRegularExpression* aExpression = [[NSRegularExpression alloc] initWithPattern:regex options:NSRegularExpressionCaseInsensitive error:&error];
            NSRange matchedRange = NSMakeRange(NSNotFound, 0UL);  
            NSRange searchRange = NSMakeRange(0, [str length]);
            matchedRange = [aExpression rangeOfFirstMatchInString:str options:NSMatchingReportProgress range:searchRange];
            if(matchedRange.location!=NSNotFound)
            {
                NSValue* matchedRangeValue = [NSValue valueWithRange:matchedRange];
                if (rtval==nil) {
                    rtval = [NSMutableArray arrayWithCapacity:0];
                }
                [rtval addObject:matchedRangeValue];
                searchRange.location = matchedRange.length + matchedRange.location;
                searchRange.length = [str length] - searchRange.location;
            }
            else
            {
                searchRange.location += matchedRange.length;
                searchRange.length = 0;
            }
        }
        
        
    }
    
    
    return rtval;
}

-(void)backClicked:(UIButton*)sender
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(viewHidened)];
    self.view.alpha = 0.0;
    [UIView commitAnimations];
}

-(void)viewHidened
{
    [self.view removeFromSuperview];
    self.parseString = nil;
    self.parsedRangeArray = nil;
    if ([delegate respondsToSelector:@selector(UrlParserHiden:)]) {
        [delegate UrlParserHiden:self];
    }
}

#pragma mark -
#pragma mark table

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==1) {
        return 44;
    }
    return 44;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.parsedRangeArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int rowNum = indexPath.row;
    NSMutableArray* dataArray = nil;
    
    
    NSString* userIdentifier = @"textIdentifier";
    UITableViewCell* cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:userIdentifier];
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:userIdentifier] autorelease];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    NSValue* rangeValue = [self.parsedRangeArray objectAtIndex:rowNum];
    cell.textLabel.text = [parseString substringWithRange:[rangeValue rangeValue]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath  
{
    int rowNum = indexPath.row;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSValue* rangeValue = [self.parsedRangeArray objectAtIndex:rowNum];
    NSString* urlString = [parseString substringWithRange:[rangeValue rangeValue]];
    [self viewHidened];
    if ([delegate respondsToSelector:@selector(UrlParser:urlString:)]) {
        [delegate UrlParser:self urlString:urlString];
    }
    
}


@end
