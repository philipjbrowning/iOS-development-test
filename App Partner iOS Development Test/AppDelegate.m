//
//  AppDelegate.m
//  App Partner iOS Development Test
//
//  Created by Philip J Browning II on 2/24/14.
//  Copyright (c) 2014 Philip J Browning II. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    /*
     UIImage *backImage = [[UIImage imageNamed:@"headerbutton_back_off"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 13.0f, 0, 6.0f)];
    [[UINavigationBar appearance] setBackgroundImage:backImage forBarMetrics:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setBack]
    */
    
    /*
    // Set back button
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60.0f, 30.0f)];
    UIImage *backImage = [[UIImage imageNamed:@"headerbutton_back_off"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 12.0f, 0, 12.0f)];
    [backButton setBackgroundImage:backImage forState:UIControlStateNormal];
    [backButton setTitle:@"" forState:UIControlStateNormal];
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationController.navigationItem.backBarButtonItem = backButtonItem;
    // [self.navigationItem.backBarButtonItem]
    */
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

@end
