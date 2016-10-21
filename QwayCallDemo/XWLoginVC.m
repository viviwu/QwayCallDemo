//
//  XWLoginVC.m
//  QwayCallDemo
//
//  Created by viviwu on 2016/10/20.
//  Copyright © 2016年 viviwu. All rights reserved.
//

#import "XWLoginVC.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"


@interface XWLoginVC ()

@property (strong, nonatomic) IBOutlet UITextField *numberTF;
@property (strong, nonatomic) IBOutlet UITextField *passwordTF;
@property (copy, nonatomic) NSString * internationalTelephoneCode;

@end

@implementation XWLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.numberTF.text=memberid;
    self.passwordTF.text=memberkey;
    self.internationalTelephoneCode=kUserDef_OBJ(@"area");
    
    // Do any additional setup after loading the view.
}
- (IBAction)loginAction:(id)sender {
    [self.numberTF resignFirstResponder];
    [self.passwordTF resignFirstResponder];
    if (self.numberTF.text.length == 0) {
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"Number Is Empty!";
        [hud show:YES];
        [hud hide:YES afterDelay:1.4];
        
        return;
    }
    
    if (self.numberTF.text.length == 0) {
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText =  @"PasswordEmpty";
        
        [hud show:YES];
        [hud hide:YES afterDelay:1.4];
        
        return;
    }
    
    
    [self.view endEditing:YES];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    if (!kAppDel.devicePushToken) {
        kAppDel.devicePushToken=kUserDef_OBJ(@"devicetoken");//你本机获取的APNS pushtoken
    }
    //正在完善中 预计下午4:00前
    NSString *loginUrl = [NSString stringWithFormat:@"%@?appid=%@&lang=cn&mobile=%@&password=%@&devicetoken=%@&area=%@&version=%@&platform=i", sandBoxServer, kID_QWAY_APP, self.numberTF.text, self.passwordTF.text, kAppDel.devicePushToken, self.internationalTelephoneCode, kAPP_VERSION];
    
    NSLog(@"loginUrl==%@", loginUrl);
    
    NSURLRequest *loginRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:loginUrl]];
    [NSURLConnection sendAsynchronousRequest:loginRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError){
        
        if (!connectionError) {

            NSDictionary * resDic=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&connectionError];
            NSLog(@"*******resDic=%@", resDic);
            if ([[NSString stringWithFormat:@"%@",resDic[@"code"]] isEqualToString:@"100"] &&[resDic[@"data"] isKindOfClass:[NSArray class]])
            {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
                NSDictionary * dataDic=resDic[@"data"][0];
                //            NSLog(@"dataDic==%@", dataDic);
                
                [kUserDef setObject:dataDic[@"mobile"] forKey:@"phoneNum"];
                [kUserDef setObject:dataDic[@"logintoken"] forKey:@"logintoken"];
                [kUserDef setObject:dataDic[@"sipphone"] forKey:@"username"];
                [kUserDef setObject:dataDic[@"sippw"] forKey:@"password"];
                
                [kUserDef setObject:[dataDic objectForKey:@"imserver"] forKey:@"imserver"];
                [kUserDef setObject:[dataDic objectForKey:@"sipserver"] forKey:@"sipserver"];
                
                [kUserDef setObject:[dataDic objectForKey:@"paytype"] forKey:@"paytype"];
                
                [kUserDef setObject:self.passwordTF.text forKey:@"user_pass_word"];
                [kUserDef setObject:self.internationalTelephoneCode  forKey:@"countryCode"];
                [kUserDef setObject:self.internationalTelephoneCode forKey:@"COUNTRY_CODE"];
                
                [kUserDef setObject:[NSString stringWithFormat:@"%@",dataDic[@"email"]] forKey:@"email"];
                [kUserDef setObject:[NSString stringWithFormat:@"%@ ",dataDic[@"bonus"]] forKey:@"bonus"];//简直坑爹
                
                [kUserDef synchronize];
                
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.labelText =  @"LoginDone";
                hud.completionBlock = ^() {
                    
                    [kAppDel enterMainViewWithIdentifier:@"0"];
                };
                [hud show:YES];
                [hud hide:YES afterDelay:1.0];
                
            }else{
                [self showDetailInfo:[NSString stringWithFormat:@"Error:%@", resDic[@"msg"]]];
            }
            
        }else {
            NSLog(@"%@",connectionError);
            [self showDetailInfo: @"NetworkError" ];
        }
    }];

}

- (IBAction)stopEdit:(id)sender {
    [self.view endEditing:YES];
}

- (void)showDetailInfo:(NSString*)msg
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = msg;
    
    [hud show:YES];
    [hud hide:YES afterDelay:1.4];
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
