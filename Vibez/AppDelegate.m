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
#import "LoginViewController.h"
#import "UIFont+PIK.h"
#import "UIColor+Piktu.h"
#import <Braintree/Braintree.h>
#import <Reachability/Reachability.h>
#import "NFNotificationController.h"
#import "IntroductionViewController.h"


@interface AppDelegate () {
    BOOL loggedIn;
    LoginViewController* loginViewController;
    IntroductionViewController *introViewController;
}
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self setupParse:launchOptions];
    [self setupBrainTree];
    [self setupLookBack];
    [self setupAppearance];
    [self monitorReachability];
    [NFNotificationController scheduleNotifications];
    
    if ([PFUser currentUser]) {
        if(![[[PFUser currentUser] objectForKey:@"isAdmin"] boolValue]) {
            self.window.rootViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateInitialViewController];
        } else {
            self.window.rootViewController = [[UIStoryboard storyboardWithName:@"TicketReading" bundle:[NSBundle mainBundle]] instantiateInitialViewController];
        }
    } else {
        [self presentLoginView];
    }
    
    return YES;
}

- (void)setupLookBack {
    //[Lookback setupWithAppToken:@"2uJt7XXBvSn5aApEL"];
    //[Lookback sharedLookback].shakeToRecord = YES;
    //[Lookback sharedLookback].feedbackBubbleVisible = YES;
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {

    return [Braintree handleOpenURL:url sourceApplication:sourceApplication];
}

-(void)setupBrainTree
{
    [Braintree setReturnURLScheme:@"com.Piktu.Vibez.payments"];
    //    BraintreeEncryption * myEncryption = [[BraintreeEncryption alloc]initWithPublicKey:@"MIIBCgKCAQEAtxPMbigvYY9pe8JeHV2W/BVHFfy6n1JRU//36aQAV/Hc0DwyEwPE1lHZqMIph2vzmaBc4b0/Fa1RXo9BCYvrp+W/eqsIufPkiTXLi1J9l80Dj6cPfihv3z43vHcBo3fcz2BdfRm07lgTk1oqElwGZ3BPx3LKuntSaqWyAFvrBRt/djxynlMxwU0AWjrbtK1PzCw8R4DeOpweTXHs3CHU47tMD7IXrThEVwZOwKFThnwVsm0/CPXIYPjeOFM19HcsF8FPrkImcZKOPEquhmDCCGiFToQFqQaQFJ3Ny/jEaS7zCuaAme2t7WUvQc5pWN444Yj9ROSIb+xw7C5wmob6kQIDAQAB"];
}

-(void)setupParse:(NSDictionary *)launchOptions
{
    // [Optional] Power your app with Local Datastore. For more info, go to
    // https://parse.com/docs/ios_guide#localdatastore/iOS
    //[Parse enableLocalDatastore];
    
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
    //loginViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"LoginViewController"]; //
    
    introViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"IntroductionViewController"];
    UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:introViewController];
    [[self window] setRootViewController:navigation];
    [[self window] makeKeyAndVisible];
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
    return [self networkStatus] != NotReachable;
}

-(void)logout:(completion)compblock
{
    // clear NSUserDefaults
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    // Unsubscribe from push notifications by removing the user association from the current installation.
    [[PFInstallation currentInstallation] saveInBackground];
    
    // Clear all caches
    [PFQuery clearAllCachedResults];
    
    // Log out
    [PFUser logOut];
    //[FBSession setActiveSession:nil];
    
    // clear out cached data, view controllers, etc
    //UINavigationController *navController = (UINavigationController *)self.window.rootViewController;
    //[navController popToRootViewControllerAnimated:YES];
    
    [self deleteAllObjects:@"Event"];
    [self deleteAllObjects:@"Venue"];
    [self deleteAllObjects:@"Ticket"];
    [self deleteAllObjects:@"User"];
    [self deleteAllObjects:@"Order"];
    
    loginViewController = nil;
    
    [self presentLoginView];
    
    compblock(YES);
}

