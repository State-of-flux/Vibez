//
//  FriendsTableViewController.m
//  Vibez
//
//  Created by Harry Liddell on 16/08/2015.
//  Copyright (c) 2015 Pikture. All rights reserved.
//

#import "FriendsTableViewController.h"
#import <Parse/Parse.h>

@interface FriendsTableViewController ()

@end

@implementation FriendsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavBar:@"Friends"];
    [self orderAlphabetically];
}

- (void)orderAlphabetically
{
    self.sections = [[NSMutableDictionary alloc] init];
    NSMutableArray *array = [[NSMutableArray alloc] initWithArray:[[[PFUser currentUser] objectForKey:@"friends"] mutableCopy]];
    
    BOOL found;
    
    for (NSString *temp in array)
    {
        NSString *c = [temp substringToIndex:1];
        
        found = NO;
        
        for (NSString *str in [self.sections allKeys])
        {
            if ([str isEqualToString:c])
            {
                found = YES;
            }
        }
        
        if (!found)
        {
            [self.sections setValue:[[NSMutableArray alloc] init] forKey:c];
        }
    }
    for (NSString *temp in array)
    {
        [[self.sections objectForKey:[temp substringToIndex:1]] addObject:temp];
    }
}

-(void)setNavBar:(NSString*)titleText
{
    UIBarButtonItem *addFriend = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addFriend:)];
    
    [self.navigationItem setRightBarButtonItem:addFriend];
    [self.navigationItem setTitle:titleText];
}

- (void)addFriend:(id)sender
{
    NSMutableArray *arrayOfFriends = [[PFUser currentUser] objectForKey:@"friends"];
    [arrayOfFriends addObject:@"New person yo"];
    [[PFUser currentUser] setObject:arrayOfFriends forKey:@"friends"];
    [[PFUser currentUser] saveInBackground];
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [[[self.sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:section];
}

//- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
//    return [[self.sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
//}

-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    view.tintColor = [UIColor pku_lightBlack];
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setTextColor:[UIColor whiteColor]];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[self.sections allKeys] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.sections valueForKey:[[[self.sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:section]] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* CellIdentifier = @"FriendCell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == Nil)
    {
        cell  = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSString *titleText = [[self.sections valueForKey:[[[self.sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    cell.textLabel.text = titleText;
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

@end
