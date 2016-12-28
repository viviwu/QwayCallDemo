//
//  AppDelegate.h
//  QwayCallDemo
//
//  Created by viviwu on 2016/10/20.
//  Copyright © 2016年 viviwu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XWCallCenter.h"
#import "XWDialVC.h"

#define kAppDel         ((AppDelegate *)[UIApplication sharedApplication].delegate)
#define kUserDef_OBJ(s) [[NSUserDefaults standardUserDefaults] objectForKey:s]
#define kUserDef        [NSUserDefaults standardUserDefaults]

#define kAPP_VERSION    [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]

#define kAppID @"5f0874855e322897939bff801abe75f8"
#define memberid2 @"a4882d0340850a80555d079dacf7c241"
#define memberkey2 @"ea442ae0d2d22337"
#define memberid @"50230379c398c969fd2c2a59e3669ede"
#define memberkey @"acdb06dcffb8e635"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, copy) NSString* apnsPushToken;
@property (nonatomic, copy) NSString* voipPushToken;
@property (nonatomic, copy) NSString* currentMemberid;
@property (nonatomic, copy) NSString* currentMemberkey;

@property (nonatomic, strong)XWDialVC * mainDialVC;
-(void)logoutAction;

@end

