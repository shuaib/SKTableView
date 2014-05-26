//
//  HomeVC.m
//  SKTableView
//
//  Created by Shuaib on 27/05/2014.
//  Copyright (c) 2014 Bytehood. All rights reserved.
//

#import "HomeVC.h"

@interface HomeVC ()

@end

@implementation HomeVC

- (id)init
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"Home";
    
    CGRect frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    self.tableView = [[SKTableView alloc] initWithFrame:frame];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - SKTableViewDataSource

- (NSInteger)numberOfRowsInSKTableView:(SKTableView *)skTableView {
    return 50;
}

- (SKTableViewCell *)skTableView:(SKTableView *)skTableView cellForRow:(NSInteger)row {
    
    SKTableViewCell *cell = [skTableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[SKTableViewCell alloc] initWithReuseIdentifier:@"Cell"];
    }
    if (row%2==0) {
        [cell setBackgroundColor:[UIColor lightGrayColor]];
    } else {
        [cell setBackgroundColor:[UIColor darkGrayColor]];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%d", row+1];
    return cell;
}

#pragma mark - SKTableViewDelegate

- (CGFloat)skTableView:(SKTableView *)skTableView heightForRow:(NSInteger)row {
    return 50;
}

@end
