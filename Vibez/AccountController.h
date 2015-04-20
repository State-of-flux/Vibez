//
//  AccountController.h
//  Vibez
//
//  Created by Harry Liddell on 20/04/2015.
//  Copyright (c) 2015 Pikture. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AccountController : NSObject

-(NSArray *)FacebookPermissions;
-(void)LoginWithUsername:(NSString *)username andPassword:(NSString *)password
-(void)LoginWithFacebook;
-(void)SignUpWithUsername:(NSString *)username emailAddress:(NSString *)emailAddress password:(NSString *)password;
-(void)SignUpWithFacebook;
-(void)LinkAccountToFacebook;
-(void)Logout;

@end
