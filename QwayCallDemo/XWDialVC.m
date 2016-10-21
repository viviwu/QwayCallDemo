//
//  XWDialVC.m
//  QwayCallDemo
//
//  Created by viviwu on 2016/10/20.
//  Copyright © 2016年 viviwu. All rights reserved.
//

#import "XWDialVC.h"
#import "AppDelegate.h"

@interface XWDialVC ()
@property (strong, nonatomic) IBOutlet UITextField *numberTF;
@property (nonatomic, copy) NSString * dialNumber;
@property (nonatomic, copy) NSString * dialName;
@end

@implementation XWDialVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _dialName=@"vivi";
    _dialNumber=@"13048839909";
    // Do any additional setup after loading the view.
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (![kUserDef_OBJ(@"username") length] ||
        ![kUserDef_OBJ(@"password") length] ||
        ![kUserDef_OBJ(@"logintoken") length] ||
        ![kUserDef_OBJ(@"sipserver") length] ||
        ![kUserDef_OBJ(@"imserver") length])
    {
        [UIView animateWithDuration:1.0f animations:^(){
            [kAppDel enterMainViewWithIdentifier:@"1"];
        }];
    }
}
- (IBAction)stopEdit:(id)sender {
    [self.view endEditing:YES];
}

- (IBAction)makeVoipCall:(id)sender {
    
    if (_numberTF.text.length>0){
        self.dialNumber=_numberTF.text;
    }else{
        return;
    }
    [[XWCallCenter instance]call:self.dialNumber
                     displayName:self.dialName
                        transfer:NO];
    
}

//- (IBAction)makeOutCall:(id)sender {
//    
//    if (self.dialNumber.length>0) {
//        if (![[self.dialNumber substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"0"])
//        {
//            if ([self.dialNumber rangeOfString:@"+"].location !=NSNotFound)
//            {
//                self.dialNumber  = (NSString *)[self.dialNumber  stringByReplacingOccurrencesOfString:@"+" withString:@"00"];
//            }else{
//                self.dialNumber = [NSString stringWithFormat:@"00%@%@", kUserDef_OBJ(@"countryCode"), self.dialNumber];
//            }
//        }
//        NSLog(@"%s--%@", __func__, self.dialNumber);
//        [[XWCallCenter instance]call:self.dialNumber displayName:self.dialName transfer:NO];
//    }
//}
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
