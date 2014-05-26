//
//  HomeVC.h
//  SKTableView
//
//  Created by Shuaib on 27/05/2014.
//  Copyright (c) 2014 Bytehood. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKTableView.h"

@interface HomeVC : UIViewController <SKTableViewDataSource, SKTableViewDelegate>

- (id)init;

@property (nonatomic, strong) SKTableView *tableView;

@end
