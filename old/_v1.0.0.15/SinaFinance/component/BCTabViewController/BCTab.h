
@interface BCTab : UIButton {
@private
	UIImageView* forceImageView;
    UIImageView* backgroundImageView;
    UIImageView* mainImageView;
    UILabel* nameLabel;
    BOOL mSelected;
}

@property(nonatomic,retain)UIImageView* forceImageView;
@property(nonatomic,retain)UIImageView* backgroundImageView;
@property(nonatomic,assign)BOOL hasbgEdageImageView;
@property(nonatomic,retain)UIImageView* mainImageView;
@property(nonatomic,retain)UILabel* nameLabel;
@property(nonatomic,assign)BOOL selected;


@property(nonatomic,retain)UIImageView*  hightbackgroundImageView;

- (void)setSelected:(BOOL)bSelected animated:(BOOL)animated;
- (CGSize)sizeThatFits:(CGSize)size;
-(NSString*)titleName;

@end
