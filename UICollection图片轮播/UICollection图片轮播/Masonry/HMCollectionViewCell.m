//
//  HMCollectionViewCell.m
//  UICollection图片轮播
//
//  Created by user on 16/8/21.
//  Copyright © 2016年 user. All rights reserved.
//

#import "HMCollectionViewCell.h"
#import "Masonry.h"

@interface HMCollectionViewCell ()

@property (nonatomic, weak)UIImageView *imageView;

@end
@implementation HMCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.backgroundColor = [UIColor magentaColor];
    
    self.imageView = imageView;
    
    [self.contentView addSubview:imageView];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
}

- (void)setImage:(UIImage *)image {
    _image = image;
    
    self.imageView.image = _image;
}
@end
