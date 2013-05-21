//
//  JMAppDelegate.m
//  FootBallVedio
//
//  Created by wang animeng on 13-4-17.
//  Copyright (c) 2013年 jam. All rights reserved.
//

#import "JMAppDelegate.h"

#import "JMMasterViewController.h"
#import "UMSocialSnsService.h"
#import "UMSocialData.h"
#import "WXApi.h"
#import "JMDetailViewController.h"

@interface JMAppDelegate()

@property (nonatomic,strong) JMMasterViewController *masterCtr;

@end

@implementation JMAppDelegate

- (void)umengTrack {
    [MobClick setCrashReportEnabled:YES];
    [MobClick setLogEnabled:NO];
    [MobClick setAppVersion:XcodeAppVersion];
    [MobClick startWithAppkey:UMENG_APPKEY reportPolicy:(ReportPolicy) REALTIME channelId:nil];
    [MobClick updateOnlineConfig];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onlineConfigCallBack:) name:UMOnlineConfigDidFinishedNotification object:nil];
    
    [UMSocialData setAppKey:UMENG_APPKEY];
    [UMSocialData openLog:NO];
    
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.

    JMMasterViewController *masterViewController = [[JMMasterViewController alloc] initWithNibName:@"JMMasterViewController" bundle:nil];
    UINavigationController *masterNavigationController = [[UINavigationController alloc] initWithRootViewController:masterViewController];
    self.masterCtr = masterViewController;

    JMDetailViewController *detailViewController = [[JMDetailViewController alloc] initWithNibName:@"JMDetailViewController" bundle:nil];
    UINavigationController *detailNavigationController = [[UINavigationController alloc] initWithRootViewController:detailViewController];

    masterViewController.detailViewController = detailViewController;

    self.splitViewController = [[UISplitViewController alloc] init];
    self.splitViewController.delegate = detailViewController;
    self.splitViewController.viewControllers = @[masterNavigationController, detailNavigationController];
    self.window.rootViewController = self.splitViewController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    if (self.masterCtr) {
        [self.masterCtr refreshSource:nil];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    // 如果你除了使用我们sdk之外还要处理另外的url，你可以把`handleOpenURL:wxApiDelegate:`的实现复制到你的代码里面，再添加你要处理的url。
    return  [UMSocialSnsService handleOpenURL:url wxApiDelegate:nil];
}

@end
