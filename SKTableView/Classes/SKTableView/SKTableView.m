//
//  SKTableView.m
//  SKTableView
//
//  Created by Shuaib on 26/05/2014.
//  Copyright (c) 2014 Bytehood. All rights reserved.
//

#import "SKTableView.h"

@interface SKRowRecord : NSObject

@property (nonatomic, assign) CGFloat rowHeight;
@property (nonatomic, assign) CGFloat startPositionY;
@property (nonatomic, strong) SKTableViewCell *cachedCell;

@end

@implementation SKRowRecord
@end

@implementation SKTableViewCell

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}

@end

@interface SKTableView ()

@property (nonatomic, strong) NSMutableArray *reusePool;
@property (nonatomic, assign) CGFloat rowHeight;
@property (nonatomic, assign) CGFloat skRowMargin;
@property (nonatomic, strong) NSMutableArray *rowRecords;
@property (nonatomic, strong) NSMutableIndexSet *visibleRows;

@end

@implementation SKTableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.rowHeight = 40.0;
        self.skRowMargin = 2.0;
        self.reusePool = [NSMutableArray new];
        self.rowRecords = [NSMutableArray new];
        self.visibleRows = [NSMutableIndexSet new];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (SKTableViewCell *)dequeueReusableCellWithIdentifier: (NSString*) reuseIdentifier
{
    SKTableViewCell *tableCell = nil;
    for (SKTableViewCell *cell in self.reusePool) {
        if([[cell reuseIdentifier] isEqualToString:reuseIdentifier]) {
            tableCell = cell;
            break;
        }
    }
    if (tableCell) {
        [self.reusePool removeObject:tableCell];
    }
    return tableCell;
}

- (void) setContentOffset:(CGPoint)contentOffset
{
    [super setContentOffset: contentOffset];
    [self layoutTableRows];
}

#pragma mark - Private Methods

- (void)generateHeightAndOffsetData
{
    CGFloat currentOffsetY = 0.0;
    BOOL checkHeightForEachRow = [[self delegate] respondsToSelector:@selector(skTableView:heightForRow:)   ];
    NSMutableArray *newRowRecords = [NSMutableArray array];
    NSInteger numberOfRows = [[self dataSource] numberOfRowsInSKTableView:self];
    for (NSUInteger i=0; i<numberOfRows; i++) {
        SKRowRecord *rowRecord = [SKRowRecord new];
        CGFloat rowHeight = checkHeightForEachRow ? [[self delegate] skTableView:self heightForRow:i] : [self rowHeight];
        rowRecord.rowHeight = rowHeight;
        rowRecord.startPositionY = currentOffsetY + self.skRowMargin;
        [newRowRecords insertObject:rowRecord atIndex:i];
        currentOffsetY = currentOffsetY + rowHeight + self.skRowMargin;
    }
    self.rowRecords = newRowRecords;
    self.contentSize = CGSizeMake(self.bounds.size.width, currentOffsetY);
}

- (void)layoutTableRows
{
    CGFloat currentStartY = self.contentOffset.y;
    CGFloat currentEndY = self.frame.size.height + currentStartY;

    NSInteger rowToDisplay = [self findRowForOffsetY:currentStartY inRange:NSMakeRange(0, self.rowRecords.count)];
    NSMutableIndexSet* newVisibleRows = [[NSMutableIndexSet alloc] init];
    CGFloat yOrigin;
    CGFloat rowHeight;
    do {

        yOrigin = [self startPositionYForRow:rowToDisplay];
        rowHeight = [self heightForRow:rowToDisplay];
        [newVisibleRows addIndex:rowToDisplay];
    
        SKTableViewCell *cell = [self cachedCellForRow:rowToDisplay];
        if (!cell) {
            cell = [[self dataSource] skTableView:self cellForRow:rowToDisplay];
            [self setCachedCell:cell forRow:rowToDisplay];
            [cell setFrame:CGRectMake(0, yOrigin, self.bounds.size.width, rowHeight)];
            [self addSubview:cell];
        }
        rowToDisplay++;
    }while(yOrigin+rowHeight < currentEndY && rowToDisplay<self.rowRecords.count);
 
    [self returnNonVisibleRowsToPool:newVisibleRows];
}

- (NSInteger) findRowForOffsetY: (CGFloat) yPosition inRange: (NSRange) range
{
    if ([[self rowRecords] count] == 0) return 0;
    
    SKRowRecord* rowRecord = [[SKRowRecord alloc] init];
    [rowRecord setStartPositionY: yPosition];
    
    NSInteger returnValue = [[self rowRecords] indexOfObject: rowRecord
                                               inSortedRange: NSMakeRange(0, [[self rowRecords] count])
                                                     options: NSBinarySearchingInsertionIndex
                                             usingComparator: ^NSComparisonResult(SKRowRecord* rowRecord1, SKRowRecord* rowRecord2){
                                                 if ([rowRecord1 startPositionY] < [rowRecord2 startPositionY])
                                                     return NSOrderedAscending;
                                                 return NSOrderedDescending;
                                             }];
    if (returnValue == 0) return 0;
    return returnValue - 1;
}

- (CGFloat)startPositionYForRow:(NSInteger)row
{
    return [[self.rowRecords objectAtIndex:row] startPositionY];
}

- (CGFloat)heightForRow:(NSInteger)row
{
    return [[self.rowRecords objectAtIndex:row] rowHeight];
}
            
- (SKTableViewCell *)cachedCellForRow:(NSInteger)row
{
    return [[self.rowRecords objectAtIndex:row] cachedCell];
}

- (void)setCachedCell:(SKTableViewCell *)cell forRow:(NSInteger)row
{
    [[self.rowRecords objectAtIndex:row] setCachedCell:cell];
}

- (void)returnNonVisibleRowsToPool:(NSMutableIndexSet *)visibleRows
{
    [self.visibleRows removeIndexes:visibleRows];
    [self.visibleRows enumerateIndexesUsingBlock:^(NSUInteger row, BOOL *stop) {
        SKTableViewCell *cell = [self cachedCellForRow:row];
        if (cell) {
            [self.reusePool addObject:cell];
            [cell removeFromSuperview];
            [self setCachedCell:nil forRow:row];
        }
    }];
    self.visibleRows = visibleRows;
}

- (void) reloadData
{
    [self returnNonVisibleRowsToPool: nil];
    [self generateHeightAndOffsetData];
    [self layoutTableRows];
}

@end
