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
        [[XWCallCenter instance] startXWCallCore];
    }
    [XWCallCenter removeAllAccountsConfig];//清空之前的配置
    
    [XWCallCenter addProxyConfig: kUserDef_OBJ(@"username")
                        password: kUserDef_OBJ(@"password")
                          domain: kUserDef_OBJ(@"sipserver")
                          server: kUserDef_OBJ(@"server")];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
     XWCallCenter *instance = [XWCallCenter instance];
    [instance   startXWCallCore];//主要是确保首次启动前完全初始化了
    
     [[XWOnCallVC instance] resetControlersToDefaultState];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
