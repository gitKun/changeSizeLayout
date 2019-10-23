


//
//  FixedCollectionCell.m
//  CollectionViewRefreshDemo
//
//  Created by 李亚坤 on 2019/10/21.
//  Copyright © 2019 DR_Kun. All rights reserved.
//

#import "FixedCollectionCell.h"


@interface FixedCollectionCell ()<UIGestureRecognizerDelegate>

@property (nonatomic, weak) UISwipeGestureRecognizer *leftSwipG;
@property (nonatomic, weak) UISwipeGestureRecognizer *rightSwipG;
@property (nonatomic, weak) UIPanGestureRecognizer *panG;

@end


@implementation FixedCollectionCell

+ (NSString *)reuseID {
    return @"FixedCollectionCellID";
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self registSwipeGesture];
    }
    return self;
}


- (void)registSwipeGesture {
    UISwipeGestureRecognizer *leftSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(cellSwipeGestureAction:)];
    leftSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
    leftSwipe.delegate = self;
    [self addGestureRecognizer:leftSwipe];
    self.leftSwipG = leftSwipe;
    UISwipeGestureRecognizer *rightSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(cellSwipeGestureAction:)];
    rightSwipe.direction = UISwipeGestureRecognizerDirectionRight;
    rightSwipe.delegate = self;
    [self addGestureRecognizer:rightSwipe];
    self.rightSwipG = rightSwipe;
    
    // 添加 panGesture 拦截 gesture 传递给 collection
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dr_pan:)];
    pan.delegate = self;
//    pan.delaysTouchesBegan = YES;
    self.panG = pan;
    [self addGestureRecognizer:pan];
    
}

- (void)dr_pan:(UIPanGestureRecognizer *)panG {
    
}

- (void)cellSwipeGestureAction:(UISwipeGestureRecognizer *)swipeG {
    NSLog(@"CollecionContainerCell 开始处理轻扫手势!");
    
    switch (swipeG.direction) {
        case UISwipeGestureRecognizerDirectionRight:
        {
            if (self.swipeDelegate) {
                [self.swipeDelegate fixedCollectionCell:self didStartSwipeWithDirection:UISwipeGestureRecognizerDirectionRight];
            }
        }
            break;
        case UISwipeGestureRecognizerDirectionLeft:
        {
            [self.swipeDelegate fixedCollectionCell:self didStartSwipeWithDirection:UISwipeGestureRecognizerDirectionLeft];
        }
            break;
        default:
            break;
    }
}


#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(nonnull UIGestureRecognizer *)otherGestureRecognizer {
   
    if ((gestureRecognizer == self.leftSwipG || gestureRecognizer == self.rightSwipG)) {
        return YES;
    }
    
    if ([otherGestureRecognizer.view isKindOfClass:[UITableView class]]) {
        UITableView *tab = (UITableView *)[otherGestureRecognizer view];
        CGPoint vel = [tab.panGestureRecognizer velocityInView:tab];
        DRPanGestureDirection tabPanDirection = [DRCustomUnit gestureDirectionFromCommitTranslation:vel ignoreDirectionLength:10];
        if (tabPanDirection & DRPanGestureDirectionLeft || tabPanDirection & DRPanGestureDirectionRight) {
            return NO;
        }
        return YES;
    }
    
    return NO;
}


@end
