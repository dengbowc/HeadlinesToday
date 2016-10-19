//
//  TTBaseViewController.m
//  HeadlinesToday
//
//  Created by 瑶波波 on 16/10/13.
//  Copyright © 2016年 dengbowc. All rights reserved.
//

#import "TTBaseViewController.h"
#import "TTTabControlView.h"

@interface TTBaseViewController ()

@end

@implementation TTBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addViews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addViews {
    self.automaticallyAdjustsScrollViewInsets = NO;
    TTTabControlView *aView = [[TTTabControlView alloc]initWithTitles:@[@"推荐" ,@"热点" ,@"体育" ,@"北京" ,@"娱乐" ,@"视频" ,@"社会" ,@"推荐" ,@"热点" ,@"体育" ,@"北京" ,@"娱乐" ,@"视频" ,@"社会"] frame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height)];
    [self.view addSubview:aView];
}

@end
