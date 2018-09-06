//
//  XWOnCallVC.h
//  QwayCallDemo
//
//  Created by viviwu on 2014/10/20.
//  Copyright © 2014年 viviwu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XWCallCenter.h"

@interface XWOnCallVC : UIViewController

+(XWOnCallVC*)instance;

-(void)resetControlersToDefaultState;
-(void) terminateCurrentCall;

@end
