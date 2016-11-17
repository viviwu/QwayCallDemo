//
//  AppDelegate.m
//  QwayCallDemo
//
//  Created by viviwu on 2016/10/20.
//  Copyright © 2016年 viviwu. All rights reserved.
//
#include <string.h>
#include <CommonCrypto/CommonCrypto.h>
#import <PushKit/PushKit.h>

#import "AppDelegate.h"
#import "XWOnCallVC.h"


@interface AppDelegate ()

@property (nonatomic, strong) PKPushRegistry* pushRegistry;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    _currentMemberid=kUserDef_OBJ(@"memberid")?kUserDef_OBJ(@"memberid"):memberid;
    _currentMemberkey=kUserDef_OBJ(@"memberkey")?kUserDef_OBJ(@"memberkey"):memberkey;
    
//#if TARGET_IPHONE_SIMULATOR
//    self.apnsPushToken = @"12345678901234567812345678";
//    self.voipPushToken = @"12345678901234567812345678";
//#else
//    NSString *apnsToken = kUserDef_OBJ(@"apnsToken");
//    NSString *voipToken = kUserDef_OBJ(@"voipToken");
//    self.apnsPushToken = apnsToken?apnsToken:@"1234567890";
//    self.voipPushToken = voipToken?voipToken:@"1234567890";
//#endif
    UIUserNotificationType type =  UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
    // UIMutableUserNotificationCategory
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:type   categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    
    _pushRegistry = [[PKPushRegistry alloc] initWithQueue:dispatch_get_main_queue()];
    _pushRegistry.delegate = (id)self;
    _pushRegistry.desiredPushTypes=[NSSet setWithObject:PKPushTypeVoIP];
    
     XWCallCenter *instance = [XWCallCenter instance];
     [instance   startXWCallCore];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(callRemoteCommandAction:) name:kCallRemoteCommandNotification object:nil];
    
    if (![XWCallCenter isRegistrationAvailable])
    {//请合作企业 自行联系http://www.91qway.com 申请appID和账号 测试 尽量不要用demo里的账号
        [[XWCallCenter instance] proxyCoreWithAppKey:kAppID
                                            Memberid:_currentMemberid
                                           Memberkey:_currentMemberkey];
    }else{
        //现在每次都要去重新请求SIP 服务器了
        [[XWCallCenter instance] updateServer];
    }
    
     [[XWOnCallVC instance] resetControlersToDefaultState];
    return YES;
}

-(void)logoutAction{
    
    if ([XWCallCenter isXWCallCoreReady])
    {
        [XWCallCenter removeAllAccountsData];
        [XWCallCenter XWCallWillTerminate];
    }
    _mainDialVC.view.backgroundColor=[UIColor brownColor];;
}

-(void)callRemoteCommandAction:(NSNotification*)notify
{
    NSDictionary * info =notify.userInfo;
    XWCallRemoteCommand cmd=[info[kCallRemoteCommandKey] intValue];
    if(XWCallRemoteCommandLogout == cmd){
        NSString * reason=info[@"reason"];
        UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"" message:reason delegate:nil cancelButtonTitle:@"ok" otherButtonTitles: nil];
        [alert show];
        [self performSelector:@selector(logoutAction) withObject:nil afterDelay:5.0f];
    }else if(XWCallRemoteCommandChangeServer == cmd){
        //根据收到的服务器替换登录时收到的IP去切换连接
        [[XWCallCenter instance] updateServer];
        //一般不会更换的
    }
}

#pragma mark PKPushRegistryDelegate VoIP推送

- (void)pushRegistry:(PKPushRegistry *)registry didUpdatePushCredentials:(PKPushCredentials *)credentials forType:(PKPushType)type
{ 
    if([credentials.token length] == 0)
    {
        NSLog(@"voip token NULL");
    }else{
        NSString *token = [[credentials.token description] stringByTrimmingCharactersInSet: [NSCharacterSet characterSetWithCharactersInString:@"<>"]];
        token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
        if (token) {
            self.voipPushToken=token;
            [kUserDef setObject:token forKey:@"voipToken"];//目前你直接这么用字段存吧
            [kUserDef synchronize];
        }
        NSLog(@"voipToken:\n%@", token);
    }
}

