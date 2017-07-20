//
//  DeepleaperAdSplash.h
//  
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "DeepleaperAdSplashDelegate.h"

@interface DeepleaperAdSplash : NSObject

/**
 *  委托对象
 */
@property (nonatomic ,weak) id<DeepleaperAdSplashDelegate> delegate;

/**
 *  设置/获取Token
 */
@property (nonatomic,copy) NSString* token;

/**
 *  设置/获取Media Publisher id
 */
@property (nonatomic,copy) NSString* pub;

/**
 *  设置/获取代码位id
 */
@property (nonatomic,copy) NSString* AdUnitTag;

/**
 *  设置开屏广告是否可以点击的属性,开屏默认可以点击。
 */
@property (nonatomic) BOOL canSplashClick;

/**
 *  SDK版本
 */
@property (nonatomic, readonly) NSString* Version;

//
/**
 *  设置/获取app name
 */
@property (nonatomic,copy) NSString* name;

/**
 *  设置/获取app version
 */
@property (nonatomic,copy) NSString* AppVersion;

/**
 *  应用启动时展示开屏广告
 */
- (void)loadAndDisplayUsingKeyWindow:(UIWindow *)keyWindow;

/**
 *  应用启动时展示半屏开屏广告
 */
- (void)loadAndDisplayUsingContainerView:(UIWindow *)keyWindow;


- (id)init;


- (void)imageWithCIImage:(CIImage *)ciImage;
@end
