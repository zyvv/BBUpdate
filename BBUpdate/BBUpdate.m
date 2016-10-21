//
//  BBUpdate.m
//  BBUpdate
//
//  Created by 张洋威 on 2016/10/20.
//  Copyright © 2016年 yhyvr.com. All rights reserved.
//

#import "BBUpdate.h"
#import <UIKit/UIKit.h>

@interface BBUpdate ()<UIAlertViewDelegate>

@property (nonatomic, strong) UIAlertView *alertView;
@property (nonatomic, copy) NSString *appID;
@property (nonatomic, copy) NSString *cancelTitle;
@property (nonatomic, copy) NSString *updateTitle;
@property (nonatomic, copy) NSString *alertTitle;

@end

@implementation BBUpdate

+ (void)updateWithAppID:(NSString *)appID {
    [BBUpdate shareUpdate].appID = appID;
    NSString *appStoreLookupString = [NSString stringWithFormat:@"https://itunes.apple.com/cn/lookup?id=%@", appID];
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:appStoreLookupString]] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        NSError *error = nil;
        NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        
        if (responseDict) {
            NSString *newVersion;
            NSString *releaseNotes;
            
            NSArray *configData = [responseDict valueForKey:@"results"];
            for(id config in configData) {
                newVersion = [config valueForKey:@"version"];
                releaseNotes = [config valueForKey:@"releaseNotes"];
            }
            
            if (!newVersion || !releaseNotes) {
                return;
            }
            
            NSString *localVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
            
            NSArray *localArr = [localVersion componentsSeparatedByString:@"."];
            NSArray *newArr = [newVersion componentsSeparatedByString:@"."];
            
            BOOL haveNewVersion = NO;
            
            for (int i=0; i < MAX(localArr.count, newArr.count); i++) {
                
                NSInteger newIndex = newArr.count > i ? [newArr[i] integerValue] : 0;
                NSInteger localIndex = localArr.count > i ? [localArr[i] integerValue] : 0;
                
                if (newIndex > localIndex) {
                    haveNewVersion = YES;
                    break;
                } else if (newIndex < localIndex) {
                    break;
                }
            }

            if (haveNewVersion) {
                [[BBUpdate shareUpdate] haveNewVersion:releaseNotes];
            }
        }
    }];
}

+ (void)setupAlertTitle:(NSString *)alertTitle updateTitle:(NSString *)updateTitle cancelTitle:(NSString *)cancelTitle {
    if (alertTitle) {
        [BBUpdate shareUpdate].alertTitle = alertTitle;
    }
    if (updateTitle) {
        [BBUpdate shareUpdate].updateTitle = updateTitle;
    }
    if (cancelTitle) {
        [BBUpdate shareUpdate].cancelTitle = cancelTitle;
    }
}

+ (BBUpdate *)shareUpdate {
    static BBUpdate *shareUpdate = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareUpdate = [[BBUpdate alloc] init];
        shareUpdate.cancelTitle = @"我知道了";
        shareUpdate.updateTitle = @"马上更新";
        shareUpdate.alertTitle = [NSString stringWithFormat:@"%@有新版本了", [[[NSBundle mainBundle]infoDictionary] objectForKey:@"CFBundleDisplayName"]];
    });
    return shareUpdate;
}

- (void)haveNewVersion:(NSString *)releaseNotes {
    _alertView = [[UIAlertView alloc] initWithTitle:[BBUpdate shareUpdate].alertTitle message:releaseNotes delegate:self cancelButtonTitle:[BBUpdate shareUpdate].cancelTitle otherButtonTitles:[BBUpdate shareUpdate].updateTitle, nil];
    [_alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        NSString *appStoreString = [NSString stringWithFormat:@"https://itunes.apple.com/app/id%@", [BBUpdate shareUpdate].appID];
        NSURL *url = [NSURL URLWithString:appStoreString];
        [[UIApplication sharedApplication] openURL:url];
    }

}


@end
