//
//  TTAppDelegate.m
//  HeadlinesToday
//
//  Created by 瑶波波 on 16/10/13.
//  Copyright © 2016年 dengbowc. All rights reserved.
//

#import "TTAppDelegate.h"
#import "TTBaseViewController.h"

@implementation TTAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    TTBaseViewController *toVC = [[TTBaseViewController alloc]init];
    self.window.rootViewController = toVC;
    [self.window makeKeyAndVisible];
    return YES;
}

@end
