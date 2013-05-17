//
//  IntervalSelectionViewController.m
//  SinaFinance
//
//  Created by 鹏 孙 on 11-12-22.
//  Copyright (c) 2011年 新浪网. All rights reserved.
//

#import "IntervalSelectionViewController.h"
#import "MyCustomToolbar.h"
#import "ShareData.h"
#import "SaveData.h"

@implementation IntervalSelectionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
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
    
    MyCustomToolbar *topToolBar = [[[MyCustomToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)] autorelease];
    topToolBar.tintColor =[UIColor blackColor];
    [self.view addSubview:topToolBar];
    
    UILabel *titleLabel = [[[UILabel alloc] init] autorelease];
    titleLabel.frame = CGRectMake(60, 0, 200, 44);
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = @"刷新时间";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = UITextAlignmentCenter;
    titleLabel.font = [UIFont fontWithName:APP_FONT_NAME size:20];
    [topToolBar addSubview:titleLabel];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(5, 7, 50, 30);
    [backBtn setTitle:@" 返回" forState:UIControlStateNormal];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"return_btn.png"] forState:UIControlStateNormal];
    backBtn.titleLabel.font = [UIFont fontWithName:APP_FONT_NAME size:14];
    [backBtn addTarget:self action:@selector(handleBackPressed) forControlEvents:UIControlEventTouchUpInside];
    [topToolBar addSubview:backBtn];
    
    UITableView *tableView = [[[UITableView alloc] initWithFrame:CGRectMake(0, 44, 320, self.view.bounds.size.height-44) style:UITableViewStyleGrouped] autorelease];
    tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    tableView.delegate = self;
    tableView.dataSource = self;
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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    switch (indexPath.row) {
//        case 0:
//            cell.textLabel.text = @"10秒";
//            break;
        case 0:
            cell.textLabel.text = @"15秒";
            break;
        case 1:
            cell.textLabel.text = @"30秒";
            break;
        case 2:
            cell.textLabel.text = @"60秒";
            break;
        case 3:
            cell.textLabel.text = @"手动刷新";
            break;
        default:
            break;
    }
    
    NSInteger markIndex = 0;
    switch ([ShareData sharedManager].refreshInterval) {
        case 15:
            markIndex = 0;
            break;
        case 30:
            markIndex = 1;
            break;
        case 60:
            markIndex = 2;
            break;
        case 0:
            markIndex = 3;
            break;
        default:
            break;
    }
    
    if(indexPath.row == markIndex){
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
        
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
//        case 0:
//            [ShareData sharedManager].refreshInterval = 10;
//            break;
        case 0:
            [SaveData saveDataForKey:SETTINGS_INTERVAL_KEY data:[NSNumber numberWithInt:15]];
            [ShareData sharedManager].refreshInterval = 15;
            break;
        case 1:
            [SaveData saveDataForKey:SETTINGS_INTERVAL_KEY data:[NSNumber numberWithInt:30]];
            [ShareData sharedManager].refreshInterval = 30;
            break;
        case 2:
            [SaveData saveDataForKey:SETTINGS_INTERVAL_KEY data:[NSNumber numberWithInt:60]];
            [ShareData sharedManager].refreshInterval = 60;
            break;
        case 3:
            [SaveData saveDataForKey:SETTINGS_INTERVAL_KEY data:[NSNumber numberWithInt:0]];
            [ShareData sharedManager].refreshInterval = 0;
            break;
        default:
            break;
    }
    
//    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    NSArray *ips = [tableView indexPathsForVisibleRows];
    for(NSIndexPath *path in ips){
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:path];
        if(path.row == indexPath.row){
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else{
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
//    for(UITableViewCell *cell in tableView.subviews){
//        if(cell == selectedCell){
//            selectedCell.accessoryType = UITableViewCellAccessoryCheckmark;
//        }
//        else{
//            cell.accessoryType = UITableViewCellAccessoryNone;
//        }
//    }
}

- (void)handleBackPressed
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
