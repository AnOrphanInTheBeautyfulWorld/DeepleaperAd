//
//  DeepleaperAdCommonConfig.h
//

#import <UIKit/UIKit.h>

#ifndef DeepleaperAdCommonConfig_h
#define DeepleaperAdCommonConfig_h


// SDK版本号
#define SDK_VERSION @"1.1.2"

typedef enum {
    DLAD_UNKNOWN = 0, // 未知
    DLAD_BANNER = 1, // banner
    DLAD_INTERSTITIAL = 2, // 插屏
    DLAD_SPLASH = 3, // 开屏
} AdType;

typedef enum {
    NORMAL, // 一般图文或图片广告
    VIDEO, // 视频播放类广告，需开发者增加播放器支持
    HTML // 信息流模版广告
} MaterialType;

typedef enum {
    BaiduMobNativeAdActionTypeLP = 1,
    BaiduMobNativeAdActionTypeDL = 2
} BaiduMobNativeAdActionType;

typedef enum {
    onShow,  //video展现
    onClickToPlay,//点击播放
    onStart, //开始播放
    onError, //播放失败
    onComplete, //完整播放
    onClose, //播放结束
    onFullScreen, //全屏观看
    onClick, //广告点击
    onSkip, //跳过视频
    onShowEndCard,// 展现endcard
    onClickEndCard// 点击endcard
} BaiduAdNativeVideoEvent;

/**
 *  性别类型
 */
typedef enum {
    DLADSexUnknown = 0,
    DLADMale = 1,
    DLADFeMale = 2,
} DLAdUserGender;

/**
 *  广告展示失败类型枚举
 */
typedef enum _DLADFailReason {
    DLADFailReason_NOAD = 0,
    // 没有推广返回
    DLADFailReason_EXCEPTION,
    //网络或其它异常
    DLADFailReason_FRAME
    //广告尺寸异常，不显示广告
} DLAdFailReason;



#endif /* DeepleaperAdCommonConfig_h */
