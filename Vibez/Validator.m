//
//  Validator.m
//  Vibez
//
//  Created by Harry Liddell on 25/04/2015.
//  Copyright (c) 2015 Pikture. All rights reserved.
//

#import "Validator.h"

#define REGEX_USERNAME @"^[a-zA-Z0-9-_]{3,25}$"
#define REGEX_EMAIL @"[A-Z0-9a-z._%+-]{3,}+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
#define REGEX_PASSWORD @"((?=.*\\d)(?=.*[a-z])(?=.*[A-Z]).{6,40})"
#define REGEX_PHONE_DEFAULT @"[0-9]{3}\\-[0-9]{3}\\-[0-9]{4}"

@interface Validator ()
{
    
}
@end

@implementation Validator

-(BOOL)isValidUsername:(NSString *)usernameString
{
    NSPredicate *usernameTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", REGEX_USERNAME];
    
    if(![usernameTest evaluateWithObject:usernameString])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Username Invalid" message:@"Username must be between 3-25 alphanumerical characters." delegate:self cancelButtonTitle:@"Understood" otherButtonTitles:nil, nil];
        [alert show];
        
        return NO;
    }
    
    return YES;
}

-(BOOL)isValidEmail:(NSString *)emailString
{
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", REGEX_EMAIL];
    
    if(![emailTest evaluateWithObject:emailString])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Email Address Invalid" message:@"Please enter a valid email address." delegate:self cancelButtonTitle:@"Understood" otherButtonTitles:nil, nil];
        [alert show];
        
        return NO;
    }
    
    return YES;
}

-(BOOL)isValidPassword:(NSString *)password confirmPassword:(NSString *)confirmPassword
{
    if ([password length] < 6)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Password Too Short" message:@"Password must be a minimum of 6 characters." delegate:self cancelButtonTitle:@"Understood" otherButtonTitles:nil, nil];
        [alert show];
        
        return NO;
    }
    
    if ([password length] > 32)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Password Too Long" message:@"Password must be a maximum of 32 characters." delegate:self cancelButtonTitle:@"Understood" otherButtonTitles:nil, nil];
        [alert show];
        return NO;
    }
    
    if(![password isEqualToString:confirmPassword])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Passwords Do Not Match" message:@"Please enter matching passwords." delegate:self cancelButtonTitle:@"Understood" otherButtonTitles:nil, nil];
        [alert show];
        return NO;
    }
    
    //NSRange rang;
    
    //rang = [password rangeOfCharacterFromSet:[NSCharacterSet letterCharacterSet]];
    //if ( !rang.length ) return NO;  // No Letters
    
    //rang = [password rangeOfCharacterFromSet:[NSCharacterSet decimalDigitCharacterSet]];
    //if ( !rang.length )  return NO;  // No numbers
    
    return YES;
}

@end
