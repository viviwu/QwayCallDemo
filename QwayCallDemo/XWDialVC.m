//
//  XWDialVC.m
//  QwayCallDemo
//
//  Created by viviwu on 2014/10/20.
//  Copyright © 2014年 viviwu. All rights reserved.
//

#import "XWDialVC.h"
#import "AppDelegate.h"

@interface XWDialVC ()

@property (strong, nonatomic) IBOutlet UIView *accountView;
@property (strong, nonatomic) IBOutlet UITextField *memberidTF;
@property (strong, nonatomic) IBOutlet UITextField *memberkeyTF;

@property (strong, nonatomic) IBOutlet UIView *dialView;
@property (strong, nonatomic) IBOutlet UILabel *accountLabel;
@property (strong, nonatomic) IBOutlet UITextField *numberTF;
@property (nonatomic, copy) NSString * dialNumber;
@property (nonatomic, copy) NSString * dialName;
@property (strong, nonatomic) IBOutlet UIButton *checkOutBtn;

@end

@implementation XWDialVC
- (id)initWithCoder:(NSCoder *)aDecoder
{
  self=[super initWithCoder:aDecoder];
  if (self) {
    //检测 sip注册状态
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(registrationUpdate:)  name:kXWCallRegistrationUpdate object:nil];
    
  }
  return self;
}

- (void)dealloc
{
  [[NSNotificationCenter defaultCenter] removeObserver:self name:kXWCallRegistrationUpdate object:nil];
}

- (void)registrationUpdate:(NSNotification*)notif
{
  XWCallRegistrationState state = [[notif.userInfo objectForKey: @"state"] intValue];
  NSString * message=[notif.userInfo objectForKey: @"message"];
  NSString * stateInfo=message;
  //    NSLog(@"registrationUpdate:------>\n%@", notif.userInfo);
  switch (state) {
    case XWCallRegistrationNone:
      stateInfo=@"CallRegistration None";
      break;
      
    case XWCallRegistrationProgress:
      stateInfo=@"CallRegistration Progress";
      break;
      
    case XWCallRegistrationOk:
      stateInfo=@"CallRegistration Ok";
      _accountLabel.text=kUserDef_OBJ(@"sipphone");
      _accountView.hidden=YES;
      _checkOutBtn.hidden=NO;
      _dialView.hidden=NO;
      self.view.backgroundColor=[UIColor groupTableViewBackgroundColor];
      break;
      
    case XWCallRegistrationCleared:
      stateInfo=@"CallRegistration Cleared";
      break;
      
    case XWCallRegistrationFailed:
      stateInfo=@"CallRegistration Failed";
      self.view.backgroundColor=[UIColor brownColor];
      break;
      
    default:
      break;
  }
  self.title=stateInfo;
}

- (IBAction)checkOnlineStatus:(id)sender {
  if (_numberTF.text.length>0){
    self.dialNumber=_numberTF.text;
  }
  
  if ([XWCallCenter isCurrentUserOnline:_dialNumber]) {
    NSLog(@"%@ is online!!!",_dialNumber);
  }else{
    NSLog(@"%@ is offline!!!", _dialNumber);
  }
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  _dialName=@"vivi";
  _dialNumber=@"300621";
  
  _memberidTF.text=memberid2;
  _memberkeyTF.text=memberkey2;
  self.view.backgroundColor=[UIColor brownColor];
  ((AppDelegate*)[UIApplication sharedApplication].delegate).mainDialVC=(id)self;
  // Do any additional setup after loading the view.
}

- (IBAction)saveAcount:(id)sender {
  if (_memberidTF.text != nil) {
    [kUserDef setObject:_memberidTF.text forKey:@"memberid"];
    kAppDel.currentMemberid=_memberidTF.text;
  }
  if (_memberkeyTF.text !=nil) {
    [kUserDef setObject:_memberkeyTF.text forKey:@"memberkey"];
    kAppDel.currentMemberkey=_memberkeyTF.text;
  }
  [kUserDef synchronize];
  
  [self refreshSipConnect:nil];
}

- (IBAction)refreshSipConnect:(id)sender {
  //登陆信息异常 重新登陆
  if (![XWCallCenter isXWCallCoreReady]) {
    [[XWCallCenter instance] startXWCallCore];
  }else{
    [[XWCallCenter instance] proxyCoreWithAppKey:kAppID
                                        Memberid:kAppDel.currentMemberid
                                       Memberkey:kAppDel.currentMemberkey];
  }
}

-(void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  if (_numberTF.text.length>0){
    self.dialNumber=_numberTF.text;
  }
  [self performSelector:@selector(checkLoginState) withObject:nil afterDelay:5.0f];
}
-(void)checkLoginState
{
  if (![XWCallCenter isProxyParameterAvailable])
  {
    [[XWCallCenter instance] updateServer];
  }
  
}

- (IBAction)stopEdit:(id)sender {
  [self.view endEditing:YES];
}

- (IBAction)makeVoipCall:(id)sender {
  [self.view endEditing:YES];
  if (_numberTF.text.length>0){
    self.dialNumber=_numberTF.text;
  }else{
    return;
  }
  if ([XWCallCenter isXWCallCoreReady]) {
    [[XWCallCenter instance]call:self.dialNumber
                     displayName:self.dialName
                        transfer:NO];
  }
}

- (IBAction)logoutAction:(id)sender {
  
  _accountView.hidden=NO;
  _dialView.hidden=YES;
  
  [kAppDel logoutAction];
  
}
 

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
