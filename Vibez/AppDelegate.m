//
//  AppDelegate.m
//  Vibez
//
//  Created by Harry Liddell on 03/04/2015.
//  Copyright (c) 2015 Pikture. All rights reserved.
//

#import "AppDelegate.h"
#import <Reachability/Reachability.h>
#import <Parse/Parse.h>
#import <Bolts/Bolts.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <ParseFacebookUtilsV4/PFFacebookUtils.h>
#import "LoginViewController.h"
#import "UIFont+PIK.h"

@interface AppDelegate ()
{
    BOOL loggedIn;
    LoginViewController* loginViewController;
}
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self setupParse:launchOptions];
    //[self setupContextManager];
    [self setupAppearance];
    [self monitorReachability];
    
    if ([PFUser currentUser])
    {
        self.window.rootViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateInitialViewController];
    }
    else
    {
        [self presentLoginView];
    }
    
    return YES;
}

-(void)setupParse:(NSDictionary *)launchOptions
{
    // [Optional] Power your app with Local Datastore. For more info, go to
    // https://parse.com/docs/ios_guide#localdatastore/iOS
    [Parse enableLocalDatastore];
    
    // Initialize Parse.
    [Parse setApplicationId:@"l0l32W658tvwkjbkre94nNCwhSKijWaYTZxzgDYe"
                  clientKey:@"WkogSkhJvUKFOkjHEaWVM9hkFOFUkJVKsqPjFtB7"];
    
    // [Optional] Track statistics around application opens.
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    // Override point for customization after application launch.
    [PFFacebookUtils initializeFacebookWithApplicationLaunchOptions:launchOptions];
    
    //return [[FBSDKApplicationDelegate sharedInstance] application:applicationdidFinishLaunchingWithOptions:launchOptions];
}

-(void)presentLoginView
{
    loginViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"LoginViewController"];
    UINavigationController* navigation = [[UINavigationController alloc] initWithRootViewController:loginViewController];
    self.window.rootViewController = navigation;
    [self.window makeKeyAndVisible];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     [FBSDKAppEvents activateApp];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)isParseReachable {
    return self.networkStatus != NotReachable;
}

- (void)logout
{
    // clear NSUserDefaults
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    // Unsubscribe from push notifications by removing the user association from the current installation.
    [[PFInstallation currentInstallation] saveInBackground];
    
    // Clear all caches
    [PFQuery clearAllCachedResults];
    
    // Log out
    [PFUser logOut];
    
    // clear out cached data, view controllers, etc
    //UINavigationController *navController = (UINavigationController *)self.window.rootViewController;
    //[navController popToRootViewControllerAnimated:YES];

    loginViewController = nil;
    
    [self presentLoginView];
}

- (void)monitorReachability {
    Reachability *hostReach = [Reachability reachabilityWithHostname:@"api.parse.com"];
    
    hostReach.reachableBlock = ^(Reachability*reach) {
        _networkStatus = [reach currentReachabilityStatus];
        
        if ([self isParseReachable] && [PFUser currentUser] /*&& self.homeViewController.objects.count == 0*/) {
            // Refresh home timeline on network restoration. Takes care of a freshly installed app that failed to load the main timeline under bad network conditions.
            // In this case, they'd see the empty timeline placeholder and have no way of refreshing the timeline unless they followed someone.
            
            //[self.homeViewController loadObjects];
        }
    };
    
    hostReach.unreachableBlock = ^(Reachability*reach) {
        _networkStatus = [reach currentReachabilityStatus];
    };
    
    [hostReach startNotifier];
}

- (void)setupAppearance
{
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowOffset = CGSizeMake(0.0, 0.0);
    shadow.shadowColor = [UIColor whiteColor];
    
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil]
     setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor],
       NSShadowAttributeName:shadow,
       NSFontAttributeName:[UIFont pik_avenirNextRegWithSize:18.0f]
       }
     forState:UIControlStateNormal];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [self.window setBackgroundColor:[UIColor colorWithRed:44.0f/255.0f green:44.0f/255.0f blue:44.0f/255.0f alpha:1.0f]];
    [[UIBarButtonItem appearance] setTintColor:[UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0f]];
    [[UINavigationBar appearance] setTranslucent:NO];
    //[[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:1.0f]];
    
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:44.0f/255.0f green:44.0f/255.0f blue:44.0f/255.0f alpha:1.0f]];
    
    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    [[UINavigationBar appearance] setClipsToBounds:YES];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
}

//- (void)setupContextManager
//{
//    if (!self.contextManager) {
//        NSManagedObjectModel *model = [NSManagedObjectModel mergedModelFromBundles:nil];
//        self.contextManager = [[SQKContextManager alloc] initWithStoreType:NSSQLiteStoreType
//                                                        managedObjectModel:model
//                                            orderedManagedObjectModelNames:@[ @"Vibez" ]
//                                                                  storeURL:nil];
//    }
//}

@end
