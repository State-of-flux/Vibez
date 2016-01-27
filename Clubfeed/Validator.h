//
//  Validator.h
//  Vibez
//
//  Created by Harry Liddell on 25/04/2015.
//  Copyright (c) 2015 Pikture. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Validator : NSObject

+ (BOOL)isValidUsername:(NSString *)usernameString;
+ (BOOL)isValidEmail:(NSString *)emailString;
+ (BOOL)isValidPassword:(NSString *)password confirmPassword:(NSString *)confirmPassword;

@end
