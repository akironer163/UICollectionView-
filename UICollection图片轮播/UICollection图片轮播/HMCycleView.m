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

#define kSeed 100
static NSString *cellID = @"cellID";

@interface HMCycleView ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property(nonatomic, weak)UICollectionView *collectionView;
@property(nonatomic, weak)UIPageControl *pageContrl;
@property(nonatomic, strong)NSTimer *timer;

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

//设置第一个显示的cell
- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:_arrayList.count * kSeed * 0.5 inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
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

//collectionView停止减速的时候会调用这个方法
//用这个代理方法 解决第一个cell和最后一个cell不能继续滚动的问题
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    //获取当前cell
    HMCollectionViewCell *currentCell = [[self.collectionView visibleCells]lastObject];
    
    //当前cell的indexPath
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:currentCell];
    
    //获取collectionView里一共有多少个cell
    NSInteger itemCount = [self.collectionView numberOfItemsInSection:0];
    
    //当前cell是最后一个
    if (indexPath.item == itemCount - 1) {
        
        //让collectionView跳转到图片的个数 - 1个item
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:_arrayList.count * kSeed - 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    }
    
    //当前cell是第一个
    if (indexPath.item == 0) {
        
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:_arrayList.count * kSeed inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    //把定时器给停掉
    self.timer.fireDate = [NSDate distantFuture];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    //从现在开始隔2秒钟以后，开火
    self.timer.fireDate = [NSDate dateWithTimeIntervalSinceNow:2];
}

#pragma mark - 定时器方法 让collectionView开始滚动
- (void)scrollPicture {
    
    //1.获取当前偏移量x值
    CGFloat offsetX = self.collectionView.contentOffset.x;
    
    //2.每调用一次这个方法，x偏移量就加一个collectionView的宽度
    offsetX += self.collectionView.bounds.size.width;
    
    //3.把偏移量重新设置给collectionView
    [self.collectionView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
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
    
    //3.添加计时器
    //timerInterval：以秒为单位的时间
    //target:调用方法的对象
    //selector:调用的方法
    //repeats:是否重复
    //每隔1秒钟，会调用一次self的playPicture方法
    NSTimer *timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(scrollPicture) userInfo:nil repeats:YES];
    
    //以通用模式把计时器添加到运行循环
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    
    self.timer = timer;
}

- (void)setArrayList:(NSArray<UIImage *> *)arrayList {
    _arrayList = arrayList;
    
    self.pageContrl.numberOfPages = _arrayList.count;
}

//当collectionView被移除的时候，停掉计数器
- (void)removeFromSuperview {
    [super removeFromSuperview];
    
    [self.timer invalidate];
}

@end
