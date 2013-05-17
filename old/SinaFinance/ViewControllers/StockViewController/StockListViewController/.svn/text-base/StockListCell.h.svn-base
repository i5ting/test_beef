//
//  StockListCell.h
//  SinaFinance
//
//  Created by shieh exbice on 12-4-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

enum StockListCellType
{
    StockListCell_SingleName,
    StockListCell_MultiName
};

@interface StockListCell : UITableViewCell
{
    NSArray* columnWidths;
    BOOL hasSeperatorLine;
    BOOL bRealtime;
    BOOL bDelaytime;
    NSInteger cellType;
}
@property(nonatomic,assign)BOOL bDelaytime;
@property(nonatomic,assign)BOOL bRealtime;
@property(nonatomic,assign)BOOL hasSeperatorLine;
@property(nonatomic,retain)NSArray* columnWidths;
@property(nonatomic,assign)NSInteger leftMargin;

- (id)initWithCellType:(NSInteger)type reuseIdentifier:(NSString *)reuseIdentifier;
-(UILabel*)labelWithIndex:(NSInteger)index;
-(NSArray*)allLabels;
@end
