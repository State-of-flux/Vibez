//
//  LoginViewController.m
//  Vibez
//
//  Created by Harry Liddell on 16/04/2015.
//  Copyright (c) 2015 Pikture. All rights reserved.
//

#import "LoginViewController.h"
#import "AccountController.h"
#import "AppDelegate.h"
#import "PIKContextManager.h"
#import "Ticket+Additions.h"
#import "FLAnimatedImage.h"

@interface LoginViewController ()
{
    
}
@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //    NSString *filePath = [[NSBundle mainBundle] pathForResource: @"background" ofType: @"gif"];
    //
    //    NSData *gifData = [NSData dataWithContentsOfFile: filePath];
    //
    //    FLAnimatedImage *image = [FLAnimatedImage animatedImageWithGIFData:gifData];
    //    FLAnimatedImageView *imageView = [[FLAnimatedImageView alloc] init];
    //    imageView.animatedImage = image;
    //    imageView.frame = CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height);
    //    [self.view addSubview:imageView];
    //    [self.view sendSubviewToBack:imageView];
    
    [self tapOffKeyboardGestureSetup];
    [self placeholderTextColor];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    self.FacebookLoginButton.readPermissions = [AccountController FacebookPermissions];
    
    //[self setMaskTo:self.viewUsername byRoundingCorners:(UIRectCornerTopLeft|UIRectCornerTopRight)];
    [self setMaskTo:self.loginButton byRoundingCorners:(UIRectCornerTopLeft|UIRectCornerBottomRight)];
}

- (void)setMaskTo:(UIView*)view byRoundingCorners:(UIRectCorner)corners
{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds
                                                   byRoundingCorners:corners
                                                         cornerRadii:CGSizeMake(25.0, 25.0)];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = view.bounds;
    maskLayer.path = maskPath.CGPath;
    view.layer.mask = maskLayer;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [self.navigationController setNavigationBarHidden:YES];
    
    self.emailAddressTextField.text = @"123";
    self.passwordTextField.text = @"123456";
}

#pragma mark - Button Event Handling

- (IBAction)loginButtonTapped:(id)sender
{
    self.loginButton.enabled = false;
    self.signUpButton.enabled = false;
    [self Login];
}

- (IBAction)signUpButtonTapped:(id)sender
{
    [self performSegueWithIdentifier:@"loginToSignUpSegue" sender:self];
}

#pragma mark - Parse Login

-(void)Login
{
    NSString *emailIdentifier = @"@";
    NSString *usernameOrEmailString = self.emailAddressTextField.text;
    NSString *passwordString = self.passwordTextField.text;
    
    if ([usernameOrEmailString rangeOfString:emailIdentifier].location != NSNotFound) {
        //"username" contains the email identifier @, therefore this is an email. Pull down the username.
        PFQuery *query = [PFUser query];
        [query whereKey:@"email" equalTo:usernameOrEmailString];
        NSArray *foundUsers = [query findObjects];
        
        if([foundUsers count]  == 1) {
            for (PFUser *foundUser in foundUsers) {
                usernameOrEmailString = [foundUser username];
                [self LoginWithUsernameParse:usernameOrEmailString andPassword:passwordString];
            }
        }
    }
    else
    {
        [self LoginWithUsernameParse:usernameOrEmailString andPassword:passwordString];
    }
}

-(void)LoginWithUsernameParse:(NSString *)username andPassword:(NSString *)password
{
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser *user, NSError *error)
     {
         if(user)
         {
             NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
             [defaults setObject:user.username forKey:@"username"];
             [defaults setObject:user.email forKey:@"emailAddress"];
             
             [self loadAllData:^(BOOL finished) {
                 if(finished)
                 {
                     AppDelegate *appDelegateTemp = [[UIApplication sharedApplication] delegate];
                     appDelegateTemp.window.rootViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateInitialViewController];
                 }
             }];
         }
         else
         {
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login Failed" message:error.description delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
             [alert show];
         }
         
         self.loginButton.enabled = true;
         self.signUpButton.enabled = true;
     }];
}

