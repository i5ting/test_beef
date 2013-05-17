//
//  IndexTableViewCell.h
//  SinaFinance
//
//  Created by sang on 10/28/12.
//
//

#import <UIKit/UIKit.h>

@interface IndexTableViewCell : UITableViewCell

{
    UIImageView *background;
    UILabel *titleLabel;
    UILabel *detailLabel;
    UILabel *sourceLabel;
    UIImageView *readIcon;
    UIImageView *line;
}

@property (nonatomic, retain) UIImageView *readIcon;
@property (nonatomic, retain) UIImageView *background;
@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UILabel *detailLabel;
@property (nonatomic, retain) UILabel *sourceLabel;
@property (nonatomic, retain) UIImageView *line;
@property (nonatomic, assign) NSInteger leftrightMargin;

@end
