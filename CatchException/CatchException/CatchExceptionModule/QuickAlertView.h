//
//  QuickAlertView.h
//  CatchException
//
//  Created by 刘松洪 on 2018/11/16.
//  Copyright © 2018年 刘松洪. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuickAlertView : UIView
/**
 * 目前支持8.0以后了，之前的不需要兼容
 * 成功/或者失败的按钮不需要就传nil
 * showBlock 成功推出UIAlertViewController 的回调
 */
+ (void)presentAlertViewWithTitle:(NSString *)title
                          message:(NSString *)message
                         showType:(UIAlertControllerStyle)type
                           cancel:(NSString *)cancelTitle
                          comform:(NSString *)conformTitle
                          present:(UIViewController *)present
                     comformBlock:(void (^ _Nullable)(UIAlertAction * _Nullable action))comformBlock
                       cacelBlock:(void (^ _Nullable)(UIAlertAction * _Nullable action))cancelBlock
                        showBlock:(void (^ _Nullable)(void))showBlock;
@end
