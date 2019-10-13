//
//  ViewController.m
//  CollectionViewRefreshDemo
//
//  Created by DR_Kun on 2019/10/5.
//  Copyright © 2019 DR_Kun. All rights reserved.
//

#import "ViewController.h"
#import "ChangeFrameLayout.h"
#import "ItemModelCreateUnit.h"
#import "ShowInfoCell.h"

#import "CollectionInTableController.h"

#import <Masonry/Masonry.h>


/*
 
 * 界面显示 和 数据渲染 区分开来
 
 
 */


@interface ViewController ()<UICollectionViewDelegate, UICollectionViewDataSource,ChangeFrameLayoutDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray <NSMutableArray <ShowInfoModel *>*>*dataSouce;
@property (weak, nonatomic) IBOutlet UITextField *textField;

@property (nonatomic, strong) NSMutableArray <NSValue *>*createCellSizeData;

@property (nonatomic, strong) NSMutableArray *sectionControlData;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUIElement];
    self.collectionView.delegate = self;
    ChangeFrameLayout *layout = (ChangeFrameLayout *)self.collectionView.collectionViewLayout;
    layout.delegate = self;
    
    
    // 模拟网络数据请求
    [self testShowNetworkInfo];
    
}

- (void)testShowNetworkInfo {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(8.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // TODO: 给model赋值比给创建model的时间更久(10倍) 所以要将赋值代码在其他线程执行
        CFAbsoluteTime refTime = CFAbsoluteTimeGetCurrent();
        NSLog(@"赋值循环开始: start time 0.000000");
        for (NSArray *list in self.dataSouce) {
            NSInteger count = list.count;
            @autoreleasepool {
                for (NSInteger i = 0; i < count; i++) {
                    ShowInfoModel *model = list[i];
                    model.inputString = [NSString stringWithFormat:@"网络数据:%02ld",(long)i];
                    model.showDataStatus = NO;
                }
            }
        }
        NSLog(@"赋值循环开始: after busy %f", CFAbsoluteTimeGetCurrent() - refTime);
        // TODO: 赋值结束后通知主线程刷新数据
        [self.collectionView reloadData];
    });
}


#pragma mark - Create UI element

- (void)initUIElement {
    ChangeFrameLayout *layout = [[ChangeFrameLayout alloc] init];
    layout.delegate = self;
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];    
    [self.view addSubview:collectionView];
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).with.offset(16);
        make.right.equalTo(self.view.mas_right).with.offset(-16);
        make.height.mas_equalTo(500);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-100);
    }];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.backgroundColor = [UIColor lightGrayColor];
    collectionView.bounces = NO;
    collectionView.directionalLockEnabled = YES;
//    [collectionView registerNib:[UINib nibWithNibName:@"ShowInfoCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"ShowInfoCellID"];
    [collectionView registerClass:[ShowInfoCell class] forCellWithReuseIdentifier:@"ShowInfoCellID"];
    self.collectionView = collectionView;
}

#pragma mark - UI action

- (IBAction)showOrHiddenButtonClicked:(UIButton *)sender {
    [self.textField resignFirstResponder];
    self.textField.inputView = ({
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
        view.backgroundColor = UIColor.redColor;
        view;
    });
    
    if (sender.isSelected) {
        // 显示
        self.createCellSizeData[1] = [NSValue valueWithCGSize:CGSizeMake([ItemModelCreateUnit defaultWidthForItemAtIndex:1], [ItemModelCreateUnit defaultHeight])];
    } else {
        // 隐藏
        self.createCellSizeData[1] = [NSValue valueWithCGSize:CGSizeZero];
    }
    
    ChangeFrameLayout *layout = (ChangeFrameLayout *)self.collectionView.collectionViewLayout;
    [layout reloadData];
    [layout invalidateLayout];
    sender.selected = !sender.isSelected;
}

- (IBAction)increaseOrReduceButtonClicked:(UIButton *)sender {
    [self.textField resignFirstResponder];
    self.textField.inputView = nil;
    if (sender.isSelected) {
        // 增加
        self.createCellSizeData[3] = [NSValue valueWithCGSize:CGSizeMake([ItemModelCreateUnit defaultWidthForItemAtIndex:3] * 1.2, [ItemModelCreateUnit defaultHeight])];
    } else {
        // 减少
        self.createCellSizeData[3] = [NSValue valueWithCGSize:CGSizeMake([ItemModelCreateUnit defaultWidthForItemAtIndex:3] * 0.8, [ItemModelCreateUnit defaultHeight])];
    }
    
    ChangeFrameLayout *layout = (ChangeFrameLayout *)self.collectionView.collectionViewLayout;
    [layout reloadData];
    [layout invalidateLayout];
    sender.selected = !sender.isSelected;
}

