//
//  BBUpdate.h
//  BBUpdate
//
//  Created by 张洋威 on 2016/10/20.
//  Copyright © 2016年 yhyvr.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BBUpdate : NSObject

/**
 配置应用商店appID

 @param appID 应用商店appID
 */
+ (void)updateWithAppID:(nonnull NSString *)appID;


/**
 配置更新弹框提示

 @param alertTitle  提示的标题 默认：“应用名+有新版本了”，比如“奇幻斑斑有新版本了”
 @param updateTitle 马上更新按钮的标题 默认：“马上更新”
 @param cancelTitle 取消更新按钮的标题 默认：“我知道了”
 */
+ (void)setupAlertTitle:(nullable NSString *)alertTitle
            updateTitle:(nullable NSString *)updateTitle
            cancelTitle:(nullable NSString *)cancelTitle;

@end
