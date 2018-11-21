//
//  CatchExceptionDispose.m
//  Demo
//
//  Created by 刘松洪 on 2018/11/10.
//  Copyright © 2018年 刘松洪. All rights reserved.
//

#import "CatchExceptionDispose.h"
#import "CatchExceptionTextView.h"
#import "Masonry.h"
#import <MessageUI/MessageUI.h>
#import "QuickAlertView.h"

@interface CatchExceptionDispose () <MFMailComposeViewControllerDelegate>
@property (nonatomic, strong) UIViewController *topViewController;
@end

@implementation CatchExceptionDispose
+ (instancetype)shareInstance {
    static CatchExceptionDispose *_dispose = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _dispose = [[CatchExceptionDispose alloc] init];
    });
    return _dispose;
}


static NSInteger dismissed = 0;
- (NSInteger *)showExceptionStr:(NSString *)exceptionStr exception:(NSException *)exception {
    UIViewController *currentVC = [CatchExceptionDispose currentTopViewController];
    self.topViewController = currentVC;
    if (DEBUG)
    {
 
        CatchExceptionTextView *textView = [[CatchExceptionTextView alloc] initWithFrame:CGRectZero textContainer:nil];
        textView.editable = NO;
        [textView setText:exceptionStr];
        textView.textColor = [UIColor redColor];
        [currentVC.view addSubview:textView];
        [textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(currentVC.view);
        }];
        textView.DissMissBlock = ^{
            dismissed = 1;
        };
        return &dismissed;
    }
    else
    {
        [QuickAlertView presentAlertViewWithTitle:@"抱歉，由于程序猿发呆导致程序崩溃"
                                           message:@"您可以发送邮件给引起此问题的序猿狠狠怼他"
                                          showType:UIAlertControllerStyleAlert
                                            cancel:@"原谅他了,不发了"
                                           comform:@"我要狠狠怼他!"
                                           present:currentVC
                                      comformBlock:^(UIAlertAction * _Nullable action) {
                                          if ([MFMailComposeViewController canSendMail])
                                          {
                                              MFMailComposeViewController *vc = [self senderEmail:exceptionStr exception:exception];
                                              [currentVC presentViewController:vc animated:YES completion:nil];
                                          }
                                          else
                                          {
                                              UIPasteboard *paste = [UIPasteboard generalPasteboard];
                                              paste.string = exceptionStr;
                                              [QuickAlertView presentAlertViewWithTitle:@"检测到您的手机未配置邮箱，所以不能发送邮件"
                                                                                 message:@"日志已经拷贝到剪切板，你可以通过其他方式将崩溃信息反馈到我司"
                                                                                showType:UIAlertControllerStyleAlert
                                                                                  cancel:nil
                                                                                 comform:@"点击就闪退啦！"
                                                                                 present:currentVC
                                                                            comformBlock:^(UIAlertAction * _Nullable action) {
                                                                                dismissed = 1;
                                                                            } cacelBlock:nil
                                                                               showBlock:nil];
                                          }
                                      } cacelBlock:^(UIAlertAction * _Nullable action) {
                                          dismissed = 1;
                                      } showBlock:nil];
        
        return &dismissed;
    }
}


#pragma mark - 发送邮件
- (MFMailComposeViewController *)senderEmail:(NSString *)exceptionStr exception:(NSException *)exception {
    MFMailComposeViewController *mailCompose = [[MFMailComposeViewController alloc] init];
    [mailCompose setMailComposeDelegate:self];
    [mailCompose setToRecipients:@[@"yunxiyaoyue@163.com"]];//收件人
    [mailCompose setCcRecipients:@[@"996962732@qq.com"]];//抄送人
//    [mailCompose setBccRecipients:@[]];//设置密送人
    [mailCompose setSubject:@"程序崩溃"];
    NSString *emailContent = exceptionStr;
    [mailCompose setMessageBody:emailContent isHTML:NO];
    
    return mailCompose;
}


#pragma mark - MFMailComposeViewControllerDelegate
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(nullable NSError *)error {
    NSString *resultStr = @"";
    switch (result) {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail send canceled: 用户取消编辑");
            resultStr = @"谢谢不怼之恩";
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved: 用户保存邮件");
            resultStr = @"邮件保存成功";
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent: 用户点击发送");
            resultStr = @"恭喜你，成功怼到程序猿";
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail send errored: %@ : 用户尝试保存或发送邮件失败", [error localizedDescription]);
            resultStr = [NSString stringWithFormat:@"Mail send errored: %@ : 用户尝试保存或发送邮件失败", [error localizedDescription]];
            break;
    }
    [controller dismissViewControllerAnimated:YES completion:^{
        [QuickAlertView presentAlertViewWithTitle:resultStr
                                           message:nil
                                          showType:UIAlertControllerStyleAlert
                                            cancel:nil
                                           comform:@"点击就闪退啦！"
                                           present:self.topViewController
                                      comformBlock:^(UIAlertAction * _Nullable action) {
                                          dismissed = 1;
                                      } cacelBlock:nil
                                         showBlock:nil];
    }];
    
}



+ (UIViewController *)currentTopViewController
{
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    
    if ([rootViewController isKindOfClass:[UITabBarController class]])
    {
        
        UINavigationController *nav =  (UINavigationController *)[(UITabBarController *)rootViewController selectedViewController];
        UIViewController *presentedVC = [[self class] topModalViewControllerFromCurViewController:nav];//nav.presentedViewController;
        
        // 无模态
        if (!presentedVC)
        {
            return nav.topViewController;
        }
        
        if (presentedVC == nav)
        {
            return nav.topViewController;
        }
        
        // 模态一个视图控制器
        if (![presentedVC isKindOfClass:[UINavigationController class]])
        {
            return presentedVC;
        }
        
        // 正在移除的情况下 消失
        if ([presentedVC isBeingDismissed] || [presentedVC isMovingFromParentViewController])
        {
            UIViewController *presetingViewController = presentedVC.presentingViewController;
            if ([presetingViewController isKindOfClass:[UITabBarController class]])
            {
                return nav.topViewController;
            }
            
            if ([presetingViewController isKindOfClass:[UINavigationController class]])
            {
                return ((UINavigationController *)presetingViewController).topViewController;
            }
        }
        
        return ((UINavigationController *)presentedVC).topViewController;
        
    }
    
    if ([rootViewController isKindOfClass:[UINavigationController class]])
    {
        return ((UINavigationController *)rootViewController).topViewController;
    }
    
    
    return rootViewController;
}

+ (UIViewController *)topModalViewControllerFromCurViewController:(UIViewController *)curViewController
{
    if (!curViewController)
    {
        return nil;
    }
    
    if (!curViewController.presentedViewController)
    {
        return curViewController;
    }
    
    return [[self class] topModalViewControllerFromCurViewController:curViewController.presentedViewController];
}
@end