- (void)deleteAllObjects:(NSString *) entityDescription {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityDescription inManagedObjectContext:[PIKContextManager mainContext]];
    
    [fetchRequest setEntity:entity];
    
    NSError *error;
    NSArray *items = [[PIKContextManager mainContext] executeFetchRequest:fetchRequest error:&error];
    
    for (NSManagedObject *managedObject in items) {
        [[PIKContextManager mainContext] deleteObject:managedObject];
        NSLog(@"Object Deleted: %@. %s", entityDescription, __PRETTY_FUNCTION__);
    }
    if (![[PIKContextManager mainContext] save:&error]) {
        NSLog(@"Error : %@. %s", error.localizedDescription, __PRETTY_FUNCTION__);
    }
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

- (void)setupAppearance {
    //UIImage *backButtonIcon = [self imageWithImage:[UIImage imageNamed:@"backArrow.png"] scaledToSize:CGSizeMake(36, 36)];
    //[[UINavigationBar appearance] setBackIndicatorImage:[backButtonIcon imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    //[[UINavigationBar appearance] setBackIndicatorTransitionMaskImage:[backButtonIcon imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [[UINavigationBar appearance] setBarTintColor:[UIColor pku_lightBlack]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTranslucent:NO];
    [[UINavigationBar appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName : [UIColor whiteColor], NSBackgroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : [UIFont pik_avenirNextBoldWithSize:18.0f]}];
    //[[UINavigationBar appearance] setClipsToBounds:YES];
    
    // Hides back button text
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];
    
    [[UITabBar appearance] setBarTintColor:[UIColor pku_lightBlack]];
    [[UITabBar appearance] setTintColor:[UIColor pku_purpleColor]];
    [[UITabBar appearance] setTranslucent:NO];
    [[UITabBarItem appearance] setTitleTextAttributes: @{ NSFontAttributeName : [UIFont pik_montserratRegWithSize:12.0f]} forState:UIControlStateNormal];
    
    [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: [UIFont pik_avenirNextRegWithSize:16.0f], NSFontAttributeName, nil] forState:UIControlStateNormal];
    
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil]
     setDefaultTextAttributes:@{ NSFontAttributeName: [UIFont pik_avenirNextRegWithSize:16.0f], NSForegroundColorAttributeName:[UIColor whiteColor], NSBackgroundColorAttributeName : [UIColor clearColor] }];
    // BAR BUTTON
    [[UIBarButtonItem appearanceWhenContainedIn:[BTDropInViewController class], nil] setTintColor:[UIColor pku_lightBlack]];
    [[UIBarButtonItem appearanceWhenContainedIn:[BTDropInViewController class], nil] setTitleTextAttributes:@{ NSForegroundColorAttributeName : [UIColor pku_lightBlack], NSBackgroundColorAttributeName : [UIColor pku_lightBlack], NSFontAttributeName : [UIFont pik_avenirNextRegWithSize:18.0f]} forState:UIControlStateNormal];
    
    
    [[UIBarButtonItem appearanceWhenContainedIn:[BTPayPalViewController class], nil] setTintColor:[UIColor pku_lightBlack]];
    [[UIBarButtonItem appearanceWhenContainedIn:[BTPayPalViewController class], nil] setTitleTextAttributes:@{ NSForegroundColorAttributeName : [UIColor pku_lightBlack], NSBackgroundColorAttributeName : [UIColor pku_lightBlack], NSFontAttributeName : [UIFont pik_avenirNextRegWithSize:18.0f]} forState:UIControlStateNormal];
    
    [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil] setTintColor:[UIColor whiteColor]];
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTintColor:[UIColor whiteColor]];
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil]
     setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName:[UIFont pik_avenirNextRegWithSize:18.0f]} forState:UIControlStateNormal];
}

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize
{
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
