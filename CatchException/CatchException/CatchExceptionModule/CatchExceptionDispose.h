//
//  CatchExceptionDispose.h
//  Demo
//
//  Created by 刘松洪 on 2018/11/10.
//  Copyright © 2018年 刘松洪. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CatchExceptionDispose : NSObject
/**
 * 崩溃处理类
 */

+ (instancetype)shareInstance;
- (NSInteger *)showExceptionStr:(NSString *)exceptionStr exception:(NSException *)exception;
@end
