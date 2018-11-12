//
//  CatchExceptionTextView.h
//  Demo
//
//  Created by 刘松洪 on 2018/11/9.
//  Copyright © 2018年 刘松洪. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CatchExceptionTextView : UITextView
@property (nonatomic, copy) void(^DissMissBlock)(void);
@end
