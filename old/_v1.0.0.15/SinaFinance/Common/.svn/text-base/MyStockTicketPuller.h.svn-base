//
//  MyStockTicketPuller.h
//  SinaFinance
//
//  Created by Du Dan on 11/30/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MyStockTicketPullerDelegate;

@interface MyStockTicketPuller : NSObject
{
    NSString *myStockTicket;
    id<MyStockTicketPullerDelegate> delegate;
    id myDelegate;
}

@property (nonatomic, retain) NSString *myStockTicket;
@property (nonatomic, retain) id<MyStockTicketPullerDelegate> delegate;

- (id)initWithDelegate:(id)delegate;
- (void)requestMyStockTicket;

@end

@protocol MyStockTicketPullerDelegate <NSObject>

- (void)requestTicketFinished;
- (void)requestTicketFailed;

@end
