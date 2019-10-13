//
//  InnerTestCollectionViewLayout.m
//  CollectionViewRefreshDemo
//
//  Created by DR_Kun on 2019/10/11.
//  Copyright © 2019 DR_Kun. All rights reserved.
//

#import "InnerTestCollectionViewLayout.h"


@interface InnerTestCollectionViewLayout ()

@property (nonatomic, strong) NSMutableArray <UICollectionViewLayoutAttributes *>*dataArray;

@end


@implementation InnerTestCollectionViewLayout


#pragma mark - overrite

- (void)prepareLayout {
    [super prepareLayout];
    //NSLog(@"ChangeFrameLayout -> prepareLayout ____#");
    NSInteger count = [self.collectionView.dataSource collectionView:self.collectionView numberOfItemsInSection:0];
    [self.dataArray removeAllObjects];
    for (NSInteger row = 0; row < count; row++) {
        [self.dataArray addObject:[self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]]];
    }
}

- (CGSize)collectionViewContentSize {
    return CGSizeMake(1024, 1800);
}


- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    //NSLog(@"ChangeFrameLayout -> layoutAttributesForElementsInRect: ____#");
    NSMutableArray *resultArray = [NSMutableArray new];
    for (UICollectionViewLayoutAttributes *att in self.dataArray) {
        if (CGRectIntersectsRect(rect, att.frame)) {
            [resultArray addObject:att];
        }
    }
    return resultArray;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger idx = indexPath.row;
    NSInteger row = floor(idx * 1.0 / 8);
    NSInteger column = idx % 8;
    CGFloat width = 128;
    CGFloat height = 36;
    // add new row
    CGSize size = CGSizeMake(width, height);
    CGFloat originX = column * width;
    CGFloat originY = row * height;
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attributes.frame = CGRectMake(originX, originY, size.width, size.height);
    [self.dataArray addObject:attributes];
    return attributes;
}



#pragma mark - Calculate property

// --- //

#pragma mark - Lazy load (getter methods)

- (NSMutableArray<UICollectionViewLayoutAttributes *> *)dataArray {
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}



@end
