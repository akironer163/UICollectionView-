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
#import "HMCollectionViewCell.h"

#define kSeed 100;
static NSString *cellID = @"cellID";

@interface HMCycleView ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property(nonatomic, weak)UICollectionView *collectionView;
@property(nonatomic, weak)UIPageControl *pageContrl;

@end

@implementation HMCycleView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.arrayList.count * kSeed;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    HMCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    
    cell.image = _arrayList[indexPath.item % _arrayList.count];
    
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat offsetX = scrollView.contentOffset.x;
    CGFloat page = offsetX / scrollView.bounds.size.width;
    
    self.pageContrl.currentPage = (NSInteger)(page + 0.5) % _arrayList.count;
    
}

#pragma mark - 搭建界面
- (void)setupUI {
    
    //1.添加collectionView
    HMCollectionViewFlowLayout *flowLayout = [[HMCollectionViewFlowLayout alloc] init];
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    collectionView.backgroundColor = [UIColor whiteColor];
    
    collectionView.pagingEnabled = YES;
    collectionView.showsHorizontalScrollIndicator = NO;

    collectionView.dataSource = self;
    collectionView.delegate = self;
    
    self.collectionView = collectionView;
    
    [collectionView registerClass:[HMCollectionViewCell class] forCellWithReuseIdentifier:cellID];
    
    
    
    [self addSubview:collectionView];
    
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.left.right.equalTo(self);
        make.bottom.equalTo(self).offset(-20);
    }];
    
    //2.添加pageContrl
    UIPageControl *pageContrl = [[UIPageControl alloc] init];
    pageContrl.pageIndicatorTintColor = [UIColor colorWithWhite:0.8 alpha:1.0];
    pageContrl.currentPageIndicatorTintColor = [UIColor colorWithWhite:0.2 alpha:1.0];
    
    [self addSubview:pageContrl];
    
    self.pageContrl = pageContrl;
    
    [pageContrl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(collectionView);
        make.top.equalTo(collectionView.mas_bottom).offset(-8);
    }];
    
}

- (void)setArrayList:(NSArray<UIImage *> *)arrayList {
    _arrayList = arrayList;
    
    self.pageContrl.numberOfPages = _arrayList.count;
}

@end
