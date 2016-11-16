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

//#define kURL_VOIP_PRE @"https://api.91voip.com"
#define kAppID @"a2c29623ef7435e35426175f4bd755d0"

//test01@qq.com    650001
//test02@qq.com    654619

//#define memberid @"test01@qq.com"
//#define memberkey @"65c47523b3284f74"

//#define memberid2 @"test02@qq.com"
//#define memberkey2 @"6ed2a1a6a1e690bf"

#define memberid @"ios01"
#define memberkey @"069d81a0c751764f"

#define memberid2 @"ios02"
#define memberkey2 @"5fd869139e462197"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, copy) NSString* apnsPushToken;
@property (nonatomic, copy) NSString* voipPushToken;
@property (nonatomic, copy) NSString* currentMemberid;
@property (nonatomic, copy) NSString* currentMemberkey;


@property (nonatomic, strong)XWDialVC * mainDialVC;

-(void)logoutAction;

@end