-(void)loadAllData:(completion) compblock {
    
    [Event getAllFromParseWithSuccessBlock:^(NSArray *objects)
     {
         NSError *error;
         NSManagedObjectContext *newPrivateContext = [PIKContextManager newPrivateContext];
         [Event importEvents:objects intoContext:newPrivateContext];
         [Event deleteInvalidEventsInContext:newPrivateContext];
         [newPrivateContext save:&error];
         
         if(error)
         {
             NSLog(@"Error : %@. %s", error.localizedDescription, __PRETTY_FUNCTION__);
         }
         
         compblock(YES);
     }
                              failureBlock:^(NSError *error)
     {
         NSLog(@"Error : %@. %s", error.localizedDescription, __PRETTY_FUNCTION__);
     }];
    
    [Venue getAllFromParseWithSuccessBlock:^(NSArray *objects) {
        NSError *error;
        NSManagedObjectContext *newPrivateContext = [PIKContextManager newPrivateContext];
        [Venue importVenues:objects intoContext:newPrivateContext];
        [Venue deleteInvalidVenuesInContext:newPrivateContext];
        [newPrivateContext save:&error];
        
        if(error)
        {
            NSLog(@"Error : %@. %s", error.localizedDescription, __PRETTY_FUNCTION__);
        }
        
        compblock(YES);
    }
                              failureBlock:^(NSError *error)
     {
         NSLog(@"Error : %@. %s", error.localizedDescription, __PRETTY_FUNCTION__);
     }];
    
    [Ticket getTicketsForUserFromParseWithSuccessBlock:^(NSArray *objects)
     {
         NSError *error;
         
         NSManagedObjectContext *newPrivateContext = [PIKContextManager newPrivateContext];
         [Ticket importTickets:objects intoContext:newPrivateContext];
         [Ticket deleteInvalidTicketsInContext:newPrivateContext];
         [newPrivateContext save:&error];
         
         if(error)
         {
             NSLog(@"Error : %@. %s", error.localizedDescription, __PRETTY_FUNCTION__);
         }
         
         compblock(YES);
     }
                                          failureBlock:^(NSError *error)
     {
         NSLog(@"Error : %@. %s", error.localizedDescription, __PRETTY_FUNCTION__);
     }];
}

#pragma mark - Facebook Login

- (IBAction)FacebookLoginButtonTapped:(id)sender
{
    //[accountController LoginWithFacebook];
}

#pragma mark - Navigation

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
}

#pragma mark - UI Stuff

-(void)placeholderTextColor
{
    NSDictionary *attributes = @{NSForegroundColorAttributeName : [UIColor pku_placeHolderTextColor]};
    self.emailAddressTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.emailAddressTextField.placeholder attributes:attributes];
    self.passwordTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.passwordTextField.placeholder attributes:attributes];
}

- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - Keyboard Dismissal

-(void)tapOffKeyboardGestureSetup
{
    UIGestureRecognizer *tapOffKeyboard = [[UITapGestureRecognizer alloc]
                                           initWithTarget:self action:@selector(handleSingleTap:)];
    tapOffKeyboard.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapOffKeyboard];
}

- (void)handleSingleTap:(UITapGestureRecognizer *) sender
{
    [self.view endEditing:YES];
}

-(IBAction)prepareForUnwindToLogin:(UIStoryboardSegue *)segue {
}

- (IBAction)buttonForgotPasswordPressed:(id)sender {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Password Reset", @"Password Reset") message:NSLocalizedString(@"Please enter your username or email. If the username or email exists, a password reset email will be sent.", @"Please enter your username or email. If the username or email exists, a password reset email will be sent.") preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textFieldPassword)
     {
         textFieldPassword.placeholder = NSLocalizedString(@"Username or Email", @"Username or Email");
     }];
    
    UIAlertAction *actionValidate = [UIAlertAction actionWithTitle:NSLocalizedString(@"Send Reset", @"Send Reset")
                                                             style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction *action){
                                                               
                                                               UITextField *textField = alert.textFields.firstObject;
                                                               NSString *input = textField.text;
                                                               NSString *emailIdentifier = @"@";
                                                               
                                                               // If entered input is an email just go straight to password reset.
                                                               if ([input rangeOfString:emailIdentifier].location != NSNotFound) {
                                                                   [PFUser requestPasswordResetForEmail:input];
                                                               }
                                                               else
                                                               {
                                                                   // If it's not an email, it must be a username, so find that usernames email, and send it to that.
                                                                   PFQuery *query = [PFUser query];
                                                                   [query whereKey:@"username" equalTo:input];
                                                                   NSArray *foundUsers = [query findObjects];
                                                                   
                                                                   if([foundUsers count]  == 1) {
                                                                       for (PFUser *foundUser in foundUsers) {
                                                                           input = [foundUser email];
                                                                           
                                                                           [PFUser requestPasswordResetForEmail:input];
                                                                       }
                                                                   }
                                                               }
                                                           }];
    
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", @"Cancel")
                                                           style:UIAlertActionStyleCancel
                                                         handler:nil];
    
    [alert addAction:actionValidate];
    [alert addAction:actionCancel];
    
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)sendResetEmail:(NSString *)email
{
    [PFUser requestPasswordResetForEmail:email];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sent" message:@"Please search your email now." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
    [alert show];
}

@end
