//
//  AppDelegate.m
//  YSQLogTest
//
//  Created by ysq on 14/8/6.
//  Copyright (c) 2014年 ysq. All rights reserved.
//

#import "AppDelegate.h"
#import "YSQLog.h"
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //log init
    YSQLogInit();
    
    //test
    NSArray *test = @[];
    NSLog(@"%@",test[3]);
    
    //open Library/Caches/com.ysq.ysq.errorLog
    
    return YES;
}


@end
