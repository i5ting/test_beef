//
//  MoreViewController.m
//  SinaFinance
//
//  Created by Du Dan on 12/8/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "MoreViewController.h"
#import "MyCustomToolbar.h"
#import "ShareData.h"

@implementation MoreViewController

static NSString *ctrlNames[] = {@"提醒",@"设置",nil};
static NSString *ctrlIcons[] = {@"reminder_icon.png",@"settings_icon.png",nil};

- (id)initWithControllers:(NSArray*)ctrls
{
    self = [super init];
    if (self) {
        self.title = @"更多";
        self.tabBarItem.image = [UIImage imageNamed:@"reminder_icon.png"];
        controllers = [[NSArray alloc] initWithArray:ctrls];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)dealloc
{
    [controllers release];
    [super dealloc];
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor colorWithRed:3.0/255 green:30.0/255 blue:54.0/255 alpha:1.0];
    
    MyCustomToolbar *topToolBar = [[[MyCustomToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)] autorelease];
    topToolBar.tintColor =[UIColor blackColor];
    [self.view addSubview:topToolBar];
    
    UILabel *titleLabel = [[[UILabel alloc] init] autorelease];
    titleLabel.frame = CGRectMake(110, 0, 100, 44);
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont fontWithName:APP_FONT_NAME size:20];
    titleLabel.text = @"更多";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = UITextAlignmentCenter;
    [topToolBar addSubview:titleLabel];
    
    UIImageView *logo = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sina_logo.png"]] autorelease];
    logo.frame = CGRectMake(15, 8, 38, 27);
    logo.contentMode = UIViewContentModeScaleToFill;
    [topToolBar addSubview:logo];
    
    UITableView *tableView = [[[UITableView alloc] init] autorelease];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.frame = CGRectMake(0, 44, 320, 360);
    tableView.rowHeight = 50;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark
#pragma mark UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return controllers.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        
        UIImageView *icon = [[[UIImageView alloc] init] autorelease];
        icon.frame = CGRectMake(5, 10, 30, 30);
        icon.tag = 1000;
        [cell addSubview:icon];
        
        UILabel *text = [[[UILabel alloc] init] autorelease];
        text.frame = CGRectMake(50, 0, 270, 50);
        text.backgroundColor = [UIColor clearColor];
        text.textColor = [UIColor whiteColor];
        text.tag = 1001;
        [cell addSubview:text];
        
        UIImageView *line = [[[UIImageView alloc] init] autorelease];
        line.image = [UIImage imageNamed:@"news_line.png"];
        line.frame = CGRectMake(0, 49, 320, 1);
        [cell addSubview:line];
    }
    
    UIImageView *icon = (UIImageView*)[cell viewWithTag:1000];
    icon.image = [UIImage imageNamed:ctrlIcons[indexPath.row]];
    UILabel *text = (UILabel*)[cell viewWithTag:1001];
    text.text = ctrlNames[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.navigationController pushViewController:[controllers objectAtIndex:indexPath.row] animated:YES];
}


@end
