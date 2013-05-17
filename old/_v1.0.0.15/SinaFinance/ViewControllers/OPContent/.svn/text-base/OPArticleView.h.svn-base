//
//  OPArticleView.h
//  SinaNews
//
//  Created by fabo on 12-10-17.
//
//

#import <UIKit/UIKit.h>
#import "OPContentSetting.h"

@interface OPImageModel : NSObject {
@private
    NSString *fullPath;
    CGFloat heightValue;
    CGFloat widthValue;
    NSString *title;
}
@property (nonatomic, retain) NSString *fullPath;
@property(nonatomic,assign)CGFloat heightValue;
@property(nonatomic,assign)CGFloat widthValue;
@property (nonatomic, retain) NSString *title;
@end

@interface OPVideoModel : NSObject {
@private
    OPImageModel* thumb;
    NSString *vid;
}
@property (nonatomic, retain) OPImageModel* thumb;
@property (nonatomic, retain) NSString *vid;

@end

@interface OPSingleNewsModel : NSObject {
@private
    NSMutableArray* imagesSet;
    NSString* content;
    NSString* title;
    NSString* declare;
    NSDate *createTime;
    NSString *media;
    NSString *url;
    NSString *clickurl;
    NSArray* commentSet;
    NSArray* relativeNewsArray;
    OPVideoModel* video;
    id extraData;
    id titleSymbolData;
}
@property(nonatomic,retain)NSMutableArray* imagesSet;
@property(nonatomic,retain)NSArray* relativeNewsArray;
@property(nonatomic,retain)NSString* content;
@property(nonatomic,retain)NSString* title;
@property(nonatomic,retain)NSString* declare;
@property(nonatomic,retain)NSDate *createTime;
@property(nonatomic,retain)NSString *media;
@property(nonatomic,retain)OPVideoModel* video;
@property (nonatomic, retain) NSString *url;
@property(nonatomic,retain)NSString *clickurl;
@property(nonatomic,retain)NSArray* commentSet;
@property(nonatomic,retain)id extraData;
@property(nonatomic,retain)id titleSymbolData;
@property(nonatomic,retain)NSString* bottomDeclare;
@end


@interface OPArticleView : UIView
@property(nonatomic,retain)UIScrollView* contentScrollView;


@property(nonatomic,retain)OPSingleNewsModel* myModel;
@property (nonatomic, retain) OPContentSetting* mySetting;
@property (nonatomic, assign) id delegate;
@property (nonatomic, assign) BOOL nightMode;
@property(nonatomic,assign)BOOL nonImageMode;
@property (nonatomic, assign) BOOL bDateBeforeSource;

- (id) initWithFrame:(CGRect)frame
			   model:(OPSingleNewsModel*)newModel
			 setting:(OPContentSetting*)newSetting;
- (void)layoutArticle;
- (void)reLoadComment;
- (void)setContentFont:(BOOL)isLargeFont;
@end


@protocol OPArticleView_Delegate <NSObject>
@optional
-(void)view:(OPArticleView*)aView imageClicked:(NSString*)imageURL;
-(void)view:(OPArticleView*)aView clickedMode:(NSInteger)mode;
-(void)view:(OPArticleView*)aView urlClicked:(NSString*)url;
-(void)view:(OPArticleView*)aView allCommentClicked:(UIButton*)sender;
-(void)view:(OPArticleView*)aView relativeURLClicked:(NSString*)url;
-(UIView*)view:(OPArticleView*)aView extraViewWithData:(id)data margin:(NSInteger)margin width:(NSInteger)width fontSize:(NSInteger)fontSize;
-(UIView*)view:(OPArticleView*)aView titleSymbolWithData:(id)data margin:(NSInteger)margin width:(NSInteger)width fontSize:(NSInteger)fontSize;
@end
