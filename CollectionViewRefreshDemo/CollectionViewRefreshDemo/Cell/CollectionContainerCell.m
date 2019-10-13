//
//  CollectionContainerCell.m
//  CollectionViewRefreshDemo
//
//  Created by DR_Kun on 2019/10/11.
//  Copyright © 2019 DR_Kun. All rights reserved.
//

#import "CollectionContainerCell.h"

#import "InnerTestCollectionViewLayout.h"
#import "InnerTestCollectionViewCell.h"

#import <Masonry/Masonry.h>

@interface CollectionContainerCell ()<UICollectionViewDelegate, UICollectionViewDataSource>

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
    self.cellCollectionView.scrollEnabled = NO;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)mainTableViewContentOffsetChange:(CGFloat)offsetY {
    
    
    CGRect selfRect = [self.contentView convertRect:self.cellCollectionView.frame toView:self.vcView];
    
    
    
    CGRect showingRect =CGRectMake(CGRectGetMinX(self.vcView.frame), CGRectGetMinY(self.vcView.frame) - 5, CGRectGetWidth(self.vcView.frame), CGRectGetHeight(self.vcView.frame) + 6);
    
    if (!CGRectContainsRect(showingRect, selfRect)) {
        if (self.cellCollectionView.scrollEnabled) {
            self.cellCollectionView.scrollEnabled = NO;
            if (self.delegate) {
                [self.delegate collectionContainerCell:self changeScrollEnable:NO];
            }
        }
    
        return;
    } else {
        
        if (!self.bottomScrollEnd || !self.topScrollEnd) {
            if (!self.cellCollectionView.scrollEnabled) {
                self.cellCollectionView.scrollEnabled = YES;
                if (self.delegate) {
                    [self.delegate collectionContainerCell:self changeScrollEnable:YES];
                }
            }
        }
        
        return;
    }
    
    CGRect topBoundsRect = CGRectMake(0, CGRectGetMinY(selfRect) + 1, CGRectGetWidth(selfRect), 1);
    CGRect bottomBoundsRect = CGRectMake(0, CGRectGetMaxY(selfRect) - 1, CGRectGetWidth(selfRect), 1);
    
    BOOL showingTop = CGRectContainsRect(self.vcView.bounds, topBoundsRect);
    BOOL showingBottom = CGRectContainsRect(self.vcView.bounds, bottomBoundsRect);
    
    if (showingTop && !showingBottom) {
        // 外部滚动时 内部必定不能滚动
        if (!self.topScrollEnd) {
            if (!self.cellCollectionView.scrollEnabled) {
                self.cellCollectionView.scrollEnabled = YES;
                if (self.delegate) {
                    [self.delegate collectionContainerCell:self changeScrollEnable:YES];
                }
            }
        }
        
    } else if (showingBottom && !showingTop) {
        if (!self.bottomScrollEnd) {
            if (!self.cellCollectionView.scrollEnabled) {
                self.cellCollectionView.scrollEnabled = YES;
                if (self.delegate) {
                    [self.delegate collectionContainerCell:self changeScrollEnable:YES];
                }
            }
        }
    }
}




//- (void)changeScrollEnable {
//    if (self.cellCollectionView.scrollEnabled) {
//        self.cellCollectionView.scrollEnabled = NO;
//        if (self.delegate) {
//            [self.delegate collectionContainerCell:self changeScrollEnable:NO];
//        }
//    } else if (!self.cellCollectionView.scrollEnabled) {
//        self.cellCollectionView.scrollEnabled = YES;
//        if (self.delegate) {
//            [self.delegate collectionContainerCell:self changeScrollEnable:YES];
//        }
//    }
//}

#pragma mark -

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.cellCollectionView) {
        CGFloat offsetY = scrollView.contentOffset.y;
        CGFloat contentHeight = scrollView.contentSize.height;
        CGFloat height = CGRectGetHeight(scrollView.bounds);
        
        if (offsetY <= 0.01) {
            if (scrollView.scrollEnabled) {
                scrollView.scrollEnabled = NO;
                self.topScrollEnd = YES;
                if (self.delegate) {
                    [self.delegate collectionContainerCell:self changeScrollEnable:NO];
                }
            }
        } else {
            self.topScrollEnd = NO;
        }
        
        if (offsetY + height >= contentHeight - 0.01) {
            if (scrollView.scrollEnabled) {
                scrollView.scrollEnabled = NO;
                self.bottomScrollEnd = YES;
                if (self.delegate) {
                    [self.delegate collectionContainerCell:self changeScrollEnable:NO];
                }
            }
        } else {
            self.bottomScrollEnd = NO;
        }
        
    }
}


#pragma mark - UICollectionViewDelegate && UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 400;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    InnerTestCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[InnerTestCollectionViewCell reuseID] forIndexPath:indexPath];
    if (!cell) {
        
    }
    return cell;
}


#pragma mark - lazy load

- (UICollectionView *)cellCollectionView {
    if (!_cellCollectionView) {
        InnerTestCollectionViewLayout *layout = [[InnerTestCollectionViewLayout alloc] init];
        _cellCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _cellCollectionView.backgroundColor = [UIColor whiteColor];
        [_cellCollectionView registerClass:[InnerTestCollectionViewCell class] forCellWithReuseIdentifier:[InnerTestCollectionViewCell reuseID]];
        _cellCollectionView.dataSource = self;
        _cellCollectionView.delegate = self;
        _cellCollectionView.bounces = NO;
    }
    return _cellCollectionView;
}



@end
