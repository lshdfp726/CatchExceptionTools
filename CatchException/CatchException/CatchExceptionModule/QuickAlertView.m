//
//  QuickAlertView.m
//  CatchException
//
//  Created by 刘松洪 on 2018/11/16.
//  Copyright © 2018年 刘松洪. All rights reserved.
//

#import "QuickAlertView.h"

@implementation QuickAlertView
+ (void)presentAlertViewWithTitle:(NSString *)title
                          message:(NSString *)message
                         showType:(UIAlertControllerStyle)type
                           cancel:(NSString *)cancelTitle
                          comform:(NSString *)conformTitle
                          present:(UIViewController *)present
                     comformBlock:(void (^ __nullable)(UIAlertAction *action))comformBlock
                       cacelBlock:(void (^ __nullable)(UIAlertAction *action))cancelBlock
                        showBlock:(void(^)(void))showBlock {
    UIAlertController *vc = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    
    UIAlertAction *comfire = nil;
    UIAlertAction *cancel  = nil ;
    
    if (conformTitle && conformTitle.length != 0) {
        comfire = [UIAlertAction actionWithTitle:conformTitle style:UIAlertActionStyleDefault handler:comformBlock];
        [vc addAction:comfire];
    }
    
    if (cancelTitle && cancelTitle.length != 0) {
        cancel = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:cancelBlock];
        [vc addAction:cancel];
    }
    
    [present presentViewController:vc animated:YES completion:showBlock];
}

@end
