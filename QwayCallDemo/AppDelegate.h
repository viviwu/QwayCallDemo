//
//  AppDelegate.h
//  QwayCallDemo
//
//  Created by viviwu on 2016/10/20.
//  Copyright © 2016年 viviwu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XWCallCenter.h"

#define kAppDel         ((AppDelegate *)[UIApplication sharedApplication].delegate)
#define kUserDef_OBJ(s) [[NSUserDefaults standardUserDefaults] objectForKey:s]
#define kUserDef        [NSUserDefaults standardUserDefaults]

#define kAPP_VERSION    [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]

//#define kURL_VOIP_PRE @"https://api.91voip.com"
#define kAppID @"a2c29623ef7435e35426175f4bd755d0"

//651400



//test01@qq.com    650001
//test02@qq.com    654619

#define memberid @"test01@qq.com"
#define memberkey @"65c47523b3284f74"

#define memberid2 @"test02@qq.com"
#define memberkey2 @"6ed2a1a6a1e690bf"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, copy) NSString* devicePushToken;
@property (nonatomic, copy) NSString* currentMemberid;
@property (nonatomic, copy) NSString* currentMemberkey;

-(void)logoutAction;

@end

