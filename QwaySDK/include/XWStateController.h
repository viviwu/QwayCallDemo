//
//  XWStateController.h
//  XWPhone
//
//  Created by viviwu on 2016/10/20.
//  Copyright © 2016年 viviwu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

extern NSString *const kCallRemoteCommandNotification;
extern NSString *const kCallRemoteCommandKey;
extern NSString *const kSocketNotification;
extern NSString *const kSocketNotificationConnectKey;

typedef enum XMPPConnectStatus {
    
    XMPPConnectStatus_Failed,        //XMPP连接失败
    XMPPConnectStatus_Connected,     //XMPP已连接
    XMPPConnectStatus_Timeout,       //XMPP连接超时
    XMPPConnectStatus_Disconnect,    //XMPP连接已断开
    XMPPConnectStatus_Connecting,    //XMPP连接中
    
}XMPPConnectStatus;

typedef enum _CallRemoteCommand {
    XWCallRemoteCommandLogout = 0 ,   //远程命令下线  （异地登录或安全问题等）
    XWCallRemoteCommandChangeServer,    //服务IP要改变了
    
} XWCallRemoteCommand;

//typedef enum XMPPMessageStatus {
//    
//    XMPPMessageStatus_Sent,          //消息已发送
//    XMPPMessageStatus_Received,      //对方已接收到消息
//    XMPPMessageStatus_Read,          //对方已查看到消息
//    XMPPMessageStatus_SendFailed,    //消息发送失败
//    XMPPMessageStatus_Coming,        //新消息到达
//    
//}XMPPMessageStatus;
//=============================================

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
    XWCallEarlyUpdatedByRemote, /*<The call is updated by remote while not yet answered (early dialog SIP UPDATE received).*/
    XWCallEarlyUpdating /*<We are updating the call while not yet answered (early dialog SIP UPDATE sent)*/
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


@interface XWStateController : NSObject

@property (nonatomic, strong) NSTimer * pingTimer;
@property (nonatomic, assign) NSInteger unreadBadge;

@end
