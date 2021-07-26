//
//  TBaseViewController.m
//  YewenPlayerDemo
//
//  Created by phq on 2018/8/14.
//  Copyright © 2018年 phq. All rights reserved.
//

#import "TBaseViewController.h"

#define rgbColor(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)/1.0f]

@interface HPBaseViewController ()
@property (nonatomic, assign) BOOL viewWillFirstAppeared;
@property (nonatomic, assign) BOOL viewDidFirstAppeared;
@property (nonatomic, assign) BOOL interactivePopGestureRecognizerEnabled; //右滑返回手势是否激活，默认返回YES。
@end

@implementation TBaseViewController

#pragma mark - Init

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self performInitConfigurations];
    }
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self performInitConfigurations];
    }
    return self;
}

- (void)performInitConfigurations {
    _shouldAutorotate = NO;
    _statusBarStyle = UIStatusBarStyleDefault;
    _hiddenStatusBar = NO;
    _hiddenNavigationShadow = NO;
    _viewWillFirstAppeared = YES;
    _viewDidFirstAppeared = YES;
    _interactivePopGestureRecognizerEnabled = YES;
    _popGestureEnabled = YES;
}

#pragma mark - ViewLifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    //[self resetNavigationInteractivePopGestureRecognizerDelegate];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // Warning: 只能将手势开关放这里，不要放viewWillAppear里面。
    // 否则在未禁用的页面右滑返回已禁用的页面，由于viewWillAppear的顺序会引起配置冲突，导致返回键失效。
    self.interactivePopGestureRecognizerEnabled = _popGestureEnabled;
    
    if (_hiddenNavigationShadow) {
        [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
        [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    }
    @synchronized (self) {
        if (self.viewWillFirstAppeared) {
            self.viewWillFirstAppeared = NO;
            [self viewWillFirstAppear];
        }
    }
}

- (void)viewWillFirstAppear {
    //默认为空。子类可以重载
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (_hiddenNavigationShadow) {
        [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
        [self.navigationController.navigationBar setShadowImage:nil];
    }
    @synchronized (self) {
        if (self.viewDidFirstAppeared) {
            self.viewDidFirstAppeared = NO;
            [self viewDidFirstAppear];
        }
    }
}

- (void)viewDidFirstAppear {
    //默认为空。子类可以重载
}

#pragma mark - Interface Orientation

/*
// 在AppDelegate.m写支持的旋转方向，为了防止横屏方向，应用启动时候界面变为横屏模式的情况。
- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    return UIInterfaceOrientationMaskAllButUpsideDown;
}
*/

// 是否支持自动转屏
- (BOOL)shouldAutorotate {
    return _shouldAutorotate;
}

// 支持哪些转屏方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return _shouldAutorotate?UIInterfaceOrientationMaskAllButUpsideDown:UIInterfaceOrientationMaskPortrait;
    
}

// 页面展示的时候默认屏幕方向（当前ViewController必须是通过模态ViewController（模态带导航的无效）方式展现出来的，才会调用这个方法）
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

// 强制屏幕转屏
- (void)interfaceOrientation:(UIInterfaceOrientation)orientation {
    // arc下
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        //int val = orientation;
        // 从2开始是因为0 1 两个参数已经被selector和target占用
        [invocation setArgument:&orientation atIndex:2];
        [invocation invoke];
    }
    /*
     // 非arc下
     if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
     [[UIDevice currentDevice] performSelector:@selector(setOrientation:)
     withObject:@(orientation)];
     }
     
     // 直接调用这个方法通不过apple上架审核
     [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIInterfaceOrientationLandscapeRight] forKey:@"orientation"];
     */
}


#pragma mark - Status Bar Style

// 状态栏的样式
// iOS7后更改状态栏样式的父类方法。由于使用Nav，Nav有自己的状态栏，所以不被调用。需要使用navigationBar的barStyle设置样式
- (UIStatusBarStyle)preferredStatusBarStyle {
    return _statusBarStyle;
}

// 隐藏状态栏
- (BOOL)prefersStatusBarHidden {
    return _hiddenStatusBar;
    //注：[self setNeedsStatusBarAppearanceUpdate]; // 会触发-prefersStatusBarHidden更新状态栏显示
}

#pragma mark - interactivePopGestureRecognizer

