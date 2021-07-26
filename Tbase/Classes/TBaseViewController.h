//
//  TBaseViewController.h
//  YewenPlayerDemo
//
//  Created by phq on 2018/8/14.
//  Copyright © 2018年 phq. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TBaseViewController : UIViewController

#pragma mark -ViewLifeCycle
@property (nonatomic, assign, readonly) BOOL viewWillFirstAppeared;
@property (nonatomic, assign, readonly) BOOL viewDidFirstAppeared;
- (void)viewWillFirstAppear;    // ViewController首次将要呈现。抽象方法，子类可以重载
- (void)viewDidFirstAppear;     // ViewController首次已呈现。抽象方法，子类可以重载
/// 以下配置应在初始化-init()方法体中完成配置
#pragma mark -Status Bar
@property (nonatomic) BOOL hiddenStatusBar;                 // 状态栏是否隐藏，默认NO
@property (nonatomic) UIStatusBarStyle statusBarStyle;      // 状态栏类型,默认UIStatusBarStyleDefault
#pragma mark -Navigation Bar
@property (nonatomic) BOOL hiddenNavigationShadow;          // 隐藏导航栏底部分隔线阴影
#pragma mark -Orientation
@property (nonatomic) BOOL shouldAutorotate;                // 是否允许自动转屏，默认NO
- (void)interfaceOrientation:(UIInterfaceOrientation)orientation;  // 强制转屏
#pragma mark -interactivePopGestureRecognizer
@property (nonatomic) BOOL popGestureEnabled; //右滑返回手势是否激活，默认返回YES。
@end

@interface TBaseViewController (Alert)

/// 简单的Alert（只有“确定”按钮）
/// @param title 提示标题。title 与 message 两者至少其一不为空。
/// @param message  提示内容。title 与 message 两者至少其一不为空。
/// @param handler 点击按钮后回调
- (void)alertWithTitle:(nullable NSString *)title
               message:(nonnull NSString *)message
               handler:(void (^ __nullable)(UIAlertAction * _Nonnull action))handler;

/// 带TextField的Alert（只有“取消和确定”按钮）。可通过alertController.textFields获取对应的textFiled。
/// @param title 提示标题。title 与 message 两者至少其一不为空。
/// @param message 提示内容。title 与 message 两者至少其一不为空。
/// @param handler 点击按钮后回调
- (void)alertTextFieldWithTitle:(nullable NSString *)title
                        message:(nonnull NSString *)message
                        handler:(void (^ __nullable)(UIAlertController * _Nonnull alertController,UIAlertAction * _Nonnull action))handler;

/// 系统提示框Alert，会自动回到主线程执行。
/// @param title 提示标题。title 与 message 两者至少其一不为空。
/// @param message 提示内容。title 与 message 两者至少其一不为空。
/// @param cancelTitle 取消按钮的标题，默认“确定”。
/// @param othertitles 其它按钮标题。
/// @param handler 点击按钮后回调，可以通过action的style属性和title属性判断得知点击了哪个按钮。
- (void)alertWithTitle:(nullable NSString *)title
               message:(nullable NSString *)message
     cancelButtonTitle:(nullable NSString *)cancelTitle
     otherButtonTitles:(nullable NSArray <NSString *> *)othertitles
               handler:(void (^ __nullable)(UIAlertAction * _Nonnull action))handler;

/// ActionSheet
/// @param title 提示标题。
/// @param message 提示内容。
/// @param set 选项集，选项个数必须大于等于1，否则被忽略。
/// @param handler 点击选项集的回调block。
- (void)actionSheetWithTitle:(nullable NSString *)title
                     message:(nullable NSString *)message
                       items:(NSSet <NSString *> *_Nonnull)set
                     handler:(void (^ __nullable)(UIAlertAction * _Nonnull action))handler;

@end

@interface TBaseViewController (AbnormalIOS13)

/// iOS13 获取当前Controller的暗黑模式状态:-1未知，0正常，1暗黑模式
- (int)darkModeStyle;

/// iOS13  禁用当前Controller的暗黑模式
- (void)darkModeDisable;

/// 模态全屏展示
/// @param ctl 将要模态呈现的UIViewController
- (void)modalPresentFullScreen:(UIViewController *_Nonnull)ctl;

@end
