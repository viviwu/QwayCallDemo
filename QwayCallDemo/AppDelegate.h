//
//  AppDelegate.h
//  QwayCallDemo
//
//  Created by viviwu on 2016/10/20.
//  Copyright © 2016年 viviwu. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kAppDel         ((AppDelegate *)[UIApplication sharedApplication].delegate)
#define kUserDef_OBJ(s) [[NSUserDefaults standardUserDefaults] objectForKey:s]
#define kUserDef        [NSUserDefaults standardUserDefaults]
#define kURL_VOIP_PRE @"https://api.91voip.com"
#define kID_QWAY_APP @"e62431fa1172ad0e3280eb445094b60d"
#define kAPP_VERSION    [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, copy) NSString* devicePushToken;

-(void)enterMainViewWithIdentifier:(NSString *)identifier;

@end

