//
//  CatchExceptionTextView.m
//  Demo
//
//  Created by 刘松洪 on 2018/11/9.
//  Copyright © 2018年 刘松洪. All rights reserved.
//

#import "CatchExceptionTextView.h"
#define CLICK 5

@interface CatchExceptionTextView ()<UIResponderStandardEditActions>

@end

@implementation CatchExceptionTextView
static NSInteger count = 0;
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    count ++;
    if (count > CLICK) {
        if (self.DissMissBlock) {
            self.DissMissBlock();
        }
    }
}


#pragma mark -UIResponderStandardEditActions
- (BOOL)canPerformAction:(SEL)action withSender:(nullable id)sender {
    if (action == @selector(selectAll:)) {
        return YES;
    }
    return NO;
}


- (void)selectAll:(id)sender {
    UIPasteboard *paste = [UIPasteboard generalPasteboard];
    paste.string = self.text;
    NSString *str = [self.text copy];
    NSRange range = NSMakeRange(0, str.length);
    self.selectedRange = range;
}
@end
