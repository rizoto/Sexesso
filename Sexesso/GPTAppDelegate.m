//
//  GPTAppDelegate.m
//  Sexesso
//
//  Created by Lubor Kolacny on 14/07/13.
//  Copyright (c) 2013 Lubor Kolacny. All rights reserved.
//

#import "devices.h"
#import "GPTAppDelegate.h"
#import "GPTMainMenuViewController.h"
#import "GPTSettingsViewController.h"
#import "GPTPlayGameViewController.h"
#import "GPTScoreViewController.h"
#import "GPTHelpViewController.h"
#import "GPTInfoViewController.h"
#import "GPTFirstHelpViewController.h"
#import "game_def.h"
#import "GPTSettings.h"

@interface GPTAppDelegate()

@property (retain) UIViewController* rootViewControllerX;

@end

@implementation GPTAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor blackColor];
    self.singeltonGameTimer = nil;
    [self changeRootViewController:VC_FIRSTHELP];
    [self.window makeKeyAndVisible];
    
	// Let the device know we want to receive push notifications
	[[UIApplication sharedApplication] registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    
    GPTLog(@"%@, %.2f",[[UIDevice currentDevice] model],[[UIScreen mainScreen]bounds].size.height);
    
    return YES;
}

- (void)changeRootViewController:(NSString *)controllerName
{
    if ([controllerName isEqual:VC_PLAYGAME]) {
        self.rootViewControllerX = (UIViewController *)[[GPTPlayGameViewController alloc] init];
    } else if ([controllerName isEqual:VC_SETTINGS]) {
        self.rootViewControllerX = (UIViewController *)[[GPTSettingsViewController alloc] init];
    } else if ([controllerName isEqual:VC_MAINMENU]) {
        self.rootViewControllerX = (UIViewController *)[[GPTMainMenuViewController alloc] init];
    } else if ([controllerName isEqual:VC_SCORE]) {
        self.rootViewControllerX = (UIViewController *)[[GPTScoreViewController alloc] init];
    } else if ([controllerName isEqual:VC_HELP]) {
        self.rootViewControllerX = (UIViewController *)[[GPTHelpViewController alloc] init];
    } else if ([controllerName isEqual:VC_INFO]) {
        self.rootViewControllerX = (UIViewController *)[[GPTInfoViewController alloc] init];
    } else if ([controllerName isEqual:VC_FIRSTHELP]) {
        self.rootViewControllerX = (UIViewController *)[[GPTFirstHelpViewController alloc] init];
    }
    if (self.rootViewControllerX) {
        [self.window setRootViewController:self.rootViewControllerX];
    }
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    GPTLog(@"applicationWillResignActive");
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    if (self.singeltonGameTimer) {
        [self.singeltonGameTimer invalidate];
        [self changeRootViewController:VC_MAINMENU];
    }
    GPTLog(@"applicationDidEnterBackground");
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    GPTLog(@"applicationWillEnterForeground");    
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    GPTLog(@"applicationDidBecomeActive");     
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    GPTLog(@"applicationWillTerminate");  
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    NSString *newToken = [deviceToken description];
	newToken = [newToken stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
	newToken = [newToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    [[NSUserDefaults standardUserDefaults] setObject:newToken forKey:keyDeviceToken];
    GPTSettings *settings = [[GPTSettings alloc] init];
    [settings postSavedData];
    GPTLog(@"My token is: %@", newToken);
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
	GPTLog(@"Failed to get token, error: %@", error);
}

@end