- (IBAction)reloadInfoButtonClicked:(UIButton *)sender {
    NSMutableArray <NSIndexPath *>*array = [NSMutableArray array];
    for (NSInteger i = 0; i < self.dataSouce.count; i++) {
        NSArray *itemArray = self.dataSouce[i];
        if (itemArray.count > 3) {
            ShowInfoModel *model = itemArray[2];
            model.inputString = [NSString stringWithFormat:@"relod - %@",@(arc4random() % 5 + 1)];
            [array addObject:[NSIndexPath indexPathForRow:2 inSection:i]];
        }
    }
    [self.collectionView reloadItemsAtIndexPaths:array];
}
- (IBAction)showCollectionInTableView:(UIButton *)sender {
    CollectionInTableController *ctViewcontroller = [[CollectionInTableController alloc] init];
    [self.navigationController pushViewController:ctViewcontroller animated:YES];
}


#pragma mark - Cell regaist action

- (BOOL)handleShowInfoCell:(ShowInfoCell *)cell shouldBegianEditingWith:(UITextField *)textField {
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    if (indexPath.row == 3) {
        return NO;
    }
    return YES;
}

- (void)handleShowInfoCell:(ShowInfoCell *)cell didBegainEditWith:(UITextField *)textField {
    
}

- (void)handleShowInfoCell:(ShowInfoCell *)cell changeTextInfoWith:(UITextField *)textField {
    
}

- (void)handleShowInfoCell:(ShowInfoCell *)cell didEndEditWith:(UITextField *)textField {
    
}




#pragma mark - Delegate

// --- //

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSouce[section].count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.dataSouce.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ShowInfoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ShowInfoCellID" forIndexPath:indexPath];
    __weak typeof(self) weakS = self;
    if (!cell.showInfoCellShouldBegainEdit) {
        cell.showInfoCellShouldBegainEdit = ^BOOL(ShowInfoCell * _Nonnull sCell, UITextField * _Nonnull textField) {
            return [weakS handleShowInfoCell:sCell shouldBegianEditingWith:textField];
        };
    }
    if (!cell.showInfoCellDidBegainEdit) {
        cell.showInfoCellDidBegainEdit = ^(ShowInfoCell * _Nonnull sCell, UITextField * _Nonnull textField) {
            [weakS handleShowInfoCell:sCell didBegainEditWith:textField];
        };
    }
    if (!cell.showInfoCellDidChangeTextInfo) {
        cell.showInfoCellDidChangeTextInfo = ^(ShowInfoCell * _Nonnull sCell, UITextField * _Nonnull textField, NSString * _Nonnull resultText) {
            [weakS handleShowInfoCell:sCell changeTextInfoWith:textField];
        };
    }
    if (!cell.showInfoCellDidEndEdit) {
        cell.showInfoCellDidEndEdit = ^(ShowInfoCell * _Nonnull sCell, UITextField * _Nonnull textField) {
            [weakS handleShowInfoCell:sCell didEndEditWith:textField];
        };
    }
    
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    ShowInfoCell *sCell = (ShowInfoCell *)cell;
    [sCell updateInfoWithModel:self.dataSouce[indexPath.section][indexPath.row]];
}

#pragma mark - UICollectionViewDelegate

// --- //

#pragma mark - ChangeFrameLayoutDelegate

- (CGSize)changeFrameLayout:(ChangeFrameLayout *)layout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSValue *sizeValue = self.createCellSizeData[indexPath.row];
    return [sizeValue CGSizeValue];
}

- (BOOL)changeFrameLayoutShouldFixedFirstColumnItem:(ChangeFrameLayout *)layout {
    return YES;
}

#pragma mark - lazy load

- (NSMutableArray<NSMutableArray<ShowInfoModel *> *> *)dataSouce {
    if (!_dataSouce) {
        _dataSouce = [[NSMutableArray alloc] init];
        CFAbsoluteTime refTime = CFAbsoluteTimeGetCurrent();
        NSLog(@"创建DataModel循环开始: start time 0.000000");
        for (NSInteger i = 0; i < self.sectionControlData.count; i++) {
            NSMutableArray <ShowInfoModel *>*createArray = [ItemModelCreateUnit createShowInfoModelWithColumnCount:self.createCellSizeData.count];
            [_dataSouce addObject:createArray];
        }
        NSLog(@"创建DataModel循环开始: after busy %f", CFAbsoluteTimeGetCurrent() - refTime);
    }
    return _dataSouce;
}

- (NSMutableArray<NSValue *> *)createCellSizeData {
    if (!_createCellSizeData) {
        _createCellSizeData = [[NSMutableArray alloc] init];
        for (NSInteger idx = 0; idx < 16; idx++) {
            CGSize size = CGSizeMake([ItemModelCreateUnit defaultWidthForItemAtIndex:idx], ItemModelCreateUnit.defaultHeight);
            [_createCellSizeData addObject:[NSValue valueWithCGSize:size]];
        }
    }
    return _createCellSizeData;
}

- (NSMutableArray *)sectionControlData {
    if (!_sectionControlData) {
        _sectionControlData = [[NSMutableArray alloc] initWithCapacity:100];
        for (NSInteger i = 0; i < 100; i++) {
            [_sectionControlData addObject:@(i)];
        }
    }
    return _sectionControlData;
}


@end
