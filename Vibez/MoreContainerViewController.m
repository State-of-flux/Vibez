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

@interface MoreContainerViewController ()

@end

@implementation MoreContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"MorePageInfo" ofType:@"plist"];
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
    else if([[[cell textLabel] text] isEqualToString:@"Email"])
    {
        [self setEmailCell:cell];
    }
    
    return cell;
}

-(void)setUsernameCell:(UITableViewCell *)cell
{
    [cell.detailTextLabel setText:[[PFUser currentUser] username]];
}

-(void)setEmailCell:(UITableViewCell *)cell
{
    [cell.detailTextLabel setText:[[PFUser currentUser] email]];
}

-(void)setFriendsCell:(UITableViewCell *)cell
{
    
}

-(void)setLocationCell:(UITableViewCell *)cell
{
    [cell.detailTextLabel setText:@"Sheffield"];
}

-(void)setLogoutCell:(UITableViewCell *)cell
{
    
}

-(void)setLinkToFacebookCell:(UITableViewCell *)cell
{
    
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

- (void)logout {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Logout" message:@"Are you sure you want to logout?" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* logoutAction = [UIAlertAction actionWithTitle:@"Logout" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate logout];

    }];
    
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:logoutAction];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];    
}

- (void)linkToFacebook {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate linkParseAccountToFacebook];
}

@end
