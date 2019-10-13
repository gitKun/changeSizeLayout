//
//  InnerTestCollectionViewCell.m
//  CollectionViewRefreshDemo
//
//  Created by DR_Kun on 2019/10/11.
//  Copyright © 2019 DR_Kun. All rights reserved.
//

#import "InnerTestCollectionViewCell.h"

@implementation InnerTestCollectionViewCell


+ (NSString *)reuseID {
    return @"InnerTestCollectionViewCellID";
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:(arc4random()%255 / 255.0) green:(arc4random()%255 / 255.0) blue:(arc4random()%255 / 255.0) alpha:1];
    }
    return self;
}


@end
