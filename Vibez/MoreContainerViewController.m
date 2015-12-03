//
//  MoreContainerViewController.m
//  Vibez
//
//  Created by Harry Liddell on 14/07/2015.
//  Copyright (c) 2015 Pikture. All rights reserved.
//

#import "MoreContainerViewController.h"
#import "AppDelegate.h"
#import <Parse/Parse.h>
#import <FontAwesomeIconFactory/NIKFontAwesomeIconFactory.h>
#import <FontAwesomeIconFactory/NIKFontAwesomeIconFactory+iOS.h>
#import "EventSelectorViewController.h"
#import "UIViewController+NavigationController.h"
#import <Reachability/Reachability.h>

@interface MoreContainerViewController () {
    Reachability *reachability;
}

@end

@implementation MoreContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    reachability = [Reachability reachabilityForInternetConnection];
    NSString *path = [NSString string];
    
    if(![[[PFUser currentUser] objectForKey:@"isAdmin"] boolValue]) {
        path = [[NSBundle mainBundle] pathForResource:@"MorePageInfo" ofType:@"plist"];
    } else {
        path = [[NSBundle mainBundle] pathForResource:@"MorePageInfoAdmin" ofType:@"plist"];
    }
    
    self.data = [[[NSDictionary alloc] initWithContentsOfFile:path] objectForKey:@"Sections"];
    self.accountData = [self.data objectForKey:@"Account"];
    self.filterData = [self.data objectForKey:@"Filter"];
    self.controlData = [self.data objectForKey:@"Control"];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"MoreCell" forIndexPath:indexPath];
    
    BOOL isInteractableCell;
    NSString *name = [[NSString alloc] init];
    
    switch (indexPath.section)
    {
        case 0:
            name = [[self.accountData objectAtIndex:indexPath.row] objectForKey:@"name"];
            isInteractableCell = [[[self.accountData objectAtIndex:indexPath.row] objectForKey:@"isInteractable"] boolValue];
            break;
        case 1:
            name = [[self.filterData objectAtIndex:indexPath.row] objectForKey:@"name"];
            isInteractableCell = [[[self.filterData objectAtIndex:indexPath.row] objectForKey:@"isInteractable"] boolValue];
            break;
        case 2:
            name = [[self.controlData objectAtIndex:indexPath.row] objectForKey:@"name"];
            isInteractableCell = [[[self.controlData objectAtIndex:indexPath.row] objectForKey:@"isInteractable"] boolValue];
            break;
        default:
            [cell.textLabel setText:@""];
    }
    
    [cell.textLabel setText:name];
    
    if(isInteractableCell)
    {
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        [cell.detailTextLabel setText:@""];
    }
    else
    {
        [cell setUserInteractionEnabled:NO];
    }
    
    if([[[cell textLabel] text] isEqualToString:@"Username"])
    {
        [self setUsernameCell:cell];
    }
    else if([[[cell textLabel] text] isEqualToString:@"Email"])
    {
        [self setEmailCell:cell];
    }
    else if([[[cell textLabel] text] isEqualToString:@"Logout"])
    {
        [self setLogoutCell:cell];
    }
    else if([[[cell textLabel] text] isEqualToString:@"Location"])
    {
        [self setLocationCell:cell];
    }
    else if([[[cell textLabel] text] isEqualToString:@"Friends"])
    {
        [self setFriendsCell:cell];
    }
    else if([[[cell textLabel] text] isEqualToString:@"Link to Facebook"])
    {
        [self setLinkToFacebookCell:cell];
    }
    else if([[[cell textLabel] text] isEqualToString:@"Share the Vibes"])
    {
        [self setShareTheVibesCell:cell];
    }
    else if([[[cell textLabel] text] isEqualToString:@"Event Selected"]) {
        [self setEventSelectedCell:cell];
    }
    
    return cell;
}

-(void)setUsernameCell:(UITableViewCell *)cell
{
    NIKFontAwesomeIconFactory *factory = [NIKFontAwesomeIconFactory textlessButtonIconFactory];
    [cell.imageView setImage:[factory createImageForIcon:NIKFontAwesomeIconUser]];
    [cell.detailTextLabel setText:[[PFUser currentUser] username]];
}

-(void)setEmailCell:(UITableViewCell *)cell
{
    NIKFontAwesomeIconFactory *factory = [NIKFontAwesomeIconFactory textlessButtonIconFactory];
    [cell.imageView setImage:[factory createImageForIcon:NIKFontAwesomeIconEnvelope]];
    [cell.detailTextLabel setText:[[PFUser currentUser] email]];
}

-(void)setFriendsCell:(UITableViewCell *)cell
{
    NSMutableArray *arrayOfFriends = [[PFUser currentUser] objectForKey:@"friends"];
    
    if(arrayOfFriends)
    {
        NSMutableString *stringOfFriends = [[NSMutableString alloc] init];
        
        for(NSString *friend in arrayOfFriends)
        {
            [stringOfFriends appendString:friend];
            [stringOfFriends appendString:@", "];
        }
        
        [stringOfFriends deleteCharactersInRange:NSMakeRange([stringOfFriends length]-2, 2)];
        
        [cell.detailTextLabel setText:stringOfFriends];
    }
    else
    {
        [cell.detailTextLabel setText:@""];
    }
}

