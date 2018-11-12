//
//  CatchExceptionManager.h
//  Demo
//
//  Created by 刘松洪 on 2018/11/9.
//  Copyright © 2018年 刘松洪. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CatchExceptionManager : NSObject
+ (void)startListenException;//开始监听

//维持崩溃时的线程循环
+ (void)retainCycle:(NSString *)exceptionStr exception:(NSException *)exception;
@end
