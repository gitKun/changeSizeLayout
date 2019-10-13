//
//  ShowInfoCell.m
//  CollectionViewRefreshDemo
//
//  Created by DR_Kun on 2019/10/6.
//  Copyright © 2019 DR_Kun. All rights reserved.
//

#import "ShowInfoCell.h"
#import "ShowInfoModel.h"
#import <Masonry/Masonry.h>
#import "DRMacroDefine.h"

@interface ShowInfoCell ()<UITextFieldDelegate>

@property (nonatomic, strong) UILabel *infoLabel;

@property (nonatomic, strong) UITextField *textField;

/// 在没有数据状态下呈现为灰色(0X000000A9)并且拦截点击事件
/// 在有数据状态下为透明色(clearColor) 拦截事件后通知到对应的 cell 子视图
@property (nonatomic, strong) UIControl *drMaskView;

@property (nonatomic, assign) BOOL noDataStatus;

/// 圆角并且描边的 layer
@property (nonatomic, strong) CAShapeLayer *borderLayer;

@end


@implementation ShowInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initUIElement];
    }
    return self;
}

#pragma mark - Create UI element

- (void)initUIElement {
    self.backgroundColor = [UIColor whiteColor];
    self.noDataStatus = YES;
    UILabel *label = ({
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = [UIColor redColor];
        label.text = @"xxx";
        label.lineBreakMode = NSLineBreakByTruncatingMiddle;
        label;
    });
    [self.contentView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).with.offset(3);
        make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-3);
        make.left.equalTo(self.contentView.mas_left).with.offset(3);
        make.right.equalTo(self.contentView.mas_right).with.offset(-3);
    }];
    self.infoLabel = label;
    [self.contentView addSubview:self.textField];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(label);
    }];
    [self.contentView addSubview:self.drMaskView];
    [self.drMaskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
}

#pragma mark - Override

- (void)layoutSublayersOfLayer:(CALayer *)layer {
    [super layoutSublayersOfLayer:layer];
    CGRect borderRect = self.borderLayer.bounds;
    if (!CGRectEqualToRect(self.bounds, borderRect)) {
        [self updateborderLayer];
    }
}

- (void)updateborderLayer {
    CAShapeLayer *borderLayer = self.borderLayer;
    
    CGFloat _cornerLineWidth = 0.5;
    CGRect viewBounds = self.bounds;
    
    CGRect cornerRect = viewBounds;
    UIColor *offsetLineColor = [UIColor redColor];
    CGFloat offsetLineWidth = _cornerLineWidth;
    
    CGFloat spec = 1.0;
    
    // 因为 iOS 线的宽度是从 0 往两边均匀分配的，所以有边框时要计算实际的圆角的边框
    cornerRect = CGRectMake(CGRectGetMinX(cornerRect) + spec + offsetLineWidth * 0.5, CGRectGetMinY(cornerRect) + offsetLineWidth * 0.5 + spec, CGRectGetWidth(cornerRect) - offsetLineWidth * 0.5 - 2 * spec, CGRectGetHeight(cornerRect) - offsetLineWidth * 0.5 - 2*spec);
    UIBezierPath *cornerPath = [self coverLayerPathWihtRect:cornerRect];
    
    borderLayer.path = cornerPath.CGPath;
    borderLayer.fillColor = UIColor.clearColor.CGColor;
    borderLayer.lineWidth = offsetLineWidth;
    borderLayer.strokeColor = offsetLineColor.CGColor;
}

#pragma mark - public

- (void)updateInfoWithModel:(ShowInfoModel *)model {
    self.infoLabel.text = model.inputString;
    self.textField.text = model.inputString;
    [self changeNoDataStatus:model.showDataStatus];
}

- (void)changeNoDataStatus:(BOOL)noData {
    self.noDataStatus = noData;
    self.drMaskView.backgroundColor = noData ? [UIColor colorWithWhite:0 alpha:0.75] : [UIColor clearColor];
}



#pragma mark - UI Action

