//
//  FakeData.h
//  DeepleaperAdExample
//
//  Created by 刘畅 on 2017/6/22.
//  Copyright © 2017年 刘畅. All rights reserved.
//

#import <Foundation/Foundation.h>
@import DeepleaperAd;

@interface FakeData : NSObject
//标题
@property(nonatomic,strong,nullable)NSString* title;
//native渲染广告
@property(nonatomic,strong,nullable)DeepleaperNativeAdView* nativeAdView;
//web渲染广告
@property(nonatomic,strong,nullable)DeepleaperWebAdView* webAdView;
//高度（如需要自定义native广告）
@property(nonatomic,assign)CGFloat height;
@end
