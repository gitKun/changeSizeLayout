//
//  FixedCollectionCell.h
//  CollectionViewRefreshDemo
//
//  Created by 李亚坤 on 2019/10/21.
//  Copyright © 2019 DR_Kun. All rights reserved.
//

#import "ShowInfoCell.h"

@class FixedCollectionCell;

NS_ASSUME_NONNULL_BEGIN

@protocol FixedCollectionCellSwipeDelegate <NSObject>

@required
- (void)fixedCollectionCell:(FixedCollectionCell *)fCell didStartSwipeWithDirection:(UISwipeGestureRecognizerDirection)direction;

@end



@interface FixedCollectionCell : ShowInfoCell

+ (NSString *)reuseID;


@property (nonatomic, weak, nullable) id<FixedCollectionCellSwipeDelegate>swipeDelegate;

@end

NS_ASSUME_NONNULL_END
