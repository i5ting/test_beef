//
//  MyStockTicketPuller.m
//  SinaFinance
//
//  Created by Du Dan on 11/30/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "MyStockTicketPuller.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "ShareData.h"
#import "NSDictionary_JSONExtensions.h"
#import "Util.h"

#define MYSTOCK_LOGIN_URL @"https://login.sina.com.cn/sso/login.php"


@implementation MyStockTicketPuller

@synthesize myStockTicket;
@synthesize delegate;

- (id)initWithDelegate:(id)dl
{
    if((self = [super init])){
        myDelegate = [dl retain];
        
    }
    return self;
}

- (void)requestMyStockTicket
{
    ASIFormDataRequest *request = [[[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:MYSTOCK_LOGIN_URL]] autorelease];
    [request setPostValue:@"finance_client" forKey:@"entry"];
    [request setPostValue:[ShareData sharedManager].myStockUserName forKey:@"username"];
    [request setPostValue:[ShareData sharedManager].myStockPassword forKey:@"password"];
    [request setPostValue:@"finance" forKey:@"service"];
    [request setPostValue:@"TEXT" forKey:@"returntype"];
    request.requestMethod = @"POST";
    request.delegate = self;
    [request startAsynchronous];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSData *data = request.responseData;
    NSError *error = nil;
    NSDictionary *resultJSON = [NSDictionary dictionaryWithJSONData:data error:&error];
    NSLog(@"my stock ticket return: %@", resultJSON);
    if(error == nil){
        NSString *ticket = [resultJSON objectForKey:@"ticket"];
        if(ticket == nil){
            NSString *msg = [Util decodeUTF8String:[resultJSON objectForKey:@"msg"]];
//            UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil] autorelease];
//            [alert show];
            [delegate requestTicketFailed];
            return;
        }
        else{
            myStockTicket = ticket;
            [delegate requestTicketFinished];
        }
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request{
    [delegate requestTicketFailed];
}

            
- (void)dealloc
{
    [myStockTicket release];
    [myDelegate release];
    [delegate release];
    [super dealloc];
}

@end
