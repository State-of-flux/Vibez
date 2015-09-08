//
//  AccountController.h
//  Vibez
//
//  Created by Harry Liddell on 20/04/2015.
//  Copyright (c) 2015 Pikture. All rights reserved.
//

#import <Bolts/Bolts.h>
#import <Parse/Parse.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <ParseFacebookUtilsV4/PFFacebookUtils.h>
#import <Foundation/Foundation.h>

@interface AccountController : NSObject

+(NSArray *)FacebookPermissions;
-(void)LoginWithFacebook;
-(void)LoginWithUsername:(NSString *)username andPassword:(NSString *)password;
-(void)SignUpWithUsername:(NSString *)username emailAddress:(NSString *)emailAddress password:(NSString *)password;
-(void)LinkAccountToFacebook;
//-(void)Logout;

@end