// 是否启用右滑手势返回
- (void)setInteractivePopGestureRecognizerEnabled:(BOOL)interactivePopGestureRecognizerEnabled {
    if (_interactivePopGestureRecognizerEnabled != interactivePopGestureRecognizerEnabled) {
        _interactivePopGestureRecognizerEnabled = interactivePopGestureRecognizerEnabled;
        __weak typeof(self) weakSelf = self;
        UIGestureRecognizer *recognizer = weakSelf.navigationController.interactivePopGestureRecognizer;
        if (recognizer != nil) {
            recognizer.enabled = interactivePopGestureRecognizerEnabled;
        }
    }
}

// 当自定义返回按钮(leftBarButtonItem)使右滑返回失效，在viewDidLoad中调用此语句解决问题
- (void)resetNavigationInteractivePopGestureRecognizerDelegate {
    if (_interactivePopGestureRecognizerEnabled) {
        self.navigationController.interactivePopGestureRecognizer.delegate=(id)self;
    }
}



#if 0
// 更改导航栏样式
- (void)intNatbarColor {
    self.navigationController.navigationBar.translucent = NO; // 使之不透明
    
    // 状态栏为高亮
    self.navigationController.navigationBarHidden=YES;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    // 设置导航栏颜色
    [[UINavigationBar appearance] setBarTintColor:rgbColor(53, 111, 240, 1)];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    // 标题
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                          rgbColor(245, 245, 245, 1),
                                                          NSForegroundColorAttributeName,
                                                          [UIFont systemFontOfSize:17],
                                                          NSFontAttributeName, nil]];
}
#endif

@end


@implementation TBaseViewController (Alert)

// 简单的Alert（只有“确定”按钮）
- (void)alertWithTitle:(nullable NSString *)title
               message:(nonnull NSString *)message
               handler:(void (^ __nullable)(UIAlertAction *action))handler {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:handler];
    [alertController addAction:cancelAction];
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf presentViewController:alertController animated:YES completion:nil];
    });
}

// 带TextField的Alert（只有“取消和确定”按钮）。可通过alertController.textFields获取对应的textFiled。
- (void)alertTextFieldWithTitle:(nullable NSString *)title
                        message:(nonnull NSString *)message
                        handler:(void (^ __nullable)(UIAlertController *alertController,UIAlertAction *action))handler {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        handler(alertController,action);
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        handler(alertController,action);
    }]];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        //textField.placeholder = @"";
    }];
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf presentViewController:alertController animated:YES completion:nil];
    });
}

// 全面点的alert
- (void)alertWithTitle:(nullable NSString *)title
               message:(nullable NSString *)message
     cancelButtonTitle:(nullable NSString *)cancelTitle
     otherButtonTitles:(nullable NSArray <NSString *> *)othertitles
               handler:(void (^ __nullable)(UIAlertAction *action))handler {
    if ((title == nil || title.length == 0) && (message == nil || message.length == 0)) {return;}
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelTitle?cancelTitle:@"确定" style:UIAlertActionStyleCancel handler:handler];
    [alertController addAction:cancelAction];
    if (othertitles && othertitles.count > 0) {
        for (NSString *title in othertitles) {
            if (title==nil||title.length==0) {continue;}
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:handler];
            [alertController addAction:cancelAction];
        }
    }
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf presentViewController:alertController animated:YES completion:nil];
    });
}

// ActionSheet
- (void)actionSheetWithTitle:(nullable NSString *)title
                     message:(nullable NSString *)message
                       items:(NSSet <NSString *> *)set
                     handler:(void (^ __nullable)(UIAlertAction *action))handler {
    if (set.count == 0) return;
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:handler];
    [alertController addAction:cancelAction];
    
    for (NSString *obj in set) {
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:[NSString stringWithFormat:@"%@",obj] style:UIAlertActionStyleDefault handler:handler];
        [alertController addAction:action1];
    }
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf presentViewController:alertController animated:YES completion:nil];
    });
    
}

@end

#import <objc/runtime.h>
@implementation TBaseViewController (AbnormalIOS12)

#pragma mark - iOS12.1 bug 处理
// 参考说明 ： https://github.com/ChenYilong/iOS12AdaptationTips/issues/3

// iOS12.1 使用 UINavigationController + UITabBarController（ UITabBar 磨砂），设置hidesBottomBarWhenPushed后，在 pop 后，会引起TabBar布局异常
// 解决：添加以下两个方法到显示TabBar的类中即可

