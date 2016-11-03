//
//  UCSCallEvent.h
//  yzxapisdk
//
//  Created by tongkucky on 14-4-2.
//  Copyright (c) 2014年 yzx. All rights reserved.
//
#import "UCSCommonClass.h"


@protocol UCSEventDelegate<NSObject>



@optional
#pragma mark 初始化函数代理
//引擎初始化成功
- (void)onInitEngineSuccessful:(NSInteger)result;

#pragma mark VoIP通话的代理

/********************互联网音视频通话的代理********************/
//获取当电通话Callid，前提是收到APNS推送消息后初始化callid

//收到来电回调
- (void)onIncomingCall:(NSString*)callid withcalltype:(UCSCallTypeEnum) callType withcallerNumber:(NSString*)callerNumber;
//收到来电回调(支持昵称)
- (void)onIncomingCall:(NSString*)callid withcalltype:(UCSCallTypeEnum) callType withcallerinfo:(NSDictionary *)callinfo;
//呼叫振铃回调
-(void)onAlerting:(NSString*)called withVideoflag:(int)videoflag;
-(void)onAlerting:(NSString*)called;
//接听回调
-(void) onAnswer:(NSString*)callid;
//呼叫失败回调
- (void) onDialFailed:(NSString*)callid  withReason:(UCSReason*)reason;
//释放通话回调
- (void) onHangUp:(NSString*)callid withReason:(UCSReason*)reason;
// 语音质量上报回调
- (void)onNetWorkState:(UCSNetworkState)networkState;



/********************视频截图回调********************/

- (void)onCameraCapture:(NSString*)cameraCapFilePath;
/********************对方视频模式回调********************/
- (void)onRemoteCameraMode:(UCSCameraType)type;

/********************DTMF回调********************/

- (void)onDTMF:(NSString *)value;

@end