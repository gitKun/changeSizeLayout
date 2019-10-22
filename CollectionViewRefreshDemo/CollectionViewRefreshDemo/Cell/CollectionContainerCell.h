//
//  CollectionContainerCell.h
//  CollectionViewRefreshDemo
//
//  Created by DR_Kun on 2019/10/11.
//  Copyright © 2019 DR_Kun. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CollectionContainerCell;


NS_ASSUME_NONNULL_BEGIN


@protocol CollssssssDelegate <NSObject>

- (void)collectionContainerCell:(CollectionContainerCell *)cCell changeScrollEnable:(BOOL)enabel;

@end


@interface CollectionContainerCell : UITableViewCell

+ (NSString *)reuseID;


@property (nonatomic, weak) id<CollssssssDelegate>delegate;

@property (nonatomic, strong, readonly) UICollectionView *cellCollectionView;

@property (nonatomic, weak) UIView *vcView;


- (void)mainTableViewContentOffsetChange:(CGFloat)offsetY;


@end

NS_ASSUME_NONNULL_END
