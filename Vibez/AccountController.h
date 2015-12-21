//
//  AccountController.h
//  Vibez
//
//  Created by Harry Liddell on 20/04/2015.
//  Copyright (c) 2015 Pikture. All rights reserved.
//

#import <Bolts/Bolts.h>
#import <Parse/Parse.h>
#import <Foundation/Foundation.h>

@interface AccountController : NSObject

+(NSArray *)FacebookPermissions;

+ (void)loginWithFacebook:(id)sender;
+ (void)loginWithUsernameOrEmail:(NSString *)username andPassword:(NSString *)password sender:(id)sender;
+ (void)signupWithUsername:(NSString *)username email:(NSString *)email password:(NSString *)password sender:(id)sender;
+ (void)forgotPasswordWithEmail:(NSString *)email sender:(id)sender;
+ (void)sendResetEmail:(NSString *)email;

@end
