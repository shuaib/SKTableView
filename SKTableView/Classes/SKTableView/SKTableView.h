//
//  SKTableView.h
//  SKTableView
//
//  Created by Shuaib on 26/05/2014.
//  Copyright (c) 2014 Bytehood. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SKTableView;
@class SKTableViewCell;

@protocol SKTableViewDelegate <NSObject, UIScrollViewDelegate>
- (CGFloat)skTableView:(SKTableView *)skTableView heightForRow:(NSInteger)row;
@end

@protocol SKTableViewDataSource
@required
- (NSInteger)numberOfRowsInSKTableView:(SKTableView *)skTableView;
- (SKTableViewCell *)skTableView:(SKTableView*)skTableView cellForRow:(NSInteger)row;
@end


@interface SKTableView : UIScrollView
@property (nonatomic, weak) id<SKTableViewDelegate> delegate;
@property (nonatomic, weak) id<SKTableViewDataSource> dataSource;

- (void)reloadData;

- (SKTableViewCell *)dequeueReusableCellWithIdentifier: (NSString*) reuseIdentifier;
@end

@interface SKTableViewCell : UITableViewCell
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier;
@end



