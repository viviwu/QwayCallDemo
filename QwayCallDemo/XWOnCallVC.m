//
//  XWOnCallVC.m
//  QwayCallDemo
//
//  Created by viviwu on 2016/10/20.
//  Copyright © 2016年 viviwu. All rights reserved.
//

#import "XWOnCallVC.h"
#import "AppDelegate.h"

const static char _keyValues[] = {0, '1', '2', '3', '4', '5', '6', '7', '8', '9', '*', '0', '#'};
@interface XWOnCallVC ()
{
    NSTimer * callTimer;
}

@property (weak, nonatomic) IBOutlet UILabel * numberLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;

@property (strong, nonatomic) IBOutlet UIView * keypad;
@property (strong, nonatomic) IBOutlet UIButton * hungUpBtn;
@property (strong, nonatomic) IBOutlet UIButton * rejectBtn;
@property (strong, nonatomic) IBOutlet UIButton * answerBtn;

@property (strong, nonatomic) IBOutlet UIButton *micMuteBtn;
@property (strong, nonatomic) IBOutlet UIButton *speakerBtn;
@property (strong, nonatomic) IBOutlet UIButton *holdOnBtn;

@end

static XWOnCallVC * globalOBJ=nil;
@implementation XWOnCallVC


+(XWOnCallVC*)instance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        globalOBJ =[[XWOnCallVC alloc]initWithIdentifier:@"3"];
    });
    return globalOBJ;
}

- (instancetype)initWithIdentifier:(NSString *)identifier {
    self=[super init];
    UIStoryboard * mianBoard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self = (XWOnCallVC*)[mianBoard instantiateViewControllerWithIdentifier:identifier];
    if (self) {
        //检测voip来电状态
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(callUpdateWithCallNotification:)
                                                     name:kXWCallUpdate
                                                   object:nil];
        
        
    }
    return self;
}

-(void)reportToCallKit:(NSString *)handle :(BOOL)hasVideo{
//    UIBackgroundTaskIdentifier backgroundTaskIdentifier = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil];
//    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        NSUUID * uuid = [NSUUID UUID];
//        [[XWProviderDelegate staticProvider] reportIncomingCallUUID:uuid handle:handle hasVideo:hasVideo completion:^(NSError * error){
//            
//            [[UIApplication sharedApplication] endBackgroundTask:backgroundTaskIdentifier];
//        }];
//        
//    });
}

-(void)resetControlersToDefaultState{
    
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    [UIDevice currentDevice].proximityMonitoringEnabled = NO;

    [[XWCallCenter instance] voipMicMute:false]; //非静音
    [[XWCallCenter instance] setSpeakerEnabled: false]; //非免提
}

