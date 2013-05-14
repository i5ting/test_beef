//
//  TestPullViewControllerWithModeViewController.m
//  Gospel_IOS
//
//  Created by sang on 4/11/13.
//  Copyright (c) 2013 sang alfred. All rights reserved.
//

#import "TestPullViewControllerWithModeViewController.h"

@interface TestPullViewControllerWithModeViewController ()

@end

@implementation TestPullViewControllerWithModeViewController

-(id)init_with_frame:(CGRect)frame  mode:(PageListViewMode)mode{
    if (self = [super init_with_frame:frame mode:mode]) {
        self.delegate = self;
    }
    
//    self.GET();
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // [self set_pull_down_enable:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - PageListViewController delegate


-(int)set_page_count
{
    return 20;
}

-(void)init_table_data
{
//    [[BaiduApi2 sharedBaiduApi2] getPath:@"search" parameters:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%d",1] forKey:@"pageno"]  success:^(AFHTTPRequestOperation *operation, id JSON) {
//        
//        NSArray *f = [JSON objectFromJSONData];
//        [self init_table_data_callback:f];
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        
//    }];
}

-(void)init_table_data_callback:(NSMutableArray *)r
{
    [super init_table_data_callback:r];
//    [self sendUISignal:<#(NSString *)#>]
}

-(void)reload_next_page:(int)cur_page_number
{
    
    
//    [[BaiduApi2 sharedBaiduApi2] getPath:@"search" parameters:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%d",cur_page_number] forKey:@"pageno"]  success:^(AFHTTPRequestOperation *operation, id JSON) {
//        
//        NSMutableArray *f = [NSMutableArray arrayWithArray:[JSON objectFromJSONData]];
//        //        _result_arr = f;
//        if (cur_page_number==2) {
//            [f removeLastObject];
//            [f removeLastObject];
//        }
//        [self reload_next_page_callback:f];
//        
//        _reloading = NO;
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        
//    }];
}

-(void)reload_next_page_callback:(NSMutableArray *)r
{
    [super reload_next_page_callback:r];
}

#pragma mark - table
- (UITableViewCell *)page_list_view:(UITableView *)tableView cell_for_row_at_index_path:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
    }
    
    NSDictionary *d = [self.result_array objectAtIndex:indexPath.row];
    if ([[d objectForKey:@"news"] count]>0) {
        NSString *title = [[[d objectForKey:@"news"] objectAtIndex:0] objectForKey:@"title"];
        cell.textLabel.text = [NSString stringWithFormat:@"#%d %@", indexPath.row,title];
    }else{
        cell.textLabel.text = [NSString stringWithFormat:@"#%d  ", indexPath.row];
    }
    
    return cell;
}

- (UITableViewCell *)page_list_view_next_page:(UITableView *)tableView cell_for_row_at_index_path:(NSIndexPath *)indexPath  has_more_page:(Boolean)has_next;
{
    static NSString *CellIdentifier = @"Cell111";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
    }
    
    if (!has_next) {
        cell.textLabel.text = [NSString stringWithFormat:@"没有了", indexPath.row];
    }else{
        cell.textLabel.text = [NSString stringWithFormat:@"#%d  下一页", indexPath.row];
    }
    
    
    return cell;
}
-(void)page_list_view:(UITableView *)tableView did_select_row_at_index_path:(NSIndexPath *)indexPath
{
    NSLog(@"sss");
}


//- (void)page_list_view_next_page:(UITableView *)tableView did_select_row_at_index_path:(NSIndexPath *)indexPath  has_more_page:(Boolean)has_next;
//{
//    NSLog(@"sss");
//
//}


- (CGFloat)page_list_view:(UITableView *)tableView height_for_row_at_index_path:(NSIndexPath *)indexPath{
    return 55.0f;
}

//- (CGFloat)page_list_view_next_page:(UITableView *)tableView height_for_row_at_index_path:(NSIndexPath *)indexPath
//{
//    return 100.0f;
//}



@end