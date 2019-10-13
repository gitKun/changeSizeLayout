//
//  ItemModelCreateUnit.h
//  CollectionViewRefreshDemo
//
//  Created by DR_Kun on 2019/10/6.
//  Copyright © 2019 DR_Kun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShowInfoModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface ItemModelCreateUnit : NSObject

+ (NSMutableArray <ShowInfoModel *>*)createShowInfoModelWithColumnCount:(NSInteger)count;

+ (CGFloat)defaultWidthForItemAtIndex:(NSInteger)index;

+ (CGFloat)defaultHeight;


+ (CGSize)defaultItemSizeAtIndex:(NSInteger)index;


@end

NS_ASSUME_NONNULL_END
