//
//  ChangeFrameLayout.h
//  CollectionViewRefreshDemo
//
//  Created by DR_Kun on 2019/10/5.
//  Copyright © 2019 DR_Kun. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ChangeFrameLayout;

NS_ASSUME_NONNULL_BEGIN


@protocol ChangeFrameLayoutDelegate <NSObject>


@required
- (CGSize)changeFrameLayout:(ChangeFrameLayout *)layout sizeForItemAtIndexPath:(NSIndexPath *)indexPath;

- (BOOL)changeFrameLayoutShouldFixedFirstColumnItem:(ChangeFrameLayout *)layout;

@end



@interface ChangeFrameLayout : UICollectionViewLayout


@property (nonatomic, weak) id<ChangeFrameLayoutDelegate>delegate;

- (void)reloadData;

@end

NS_ASSUME_NONNULL_END
