//
//  CollectionContainerCell.m
//  CollectionViewRefreshDemo
//
//  Created by DR_Kun on 2019/10/11.
//  Copyright © 2019 DR_Kun. All rights reserved.
//

#import "CollectionContainerCell.h"

#import "ChangeFrameLayout.h"
#import "ShowInfoCell.h"
#import "FixedCollectionCell.h"
//#import "InnerTestCollectionViewLayout.h"
//#import "InnerTestCollectionViewCell.h"
#import "ShowInfoModel.h"

#import <Masonry/Masonry.h>
#import "DRCustomUnit.h"


@interface CollectionContainerCell ()<UICollectionViewDelegate, UICollectionViewDataSource, ChangeFrameLayoutDelegate, FixedCollectionCellSwipeDelegate>

@property (nonatomic, strong, readwrite) UICollectionView *cellCollectionView;


@property (nonatomic, assign) BOOL topScrollEnd;
@property (nonatomic, assign) BOOL bottomScrollEnd;


@end



@implementation CollectionContainerCell

+ (NSString *)reuseID {
    return @"CollectionContainerCellID";
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initUIElement];
        
        self.topScrollEnd = YES;
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

#pragma mark - Create UI element

- (void)initUIElement {
    self.backgroundColor = UIColor.lightGrayColor;
    
    [self.contentView addSubview:self.cellCollectionView];
    [self.cellCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self.contentView);
    }];
//    self.cellCollectionView.scrollEnabled = NO;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)mainTableViewContentOffsetChange:(CGFloat)offsetY {
    
}


#pragma mark - FixedCollectionCellSwipeDelegate

- (void)fixedCollectionCell:(FixedCollectionCell *)fCell didStartSwipeWithDirection:(UISwipeGestureRecognizerDirection)direction {
    switch (direction) {
        case UISwipeGestureRecognizerDirectionLeft:
        {
            CGRect frame = self.frame;
            if (frame.origin.x > 100) {
                frame.origin.x = 0;
                [UIView animateWithDuration:0.25 animations:^{
                    self.frame = frame;
                }];
            }
        }
            break;
        case UISwipeGestureRecognizerDirectionRight:
        {
            CGRect frame = self.frame;
            if (frame.origin.x < 10) {
                frame.origin.x = 180;
                [UIView animateWithDuration:0.25 animations:^{
                    self.frame = frame;
                }];
            }
        }
            break;
        default:
            break;
    }
}



#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

}


#pragma mark - UICollectionViewDelegate && UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 16;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        FixedCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[FixedCollectionCell reuseID] forIndexPath:indexPath];
        cell.swipeDelegate = self;
        return cell;
    }
    ShowInfoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[ShowInfoCell reuseID] forIndexPath:indexPath];
    //cell.gestureDelegate = self;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell isKindOfClass:[ShowInfoCell class]]) {
        ShowInfoCell *sCell = (ShowInfoCell *)cell;
        [sCell updateInfoWithModel:({
            ShowInfoModel *model = [[ShowInfoModel alloc] init];
            model.inputString = [NSString stringWithFormat:@"cell %@",@(indexPath.row + 1)];
            model.showDataStatus = NO;
            model;
        })];
    }
}

#pragma mark - change

- (CGSize)changeFrameLayout:(ChangeFrameLayout *)layout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return CGSizeMake(220, 40);
    } else {
        return CGSizeMake(80, 40);
    }
}

- (BOOL)changeFrameLayoutShouldFixedFirstColumnItem:(ChangeFrameLayout *)layout {
    return YES;
}


#pragma mark - lazy load

- (UICollectionView *)cellCollectionView {
    if (!_cellCollectionView) {
//        InnerTestCollectionViewLayout *layout = [[InnerTestCollectionViewLayout alloc] init];
        ChangeFrameLayout *layout = [[ChangeFrameLayout alloc] init];
        layout.delegate = self;
        _cellCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _cellCollectionView.backgroundColor = [UIColor whiteColor];
        [_cellCollectionView registerClass:[ShowInfoCell class] forCellWithReuseIdentifier:[ShowInfoCell reuseID]];
        [_cellCollectionView registerClass:[FixedCollectionCell class] forCellWithReuseIdentifier:[FixedCollectionCell reuseID]];
        _cellCollectionView.dataSource = self;
        _cellCollectionView.delegate = self;
        _cellCollectionView.bounces = NO;
//        _cellCollectionView.panGestureRecognizer.delaysTouchesBegan = YES;
    }
    return _cellCollectionView;
}



@end
