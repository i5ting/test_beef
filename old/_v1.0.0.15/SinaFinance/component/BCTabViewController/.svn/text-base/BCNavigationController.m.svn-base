//
//  BCNavigationController.m
//  SinaNews
//
//  Created by shieh exbice on 11-11-4.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "BCNavigationController.h"
#import "BCViewController.h"
#import "ShareData.h"

#define NavBackViewtag 1998767
#define NavBackViewtag_ImageView 1998768
/*
@interface MyNavigationBar : UINavigationBar
@end
@implementation MyNavigationBar
- (void)drawRect:(CGRect)rect 
{
    [super drawRect:rect];
}
@end

@implementation UINavigationBar (UINavigationBarCategory)

+ (Class)class 
{  
    return NSClassFromString(@"MyNavigationBar");
}

-(void)setBackgroundImage:(UIImage *)backgroundImage
{
    UIImageView* imageView = [[UIImageView alloc] initWithImage:backgroundImage]; 
    imageView.hidden = YES;
    imageView.frame = CGRectZero;
    imageView.tag = NavBackViewtag;
    [self addSubview:imageView];
    [imageView release];
}

-(UIImage*)backgroundImage
{
    UIImageView* backgroundView = (UIImageView*)[self viewWithTag:NavBackViewtag];
    return backgroundView.image;
}


- (void)drawRect:(CGRect)rect
{
    UIImage *image = [self backgroundImage];
    [image drawInRect:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
}

@end
*/

@implementation BCNavigationController

@synthesize tabBarImage,tabBarHighlyImage,tabBarTitle,tabBarTitleColor,tabBarTitleHighlyColor;

- (id)initWithRootViewController:(UIViewController *)rootViewController
{
    
    self = [super initWithRootViewController:rootViewController];
    if ([rootViewController isKindOfClass:[BCViewController class]]) {
        [self setNavigationBarHidden:YES];
    }
    
    return self;
}

-(void)dealloc
{
    [tabBarImage release];
    [tabBarHighlyImage release];
    [tabBarTitle release];
    [tabBarTitleColor release];
    [tabBarTitleHighlyColor release];
    
    [super dealloc];
}

-(void)didBeforeShowSubViewController:(UIViewController*)viewController
{
    UIViewController* topController = self.topViewController;
    if (topController&&topController!=viewController) {
        if ([viewController isKindOfClass:[BCViewController class]]) {
            BCViewController* bcViewController = (BCViewController*)viewController;
            if (bcViewController.showBackBtn) {
                UIButton* backBtn = bcViewController.backButton;
                CGRect backBtnFrame = backBtn.frame;
                UIView* controllerView = bcViewController.view;
                CGRect navBarFrame = bcViewController.navigationBar.frame;
                backBtnFrame.origin.y = navBarFrame.origin.y + (navBarFrame.size.height/2 - backBtnFrame.size.height/2);
                backBtnFrame.origin.x = 10;
                backBtn.frame = backBtnFrame;
                [backBtn addTarget:bcViewController action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
                [bcViewController.navigationBar addSubview:backBtn];
            }
        }
    }
}

- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated
{
    NSArray* array = [super popToRootViewControllerAnimated:animated];
    for (UIViewController* controller in array) {
        [controller viewWillDisappear:animated];
        [controller viewDidDisappear:animated];
    }
    return array;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [self didBeforeShowSubViewController:viewController];
    [super pushViewController:viewController animated:animated];
}

- (void)presentModalViewController:(UIViewController *)modalViewController animated:(BOOL)animated
{
    [self didBeforeShowSubViewController:modalViewController];
    [super presentModalViewController:modalViewController animated:animated];
}

/**
 * only ios6
 */
-(NSUInteger)supportedInterfaceOrientations
{
    NSLog(@"NAV kLineHided = %d",[ShareData sharedManager].kLineHided );
    return UIInterfaceOrientationMaskPortrait;
    //return [self.topViewController supportedInterfaceOrientations];
}

/**
 * only ios6
 */
-(BOOL)shouldAutorotate
{
    return YES;
}

@end
