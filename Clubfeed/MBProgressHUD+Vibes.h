//
//  MBProgressHUD+Vibes.h
//  Vibez
//
//  Created by Harry Liddell on 21/10/2015.
//  Copyright © 2015 Pikture. All rights reserved.
//

#import <MBProgressHUD/MBProgressHUD.h>

@interface MBProgressHUD (Vibes)

+ (void)showStandardHUD:(MBProgressHUD *)hud target:(id)target title:(NSString *)title message:(NSString *)message;
+ (void)hideStandardHUD:(MBProgressHUD *)hud target:(id)target;

+ (void)showSuccessHUD:(MBProgressHUD *)hud target:(id)target title:(NSString *)title message:(NSString *)message;
+ (void)showFailureHUD:(MBProgressHUD *)hud target:(id)target title:(NSString *)title message:(NSString *)message;

+ (void)showInfoHUD:(MBProgressHUD *)hud target:(id)target title:(NSString *)title message:(NSString *)message;

@end
