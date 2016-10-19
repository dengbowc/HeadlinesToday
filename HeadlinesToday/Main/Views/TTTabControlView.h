//
//  TTTabControlView.h
//  TouTiaoTabControl
//
//  Created by 瑶波波 on 16/10/13.
//  Copyright © 2016年 dengbowc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TTTabControlView : UIView

/**
 根据标题数组初始化
 
 @param titles 顶部的标题标签数组
 @param frame 控件frame
 @return self
 */
- (instancetype)initWithTitles:(NSArray <NSString *>*)titles frame:(CGRect)frame;

@end
