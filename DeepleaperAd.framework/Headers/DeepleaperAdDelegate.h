//
//  DeepleaperAdDelegate.h
//  
//


#import "DeepleaperAdCommonConfig.h"

@class DeepleaperAdView;
/**
 *  广告sdk委托协议
 */
@protocol DeepLeaperAdViewDelegate <NSObject>

@required
/**
 *  应用的APPID
 */
- (NSString *)publisherId;

@optional
/**
 *  渠道ID
 */
- (NSString *)channelId;
/**
 *  启动位置信息
 */
- (BOOL)enableLocation;

/**
 *  广告将要被载入
 */
- (void)willDisplayAd:(DeepleaperAdView *)adview;

/**
 *  广告载入失败
 */
- (void)failedDisplayAd:(DLAdFailReason)reason;

/**
 *  本次广告展示成功时的回调
 */
- (void)didAdImpressed;

/**
 *  本次广告展示被用户点击时的回调
 */
- (void)didAdClicked;

/**
 *  在用户点击完广告条出现全屏广告页面以后，用户关闭广告时的回调
 */
- (void)didDismissLandingPage;
/**
 *  在用户关闭banner后回调
 */
- (void)didCloseBannerAd;

///---------------------------------------------------------------------------------------
/// @name 人群属性板块
///---------------------------------------------------------------------------------------

/**
 *  关键词数组
 */
- (NSArray *)keywords;

/**
 *  用户性别
 */
- (DLAdUserGender)userGender;

/**
 *  用户生日
 */
- (NSDate *)userBirthday;

/**
 *  用户年龄范围
 */
- (NSArray *)userAge;


/**
 *  用户城市
 */
- (NSString *)userCity;

/**
 *  用户邮编
 */
- (NSString *)userPostalCode;

/**
 *  用户职业
 */
- (NSString *)userWork;

/**
 *  - 用户最高教育学历
 *  - 学历输入数字，范围为0-6
 *  - 0代表小学，1代表初中，2代表中专/高中，3代表专科
 *  - 4代表本科，5代表硕士，6代表博士
 */
- (NSInteger)userEducation;

/**
 *  - 用户收入
 *  - 收入输入数字,以元为单位
 */
- (NSInteger)userSalary;

/**
 *  用户爱好
 */
- (NSArray *)userHobbies;

/**
 *  其他自定义字段,key以及value都为NSString
 */
- (NSDictionary *)userOtherAttributes;

///---------------------------------------------------------------------------------------
/// @name 地理位置信息
///---------------------------------------------------------------------------------------

/**
 *  - 当前地理位置
 *  - geo
 */
- (NSString *)currentGeo;

/**
 *  - 当前经纬坐标
 *  - gps
 */
- (NSString *)currentGPS;
@end
