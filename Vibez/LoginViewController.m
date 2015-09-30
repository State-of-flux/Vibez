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
#import <FontAwesomeIconFactory/NIKFontAwesomeIconFactory.h>
#import <FontAwesomeIconFactory/NIKFontAwesomeIconFactory+iOS.h>
#import <Reachability/Reachability.h>
#import <MBProgressHUD/MBProgressHUD.h>

@interface LoginViewController () {
    Reachability *reachability;
}
@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    reachability = [Reachability reachabilityForInternetConnection];
    
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


#define kOFFSET_FOR_KEYBOARD 80.0

-(void)keyboardWillShow {
    // Animate the current view out of the way
    if (self.view.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
    else if (self.view.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO];
    }
}

-(void)keyboardWillHide {
    if (self.view.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
    else if (self.view.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO];
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)sender
{
    if ([sender isEqual:self.emailAddressTextField])
    {
        //move the main view, so that the keyboard does not hide it.
        if  (self.view.frame.origin.y >= 0)
        {
            [self setViewMovedUp:YES];
        }
    }
    else if ([sender isEqual:self.passwordTextField])
    {
        //move the main view, so that the keyboard does not hide it.
        if  (self.view.frame.origin.y >= 0)
        {
            [self setViewMovedUp:YES];
        }
    }
}

//method to move the view up/down whenever the keyboard is shown/dismissed
-(void)setViewMovedUp:(BOOL)movedUp
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
    
    CGRect rect = self.view.frame;
    if (movedUp)
    {
        // 1. move the view's origin up so that the text field that will be hidden come above the keyboard
        // 2. increase the size of the view so that the area behind the keyboard is covered up.
        rect.origin.y -= kOFFSET_FOR_KEYBOARD;
        rect.size.height += kOFFSET_FOR_KEYBOARD;
    }
    else
    {
        // revert back to the normal state.
        rect.origin.y += kOFFSET_FOR_KEYBOARD;
        rect.size.height -= kOFFSET_FOR_KEYBOARD;
    }
    self.view.frame = rect;
    
    [UIView commitAnimations];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [self.navigationController setNavigationBarHidden:YES];
    
    self.emailAddressTextField.text = @"123";
    self.passwordTextField.text = @"123456789";
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
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.mode = MBProgressHUDModeIndeterminate;
    self.hud.labelText = @"Logging in...";
    
    NSString *emailIdentifier = @"@";
    NSString *usernameOrEmailString = self.emailAddressTextField.text;
    NSString *passwordString = self.passwordTextField.text;
    
    if([reachability isReachable]) {
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
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"The internet connection appears to be offline, please reconnect and try again." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
        [alertView show];
    }
}

-(void)LoginWithUsernameParse:(NSString *)username andPassword:(NSString *)password
{
    [PFUser logInWithUsernameInBackground:[username lowercaseString] password:password block:^(PFUser *user, NSError *error)
     {
         if(user)
         {
             NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
             [defaults setObject:user.username forKey:@"username"];
             [defaults setObject:user.email forKey:@"emailAddress"];
             
             self.hud.labelText = @"Fetching data...";
             if(![[user objectForKey:@"isAdmin"] boolValue])
             {
                 [self loadAllCustomerData:^(BOOL finished) {
                     if(finished)
                     {
                         self.hud.labelText = @"Done!";
                         AppDelegate *appDelegateTemp = [[UIApplication sharedApplication] delegate];
                         appDelegateTemp.window.rootViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateInitialViewController];
                     }
                 }];
             }
             else
             {
                 [self loadAllAdminData:^(BOOL finished) {
                     if(finished)
                     {
                         self.hud.labelText = @"Done!";
                         AppDelegate *appDelegateTemp = [[UIApplication sharedApplication] delegate];
                         appDelegateTemp.window.rootViewController = [[UIStoryboard storyboardWithName:@"TicketReading" bundle:[NSBundle mainBundle]] instantiateInitialViewController];
                     }
                 }];
             }
         }
         else
         {
             if(error.code == 101)
             {
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Login Failed", @"Login Failed") message:NSLocalizedString(@"Username/Email or password incorrect", @"Username/Email or password incorrect") delegate:self cancelButtonTitle:NSLocalizedString(@"Okay", @"Okay") otherButtonTitles:nil, nil];
                 [alert show];
             }
             
         }
         
         [self.hud hide:YES];
         self.loginButton.enabled = true;
         self.signUpButton.enabled = true;
     }];
}

-(void)loadAllCustomerData:(completion) compblock {
    
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

-(void)loadAllAdminData:(completion) compblock {
    
    [Event getEventsFromParseForAdmin:[PFUser currentUser] withSuccessBlock:^(NSArray *objects)
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
         compblock(YES);
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
