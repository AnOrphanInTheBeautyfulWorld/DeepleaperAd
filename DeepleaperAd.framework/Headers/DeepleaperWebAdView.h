//
//  DeepleaperWebAdView.h
//  DeepleaperAdExample
//
//  Created by 刘畅 on 2017/7/10.
//  Copyright © 2017年 刘畅. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DeepleaperWebAdView;
@protocol DeepleaperWebAdViewDelegate <NSObject>
-(void)didLoadWebAdView:(DeepleaperWebAdView*)webAdView;
-(void)didCloseWebAdView:(DeepleaperWebAdView*)webAdView;
-(void)didFailLoadWebAdView:(NSError*)error;
@end
@interface DeepleaperWebAdView : UIView
/**
 广告是否为pull样式；
 
 */
@property(nonatomic,assign)BOOL isScrollAd;
/**
 广告是否已经关闭；
 
 */
@property(nonatomic,assign)BOOL isClosed;

/**
 不需要设置；
 
 */
@property(weak,nonatomic) id <DeepleaperWebAdViewDelegate> delegate;
/**
 ***不需要调用***；
 
 */
-(void)scrollWith:(NSInteger)tag;
/**
 ***不需要调用***；
 
 */
-(instancetype)initWithToken:(id)token andData:(id)data;
@end
