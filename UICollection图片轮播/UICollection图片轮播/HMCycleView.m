//
//  HMCycleView.m
//  UICollection图片轮播
//
//  Created by user on 16/8/21.
//  Copyright © 2016年 user. All rights reserved.
//

#import "HMCycleView.h"
#import "HMCollectionViewFlowLayout.h"
#import "Masonry.h"

@implementation HMCycleView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

#pragma mark - 搭建界面
- (void)setupUI {
    
    //1.添加collectionView
    HMCollectionViewFlowLayout *flowLayout = [[HMCollectionViewFlowLayout alloc] init];
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    collectionView.backgroundColor = [UIColor redColor];
    
    [self addSubview:collectionView];
    
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.left.right.equalTo(self);
        make.bottom.equalTo(self).offset(-20);
    }];
    
    //2.添加pageContrl
    UIPageControl *pageContrl = [[UIPageControl alloc] init];
    pageContrl.pageIndicatorTintColor = [UIColor colorWithWhite:0.8 alpha:1.0];
    pageContrl.currentPageIndicatorTintColor = [UIColor colorWithWhite:0.2 alpha:1.0];
    pageContrl.numberOfPages = 5;
    
    [self addSubview:pageContrl];
    
    [pageContrl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(collectionView);
        make.top.equalTo(collectionView.mas_bottom).offset(-8);
    }];
    
}

@end
