//
//  BTAppDelegate.m
//  BTCChinaTrade
//
//  Created by Yang Fei on 13-12-6.
//  Copyright (c) 2013年 appxyz. All rights reserved.
//

#import "BTAppDelegate.h"

#import "BTDepthTVC.h"
#import "BTTradeTVC.h"
#import "BTAccountTVC.h"

@implementation BTAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    // umeng
    [self umengTrack];
    
    // rate
    [Appirater setAppId:kAppStoreID];
    [Appirater setOpenInAppStore:YES];
    [Appirater setDaysUntilPrompt:1];
    [Appirater setUsesUntilPrompt:10];
    [Appirater setSignificantEventsUntilPrompt:-1];
    [Appirater setTimeBeforeReminding:2];
    [Appirater appLaunched:YES];
    
    NSString *encryptedAccesskey = [UICKeyChainStore stringForKey:@"accesskey"];
    if (encryptedAccesskey) {
        NSString *encryptedSecretKey = [UICKeyChainStore stringForKey:@"secretkey"];
        NSString *decryptedAccesskey = [FBEncryptorAES decryptBase64String:encryptedAccesskey
                                                                 keyString:@"y0ngf00"];
        NSString *decryptedSecretKey = [FBEncryptorAES decryptBase64String:encryptedSecretKey
                                                                 keyString:@"y0ngf00"];
        [BTDataManager shared].userAccessKey = decryptedAccesskey;
        [BTDataManager shared].userSecretkey = decryptedSecretKey;
    }
    
    UINavigationController *nav1 = [[UINavigationController alloc] initWithRootViewController:[[BTDepthTVC alloc] initWithStyle:UITableViewStyleGrouped]];
    UINavigationController *nav2 = [[UINavigationController alloc] initWithRootViewController:[[BTTradeTVC alloc] initWithStyle:UITableViewStyleGrouped]];
    UINavigationController *nav3 = [[UINavigationController alloc] initWithRootViewController:[[BTAccountTVC alloc] initWithStyle:UITableViewStyleGrouped]];
    
    // for test
    nav1.view.backgroundColor = [UIColor whiteColor];
    nav2.view.backgroundColor = [UIColor whiteColor];
    nav3.view.backgroundColor = [UIColor whiteColor];
    
    self.tabBarController = [[UITabBarController alloc] init];
    self.tabBarController.viewControllers = @[nav1, nav2, nav3];
    self.window.rootViewController = self.tabBarController;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
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
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - umeng

- (void)umengTrack {
    
    NSString *channelId;
    if ([MobClick isJailbroken]) {
        if ([MobClick isPirated]) {
            // 已破解(越狱)
            channelId = @"盗版市场(越狱)";
        }else{
            // 未破解(越狱)
            channelId = @"AppStore(越狱)";
        }
    }else{
        if ([MobClick isPirated]) {
            // 已破解(未越狱)
            channelId = @"盗版市场(未越狱)";
        }else{
            // 未破解(未越狱)
            channelId = @"AppStore(未越狱)";
        }
    }
    
    [MobClick startWithAppkey:kUmengKey reportPolicy:(ReportPolicy)REALTIME channelId:channelId];
    [MobClick updateOnlineConfig];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onlineConfigCallBack:)
                                                 name:UMOnlineConfigDidFinishedNotification object:nil];
}

- (void)onlineConfigCallBack:(NSNotification *)note {
    NSLog(@"online config has fininshed and note = %@", note.userInfo);
}

@end
