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
    
    [self.tableView setEmptyDataSetDelegate:self];
    [self.tableView setEmptyDataSetSource:self];
    [self.tableView setTableFooterView:[UIView new]];
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
    UIBarButtonItem *addFriend = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addFriend)];
    
    [self.navigationItem setRightBarButtonItem:addFriend];
    [self.navigationItem setTitle:titleText];
}

- (void)addFriend
{
    //    NSMutableArray *arrayOfFriends = [[PFUser currentUser] objectForKey:@"friends"];
    //
    //    if(!arrayOfFriends)
    //    {
    //        arrayOfFriends = [NSMutableArray array];
    //    }
    //    else
    //    {
    //        [arrayOfFriends addObject:@"New person yo"];
    //    }
    //
    //    [[PFUser currentUser] setObject:arrayOfFriends forKey:@"friends"];
    //    [[PFUser currentUser] saveInBackground];
    
    //
    
    [self performSegueWithIdentifier:@"friendsToAddFriendSegue" sender:self];
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

#pragma mark - DZN Empty Data Set Delegates

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return nil;
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"No friends found";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont pik_montserratBoldWithSize:20.0f],
                                 NSForegroundColorAttributeName: [UIColor whiteColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"You currently have no friends, to add some tap the button in the top right.";
    
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont pik_avenirNextRegWithSize:14.0f],
                                 NSForegroundColorAttributeName: [UIColor pku_greyColor],
                                 NSParagraphStyleAttributeName: paragraph};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView
{
    return YES;
}

- (void)emptyDataSetDidTapButton:(UIScrollView *)scrollView
{
    [self addFriend];
}

- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state
{
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont pik_montserratBoldWithSize:16.0f], NSForegroundColorAttributeName : [UIColor pku_purpleColor]};
    
    return [[NSAttributedString alloc] initWithString:@"ADD FRIEND" attributes:attributes];
}

-(IBAction)unwindToFriendsList:(UIStoryboardSegue *)segue {
    [self orderAlphabetically];
    [self.tableView reloadData];
}

@end
