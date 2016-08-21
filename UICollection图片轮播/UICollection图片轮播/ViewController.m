//
//  ViewController.m
//  UICollection图片轮播
//
//  Created by user on 16/8/21.
//  Copyright © 2016年 user. All rights reserved.
//

#import "ViewController.h"
#import "HMCycleView.h"
#import "Masonry.h"

@interface ViewController ()

@end

@implementation ViewController {
    
    //存储图片的数组
    NSArray<UIImage *> *_arrayList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    
    [self loadData];
    
}

- (void)setupUI {
    HMCycleView *cycleView = [[HMCycleView alloc] init];
    cycleView.backgroundColor = [UIColor orangeColor];
    
    [self.view addSubview:cycleView];
    
    [cycleView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.left.right.equalTo(self.view);
        make.height.equalTo(@100);
    }];
    
}

- (void)loadData {
    
    NSMutableArray<UIImage *> *arrayM = [[NSMutableArray alloc] init];
    
    for (NSInteger i = 0; i < 5; i++) {
        
        NSURL *url = [[NSBundle mainBundle] URLForResource:[NSString stringWithFormat:@"Home_Scroll_%02zd.jpg",i + 1] withExtension:nil];
        NSData *data = [NSData dataWithContentsOfURL:url];
        UIImage *image = [UIImage imageWithData:data];
        
        [arrayM addObject:image];
    }
    
    NSURL *url = [NSURL URLWithString:@"http://a.hiphotos.baidu.com/zhidao/pic/item/72f082025aafa40fa38bfc55a964034f79f019ec.jpg"];
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    [arrayM addObject:[UIImage imageWithData:data]];
    
    _arrayList = arrayM.copy;
}
@end
