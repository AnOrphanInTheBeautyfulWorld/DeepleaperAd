//
//  DeepleaperAdView.h
//  
//


#import "DeepleaperAdDelegate.h"
#import <UIKit/UIKit.h>

#define kDeepLeaperAdViewSizeDefaultWidth 320
#define kDeepLeaperAdViewSizeDefaultHeight 48

#define kDeepLeaperAdViewBanner320x48 CGSizeMake(320, 48)
#define kDeepLeaperAdViewBanner468x60 CGSizeMake(468, 60)
#define kDeepLeaperAdViewBanner728x90 CGSizeMake(728, 90)

#define kDeepLeaperAdViewSquareBanner300x250 CGSizeMake(300, 250)
#define kDeepLeaperAdViewSquareBanner600x500 CGSizeMake(600, 500)

/**
 *  投放广告的视图接口,更多信息请查看[百度移动联盟主页](http://mssp.baidu.com)
 */
/**
 *  广告类型
 * 0 banner广告
 */
typedef enum _DeepLeaperAdViewType {
    DeepLeaperAdViewTypeBanner = 0
} DeepLeaperAdViewType;

@interface DeepleaperAdView : UIView
/**
 *  委托对象
 */
@property(nonatomic, weak) id<DeepLeaperAdViewDelegate> delegate;

/**
 *  设置／获取需要展示的广告类型
 */
@property(nonatomic) DeepLeaperAdViewType AdType;

/**
 *  设置/获取代码位id
 */
@property(nonatomic, copy) NSString *AdUnitTag;

/**
 *  SDK版本
 */
@property(nonatomic, readonly) NSString *Version;

/**
 *  设置/获取Token
 */
@property (nonatomic,copy) NSString* token;

/**
 *  设置/获取Media Publisher id
 */
@property (nonatomic,copy) NSString* pub;

/**
 *  开始广告展示请求,会触发所有资源的重新加载，推荐初始化以后调用一次
 */
- (void)start;

@end

