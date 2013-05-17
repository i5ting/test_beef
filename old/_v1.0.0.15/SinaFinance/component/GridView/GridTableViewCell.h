//
//  GridTableViewCell.h
//  GridView
//
//  Created by Du Dan on 7/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#define CELL_LABEL_BEGIN_TAG 1000
#define cellHeight 44

@class GridViewController;

@interface GridTableViewCell : UITableViewCell {
    UIColor *lineColor;
    BOOL topCell;
    
    NSInteger rowsNumber;
    NSInteger colsNumber;
        
    NSArray *widthArray;
}

@property (nonatomic, retain) UIColor *lineColor;
@property (nonatomic) BOOL topCell;
@property (nonatomic) NSInteger rowsNumber;
@property (nonatomic) NSInteger colsNumber;
@property (nonatomic, retain) NSArray *widthArray;

- (id)initWithStyle:(UITableViewCellStyle)style 
    reuseIdentifier:(NSString *)reuseIdentifier
               rows:(NSInteger)rows
            columns:(NSInteger)columns
             parent:(GridViewController*)parent;

@end
