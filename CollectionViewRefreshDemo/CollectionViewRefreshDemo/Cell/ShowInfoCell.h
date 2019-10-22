//
//  ShowInfoCell.h
//  CollectionViewRefreshDemo
//
//  Created by DR_Kun on 2019/10/6.
//  Copyright © 2019 DR_Kun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DRCustomUnit.h"

@class ShowInfoModel;
@class ShowInfoCell;


/*
 
 * 代理会比 blcok 的性能更好?
 
 */



//@protocol ShowInfoCellGestureDelegate <NSObject>
//
//
//@end




NS_ASSUME_NONNULL_BEGIN

@interface ShowInfoCell : UICollectionViewCell


+ (NSString *)reuseID;


@property (nonatomic, strong, readonly, nonnull) UIView *drMaskView;


@property (nonatomic, copy) BOOL(^showInfoCellShouldBegainEdit)(ShowInfoCell *sCell, UITextField *textField);
@property (nonatomic, copy) void(^showInfoCellDidBegainEdit)(ShowInfoCell *sCell, UITextField *textField);
@property (nonatomic, copy) void(^showInfoCellDidChangeTextInfo)(ShowInfoCell *sCell, UITextField *textField, NSString *resultText);
@property (nonatomic, copy) void(^showInfoCellDidEndEdit)(ShowInfoCell *sCell, UITextField *textField);



//@property (nonatomic, weak, nullable) id<ShowInfoCellGestureDelegate>gestureDelegate;



- (void)updateInfoWithModel:(ShowInfoModel *)model;


// TODO: 改写 cell 支持数据为空时的展示

//- (void)changeNoDataStatus:(BOOL)noData;




@end

NS_ASSUME_NONNULL_END
