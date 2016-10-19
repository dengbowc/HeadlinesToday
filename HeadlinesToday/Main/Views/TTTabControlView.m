//
//  TTTabControlView.m
//  TouTiaoTabControl
//
//  Created by 瑶波波 on 16/10/13.
//  Copyright © 2016年 dengbowc. All rights reserved.
//

#define kTITLEHEIGHT 50
#define kSTATUSBARH  20
#define kTAGPREFIX   10000

#import "TTTabControlView.h"

@interface TTTabControlView () <UIScrollViewDelegate>

@property (nonatomic,strong) UIScrollView *titlesScroll;

@property (nonatomic,strong) UIScrollView *contentsScroll;

@property (nonatomic,strong) NSArray *titles;

@property (nonatomic,strong) NSMutableArray *topBtns;

// 当前索引
@property (nonatomic,assign) NSInteger currentIndex;

// 展示内容的tableView
@property (nonatomic ,strong) UITableView *table1;

@property (nonatomic ,strong) UITableView *table2;

@property (nonatomic ,strong) UITableView *table3;

@end

@implementation TTTabControlView

#pragma mark initial
- (instancetype)initWithTitles:(NSArray *)titles frame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.titles = titles;
        [self editTopScroll];
        [self editContentScroll];
        _currentIndex = 0;
    }
    return self;
}


#pragma mark editViews
/**
 初始化标题栏,添加按钮并给出contentsize
 */
- (void)editTopScroll {
    CGFloat left = 0;
    NSInteger index = 0;
    for (NSString *title in self.titles) {
        UIButton *btn = [self loadBtn:title left:left];
        btn.tag = index + kTAGPREFIX;
        left += btn.frame.size.width;
        index++;
    }
    self.titlesScroll.contentSize = CGSizeMake(left, kTITLEHEIGHT);
}

- (void)editContentScroll {
    self.contentsScroll.delegate = self;
    [self.contentsScroll addSubview:self.table1];
    if (self.titles.count == 1) {
        self.contentsScroll.contentSize = self.contentsScroll.frame.size;
        return;
    }
    [self.contentsScroll addSubview:self.table2];
    if (self.titles.count == 2) {
        self.contentsScroll.contentSize = CGSizeMake(self.contentsScroll.frame.size.width * 2, self.contentsScroll.frame.size.height);
        return;
    }
    [self.contentsScroll addSubview:self.table3];
}