- (void)pushRegistry:(PKPushRegistry *)registry didReceiveIncomingPushWithPayload:(PKPushPayload *)payload forType:(NSString *)type
{
    NSDictionary *puskDic = payload.dictionaryPayload[@"aps"];
    NSLog(@"didReceiveIncomingPushWithPayload:\n%@", puskDic);
    NSString * number= puskDic[@"caller"]?puskDic[@"caller"]:@"0";
    //暂时我们不做特殊处理
    NSString*alertTitle =[NSString stringWithFormat:@"%@", puskDic[@"alert"]];
    NSString*alertBody =[NSString stringWithFormat:@"您有一个待处理来电: %@ , %@", number,puskDic[@"time"]];
    [AppDelegate  postLocalNotificationWithTitle:alertTitle alertBody:alertBody];
//    当然CallKit可以在这里接
}

#pragma mark--RemoteNotifications
-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    if([deviceToken length] == 0){
        NSLog(@"apns token NULL");
    }else{
        NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet: [NSCharacterSet characterSetWithCharactersInString:@"<>"]];
        token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
        if (token) {
            self.apnsPushToken=token;
            [kUserDef setObject:token forKey:@"apnsToken"];
            [kUserDef synchronize];
        }
        NSLog(@"apnsPushToken:\n%@", token);
    }
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(nullable NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void(^)())completionHandler  NS_AVAILABLE_IOS(8_0)
{
    NSLog(@"RemoteNotification:%@", userInfo);//暂时我们不做特殊处理
    NSString * number= userInfo[@"caller"]?userInfo[@"caller"]:@"0";
    NSString*alertTitle =[NSString stringWithFormat:@"%@", userInfo[@"alert"]];
    NSString*alertBody =[NSString stringWithFormat:@"您有一个待处理来电: %@ , %@", number,userInfo[@"time"]];
    [AppDelegate  postLocalNotificationWithTitle:alertTitle alertBody:alertBody];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 1];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 0];
    completionHandler();
}

-(void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forLocalNotification:(UILocalNotification *)notification completionHandler:(void (^)())completionHandler NS_AVAILABLE_IOS(8_0)
{
    NSLog(@"identifier==%@----,\n notification=%@",identifier,notification);
    UIApplicationState state = application.applicationState;
    if(state == UIApplicationStateActive)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:notification.alertTitle
                                                        message:notification.alertBody
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }else{
        if(state == UIApplicationStateInactive){
            NSLog(@"StateInactive: 程序运行在后台时，点击启动程序按钮时 :后台点击进入");
        }else if(state == UIApplicationStateBackground){
            NSLog(@"StateBackground: 程序运行在后台 ");
        }
//        [AppDelegate  postLocalNotificationWithTitle:notification.alertTitle alertBody:notification.alertBody];
    }
    completionHandler();
}

+(void)postLocalNotificationWithTitle:(NSString*)title alertBody:(NSString*)bodly
{
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    localNotification.alertTitle = title;
    localNotification.alertBody = bodly;
    localNotification.soundName = @"prison_break.m4r";
    [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
    
    NSInteger budgetCnt = [[UIApplication sharedApplication] applicationIconBadgeNumber];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:budgetCnt+1];
}


-(void)displayIncomingCall:(NSUUID*)uuid handle:(NSString *)handle hasVideo:(BOOL)hasVideo completion:(void (^)(NSError * error))completionHandler
{
    //    [_providerDelegate reportIncomingCallUUID:uuid handle:handle hasVideo:hasVideo completion:completionHandler];
}



#pragma mark--applicationDidEnterBackground
UIBackgroundTaskIdentifier backgroundTaskID;
- (void)applicationWillResignActive:(UIApplication *)application {
 
    [XWCallCenter XWCallWillResignActive];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    //虽说VoIP的pushKit可以快速通知来电信息 但你不希望应用一退到后台 一会儿就系统被杀了吧
#warning  应用如何持续后台 自己写吧 这只是个例子，虽然有推送，但天朝的网你懂得 并不是万无一失的
    
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
    
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    [[XWCallCenter instance] becomeActive];
    [[XWCallCenter instance] activeIncaseOfIncommingCall];
}


- (void)applicationWillTerminate:(UIApplication *)application {

     [XWCallCenter XWCallWillTerminate];
}


@end
