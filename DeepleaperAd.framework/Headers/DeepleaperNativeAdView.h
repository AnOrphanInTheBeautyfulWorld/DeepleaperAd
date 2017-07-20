//
//  DeepleaperNativeAdView.h
//  DLNativeAdDemo
//
//  Created by 刘畅 on 2017/6/21.
//  Copyright © 2017年 刘畅. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeepleaperOriginalityView.h"
#import "DeepleaperAdditionalView.h"
#import "DeepleaperLogoView.h"


@class DeepleaperNativeAdView;

typedef enum {
    NATIVE_UNKNOW = 0, // 未知
    NATIVE_BIGIMAGE = 1, // PIC交互模板
    NATIVE_BIGVIDEO = 2, // Video交互模板
    NATIVE_SMALLIMAGE = 3, // 通用信息流模板
    NATIVE_SINGLETITLE = 4, // 纯文字信息流模板
    NATIVE_SINGLEIMAGE = 5, // PIC垂直图片模板
    NATIVE_SINGLEVIDEO = 6, // Video垂直视频模板
    NATIVE_THREEIMAGES = 7, // 组图展示模板
} NativeType;//native广告模板样式

typedef enum {
    ADDITIONAL_NONE = 0, // 未知
    ADDITIONAL_PHONE = 1, // 拨打电话
    ADDITIONAL_DOWNLOAD = 2, // APP下载
    ADDITIONAL_FORM = 3, // 落地页跳转
} AdditionalType;//native广告附加样式

@protocol DeepleaperNativeAdViewDelegate <NSObject>
-(void)didLoadNativeAdView:(nonnull DeepleaperNativeAdView*)nativeAdView;
-(void)didCloseNativeAdView:(nonnull DeepleaperNativeAdView*)nativeAdView;
-(void)didFailLoadNativeAdView:(nullable NSError*)error;
@end

@interface DeepleaperNativeAdView : UIView
/**
 广告是否已经关闭；
 
 */
@property(nonatomic,assign)BOOL isClosed;
/**
 是否采用默认的自动布局；
 是：将会用autoLayout自动布局，您同样可以指定各个控件的属性（如字体，字号，颜色），但是您不应该再指定控件的位置；
 否：请设置autoMode为NO；然后根据NativeType模板类型和配置title，originalityView，additionalView，logoView和他们的子控件的位置和属性；
 
 */
@property(nonatomic,assign)BOOL autoMode;//default is YES；
/**
 自动布局采用时，和边框的间距；
 
 */
@property (nonatomic,assign)CGFloat space;//default is 10.0；
/**
 如果有图片，图片的宽高比（例：9/16）；
 
 */
@property (nonatomic,assign,readonly)CGFloat scale;
/**
 模板类型；
 
 */
@property(nonatomic, assign, readonly)NativeType nativeType;
/**
 附加类型；
 
 */
@property(nonatomic, assign, readonly)AdditionalType additionalType;
/**
 标题；
 
 */
@property(nonatomic,strong,nullable) UILabel* title;
/**
 创意视图；
 
 */
@property(nonatomic,strong,nonnull) DeepleaperOriginalityView* originalityView;
/**
 附加视图；
 
 */
@property(nonatomic,strong,nullable) DeepleaperAdditionalView* additionalView;
/**
 logo视图；
 
 */
@property(nonatomic,strong,nonnull) DeepleaperLogoView* logoView;
/**
 不需要调用；
 
 */
-(nullable instancetype)initWithToken:(nonnull id)token andData:(nonnull id)data;
/**
 不需要设置；
 
 */
@property(weak,nonatomic,nullable) id <DeepleaperNativeAdViewDelegate> delegate;
@end


