//
//  AppDelegate.m
//  QwayCallDemo
//
//  Created by viviwu on 2016/10/20.
//  Copyright © 2016年 viviwu. All rights reserved.
//

#import "AppDelegate.h"
#import "XWDialVC.h"
#import "XWOnCallVC.h"
#import "XWLoginVC.h"

@interface AppDelegate ()

@property (nonatomic, strong)XWDialVC * mainDialVC;

@end

@implementation AppDelegate

-(void)enterMainViewWithIdentifier:(NSString *)identifier{
    // dispatch_async( dispatch_get_global_queue ( DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{ /*  */    });
    // initialize UI
    if (!_mainDialVC) {
        UIStoryboard * mainUIStoryboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        _mainDialVC=[mainUIStoryboard instantiateViewControllerWithIdentifier:@"2"];
    }
    [[XWOnCallVC instance] resetControlersToDefaultState];
    
    UIStoryboard * mianBoard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController * mainVC=nil;
    mainVC=[mianBoard instantiateViewControllerWithIdentifier:identifier];
    [UIView transitionWithView: self.window
                      duration: 0.5
                       options: UIViewAnimationOptionTransitionFlipFromLeft
                    animations: ^{
                        BOOL oldState=[UIView areAnimationsEnabled];
                        [UIView setAnimationsEnabled:NO];
                        self.window.rootViewController = mainVC;
                        [UIView setAnimationsEnabled:oldState];
                    }completion: NULL
     ];
    
    if ([identifier isEqualToString:@"0"]) {
        if (![kUserDef_OBJ(@"username") length] ||
            ![kUserDef_OBJ(@"password") length] ||
            ![kUserDef_OBJ(@"logintoken") length] ||
            ![kUserDef_OBJ(@"sipserver") length] ||
            ![kUserDef_OBJ(@"imserver") length])
        {
            //            [self enterMainViewWithIdentifier:@"1"];
        }else{
            [self voipInitializeProxyConfig];
        }
    }else{ }
    
}
#pragma mark-linphoneVoipProxyConfig

-(void)voipInitializeProxyConfig
{
    if(![XWCallCenter isXWCallCoreReady]) {
        [[XWCallCenter instance] startXWCallCoreWithAppID:kID_QWAY_APP];
    }
    [XWCallCenter removeAllAccountsConfig];//清空之前的配置
    
    [XWCallCenter addProxyConfig: kUserDef_OBJ(@"username")
                        password: kUserDef_OBJ(@"password")
                          domain: kUserDef_OBJ(@"sipserver")
                          server: kUserDef_OBJ(@"server")];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
#if TARGET_IPHONE_SIMULATOR
    self.devicePushToken = @"12345678901234567812345678";
#else
    NSString *tokenString = kUserDef_OBJ(@"deviceToken");
    if (tokenString) {
        self.devicePushToken = tokenString;
    }
#endif
    //default
    [kUserDef setObject:@"+86" forKey:@"area"];
    
     XWCallCenter *instance = [XWCallCenter instance];
     [instance   startXWCallCoreWithAppID:kID_QWAY_APP];//主要是确保首次启动前完全初始化了
    
     [[XWOnCallVC instance] resetControlersToDefaultState];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(callRemoteCommandAction:) name:kCallRemoteCommandKey object:nil];
    
    return YES;
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
-(void)logoutAction{
    
    [kUserDef removeObjectForKey:@"username"];
    [kUserDef removeObjectForKey:@"password"];
    [kUserDef removeObjectForKey:@"password"];
    [kUserDef removeObjectForKey:@"password"];
    [kUserDef removeObjectForKey:@"password"];
    [kUserDef removeObjectForKey:@"countryCode"];
    [kUserDef synchronize];
    
    [XWCallCenter XWCallWillTerminate];
    //清空配置
    [XWCallCenter removeAllAccountsConfig];
    
    if ([XWCallCenter isXWCallCoreReady]) {
        //[[XWCallCenter instance] destroyLibLinphone];
        [[XWCallCenter instance] destroyXWCallCore];
    }
    
    [UIView animateWithDuration:0.5f animations:^{
        
        UIStoryboard * mianBoard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UINavigationController * mainTab=[mianBoard instantiateViewControllerWithIdentifier:@"0"];
        [[UIApplication sharedApplication].delegate.window setRootViewController:mainTab];
    }];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    [XWCallCenter XWCallWillResignActive];
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     [[XWCallCenter instance] enterBackgroundMode];
#warning 应用如何持续后台 自己写吧 务必可以保持后台！
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
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
