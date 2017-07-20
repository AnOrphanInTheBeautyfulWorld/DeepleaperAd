//  
//  DeepleaperFeedAdManager.h
//  DeepleaperAdExample
//
//  Created by 刘畅 on 2017/7/7.
//  Copyright © 2017年 刘畅. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "DeepleaperNativeAdView.h"
#import "DeepleaperWebAdView.h"

typedef enum {
    FEEDAD_UNKNOW = 0,//未知
    FEEDAD_WEB = 1,//用webView渲染
    FEEDAD_NATIVE = 2,//用native控件渲染
}FeedAdType;//渲染类型

@protocol DeepleaperFeedAdManagerDelegate <NSObject>
@optional
/**
 native广告下载完成回调方法；
 
 - 参数 NativeAdView: native广告视图。
 */
-(void)didLoadNativeAdView:(nonnull DeepleaperNativeAdView*)nativeAdView;
/**
 native广告关闭回调方法；
 
 - 参数 NativeAdView: native广告视图。
 */
-(void)didCloseNativeAdView:(nonnull DeepleaperNativeAdView*)nativeAdView;
/**
 web广告下载完成回调方法；
 
 - 参数 webAdView: web广告视图。
 */
-(void)didLoadWebAdView:(nonnull DeepleaperWebAdView*)webAdView;
/**
 web广告关闭回调方法；
 
 - 参数 webAdView: web广告视图。
 */
-(void)didCloseWebAdView:(nonnull DeepleaperWebAdView*)webAdView;
/**
 native广告下载失败回调方法；
 
 - 参数 error: 错误信息。
 */
-(void)didFailLoadNativeAdView:(nullable NSError*)error;
/**
 web广告下载失败回调方法；
 
 - 参数 error: 错误信息。
 */
-(void)didFailLoadWebAdView:(nullable NSError*)error;
@end

@interface DeepleaperFeedAdManager : NSObject
/**
 代理。
 */
@property(weak,nullable) id <DeepleaperFeedAdManagerDelegate> delegate;
/**
 您客户端的广告位ID。
 */
@property(nonatomic,copy,nonnull)NSString* placementID;
/**
 如果您在调试，请设置sanBox为真，将从沙箱环境中请求广告，没有计费；
 */
@property(nonatomic,assign)BOOL sandBox;
/**
 根据用户阅读文章的url来请求广告，将返回和用户阅读文章相关的广告；
 
 - 参数 url: 用户阅读的文章的url(nil则不做精确匹配)。
 */
-(void)loadAdWithFeedAdType:(FeedAdType)feedAdType andUrl:(nullable NSString*)url;
/**
 在请求广告前对广告标题，图文间距进行调整；
 
 - 参数 font: 标题字体名称。
 - 参数 size: 标题字号。
 - 参数 color: 标题字色。
 - 参数 space: 标题和图片的间距。
 */
-(void)setWebAdConfigWithTitleFont:(nonnull NSString*)font TitleSize:(nonnull NSString*)size TitleColor:(nonnull NSString*)color andSpace:(nonnull NSString*)space;
/**
 用户返回信息流时调用，才会判断展示成功;
 
 */
-(void)willCloseLandPageView;
/**
 初始化DLNativeAdManager对象。
 
 - 参数 placementID: 您客户端的native广告位ID。
 */
+(nonnull DeepleaperFeedAdManager*)getFeedAdManager;
@end
