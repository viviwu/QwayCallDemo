//
//  XWOnCallVC.h
//  QwayCallDemo
//
//  Created by viviwu on 2016/10/20.
//  Copyright © 2016年 viviwu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XWCallCenter.h"

@interface XWOnCallVC : UIViewController

+(XWOnCallVC*)instance;

-(void)resetControlersToDefaultState;
-(void) terminateCurrentCall;

@end
