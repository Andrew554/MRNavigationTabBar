//
//  MRHomeViewController.m
//  LabelNavigationController
//
//  Created by Andrew554 on 16/7/2.
//  Copyright © 2016年 Andrew554. All rights reserved.
//

#import "MRHomeViewController.h"
#import "MROneViewController.h"

#define MRScreenW [UIScreen mainScreen].bounds.size.width;
#define MRScreenH [UIScreen mainScreen].bounds.size.height;

@interface MRHomeViewController ()<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *titleScrollView;

@property (weak, nonatomic) IBOutlet UIScrollView *contentScrollView;

/**
 *  选中按钮
 */
@property (nonatomic, weak) UIButton *selectedBtn;

@end

@implementation MRHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 取消系统自动设置第一个子scrollView的contentInset
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    // 添加子控制器
    [self addChildViewControllers];
    
    // 添加标签栏
    [self addNavigationLabels];
    
    // 默认滑动到第一个tab, 显示第一个控制器view
    [self scrollViewDidEndScrollingAnimation: self.contentScrollView];
}

/**
 *  添加子控制器
 */
- (void)addChildViewControllers {
    
    MROneViewController *vc1 = [[MROneViewController alloc] init];
    vc1.title = @"C";
    [self addChildViewController:vc1];
    
    MROneViewController *vc2 = [[MROneViewController alloc] init];
    vc2.title = @"JAVA";
    [self addChildViewController:vc2];
    
    MROneViewController *vc3 = [[MROneViewController alloc] init];
    vc3.title = @"OC";
    [self addChildViewController:vc3];
    
    MROneViewController *vc4 = [[MROneViewController alloc] init];
    vc4.title = @"Swift";
    [self addChildViewController:vc4];
    
    MROneViewController *vc5 = [[MROneViewController alloc] init];
    vc5.title = @"JS";
    [self addChildViewController:vc5];
    
    MROneViewController *vc6 = [[MROneViewController alloc] init];
    vc6.title = @"JQuery";
    [self addChildViewController:vc6];
    
    MROneViewController *vc7 = [[MROneViewController alloc] init];
    vc7.title = @"Html";
    [self addChildViewController:vc7];
    
    CGSize size = [UIScreen mainScreen].bounds.size;
    
    self.contentScrollView.contentSize = CGSizeMake(self.childViewControllers.count * size.width, size.height);
    
    self.contentScrollView.pagingEnabled = YES;
    
    self.contentScrollView.bounces = NO;
}

/**
 *  添加导航标签栏
 */
- (void)addNavigationLabels {
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width/5;
    
    CGFloat height = self.titleScrollView.frame.size.height;
    
    for (NSInteger i = 0; i < self.childViewControllers.count; i++) {
        
        UIButton *navigationLabel = [[UIButton alloc] init];
        
        navigationLabel.tag = i;
        
        navigationLabel.frame = CGRectMake(i * width, 0, width, height);
        
        [navigationLabel setTitle:[self.childViewControllers[i] title] forState:UIControlStateNormal];
        
        [navigationLabel setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        
        [navigationLabel setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        
        navigationLabel.backgroundColor = [UIColor colorWithRed:arc4random_uniform(100)/100.0 green:arc4random_uniform(100)/100.0 blue:arc4random_uniform(100)/100.0 alpha:1.0];
        
        [navigationLabel addTarget:self action:@selector(tap:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.titleScrollView addSubview:navigationLabel];
    }
    
    self.titleScrollView.contentSize = CGSizeMake(width * self.childViewControllers.count, height);
    
    self.titleScrollView.bounces = NO;
}


/**
 *  手势事件
 */
- (void)tap:(UIButton *)btn {
    
    NSLog(@"bool %i", btn.selected);
    
    self.selectedBtn.selected = NO;
    
    NSInteger index = btn.tag;
    
    // 定位到指定位置
    CGPoint offset = self.contentScrollView.contentOffset;
    
    offset.x = index * MRScreenW;
    
    [self.contentScrollView setContentOffset:offset animated:YES];
    
    btn.selected = YES;
    
    self.selectedBtn = btn;
}


#pragma mark - <UIScrollViewDelegate>

/**
 *  当scrollView进行动画结束的时候会调用这个方法, 例如调用[self.contentScrollView setContentOffset:offset animated:YES];方法的时候
 */
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    
    // 一些临时变量
    CGFloat width = scrollView.frame.size.width;
    CGFloat height = scrollView.frame.size.height;
    CGFloat offsetX = scrollView.contentOffset.x;
    
    // 当前控制器需要显示的控制器的索引
    NSInteger index = offsetX / width;
    
    // 让对应的顶部标题居中显示
    UIButton *label = self.titleScrollView.subviews[index];
    CGPoint titleOffsetX = self.titleScrollView.contentOffset;
    titleOffsetX.x = label.center.x - width/2;
    // 左边偏移量边界
    if(titleOffsetX.x < 0) {
        titleOffsetX.x = 0;
    }
    
    CGFloat maxOffsetX = self.titleScrollView.contentSize.width - width;
    // 右边偏移量边界
    if(titleOffsetX.x > maxOffsetX) {
        titleOffsetX.x = maxOffsetX;
    }
    
    // 修改偏移量
    self.titleScrollView.contentOffset = titleOffsetX;
    
    // 取出需要显示的控制器
    UIViewController *willShowVc = self.childViewControllers[index];
    
    // 如果当前位置的控制器已经显示过了，就直接返回，不需要重复添加控制器的view
    if([willShowVc isViewLoaded]) return;
    
    // 如果你没有显示过，则将控制器的view添加到contentScrollView上
    willShowVc.view.frame = CGRectMake(index * width, 0, width, height);
    
    [scrollView addSubview:willShowVc.view];
}


/**
 *  当手指抬起停止减速的时候会调用这个方法
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    [self scrollViewDidEndScrollingAnimation:scrollView];
}


/**
 *  scrollView滚动时调用
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
}

@end
