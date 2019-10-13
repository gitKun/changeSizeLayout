//
//  PlaceholderCell.m
//  CollectionViewRefreshDemo
//
//  Created by DR_Kun on 2019/10/11.
//  Copyright © 2019 DR_Kun. All rights reserved.
//

#import "PlaceholderCell.h"

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
        self.backgroundColor = [UIColor colorWithRed:(arc4random()%255 / 255.0) green:(arc4random()%255 / 255.0) blue:(arc4random()%255 / 255.0) alpha:1];
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
