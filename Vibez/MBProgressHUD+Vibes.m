//
//  MBProgressHUD+Vibes.m
//  Vibez
//
//  Created by Harry Liddell on 21/10/2015.
//  Copyright © 2015 Pikture. All rights reserved.
//

#import "MBProgressHUD+Vibes.h"
#import "UIColor+Piktu.h"

@implementation MBProgressHUD (Vibes)

+ (void)showStandardHUD:(MBProgressHUD *)hud target:(id)target title:(NSString *)title message:(NSString *)message {
    [[target view] setUserInteractionEnabled:NO];
    hud =[[MBProgressHUD alloc] initWithView:[target view]];
    [hud setDelegate:target];
    //[hud setDimBackground:YES];
    [[target view] addSubview:hud];
    [hud setLabelText:(title ? title : @"")];
    [hud setDetailsLabelText:(message ? message : @"")];
    //[hud setColor:[UIColor pku_purpleColorandAlpha:0.8f]];
    [hud show:YES];
}

+ (void)hideStandardHUD:(MBProgressHUD *)hud target:(id)target {
    [[target view] setUserInteractionEnabled:YES];
    [MBProgressHUD hideHUDForView:[target view] animated:YES];
}

+ (void)showSuccessHUD:(MBProgressHUD *)hud target:(id)target title:(NSString *)title message:(NSString *)message {
    //[[target view] setUserInteractionEnabled:NO];
    hud =[[MBProgressHUD alloc] initWithView:[target view]];
    [hud setDelegate:target];
    [hud setCustomView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"successIcon"]]];
    [[hud customView] setTintColor:[UIColor greenColor]];
    [hud setMode:MBProgressHUDModeCustomView];
    [hud setDimBackground:YES];
    [[target view] addSubview:hud];
    [hud setLabelText:(title ? title : @"")];
    [hud setDetailsLabelText:(message ? message : @"")];
    //[hud setColor:[UIColor pku:0.8f]];
    [hud show:YES];
    [hud hide:YES afterDelay:2];
}

+ (void)showFailureHUD:(MBProgressHUD *)hud target:(id)target title:(NSString *)title message:(NSString *)message {
    //[[target view] setUserInteractionEnabled:NO];
    hud =[[MBProgressHUD alloc] initWithView:[target view]];
    [hud setDelegate:target];
    [hud setCustomView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"crossIcon"]]];
    [[hud customView] setTintColor:[UIColor redColor]];
    [hud setMode:MBProgressHUDModeCustomView];
    [hud setDimBackground:YES];
    [[target view] addSubview:hud];
    [hud setLabelText:(title ? title : @"")];
    [hud setDetailsLabelText:(message ? message : @"")];
    //[hud setColor:[UIColor pku:0.8f]];
    [hud show:YES];
    [hud hide:YES afterDelay:2];
}

@end
