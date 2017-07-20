//
//  DeepLeeperAdSplashDelegate.h
//  
//


#import "DeepleaperAdCommonConfig.h"
#import <Foundation/Foundation.h>

@class DeepleaperAdSplash;

@protocol DeepleaperAdSplashDelegate <NSObject>

@required
/**
 *  应用的APPID
 */
- (NSString *)publisherId;

@optional

/**
 *  渠道id
 */
- (NSString*) channelId;

/**
 *  启动位置信息
 */
-(BOOL) enableLocation;


/**
 *  广告展示成功
 */
- (void)splashSuccessPresentScreen:(DeepleaperAdSplash *)splash;

/**
 *  广告展示失败
 */
- (void)splashlFailPresentScreen:(DeepleaperAdSplash *)splash withError:(DLAdFailReason) reason;
/**
 *  广告被点击
 */
- (void)splashDidClicked:(DeepleaperAdSplash *)splash;

/**
 *  广告展示结束
 */
- (void)splashDidDismissScreen:(DeepleaperAdSplash *)splash;

/**
 *  广告详情页消失
 */
- (void)splashDidDismissLp:(DeepleaperAdSplash *)splash;


///---------------------------------------------------------------------------------------
/// @name 人群属性板块
///---------------------------------------------------------------------------------------

/**
 *  关键词数组
 */
-(NSArray*) keywords;

/**
 *  用户性别
 */
-(DLAdUserGender) userGender;

/**
 *  用户生日
 */
-(NSDate*) userBirthday;

/**
 *  用户年龄范围
 */
- (NSArray *)userAge;

/**
 *  用户城市
 */
-(NSString*) userCity;


/**
 *  用户邮编
 */
-(NSString*) userPostalCode;


/**
 *  用户职业
 */
-(NSString*) userWork;

/**
 *  - 用户最高教育学历
 *  - 学历输入数字，范围为0-6
 *  - 0代表小学，1代表初中，2代表中专/高中，3代表专科
 *  - 4代表本科，5代表硕士，6代表博士
 */
-(NSInteger) userEducation;

/**
 *  - 用户收入
 *  - 收入输入数字,以元为单位
 */
-(NSInteger) userSalary;

/**
 *  用户爱好
 */
-(NSArray*) userHobbies;

/**
 *  其他自定义字段,key以及value都为NSString
 */
-(NSDictionary*) userOtherAttributes;
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