/**
 *  用 block 重写某个 class 的指定方法
 *  @param targetClass 要重写的 class
 *  @param targetSelector 要重写的 class 里的实例方法，注意如果该方法不存在于 targetClass 里，则什么都不做
 *  @param implementationBlock 该 block 必须返回一个 block，返回的 block 将被当成 targetSelector 的新实现，所以要在内部自己处理对 super 的调用，以及对当前调用方法的 self 的 class 的保护判断（因为如果 targetClass 的 targetSelector 是继承自父类的，targetClass 内部并没有重写这个方法，则我们这个函数最终重写的其实是父类的 targetSelector，所以会产生预期之外的 class 的影响，例如 targetClass 传进来  UIButton.class，则最终可能会影响到 UIView.class），implementationBlock 的参数里第一个为你要修改的 class，也即等同于 targetClass，第二个参数为你要修改的 selector，也即等同于 targetSelector，第三个参数是 targetSelector 原本的实现，由于 IMP 可以直接当成 C 函数调用，所以可利用它来实现“调用 super”的效果，但由于 targetSelector 的参数个数、参数类型、返回值类型，都会影响 IMP 的调用写法，所以这个调用只能由业务自己写。
 */
CG_INLINE BOOL
OverrideImplementation(Class targetClass, SEL targetSelector, id (^implementationBlock)(Class originClass, SEL originCMD, IMP originIMP)) {
    Method originMethod = class_getInstanceMethod(targetClass, targetSelector);
    if (!originMethod) {
        return NO;
    }
    IMP originIMP = method_getImplementation(originMethod);
    method_setImplementation(originMethod, imp_implementationWithBlock(implementationBlock(targetClass, targetSelector, originIMP)));
    return YES;
}

+ (void)load {
    /* 这个问题是 iOS 12.1 Beta 2 的问题，只要 UITabBar 是磨砂的，并且 push viewController 时 hidesBottomBarWhenPushed = YES 则手势返回的时候就会触发。
     
     出现这个现象的直接原因是 tabBar 内的按钮 UITabBarButton 被设置了错误的 frame，frame.size 变为 (0, 0) 导致的。如果12.1正式版Apple修复了这个bug可以移除调这段代码(来源于QMUIKit的处理方式)*/
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (@available(iOS 12.1, *)) {
            OverrideImplementation(NSClassFromString(@"UITabBarButton"), @selector(setFrame:), ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP originIMP) {
                return ^(UIView *selfObject, CGRect firstArgv) {
                    
                    if ([selfObject isKindOfClass:originClass]) {
                        // 如果发现即将要设置一个 size 为空的 frame，则屏蔽掉本次设置
                        if (!CGRectIsEmpty(selfObject.frame) && CGRectIsEmpty(firstArgv)) {
                            return;
                        }
                    }
                    
                    // call super
                    void (*originSelectorIMP)(id, SEL, CGRect);
                    originSelectorIMP = (void (*)(id, SEL, CGRect))originIMP;
                    originSelectorIMP(selfObject, originCMD, firstArgv);
                };
            });
        }
    });
}

@end

@implementation TBaseViewController (AbnormalIOS13)

#pragma mark - 暗黑模式
// 适配详解：
//oc : https://www.jianshu.com/p/af9ab7a33e8f
//swift : https://www.jianshu.com/p/176537b0d9dd

// 判断暗黑模式:-1未知，0正常，1暗黑模式
- (int)darkModeStyle {
    int result = 0;
    if (@available(iOS 13.0, *)) {
        UIUserInterfaceStyle mode = UITraitCollection.currentTraitCollection.userInterfaceStyle;
        if (mode == UIUserInterfaceStyleLight) {
            NSLog(@"浅色模式");
        }else if (mode == UIUserInterfaceStyleDark) {
            NSLog(@"深色模式");
            result = 1;
        } else {
            NSLog(@"未知模式");
            result = -1;
        }
    }
    return result;
}

// 禁用暗黑模式
// 全局关闭：info.plist添加key值UIUserInterfaceStyle，并设值为Light
- (void)darkModeDisable {
    if (@available(iOS 13.0, *)) {
        self.overrideUserInterfaceStyle = UIUserInterfaceStyleLight;
    }
}


#pragma mark - 模态展示
// 模态弹出默认交互改变，非全屏展示时a、b控制器的生命周期也有改变，不调用a的页面显示或隐藏方法（必须）
// 1式.父类重写方法，统一处理
//- (UIModalPresentationStyle)modalPresentationStyle {
//    return UIModalPresentationFullScreen;
//}
// 2式(不推荐).通过runtime修改默认值参考https://juejin.im/post/5d5f96866fb9a06b0517f78c
// 3式.或者在被呈现者present前改为全屏展示
- (void)modalPresentFullScreen:(UIViewController *)ctl {
    if (@available(iOS 13.0, *)) {
        ctl.modalPresentationStyle = UIModalPresentationFullScreen;
    }
    [self presentViewController:ctl animated:YES completion:nil];
}


@end
