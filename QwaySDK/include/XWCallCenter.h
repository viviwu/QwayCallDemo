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

extern NSString *const XWCALL_APP_KEY;

extern NSString *const kXWCallCoreUpdate;
extern NSString *const kXWCallUpdate;
extern NSString *const kXWCallRegistrationUpdate;
extern NSString *const kXWCallGlobalStateUpdate;

extern NSString *const kCallRemoteCommandNotification;
extern NSString *const kCallRemoteCommandKey;
extern NSString *const kSocketNotification;
extern NSString *const kSocketNotificationConnectKey;

typedef enum _CallRemoteCommand {
    XWCallRemoteCommandNone=0,
    XWCallRemoteCommandLogout = 1 ,   //fouce logout: account security
    XWCallRemoteCommandChangeServer,    //Change IP: Sip Server
    
} XWCallRemoteCommand;

//#define WeakSelf __weak typeof(self) weakSelf = self;
//#define WeakObj(o) __weak typeof(o) o##Weak = o;
//#define WeakObj(o) autoreleasepool{} __weak typeof(o) o##Weak = o;
//#define WeakObj(o) try{}@finally{} __weak typeof(o) o##Weak = o;



typedef enum _XWCallState{
    XWCallIdle,	/**<Initial call state */
    XWCallIncomingReceived, /**<This is a new incoming call */
    XWCallOutgoingInit, /**<An outgoing call is started */
    XWCallOutgoingProgress, /**<An outgoing call is in progress */
    XWCallOutgoingRinging, /**<An outgoing call is ringing at remote end */
    XWCallOutgoingEarlyMedia, /**<An outgoing call is proposed early media */
    XWCallConnected, /**<Connected, the call is answered */
    XWCallStreamsRunning, /**<The media streams are established and running*/
    XWCallPausing, /**<The call is pausing at the initiative of local end */
    XWCallPaused, /**< The call is paused, remote end has accepted the pause */
    XWCallResuming, /**<The call is being resumed by local end*/
    XWCallRefered, /**<The call is being transfered to another party, resulting in a new outgoing call to follow immediately*/
    XWCallError, /**<The call encountered an error*/
    XWCallEnd, /**<The call ended normally*/
    XWCallPausedByRemote, /**<The call is paused by remote end*/
    XWCallUpdatedByRemote, /**<The call's parameters change is requested by remote end, used for example when video is added by remote */
    XWCallIncomingEarlyMedia, /**<We are proposing early media to an incoming call */
    XWCallUpdating, /**<A call update has been initiated by us */
    XWCallReleased, /**< The call object is no more retained by the core */
    XWCallEarlyUpdatedByRemote, /**< call is updated by remote while not yet answered (early dialog SIP UPDATE received).*/
    XWCallEarlyUpdating /**< are updating the call while not yet answered (early dialog SIP UPDATE sent)*/
} XWCallState;

typedef enum _XWCallRegistrationState{
    XWCallRegistrationNone, /**<Initial state for registrations */
    XWCallRegistrationProgress, /**<Registration is in progress */
    XWCallRegistrationOk,	/**< Registration is successful */
    XWCallRegistrationCleared, /**< Unregistration succeeded */
    XWCallRegistrationFailed	/**<Registration failed */
}XWCallRegistrationState;

typedef enum _XWCallConfiguringState {
    XWCallConfiguringSuccessful,
    XWCallConfiguringFailed,
    XWCallConfiguringSkipped
} XWCallConfiguringState;

typedef enum _NetworkType {
    network_none = 0,
    network_2g,
    network_3g,
    network_4g,
    network_wwan,
    network_wifi
} NetworkType;

typedef enum _Connectivity {
    wifi,
    wwan,
    none
} Connectivity;

//***********************************
#pragma mark--********XWCallCenter

@interface XWCallCenter : NSObject

+ (XWCallCenter*)instance;

- (void)proxyCoreWithAppKey:(NSString*)appid
                   Memberid:(NSString*)memberid
                  Memberkey:(NSString*)memberkey;

+(BOOL)isRegistrationAvailable;
+(BOOL)isProxyParameterAvailable;
-(void)updateServer;

#pragma mark--ResignActive
- (void)resetXWCallCore;    //重置呼叫系统
- (void)startXWCallCore;    //启动呼叫系统
+ (BOOL)isXWCallCoreReady;//呼叫中心是否初始化完成

#pragma markk--ProxyConfig
//移除之前所有账号信息
+ (void)removeAllAccountsData;
//销毁呼叫系统
- (void)destroyXWCallCore;

//called when applicationWillResignActive
+(void)XWCallWillResignActive;  //系统将不在活跃 ：app进入后台等情况时
+(void)XWCallWillTerminate;     //系统随app被强制终止

- (void)becomeActive; //进入活跃状态
- (void)activeIncaseOfIncommingCall;    //回到前台准备接收收到call
- (BOOL)enterBackgroundMode;    //进入后台时

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

//incoming call notifaction message
#define kIC_MSG     @"Incoming call:"      //   来电铃声文件名
#define kmsg_snd    @"msg.caf"      //消息通知提示音文件名
#define kiOS7soundName    @"shortring.caf"  //iOS7以下的短铃声文件名

// Set audio assets:
#define kRemoteRing  @"ringback.wav"   //remote_ring 来电等待提示音文件名
#define kHoldMusic  @"hold.mkv"     //hold_music 通话保留音文件名
#define kLocalRing  @"notes_of_the_optimistic.caf"  //通知提示音文件名
#define sandBoxServer @"http://sandbox.91voip.com"
#define openVoipServer @"http://open.91voip.com"

@end



