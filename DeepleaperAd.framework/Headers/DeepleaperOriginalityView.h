//
//  DeepleaperOriginalityView.h
//  testLayout
//
//  Created by 刘畅 on 2017/6/22.
//  Copyright © 2017年 刘畅. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DeepleaperOriginalityView : UIView

/**
 第一张图片View；
 
 */
@property(nonatomic,strong) UIImageView* firstImageView;
/**
 第二张图片View；
 
 */
@property(nonatomic,strong) UIImageView* secondImageView;
/**
 第三张图片View；
 
 */
@property(nonatomic,strong) UIImageView* thirdImageView;
/**
 播放图片View；
 
 */
@property(nonatomic,strong) UIImageView* PlayImageView;
/**
 文本内容；
 
 */
@property(nonatomic,strong) UILabel* originalityText;
@end
