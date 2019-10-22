//
//  PlaceholderCell.m
//  CollectionViewRefreshDemo
//
//  Created by DR_Kun on 2019/10/11.
//  Copyright © 2019 DR_Kun. All rights reserved.
//

#import "PlaceholderCell.h"

#import "DRCustomUnit.h"


@implementation PlaceholderCell

+ (NSString *)reuseID {
    return @"PlaceholderCellID";
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:(arc4random()%189 / 255.0) green:(arc4random()%189 / 255.0) blue:(arc4random()%189 / 255.0) alpha:1];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
//        UIPanGestureRecognizer *panGest = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(cellPaneGestureAction:)];
//        panGest.delegate = self;
//        [self addGestureRecognizer:panGest];
        
        
        UISwipeGestureRecognizer *leftSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(cellSwipeGestureAction:)];
        leftSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
        leftSwipe.delegate = self;
        [self addGestureRecognizer:leftSwipe];
        UISwipeGestureRecognizer *rightSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(cellSwipeGestureAction:)];
        rightSwipe.direction = UISwipeGestureRecognizerDirectionRight;
        rightSwipe.delegate = self;
        [self addGestureRecognizer:rightSwipe];
        
    }
    return self;
}


#pragma mark - action

- (void)cellSwipeGestureAction:(UISwipeGestureRecognizer *)swipeG {
    switch (swipeG.direction) {
        case UISwipeGestureRecognizerDirectionRight:
        {
            CGRect frame = self.frame;
            
            if (frame.origin.x < 10) { // 右边界
                frame.origin.x = 220;
                [UIView animateWithDuration:0.25 animations:^{
                    self.frame = frame;
                }];
            }
        }
            break;
        case UISwipeGestureRecognizerDirectionLeft:
        {
            CGRect frame = self.frame;
            if (frame.origin.x > 10) { // 右边界
                frame.origin.x = 0;
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





#pragma mark - gesture delegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(nonnull UIGestureRecognizer *)otherGestureRecognizer {
    if ([otherGestureRecognizer.view isKindOfClass:[UITableView class]]) {
        UITableView *tab = (UITableView *)[otherGestureRecognizer view];
        CGPoint vel = [tab.panGestureRecognizer velocityInView:tab];
        DRPanGestureDirection tabPanDirection = [DRCustomUnit gestureDirectionFromCommitTranslation:vel ignoreDirectionLength:10];
        if (tabPanDirection & DRPanGestureDirectionUp || tabPanDirection & DRPanGestureDirectionDown) {
            return YES;
        }
    }
    return NO;
}



//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
//
//    return NO;
//}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRequireFailureOfGestureRecognizer:(nonnull UIGestureRecognizer *)otherGestureRecognizer {
    if ([otherGestureRecognizer.view isKindOfClass:[UITableView class]]) {
        UITableView *tab = (UITableView *)[otherGestureRecognizer view];
        CGPoint vel = [tab.panGestureRecognizer velocityInView:tab];
        DRPanGestureDirection tabPanDirection = [DRCustomUnit gestureDirectionFromCommitTranslation:vel ignoreDirectionLength:10];
        if (tabPanDirection & DRPanGestureDirectionLeft || tabPanDirection & DRPanGestureDirectionRight) {
            return YES;
        }
    }
    return NO;
}


//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
//    if ([otherGestureRecognizer.view isKindOfClass:[UITableView class]]) {
//        UITableView *tab = (UITableView *)[otherGestureRecognizer view];
//        CGPoint vel = [tab.panGestureRecognizer velocityInView:tab];
//        DRPanGestureDirection tabPanDirection = [self gestureDirectionFromCommitTranslation:vel];
//        if (tabPanDirection & DRPanGestureDirectionUp || tabPanDirection & DRPanGestureDirectionDown) {
//            return YES;
//        }
//    }
//    return NO;
//}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