- (void)drMaskViewClicked:(UIControl *)control {
    if (self.noDataStatus) {
        NSLog(@"等待数据填充!");
        return;
    }
    
    // 这里可以让 tf 成为第一响应者并且隐藏 label
    self.textField.hidden = NO;
    self.infoLabel.hidden = YES;
    // 即使手动调用成为第一响应者如果代理返回NO,让然不会弹出键盘样式
    [self.textField becomeFirstResponder];
}

#pragma mark - UITextFieldDelegate

- (void)textFieldChangeText:(UITextField *)textField {
    if (self.showInfoCellDidChangeTextInfo) {
        self.showInfoCellDidChangeTextInfo(self, textField, textField.text);
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    // 根据 callback block 来返回状态
    if (self.showInfoCellShouldBegainEdit) {
        return self.showInfoCellShouldBegainEdit(self, self.textField);
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    // 调用 callback
    if (self.showInfoCellDidBegainEdit) {
        self.showInfoCellDidBegainEdit(self, textField);
    }
    // UI 变更
    self.layer.borderColor = [UIColor colorWithRed:1.0/255.0 green:165.0/255.0 blue:245.0/255.0 alpha:1.0].CGColor;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    // 赋值
    
    // 回调 在 textFieldDidEndEditing: 结束后回调
    OnBlockExit(callBack){
        if (self.showInfoCellDidEndEdit) {
            NSLog(@"showInfoCellDidEndEdit() ____#");
            self.showInfoCellDidEndEdit(self, textField);
        }
    };
    // UI 变更
    self.layer.borderColor = [UIColor colorWithRed:216.0/255.0 green:216.0/255.0 blue:216.0/255.0 alpha:1.0].CGColor;
    self.textField.hidden = YES;
    self.infoLabel.hidden = NO;
    
    // 测试调用顺序
    NSLog(@"textFieldDidEndEditing: ____#");
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.textField resignFirstResponder];
    return NO;
}



#pragma mark - getter

- (CAShapeLayer *)borderLayer {
    if (!_borderLayer) {
        _borderLayer = [CAShapeLayer layer];
        [self.layer addSublayer:_borderLayer];
    }
    return _borderLayer;
}

- (UIControl *)drMaskView {
    if (!_drMaskView) {
        _drMaskView = [[UIControl alloc] initWithFrame:CGRectZero];
        _drMaskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.75];
        [_drMaskView addTarget:self action:@selector(drMaskViewClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _drMaskView;
}


- (UITextField *)textField {
    if (!_textField) {
        _textField = [[UITextField alloc] initWithFrame:CGRectZero];
        _textField.delegate = self;
        _textField.hidden = YES;
        _textField.textColor = UIColor.redColor;
        _textField.font = [UIFont systemFontOfSize:14];
        [_textField addTarget:self action:@selector(textFieldChangeText:) forControlEvents:UIControlEventEditingChanged];
    }
    return _textField;
}

#pragma mark -  tools: 圆角并且边框的处理

// TODO: 下面两的方法可以抽取到 UIView 的 ext 中

/*
 https://github.com/gitKun/DRCornerView/blob/master/Class/DRCornerAndBorder/UIView%2BDRCornerBorderStyle.m
 */
- (UIBezierPath *)coverLayerPathWihtRect:(CGRect)cornerRect {
    CGFloat width = CGRectGetWidth(cornerRect);
    CGFloat height = CGRectGetHeight(cornerRect);
    CGFloat x = CGRectGetMinX(cornerRect);
    CGFloat y = CGRectGetMinY(cornerRect);
    CGFloat maxRadius = MIN(width, height) * 0.5;
    
    CGFloat topLeftRadius     = 2;
    CGFloat topRightRadius    = 2;
    CGFloat bottomRightRadius = 2;
    CGFloat bottomLeftRadius  = 2;
    
    // 判断
    ({
        topLeftRadius = topLeftRadius < maxRadius ? topLeftRadius : maxRadius;
        topRightRadius = topLeftRadius < maxRadius ? topRightRadius : maxRadius;
        bottomRightRadius = bottomRightRadius < maxRadius ? bottomRightRadius : maxRadius;
        bottomLeftRadius = bottomLeftRadius < maxRadius ? bottomLeftRadius : maxRadius;
    });
    

    // 声明各个点 topLeft -> A & B, topRight -> C & D, bottomRight -> E & F, bottomLeft -> G & H;
    CGPoint topLeftPoint     = CGPointMake(x, y);
    CGPoint topRightPoint    = CGPointMake(width, y);
    CGPoint bottonRightPoint = CGPointMake(width, height);
    CGPoint bottonLeftPoint  = CGPointMake(x, height);
    CGPoint aPoint = topLeftPoint, bPoint = topLeftPoint, cPoint = topRightPoint, dPoint = topRightPoint, ePoint = bottonRightPoint, fPoint = bottonRightPoint, gPoint = bottonLeftPoint, hPoint = bottonLeftPoint;

    // 声明控制点(有控制点则为圆角处理---实际是根据定点对应的两坐标点是否一致来进行控制的,否则为非圆角处理)
    CGPoint nullControlPoint = CGPointMake(-100, -100);// 为了逻辑严谨，这个点应该修改为 NaN 这样的形式
    CGPoint aControlPoint = nullControlPoint, bControlPoint = nullControlPoint, cControlPoint = nullControlPoint, dControlPoint = nullControlPoint, eControlPoint = nullControlPoint, fControlPoint = nullControlPoint, gControlPoint = nullControlPoint, hControlPoint = nullControlPoint;
    // 定义圆角常量
    CGFloat controlPointOffsetRatio = 0.552;
    if (topLeftRadius > 1) {
        CGFloat offset = controlPointOffsetRatio * topLeftRadius;
        aPoint = CGPointMake(aPoint.x, aPoint.y + topLeftRadius);
        bPoint = CGPointMake(bPoint.x + topLeftRadius, bPoint.y);
        aControlPoint = CGPointMake(aPoint.x          , aPoint.y - offset);
        bControlPoint = CGPointMake(bPoint.x - offset , bPoint.y         );
    }
    if (topRightRadius > 1) {
        CGFloat offset = controlPointOffsetRatio * topRightRadius;
        cPoint = CGPointMake(cPoint.x - topRightRadius, cPoint.y);
        dPoint = CGPointMake(dPoint.x, dPoint.y + topRightRadius);
        cControlPoint = CGPointMake(cPoint.x + offset , cPoint.y         );
        dControlPoint = CGPointMake(dPoint.x          , dPoint.y - offset);
    }
    if (bottomRightRadius > 1) {
        CGFloat offset = controlPointOffsetRatio * bottomRightRadius;
        ePoint = CGPointMake(ePoint.x, ePoint.y - bottomRightRadius);
        fPoint = CGPointMake(fPoint.x - bottomRightRadius, fPoint.y);
        eControlPoint = CGPointMake(ePoint.x          , ePoint.y + offset);
        fControlPoint = CGPointMake(fPoint.x + offset , fPoint.y         );
    }
    if (bottomLeftRadius > 1) {
        CGFloat offset = controlPointOffsetRatio * bottomLeftRadius;
        gPoint = CGPointMake(gPoint.x + bottomLeftRadius, gPoint.y);
        hPoint = CGPointMake(hPoint.x, hPoint.y - bottomLeftRadius);
        gControlPoint = CGPointMake(gPoint.x - offset , gPoint.y);
        hControlPoint = CGPointMake(hPoint.x, hPoint.y + offset);
    }
    // 划线顺序: B -> C -> D -> E -> F -> G -> H -> A -> B(ClosePath);
    UIBezierPath *cornerPath = [UIBezierPath bezierPath];
    [cornerPath moveToPoint:bPoint];
    [cornerPath addLineToPoint:cPoint];
    if (!CGPointEqualToPoint(cPoint, dPoint)) {
        [cornerPath addCurveToPoint:dPoint controlPoint1:cControlPoint controlPoint2:dControlPoint];
    }
    [cornerPath addLineToPoint:ePoint];
    if (!CGPointEqualToPoint(ePoint, fPoint)) {
        [cornerPath addCurveToPoint:fPoint controlPoint1:eControlPoint controlPoint2:fControlPoint];
    }

    [cornerPath addLineToPoint:gPoint];
    if (!CGPointEqualToPoint(gPoint, hPoint)) {
        [cornerPath addCurveToPoint:hPoint controlPoint1:gControlPoint controlPoint2:hControlPoint];
    }
    [cornerPath addLineToPoint:aPoint];
    if (!CGPointEqualToPoint(aPoint, bPoint)) {
        [cornerPath addCurveToPoint:bPoint controlPoint1:aControlPoint controlPoint2:bControlPoint];
    }
    [cornerPath closePath];
    return cornerPath;
}

- (void)onlyBorder {
    CAShapeLayer *layer = self.borderLayer;
    layer.frame = self.bounds;
    
    CGFloat lineWith = 0.5;
    UIColor *lineColor = UIColor.redColor;
    
    CGRect viewBouns = self.bounds;
    CGFloat x = 0;//CGRectGetMinX(viewBouns);
    CGFloat y = 0;//CGRectGetMinY(viewBouns);
    CGFloat width = CGRectGetWidth(viewBouns);
    CGFloat height = CGRectGetHeight(viewBouns);
    CGFloat offsetLineWidth = lineWith * 0.5;
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    UIEdgeInsets edg = UIEdgeInsetsMake(1, 1, 1, 1);
    
    
    // top
    ({
        CGFloat offsetX = MAX(0, MIN(width, edg.left));
        CGFloat offsetY = MAX(offsetLineWidth, MIN(height - offsetLineWidth, edg.top + offsetLineWidth)) ;
        CGPoint start = CGPointMake(x + offsetX, y + offsetY);
        offsetX = MAX(0, MIN(width, edg.right));
        CGPoint end = CGPointMake(width - offsetX, y + offsetY);
        [path moveToPoint:start];
        [path addLineToPoint:end];
    });
    
    // bottom
    ({
        CGFloat offsetX = MAX(0, MIN(width, edg.left));
        CGFloat offsetY = MAX(offsetLineWidth, MIN(height - offsetLineWidth, edg.bottom + offsetLineWidth)) ;
        CGPoint start = CGPointMake(x + offsetX, height - offsetY);
        offsetX = MIN(width, edg.right);
        CGPoint end = CGPointMake(width - offsetX, height - offsetY);
        [path moveToPoint:start];
        [path addLineToPoint:end];
    });
    
    // left
    ({
        CGFloat offsetX = MAX(0, MIN(width - offsetLineWidth, edg.left + offsetLineWidth));
        CGFloat offsetY = MAX(0, MIN(height, edg.top));
        CGPoint start = CGPointMake(x + offsetX, y + offsetY);
        offsetY = MAX(0, MIN(height, edg.bottom));
        CGPoint end = CGPointMake(x + offsetX, height - offsetY);
        [path moveToPoint:start];
        [path addLineToPoint:end];
    });
    
    // right
    ({
        //UIEdgeInsets edg = style.dr_rightBorderEdg;
        CGFloat offsetX = MAX(0, MIN(width - offsetLineWidth, edg.right + offsetLineWidth));
        CGFloat offsetY = MAX(0, MIN(height, edg.top));
        CGPoint start = CGPointMake(width - offsetX, y + offsetY);
        offsetY = MAX(0, MIN(height, edg.bottom));
        CGPoint end = CGPointMake(width - offsetX, height - offsetY);
        [path moveToPoint:start];
        [path addLineToPoint:end];
    });
    
    
    layer.path = path.CGPath;
    layer.lineWidth = lineWith;
    layer.strokeColor = lineColor.CGColor;
    layer.fillColor = [UIColor clearColor].CGColor;
}

@end