-(void)setLocationCell:(UITableViewCell *)cell
{
    NIKFontAwesomeIconFactory *factory = [NIKFontAwesomeIconFactory textlessButtonIconFactory];
    [cell.imageView setImage:[factory createImageForIcon:NIKFontAwesomeIconMapMarker]];
    [cell.detailTextLabel setText:[[PFUser currentUser] objectForKey:@"location"]];
}

-(void)setShareTheVibesCell:(UITableViewCell *)cell
{
    NIKFontAwesomeIconFactory *factory = [NIKFontAwesomeIconFactory textlessButtonIconFactory];
    [cell.imageView setImage:[factory createImageForIcon:NIKFontAwesomeIconShare]];
}

-(void)setLogoutCell:(UITableViewCell *)cell
{
    NIKFontAwesomeIconFactory *factory = [NIKFontAwesomeIconFactory textlessButtonIconFactory];
    [cell.imageView setImage:[factory createImageForIcon:NIKFontAwesomeIconSignOut]];
}

-(void)setEventSelectedCell:(UITableViewCell *)cell
{
    NIKFontAwesomeIconFactory *factory = [NIKFontAwesomeIconFactory textlessButtonIconFactory];
    [cell.imageView setImage:[factory createImageForIcon:NIKFontAwesomeIconTicket]];
    //[cell.detailTextLabel setText:[[PFUser currentUser] objectForKey:@"location"]];
}

-(void)setLinkToFacebookCell:(UITableViewCell *)cell
{
    if([[[PFUser currentUser] objectForKey:@"isLinkedToFacebook"] boolValue])
    {
        [[cell textLabel] setText:@"Unlink from Facebook"];
    }
    else
    {
        [[cell textLabel] setText:@"Link to Facebook"];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    if([[[cell textLabel] text] isEqualToString:@"Logout"])
    {
        [self logout];
    }
    else if([[[cell textLabel] text] isEqualToString:@"Link to Facebook"])
    {
        [self linkToFacebook];
    }
    else if([[[cell textLabel] text] isEqualToString:@"Unlink from Facebook"])
    {
        [self unlinkFromFacebook];
    }
    else if([[[cell textLabel] text] isEqualToString:@"Friends"])
    {
        [self.parentViewController performSegueWithIdentifier:@"goToFriendsSegue" sender:self];
    }
    else if([[[cell textLabel] text] isEqualToString:@"Share the Vibes"])
    {
        [self shareTheVibes];
    }
    else if ([[[cell textLabel] text] isEqualToString:@"Event Selected"]) {
        [self eventSelectedPressed];
    }
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:
            return [self.accountData count];
        case 1:
            return [self.filterData count];
        case 2:
            return [self.controlData count];
        default:
            return 0;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    switch (section)
    {
        case 0:
            return @"Account";
        case 1:
            return @"Search Filters";
        case 2:
            return @"Account Control";
        default:
            return @"";
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.data count];
}

-(void)shareTheVibes
{
    NSString* title = @"Vibes";
    NSString* description = @"The Student Ticketing App";
    NSString* website = @"www.google.co.uk";
    
    NSArray* sharedArray=@[title, description, website];
    
    NSArray *excludeActivities = @[UIActivityTypeAirDrop,
                                   UIActivityTypePrint,
                                   UIActivityTypeAssignToContact,
                                   UIActivityTypeSaveToCameraRoll,
                                   UIActivityTypeAddToReadingList,
                                   UIActivityTypePostToFlickr,
                                   UIActivityTypePostToVimeo];
    
    UIActivityViewController * activityVC = [[UIActivityViewController alloc] initWithActivityItems:sharedArray applicationActivities:nil];
    activityVC.excludedActivityTypes = excludeActivities;
    
    [self presentViewController:activityVC animated:YES completion:nil];
}

- (void)logout {
    
    if ([reachability isReachable]) {
        
        self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        self.hud.mode = MBProgressHUDModeIndeterminate;
        self.hud.labelText = @"Logging out...";
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Logout", nil) message:NSLocalizedString(@"Are you sure you want to logout?", nil) preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* logoutAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Logout", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            [appDelegate logout:^(BOOL complete) {
                if(complete) {
                    [self.hud hide:YES];
                }
            }];
            
        }];
        
        UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [self.hud hide:YES];
        }];
        
        [alertController addAction:logoutAction];
        [alertController addAction:cancelAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:NSLocalizedString(@"The internet connection appears to be offline, please connect and try again.", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Okay", nil) otherButtonTitles:nil, nil];
        [alertView show];
    }
}

- (void)eventSelectedPressed {
    EventSelectorViewController *vc = [EventSelectorViewController create];
    [self presentViewController:[vc withNavigationControllerWithOpaque] animated:self completion:nil];
}

- (void)linkToFacebook {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate linkParseAccountToFacebook];
}

- (void)unlinkFromFacebook {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate unlinkParseAccountFromFacebook];
}

- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
