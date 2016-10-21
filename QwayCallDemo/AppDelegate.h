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


#define memberid @"test01@qq.com"
#define memberkey @"65c47523b3284f74"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, copy) NSString* devicePushToken;

-(void)logoutAction;

@end

