//
//  ItemModelCreateUnit.m
//  CollectionViewRefreshDemo
//
//  Created by DR_Kun on 2019/10/6.
//  Copyright © 2019 DR_Kun. All rights reserved.
//

#import "ItemModelCreateUnit.h"

#import "ItemModelCreateUnit.h"

@implementation ItemModelCreateUnit


+ (NSMutableArray <ShowInfoModel *>*)createShowInfoModelWithColumnCount:(NSInteger)count {
    NSMutableArray *resultArray = [[NSMutableArray alloc] init];
    
    for (NSInteger idx = 0; idx < count; idx++) {
        ShowInfoModel *model = [[ShowInfoModel alloc] init];
        model.inputString = [NSString stringWithFormat:@"idx:%02ld",idx];
        [resultArray addObject:model];
    }
    return resultArray;
}


+ (CGFloat)defaultWidthForItemAtIndex:(NSInteger)index {
    
    switch (index) {
        case 0:  return 22 * 10.0;
        case 1:  return 22 * 3.27;
        case 2:  return 22 * 5.55;
        case 3:  return 22 * 5.45;
        case 4:  return 22 * 5.45;
        case 5:  return 22 * 3.86;
        case 6:  return 22 * 2.72;
        case 7:  return 22 * 3.27;
        case 8:  return 22 * 7.27;
        case 9:  return 22 * 2.45;
        case 10: return 22 * 2.72;
        case 11: return 22 * 2.72;
        case 12: return 22 * 3.27;
        case 13: return 22 * 2.72;
        case 14: return 22 * 2.72;
        case 15: return 22 * 2.72;
        case 16: return 22 * 2.90;
        case 17: return 22 * 2.72;
        case 18: return 22 * 2.72;
        case 19: return 22 * 2.72;
        case 20: return 22 * 2.72;
        case 21: return 22 * 2.72;
        case 22: return 22 * 2.80;
        case 23: return 22 * 7.27;
        case 24: return 22 * 2.72;
        case 25: return 22 * 2.72;
        case 26: return 22 * 2.72;
        case 27: return 22 * 2.72;
        case 28: return 22 * 2.72;
        case 29: return 22 * 2.72;
        case 30: return 22 * 2.72;
        case 31: return 22 * 2.72;
        case 32: return 22 * 1.00;
        case 33: return 22 * 1.00;
        case 34: return 22 * 1.00;
        default: return 22 * 1.00;
    }
    
    return 10;
}

+ (CGFloat)defaultHeight {
    return 46;
}

+ (CGSize)defaultItemSizeAtIndex:(NSInteger)index {
    return CGSizeMake([self defaultWidthForItemAtIndex:index], self.defaultHeight);
}


@end
