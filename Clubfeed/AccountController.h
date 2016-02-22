//
//  AccountController.h
//  Vibez
//
//  Created by Harry Liddell on 20/04/2015.
//  Copyright (c) 2015 Pikture. All rights reserved.
//

#import <Bolts/Bolts.h>
#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface AccountController : NSObject

typedef void(^facebookAccountCompletionBlock)(BOOL succeeded, NSError *error);

+ (void)loginWithFacebook:(id)sender;
+ (void)loginWithUsernameOrEmail:(NSString *)username andPassword:(NSString *)password sender:(id)sender;
+ (void)createNewUser:(PFUser *)user forFacebookWithBlock:(facebookAccountCompletionBlock)compblock;
+ (void)signupWithEmail:(NSString *)email password:(NSString *)password firstName:(NSString *)firstName lastName:(NSString *)lastName dob:(NSDate *)dob sender:(id)sender;
+ (void)forgotPasswordWithEmail:(NSString *)email sender:(id)sender;
+ (void)sendResetEmail:(NSString *)email;
+ (void)linkOrUnlinkParseAccountFromFacebook;

@end
