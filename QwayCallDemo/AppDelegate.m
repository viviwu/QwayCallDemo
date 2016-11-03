//
//  AppDelegate.m
//  QwayCallDemo
//
//  Created by viviwu on 2016/10/20.
//  Copyright © 2016年 viviwu. All rights reserved.
//
#include <string.h>
#include <CommonCrypto/CommonCrypto.h>

#import "AppDelegate.h"
#import "XWDialVC.h"
#import "XWOnCallVC.h"

@interface AppDelegate ()

@property (nonatomic, strong)XWDialVC * mainDialVC;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
#if TARGET_IPHONE_SIMULATOR
    self.devicePushToken = @"12345678901234567812345678";
#else
    //APNS token这个玩意儿 你自己知道怎么获取吧
    NSString *tokenString = kUserDef_OBJ(@"deviceToken");
    if (tokenString) {
        self.devicePushToken = tokenString;
    }
#endif
    UIUserNotificationType type =  UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
    // UIMutableUserNotificationCategory 这个需要什么功能自己搞
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:type   categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    
    _currentMemberid=kUserDef_OBJ(@"memberid")?kUserDef_OBJ(@"memberid"):memberid;
    _currentMemberkey=kUserDef_OBJ(@"memberkey")?kUserDef_OBJ(@"memberkey"):memberkey;;
    

    
     XWCallCenter *instance = [XWCallCenter instance];
     [instance   startXWCallCore];//主要是确保首次启动前完全初始化了
    
    if (![kUserDef_OBJ(@"sipphone") length] ||
        ![kUserDef_OBJ(@"sippw") length] ||
        ![kUserDef_OBJ(@"logintoken") length] ||
        ![kUserDef_OBJ(@"sipserver") length] ||
        ![kUserDef_OBJ(@"tcpserver") length])
    {
        [[XWCallCenter instance] proxyCoreWithAppKey:kAppID
                                            Memberid:_currentMemberid
                                           Memberkey:_currentMemberid];
    }else{
        [[XWCallCenter instance] voipInitializeProxyConfig];
    }
    
     [[XWOnCallVC instance] resetControlersToDefaultState];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(callRemoteCommandAction:) name:kCallRemoteCommandKey object:nil];
    
    return YES;
}

-(void)logoutAction{
    
    if ([XWCallCenter isXWCallCoreReady]) {
        [XWCallCenter removeAllAccountsConfig];
        [XWCallCenter XWCallWillTerminate];
    }
}

-(void)callRemoteCommandAction:(NSNotification*)notify
{
    NSDictionary * info =notify.userInfo;
    XWCallRemoteCommand cmd=[info[kCallRemoteCommandKey] intValue];
    if(XWCallRemoteCommandLogout == cmd){
        NSString * reason=info[@"reason"];
        UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"" message:reason delegate:nil cancelButtonTitle:@"ok" otherButtonTitles: nil];
        [alert show];
        [self logoutAction];
    }else if(XWCallRemoteCommandChangeServer == cmd){
        //根据收到的服务器替换登录时收到的IP去切换连接
        //一般不会更换的
    }
}

#pragma mark--applicationDidEnterBackground
UIBackgroundTaskIdentifier backgroundTaskID;
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    [XWCallCenter XWCallWillResignActive];
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
#warning 应用如何持续后台 自己写吧 务必可以保持后台！
    BOOL backgroundAccepted = [[UIApplication sharedApplication] setKeepAliveTimeout:600 handler:^{
        [self backgroundhandler];
    }];
    if (backgroundAccepted)
    {
        NSLog(@"backgrounding accepted");
    }
    if (NO == [[UIDevice currentDevice] isMultitaskingSupported]){
        return;
    }
    [self backgroundhandler];
    //开启一个后台任务
    backgroundTaskID = [application beginBackgroundTaskWithExpirationHandler:^{
        
        if (backgroundTaskID != UIBackgroundTaskInvalid) {
            [application endBackgroundTask:backgroundTaskID];
            backgroundTaskID = UIBackgroundTaskInvalid;
        }
    }];
    
    [[XWCallCenter instance] enterBackgroundMode];
}
static BOOL inBackground=NO;
static NSInteger count=0;
-(void) backgroundhandler{
    NSLog(@"### -->backgroundinghandler");
    UIApplication*  app = [UIApplication sharedApplication];
    backgroundTaskID = [app beginBackgroundTaskWithExpirationHandler:^{
        if (backgroundTaskID != UIBackgroundTaskInvalid) {
            [app endBackgroundTask: backgroundTaskID];
            backgroundTaskID = UIBackgroundTaskInvalid;
        }
    }];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        while (inBackground) {
            NSLog(@"backgroundTimeRemain counter:%ld", (long)count++);
            NSLog(@"timer:%f", [app backgroundTimeRemaining]);
            sleep(1);
        }
    });
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
    if (backgroundTaskID != UIBackgroundTaskInvalid){
        [application endBackgroundTask:backgroundTaskID];
        backgroundTaskID = UIBackgroundTaskInvalid;
    }
    
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [[XWCallCenter instance] becomeActive];
    [[XWCallCenter instance] activeIncaseOfIncommingCall];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
     [XWCallCenter XWCallWillTerminate];
}
 

@end
