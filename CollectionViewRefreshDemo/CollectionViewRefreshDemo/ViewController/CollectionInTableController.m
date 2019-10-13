//
//  CollectionInTableController.m
//  CollectionViewRefreshDemo
//
//  Created by DR_Kun on 2019/10/11.
//  Copyright © 2019 DR_Kun. All rights reserved.
//

#import "CollectionInTableController.h"
#import <Masonry/Masonry.h>

#import "PlaceholderCell.h"
#import "CollectionContainerCell.h"

@interface CollectionInTableController ()<UITableViewDelegate, UITableViewDataSource, CollssssssDelegate>


@property (nonatomic, strong) UITableView *mainTableView;

@property (nonatomic, strong) UICollectionView *collectionView;


@property (nonatomic, strong) NSArray *billDetailsArray;


@property (nonatomic, weak) CollectionContainerCell *contentCell;

@property (nonatomic, assign) BOOL mainTableShouldStopScroll;// 是否暂停 mainTableView 的滚动行为

@end

@implementation CollectionInTableController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUIElement];
    
    self.billDetailsArray = ({
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:50];
        for (NSInteger i = 0; i < 50; i++) {
            [arr addObject:@(i)];
        }
        [arr copy];
    });
    
}

- (void)initUIElement {
    
    self.view.backgroundColor = [UIColor colorWithRed:(arc4random()%255 / 255.0) green:(arc4random()%255 / 255.0) blue:(arc4random()%255 / 255.0) alpha:1];
    
    [self.view addSubview:self.mainTableView];
    [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(80);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).with.offset(-10);
    }];
}



#pragma mark - SSSSSSS

- (void)collectionContainerCell:(CollectionContainerCell *)cCell changeScrollEnable:(BOOL)enabel {
    if (enabel) {
        self.mainTableView.scrollEnabled = NO;
    } else {
        self.mainTableView.scrollEnabled = YES;
    }
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.mainTableView) {
        [self.contentCell mainTableViewContentOffsetChange:scrollView.contentOffset.y];
    }
}


#pragma mark - UITableViewDelegate && UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
        case 1:
        case 3:
        case 4:
        {
            PlaceholderCell *cell = [tableView dequeueReusableCellWithIdentifier:[PlaceholderCell reuseID] forIndexPath:indexPath];
            if (!cell) {
                cell = [[PlaceholderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[PlaceholderCell reuseID]];
            }
            return cell;
        }
        case 2:
        {
            CollectionContainerCell *cell = [tableView dequeueReusableCellWithIdentifier:[CollectionContainerCell reuseID] forIndexPath:indexPath];
            if (!cell) {
                cell = [[CollectionContainerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[CollectionContainerCell reuseID]];
            }
            cell.delegate = self;
            cell.vcView = self.view;
            self.contentCell = cell;
            return cell;
        }
        default:
            break;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
          case 0:
          case 1:
          case 3:
          case 4:
          {
              return 250;
          }
          case 2:
          {
              return CGRectGetHeight(tableView.bounds) + 10;
          }
          default:
              return 100;
      }
}


#pragma mark - lazy load

- (UITableView *)mainTableView {
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _mainTableView.backgroundColor = [UIColor whiteColor];
        [_mainTableView registerClass:[PlaceholderCell class] forCellReuseIdentifier:[PlaceholderCell reuseID]];
        [_mainTableView registerClass:[CollectionContainerCell class] forCellReuseIdentifier:[CollectionContainerCell reuseID]];
        _mainTableView.dataSource = self;
        _mainTableView.delegate = self;
    }
    return _mainTableView;
}


@end
