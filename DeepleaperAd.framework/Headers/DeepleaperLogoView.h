//
//  DeepleaperLogoView.h
//  testLayout
//
//  Created by 刘畅 on 2017/6/22.
//  Copyright © 2017年 刘畅. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DeepleaperLogoView : UIView
/**
 广告标识；
 
 */
@property(nonatomic,strong) UILabel* adTag;
/**
 广告来源；
 
 */
@property(nonatomic,strong) UILabel* adSource;
/**
 关闭按钮；
 
 */
@property(nonatomic,strong) UIButton* closeButton;
@end
