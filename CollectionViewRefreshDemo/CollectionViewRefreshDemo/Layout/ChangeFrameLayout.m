//
//  ChangeFrameLayout.m
//  CollectionViewRefreshDemo
//
//  Created by DR_Kun on 2019/10/5.
//  Copyright © 2019 DR_Kun. All rights reserved.
//

#import "ChangeFrameLayout.h"


@interface ChangeFrameLayout ()

@property (nonatomic, strong) NSMutableArray <NSMutableArray <UICollectionViewLayoutAttributes *>*>*layoutAtttibutesData;


@property (nonatomic, assign) CGFloat maxX;
@property (nonatomic, assign) CGFloat maxY;
@property (nonatomic, assign) BOOL shouldFixedFirstColumnItem;


@property (nonatomic, strong) NSMutableArray <UICollectionViewLayoutAttributes *>*fixedAttributesData;

@end


@implementation ChangeFrameLayout

#pragma mark - Public

- (void)reloadData {
    [self.layoutAtttibutesData removeAllObjects];
    self.maxY = 0;
    self.maxX = 0;
    NSInteger sectionCount = [self.collectionView.dataSource numberOfSectionsInCollectionView:self.collectionView];
    for (NSInteger i = 0; i < sectionCount; i++) {
        NSInteger rowCount = [self.collectionView.dataSource collectionView:self.collectionView numberOfItemsInSection:i];
        for (NSInteger j = 0; j < rowCount; j++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:j inSection:i];
            [self layoutAttributesForItemAtIndexPath:indexPath];
        }
    }
    if (self.delegate) {
        self.shouldFixedFirstColumnItem = [self.delegate changeFrameLayoutShouldFixedFirstColumnItem:self];
    }
}

#pragma mark - overrite

- (void)prepareLayout {
    [super prepareLayout];
    //NSLog(@"ChangeFrameLayout -> prepareLayout ____#");
    [self reloadData];
}

- (CGSize)collectionViewContentSize {
    return CGSizeMake(self.maxX, self.maxY);
}


- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray *resultArray = [NSMutableArray new];
    for (NSInteger section = 0; section < self.layoutAtttibutesData.count; section++) {
        NSArray <UICollectionViewLayoutAttributes *>*attributes = self.layoutAtttibutesData[section];
        NSInteger rowCount = attributes.count;
        if (rowCount != 0) {
            NSInteger row = 0;
            // 处理外层循环开始条件
            UICollectionViewLayoutAttributes *firstRowAtt = attributes[0];
            CGRect oldFrame = firstRowAtt.frame;
            CGFloat sectionBottom = CGRectGetMaxY(oldFrame);
            if (sectionBottom < CGRectGetMinY(rect)) {
                continue;
            }
            CGFloat sectionTop = CGRectGetMinY(oldFrame);
            if (sectionTop > CGRectGetMaxY(rect)) {
                break;
            }
            // 处理悬浮
            if (_shouldFixedFirstColumnItem) {
                CGFloat offsetX = self.collectionView.contentOffset.x;
                firstRowAtt.frame = CGRectMake(offsetX, CGRectGetMinY(oldFrame), CGRectGetWidth(oldFrame), CGRectGetHeight(oldFrame));
                [resultArray addObject:firstRowAtt];
                row = 1;
            }
            for (; row < rowCount; row++) {
                UICollectionViewLayoutAttributes *att = attributes[row];
                // 处理内不循环的终止条件
                CGRect attFrame = att.frame;
                if (CGRectGetMaxX(attFrame) < CGRectGetMinX(rect)) {
                    continue;
                }
                if (CGRectGetMinX(attFrame) > CGRectGetMaxX(rect)) {
                    break;
                }
                if (CGRectIntersectsRect(rect, att.frame)) {
                    [resultArray addObject:att];
                }
            }
            
        }
    }
    return resultArray;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    BOOL needChangeMaxY = NO;
    NSMutableArray *contentArray = nil;
    if (self.layoutAtttibutesData.count > section) {
        contentArray = self.layoutAtttibutesData[section];
    } else {
        contentArray = [NSMutableArray array];
        [self.layoutAtttibutesData addObject:contentArray];
        // Add new section
        needChangeMaxY = YES;
    }
    
    if (contentArray.count > row) {
        return [contentArray objectAtIndex:row];
    }
    // add new row
    CGSize size = CGSizeZero;
    if ([self.delegate respondsToSelector:@selector(changeFrameLayout:sizeForItemAtIndexPath:)]) {
        // change size
        size = [self.delegate changeFrameLayout:self sizeForItemAtIndexPath:indexPath];
    }
    CGFloat originX = 0;
    CGFloat originY = 0;
    if (section != 0) {
        // change originY
        NSIndexPath *preSectionIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:(indexPath.section - 1)];
        UICollectionViewLayoutAttributes *preSectionAttributes = [self layoutAttributesForItemAtIndexPath:preSectionIndexPath];
        originY = CGRectGetMaxY(preSectionAttributes.frame);
    }
    if (row != 0) {
        // change originX
        NSIndexPath *preRowIndexPath = [NSIndexPath indexPathForRow:(indexPath.row - 1) inSection:indexPath.section];
        UICollectionViewLayoutAttributes *preRowAttributes = [self layoutAttributesForItemAtIndexPath:preRowIndexPath];
        originX = CGRectGetMaxX(preRowAttributes.frame);
    }
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attributes.frame = CGRectMake(originX, originY, size.width, size.height);
    if (CGSizeEqualToSize(size, CGSizeZero)) {
        attributes.hidden = YES;
    } else {
        attributes.hidden = NO;
    }
    if (needChangeMaxY) {
        self.maxY = _maxY < CGRectGetMaxY(attributes.frame) ? CGRectGetMaxY(attributes.frame) : _maxY;
    }
    self.maxX = _maxX < CGRectGetMaxX(attributes.frame) ? CGRectGetMaxX(attributes.frame) : _maxX;
    [contentArray addObject:attributes];
    if (self.shouldFixedFirstColumnItem && row == 0) {
        attributes.zIndex = 1;
        [self.fixedAttributesData addObject:attributes];
    }
    return attributes;
}

//return YES;表示一旦滑动就实时调用上面这个layoutAttributesForElementsInRect:方法
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBound {
    return YES;
}


#pragma mark - Calculate property

// --- //

#pragma mark - Lazy load (getter methods)

- (NSMutableArray<NSMutableArray<UICollectionViewLayoutAttributes *> *> *)layoutAtttibutesData {
    if (!_layoutAtttibutesData) {
        _layoutAtttibutesData = [NSMutableArray array];
    }
    return _layoutAtttibutesData;
}

- (NSMutableArray<UICollectionViewLayoutAttributes *> *)fixedAttributesData {
    if (!_fixedAttributesData) {
        _fixedAttributesData = [NSMutableArray arrayWithCapacity:30];
    }
    return _fixedAttributesData;
}

@end
