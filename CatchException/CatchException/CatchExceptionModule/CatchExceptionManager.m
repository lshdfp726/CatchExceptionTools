//
//  CatchExceptionManager.m
//  Demo
//
//  Created by 刘松洪 on 2018/11/9.
//  Copyright © 2018年 刘松洪. All rights reserved.
//

#import "CatchExceptionManager.h"
#import "CatchExceptionDispose.h"

NSString * const UncaughtExceptionHandlerSignalExceptionName = @"UncaughtExceptionHandlerSignalExceptionName";

static void ExceptionHandler(NSException *exception) {
    NSArray *arr = [exception callStackSymbols];
    NSString *reason = [exception reason];
    NSString *name = [exception name];
    NSString *exceptionStr = [NSString stringWithFormat:@"exception type : %@ \n crash reason : %@ \n call stack info : %@", name, reason, arr];
    [CatchExceptionManager retainCycle:exceptionStr exception:exception];
}


@implementation CatchExceptionManager
+ (void)startListenException {
    /**
     * 抓去崩溃前一分钟的日志
     */
    NSSetUncaughtExceptionHandler(&ExceptionHandler);
}


+ (void)retainCycle:(NSString *)exceptionStr exception:(NSException *)exception {
    NSInteger *disMiss = [[CatchExceptionDispose shareInstance] showExceptionStr:exceptionStr exception:exception];
    CFRunLoopRef runLoop = CFRunLoopGetCurrent();
    CFArrayRef allModes = CFRunLoopCopyAllModes(runLoop);
    do {
        for (NSString *mode in (__bridge NSArray *)allModes) {
            CFRunLoopRunInMode((CFStringRef)mode, 0.001, false);
//            CFRunLoopRunResult result = CFRunLoopRunInMode((CFStringRef)mode, 0.001, false);
//            NSLog(@"%d",(int)result);
        }
    } while (!*disMiss);
    CFRelease(allModes);
    exit(0);
}


@end
