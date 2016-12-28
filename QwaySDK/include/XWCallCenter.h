//
//  XWCallCenter.h
//  XWCallCenter
//
//  Created by viviwu on 2013/10/13.
//  Copyright © 2013年 viviwu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIApplication.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <CoreTelephony/CTCallCenter.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <SystemConfiguration/SCNetworkReachability.h>
#import <Availability.h>

#if defined(__APPLE__)
#include "TargetConditionals.h"
#endif

#ifndef XW_DEPRECATED
  #if defined(_XWC_VER)
  #define XW_DEPRECATED __declspec(deprecated)
  #else
  #define XW_DEPRECATED __attribute__ ((deprecated))
  #endif
#endif

#define XW_UNUSED(x) ((void)(x))

#if defined(_XWC_VER)
#define XW_PUBLIC	__declspec(dllexport)
#define XW_VAR_PUBLIC extern __declspec(dllexport)
#else
#define XW_PUBLIC
#define XW_VAR_PUBLIC extern
#endif

#define sandBoxServer @"http://sandbox.91voip.com"
#define openVoipServer @"http://open.91voip.com"

extern NSString *const XWCALL_APP_KEY;

extern NSString *const kXWCallCoreUpdate;
extern NSString *const kXWCallUpdate;
extern NSString *const kXWCallRegistrationUpdate;
extern NSString *const kXWCallGlobalStateUpdate;
extern NSString *const kXWCallConfiguringStateUpdate;
extern NSString *const kXWCallBluetoothAvailabilityUpdate;
extern NSString *const kXWCallNotifyReceived;
extern NSString *const kXWCallEncryptionChanged;

//new
extern NSString *const kCallBackNotification;
extern NSString *const kCallBackType;
extern NSString *const kCaseTitle;
extern NSString *const kCaseReason;

//struct XcCall;

typedef enum{
  XWCallBackNone=0,   //tips message ,can be ignored
  XWCMDLogoutCallBack = 1,  //logout
  XWCMDChangeIPCallBack =2, //changeIP
  XWErrorCatchCallBack = 3, //error catch with reason
}XWCallBackType;


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
    network_lte,
    network_wifi
} NetworkType;

typedef enum _Connectivity {
    wifi,
    wwan,
    none
} Connectivity;

typedef enum _VoipTransport {
  TcpTransport,
  UdpTransport,
//  TLSTransport  /*TLS is unavailable currently*/
//  DTLSTransport /*DTLS is unavailable currently*/
} VoipTransport;


//***********************************
#pragma mark--********XWCallCenter

#define QWAYSDK_IOS_VERSION @"1.1.161228"  //1.13.9-110-g1581f95

/*
 @any questions, please contact：vivi705@qq.com
 New feature in v1216:
 1.Enable 3 codecs：ilbc/8kHz,g729/8kHz,silk/16kHz ，default is ilbc
 2.Enable new notification callback format，attention to change！
 3.fix bugs about hold on call & resume call;
 4.fix bugs about crash when logout to terminate somtimes;
*/
@interface XWCallCenter : NSObject

@property(nonatomic, assign)BOOL shouldDropWhenCTCallIn;
//@property (copy, nonatomic) NSString * apnsToken;
//@property (copy, nonatomic) NSString * voipToken;
XW_PUBLIC - (void)setApnsToken:(NSString *)apnsToken;
XW_PUBLIC - (void)setVoipToken:(NSString *)voipToken;

XW_PUBLIC + (XWCallCenter*)instance;
XW_PUBLIC - (void)proxyCoreWithAppKey:(NSString*)appid
                             Memberid:(NSString*)memberid
                            Memberkey:(NSString*)memberkey XW_DEPRECATED;/* Use "-proxyCoreWithAppKey: memberid: memberkey: transport: instead"*/
XW_PUBLIC - (void)proxyCoreWithAppKey:(NSString*)appid
                             memberid:(NSString*)memberid
                            memberkey:(NSString*)memberkey
                            transport:(VoipTransport)transport;//default is tcp

//XW_PUBLIC - (void)voipInitializeProxyConfig XW_DEPRECATED;/*use "-refreshVoipConfigWithtransport:" instead*/
XW_PUBLIC - (void)refreshVoipConfigWithTransport:(VoipTransport)transport;
XW_PUBLIC - (VoipTransport)currentVoipTransportConfig;

XW_PUBLIC + (BOOL)isRegistrationAvailable;
XW_PUBLIC + (BOOL)isProxyParameterAvailable;
XW_PUBLIC - (void)updateServer;

XW_PUBLIC + (BOOL)isCurrentUserOnline:(NSString*)number;

#pragma mark--CallCore Life Cycle
XW_PUBLIC - (void)resetXWCallCore;
XW_PUBLIC - (void)startXWCallCore;
XW_PUBLIC + (BOOL)isXWCallCoreReady;

#pragma markk--ProxyConfig

XW_PUBLIC + (void)removeAllAccountsData;
XW_PUBLIC - (void)destroyXWCallCore;

//called when applicationWillResignActive
XW_PUBLIC + (void)XWCallWillResignActive;//!!!
XW_PUBLIC + (void)XWCallWillTerminate;
XW_PUBLIC - (void)becomeActive;
XW_PUBLIC - (void)activeIncaseOfIncommingCall;
XW_PUBLIC - (BOOL)enterBackgroundMode;

XW_PUBLIC + (const char*)getCurrentCallAddress;
XW_PUBLIC + (const char*)getCurrentCallAddressRemoteAddress;

XW_PUBLIC - (void)call:(NSString *)address
           displayName:(NSString*)displayName
              transfer:(BOOL)transfer;

XW_PUBLIC - (void)fixRing;
XW_PUBLIC - (BOOL)allowSpeaker;

XW_PUBLIC - (void)answerCallWithVideo:(BOOL)video;
XW_PUBLIC - (void)declineCall;
XW_PUBLIC - (void)hangupCall;
XW_PUBLIC - (void)sendDigitForDTMF:(const char)digit;
XW_PUBLIC - (void)voipMicMute:(BOOL)mute;
XW_PUBLIC - (void)setSpeakerEnabled:(BOOL)enable;
XW_PUBLIC - (void)holdOnCall:(BOOL)holdOn;//pause call
XW_PUBLIC - (void)setBluetoothEnabled:(BOOL)enable;//default is enable

typedef enum _StreamInfoType {
    StreamInfo_all = 0,
    StreamInfo_trans,
} StreamInfoType;

XW_PUBLIC XW_PUBLIC - (NSString*)updateStats:(StreamInfoType)type timer:(NSTimer *)timer;//you may need a timer to invoke

XW_PUBLIC - (int)getCallDuration;
XW_PUBLIC + (NSString *)durationToString:(int)duration;
XW_PUBLIC - (BOOL)checkPhoneNumInput:(NSString *)mobileNum;//check wether the number is a chinese telephone number


@end



