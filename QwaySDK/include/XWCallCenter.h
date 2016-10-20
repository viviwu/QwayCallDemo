//
//  XWCallCenter.h
//  XWCallCenter
//
//  Created by viviwu on 2013/10/13.
//  Copyright © 2013年 viviwu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <CoreTelephony/CTCallCenter.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <SystemConfiguration/SCNetworkReachability.h>
#import <Availability.h>

#import "XWStateController.h"

extern NSString *const XWCALL_APP_KEY;

extern NSString *const kXWCallCoreUpdate;
extern NSString *const kXWCallUpdate;
extern NSString *const kXWCallRegistrationUpdate;
extern NSString *const kXWCallGlobalStateUpdate;


//incoming call notifaction message
#define kIC_MSG     @"Incoming call:"      //   来电铃声文件名
#define kmsg_snd    @"msg.caf"      //消息通知提示音文件名
#define kiOS7soundName    @"shortring.caf"  //iOS7以下的短铃声文件名

// Set audio assets:
#define kRemoteRing  @"ringback.wav"   //remote_ring 来电等待提示音文件名
#define kHoldMusic  @"hold.mkv"     //hold_music 通话保留音文件名
#define kLocalRing  @"notes_of_the_optimistic.caf"  //通知提示音文件名

//***********************************
#pragma mark--********XWCallCenter

@interface XWCallCenter : NSObject

+ (XWCallCenter*)instance;//单例主体，切勿重复实例化

+ (BOOL)isXWCallCoreReady;//呼叫中心城市化完成

#pragma mark--Function Utills
+ (NSString*)getIPAddressForHost:(NSString *)hostname;//域名转IP

#pragma mark - GSM management
+(BOOL)currentOSversionOver:(CGFloat)version;   //当前系统版本是否高于某个版本

#pragma markk--ProxyConfig
+ (void)addProxyConfig:(NSString*)username password:(NSString*)password domain:(NSString*)domain server:(NSString*)server;//添加基本配置信息:账户名ID

+ (void)removeAllAccountsConfig;    //移除之前所有账号配置信息

#pragma mark--ResignActive
- (void)resetXWCallCore;    //重置呼叫系统
- (void)startXWCallCore;    //开启呼叫系统
- (void)destroyXWCallCore;  //销毁呼叫系统

//called when applicationWillResignActive
+(void)XWCallWillResignActive;  //系统将不在活跃 ：app进入后台等情况时
+(void)XWCallWillTerminate;     //系统随app被强制终止

//- (BOOL)resignActive;
- (void)becomeActive; //进入活跃状态
- (void)activeIncaseOfIncommingCall;    //回到前台准备接收收到call
- (BOOL)enterBackgroundMode;    //进入后台时

+ (void)kickOffNetworkConnection;//自踢下线

- (void)refreshRegisters;  //刷新注册信息

- (bool)allowSpeaker;   //扬声器是否允许使用

+(const char*)getCurrentCallAddress;//电话号码

- (void)call:(NSString *)address displayName:(NSString*)displayName transfer:(BOOL)transfer;// 发起voip呼叫

- (void)answerCallWithVideo:(BOOL)video;  //接听来电 以及是否是视频通话
- (void)declineCall;    //拒接当前来电
- (void)hangupCall;     //挂断电话
- (void)sendDigitForDTMF:(const char)digit;  //通话中发送双频多音信息
- (void)voipMicMute:(BOOL)mute; //通话中是否让麦克风静音
- (void)setSpeakerEnabled:(BOOL)enable; //扬声器是否可用
- (void)holdOnCall:(BOOL)holdOn;    //通话暂停/保留

@end