-(void) terminateCurrentCall
{
//    BOOL iOS_10= [XWCallCenter currentOSversionOver:9.9];
//    _currentCall=[XWCallManager sharedManager].calls.lastObject;
//    [_currentCall descriptionCall];
//    if (iOS_10 && _currentCall&&_currentCall.UUID) {
//        [[XWCallManager sharedManager] endCall:_currentCall];
//    }
    if (callTimer) {
        [callTimer invalidate];
    }
    [[XWOnCallVC instance].view removeFromSuperview];
    
    [[XWCallCenter instance] hangupCall];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (void)callUpdateWithCallNotification:(NSNotification*)notify
{
    NSLog(@"callUpdate==%@", notify.userInfo[@"message"]);
    XWCallState state = [[notify.userInfo objectForKey: @"state"] intValue];
    
    switch (state)
    {
        case XWCallOutgoingInit:
        case XWCallOutgoingProgress:
        case XWCallOutgoingRinging:
        case XWCallOutgoingEarlyMedia:
        {
            _timeLabel.text= @"Outgoing Progress";
            _answerBtn.hidden=YES;
            _rejectBtn.hidden=YES;
            _hungUpBtn.hidden=NO;
            
            [kAppDel.window addSubview:[XWOnCallVC instance].view];
            
            const char* constChar=[XWCallCenter getCurrentCallAddress];
            NSString *userName = [[NSString alloc] initWithUTF8String:constChar];
            NSLog(@"当前呼叫号码== %@", userName);
            _numberLabel.text=userName;

        }
            break;
            
        case XWCallIncomingReceived:
        {
            if ([callTimer isValid]) {
                callTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self  selector:@selector(timeout:) userInfo:nil repeats:YES];
                [callTimer fire];
            }
            _timeLabel.text= @"Incoming Call";

            NSString * osVersion=[[UIDevice currentDevice] systemVersion];
            BOOL is_iOS10=[osVersion floatValue]>9.0 ? YES : NO;
            if (is_iOS10)
            {
                const char* constChar=[XWCallCenter getCurrentCallAddress];
                NSString *userName = [[NSString alloc] initWithUTF8String:constChar];
                [self reportToCallKit:userName :NO];
                [UIView  animateWithDuration:2.0 animations:^{
                    [kAppDel.window addSubview:[XWOnCallVC instance].view];
                }];
            }else{
                [kAppDel.window addSubview:[XWOnCallVC instance].view];
            }
            [UIDevice currentDevice].proximityMonitoringEnabled = YES;
            [UIApplication sharedApplication].idleTimerDisabled = YES;
            _answerBtn.hidden=NO;
            _hungUpBtn.hidden=YES;
            _rejectBtn.hidden=NO;
            _keypad.hidden=YES;
        }
            break;
            
        case XWCallPausedByRemote:
        { /**<The call is paused by remote end*/
            
        }
        case XWCallConnected:
        case XWCallStreamsRunning:
        {
            if (nil == callTimer) {
                callTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self  selector:@selector(timeout:) userInfo:nil repeats:YES];
                [callTimer fire];
            }
            [UIDevice currentDevice].proximityMonitoringEnabled = YES;
            _answerBtn.hidden=YES;
            _rejectBtn.hidden=YES;
            _hungUpBtn.hidden=NO;
            _keypad.hidden=NO;
        }
            break;
            
        case XWCallUpdatedByRemote:
        {/**<like:when video is added by remote */
            
        }
            break;
            
        case XWCallError:
        {//Busy Here
            NSString * errorMsg = [notify.userInfo objectForKey:@"message"];
            NSLog(@"errorMsg==%@", errorMsg);
            if (errorMsg) {
//                [self showAlertMessage:errorMsg];
            }
        }
        case XWCallEnd:
        {
            [self resetControlersToDefaultState];
            _timeLabel.text= @"CallEnded";
            [[XWOnCallVC instance].view removeFromSuperview];
            
            [self performSelector:@selector(terminateCurrentCall)
                       withObject:nil
                       afterDelay:1.0];
        }
            break;
        case XWCallReleased:
            if (!kUserDef_OBJ(@"DisableSound"))
            {
//                NSBundle *mainBundle = [NSBundle mainBundle];
//                NSString *path = [mainBundle pathForResource:@"hungup" ofType:@"wav"];
//                [XWUtilsCenter playSoundWithFileName:path];
            }
            break;
            
        default:
            break;
    }
    
}

- (IBAction)answerTheCall:(id)sender {
    [[XWCallCenter instance] answerCallWithVideo:NO];
    _answerBtn.hidden=YES;
    _rejectBtn.hidden=YES;
    _hungUpBtn.hidden=NO;
}

//  declineCall
- (IBAction)rejectTheCall:(id)sender
{
//    BOOL iOS_10= [XWCallCenter currentOSversionOver:9.9];
//    _currentCall=[XWCallManager sharedManager].calls.lastObject;
//    
//    if (iOS_10 && _currentCall&&_currentCall.UUID) {
//        [[XWCallManager sharedManager] endCall:_currentCall];
//    }
    [[XWCallCenter instance] declineCall];
}

// endCall
- (IBAction)hungUpTheCall:(id)sender
{
    [self terminateCurrentCall];
}

//static NSString *_keyStrs[] = {nil, @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"*", @"0", @"#"};

- (IBAction)didTapDTMFKey:(UIButton *)sender {
    //这个功能对你们来说 并没有什么卵用  可以不用加
    int index=(int)(sender.tag);
    const char digit = _keyValues[index];
    NSLog(@"digit==%c", digit );
    [[XWCallCenter instance] sendDigitForDTMF:digit];
}

- (IBAction)micphoneMute:(UIButton*)sender {
    if(![XWCallCenter isXWCallCoreReady]) {
        return;
    }
    sender.selected=!sender.selected;
    [[XWCallCenter instance] voipMicMute:sender.selected];
}

- (IBAction)speakerHandsFree:(UIButton*)sender {
    sender.selected=!sender.selected;
    [[XWCallCenter instance] setSpeakerEnabled: sender.selected];
}

- (IBAction)holdOnTheCall:(UIButton*)sender {
    sender.selected=!sender.selected;
    [[XWCallCenter instance] holdOnCall: sender.selected];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kXWCallUpdate object:nil];
}

static int duration = 0;
- (void)timeout:(id)unused
{
    duration++; NSLog(@"+++++time:%d", duration);
    if (duration >= 3600) {
        long sec = duration % 3600;
        _timeLabel.text=[NSString stringWithFormat:@"%d:%02ld:%02ld", duration/3600, sec/60, sec%60];
    } else {
        _timeLabel.text=[NSString stringWithFormat:@"%02d:%02d", duration/60, duration%60];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