#pragma mark factory
- (UIButton *)loadBtn:(NSString *)text left:(CGFloat)left{
    UIButton *btn = [[UIButton alloc]init];
    [btn setTitle:text forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    if (left == 0) {
        btn.titleLabel.font = [UIFont systemFontOfSize:17];
    }
    btn.titleLabel.textColor = [UIColor whiteColor];
    [btn sizeToFit];
    btn.frame = CGRectMake(left, kSTATUSBARH, btn.frame.size.width + 20, kTITLEHEIGHT - kSTATUSBARH);
    [self.titlesScroll addSubview:btn];
    [self.topBtns addObject:btn];
    [btn addTarget:self action:@selector(titleClicked:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

- (UITableView *)getTableWithFrameLeft:(CGFloat)left {
    UITableView *table = [[UITableView alloc]initWithFrame:CGRectMake(left, 0, self.frame.size.width, self.frame.size.height - kTITLEHEIGHT)];
    [table registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    table.backgroundColor = [UIColor colorWithRed:arc4random()%256 / 255.0 green:arc4random()%256 / 255.0 blue:arc4random()%256 / 255.0 alpha:1.0]
    ;
    return table;
}


#pragma mark actions
- (void)titleClicked:(UIButton *)sender {
    self.currentIndex = sender.tag - kTAGPREFIX;
    if (self.currentIndex == 0) {
        [self.contentsScroll setContentOffset:CGPointMake(0, 0) animated:YES];
    }else if (self.currentIndex == self.titles.count - 1) {
        [self.contentsScroll setContentOffset:CGPointMake(self.frame.size.width * 2, 0) animated:YES];
    }else {
        [self.contentsScroll setContentOffset:CGPointMake(self.frame.size.width * 1, 0) animated:YES];
    }
}


#pragma mark private methods

/**
 点击标题编辑标题按钮状态

 @param index 点击按钮的索引
 */
- (void)editBtnState:(NSInteger)index {
    UIButton *lastbtn = self.topBtns[self.currentIndex];
    lastbtn.titleLabel.font = [UIFont systemFontOfSize:15];
    UIButton *thisBtn = self.topBtns[index];
    thisBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    // 改变选中按钮的位置，让其在titleScroll居中
    if (thisBtn.center.x > self.frame.size.width / 2 && thisBtn.center.x < self.titlesScroll.contentSize.width - self.frame.size.width / 2) {
        [self.titlesScroll setContentOffset:CGPointMake(thisBtn.center.x - self.frame.size.width / 2, 0) animated:YES];
    }else if (thisBtn.center.x < self.frame.size.width / 2) {
        [self.titlesScroll setContentOffset:CGPointMake(0, 0) animated:YES];
    }else if (thisBtn.center.x > self.titlesScroll.contentSize.width - self.frame.size.width / 2) {
         [self.titlesScroll setContentOffset:CGPointMake(self.titlesScroll.contentSize.width - self.frame.size.width, 0) animated:YES];
    }
}


#pragma mark scrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat offsetX = scrollView.contentOffset.x;
    // 分三种，第0页，中间页，最后一页
    if (self.currentIndex == 0) {
        // 如果是第0页
        if (offsetX == 0) {
            return;
        }
        self.currentIndex++;
        return;
    }
    if (self.currentIndex != 0 && self.currentIndex != self.titles.count - 1) {
        /*
         如果是中间页，分三种情况讨论
         1、如果是第1页，判断滑向的是下一页还是上一页，如果滑向上一页，即滑到第0页，contentscroll的offset不用回归到中间位置，currentIndex = 0；如果滑向下一页，则contentScroll的offset要居中，currentIndex++
         2、如果是中间页，则直接设offset居中，并根据方向currentIndex--或currentIndex++
         3、如果是最后一页的前一页，判断滑向的是下一页还是上一页，如果滑向下一页，即滑到最后一页，offset不用回归，currentIndex = titles.count - 1;如果滑向上一页，则offset居中，currentIndex--
         */
        if (self.currentIndex == 1) {
            if (offsetX == 0) {
                self.currentIndex--;
            }else if(offsetX == self.contentsScroll.frame.size.width * 2) {
                self.contentsScroll.contentOffset = CGPointMake(self.contentsScroll.frame.size.width, 0);
                self.currentIndex++;
            }
        }else if (self.currentIndex != 1 && self.currentIndex != self.titles.count - 2) {
            if (offsetX == 0) {
                self.currentIndex--;
            }else if(offsetX == self.contentsScroll.frame.size.width * 2) {
                self.currentIndex++;
            }
            self.contentsScroll.contentOffset = CGPointMake(self.contentsScroll.frame.size.width, 0);
        }else {
            if (offsetX == 0) {
                self.currentIndex--;
                self.contentsScroll.contentOffset = CGPointMake(self.contentsScroll.frame.size.width, 0);
            }else if(offsetX == self.contentsScroll.frame.size.width * 2) {
                self.currentIndex++;
            }
        }
        return;
    }
    
    if (self.currentIndex == self.titles.count - 1) {
        // 如果是最后一页
        if (offsetX == self.contentsScroll.frame.size.width * 2) {
            return;
        }
        self.currentIndex--;
    }
}


#pragma mark getters && setters
- (UIScrollView *)titlesScroll {
    if (!_titlesScroll) {
        _titlesScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, kTITLEHEIGHT)];
        _titlesScroll.backgroundColor = [UIColor redColor];
        [self addSubview:_titlesScroll];
        _titlesScroll.showsHorizontalScrollIndicator = NO;
    }
    return _titlesScroll;
}

- (UIScrollView *)contentsScroll {
    if (!_contentsScroll) {
        _contentsScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, kTITLEHEIGHT, self.frame.size.width, self.frame.size.height - kTITLEHEIGHT)];
        _contentsScroll.backgroundColor = [UIColor whiteColor];
        _contentsScroll.contentSize = CGSizeMake(self.frame.size.width * 3,_contentsScroll.frame.size.height);
        _contentsScroll.pagingEnabled = YES;
        [self addSubview:_contentsScroll];
    }
    return _contentsScroll;
}

- (NSMutableArray *)topBtns {
    if (!_topBtns) {
        _topBtns = [NSMutableArray array];
    }
    return _topBtns;
}

- (UITableView *)table1 {
    if (!_table1) {
        _table1 = [self getTableWithFrameLeft:0];
    }
    return _table1;
}

- (UITableView *)table2 {
    if (!_table2) {
        _table2 = [self getTableWithFrameLeft:self.frame.size.width];
    }
    return _table2;
}

- (UITableView *)table3 {
    if (!_table3) {
        _table3 = [self getTableWithFrameLeft:self.frame.size.width * 2];
    }
    return _table3;
}

- (void)setCurrentIndex:(NSInteger)currentIndex {
    NSLog(@"%zd",currentIndex);
    [self editBtnState:currentIndex];
    _currentIndex = currentIndex;
}

@end
