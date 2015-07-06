//
//  TicketsTabViewController.m
//  Vibez
//
//  Created by Harry Liddell on 31/05/2015.
//  Copyright (c) 2015 Pikture. All rights reserved.
//

#import "TicketsTabViewController.h"
#import "UIImage+MDQRCode.h"
#import "TicketTableViewCell.h"
#import "UIFont+PIK.h"

@interface TicketsTabViewController ()
{
    PFUser* user;
}
@end

@implementation TicketsTabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // Do any additional setup after loading the view.
    
    user = [PFUser currentUser];
    [self setTopBarButtons:user.username];
    
    //static NSString *ticketCellIdentifier = @"TicketCell";
    
    //[self.tableView registerClass:[TicketTableViewCell class] forCellReuseIdentifier:ticketCellIdentifier];
    
    [self.tableView setDataSource:self.ticketDataSource];
    [self.tableView setDelegate:self];
}

-(void)setTopBarButtons:(NSString*)titleText
{
    UIBarButtonItem *searchBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchAction)];
    
    UIBarButtonItem *settingsBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"\u2699" style:UIBarButtonItemStylePlain target:self action:@selector(settingsAction)];
    
    UIFont *customFont = [UIFont fontWithName:@"Futura-Medium" size:24.0];
    NSDictionary *fontDictionary = @{NSFontAttributeName : customFont};
    [settingsBarButtonItem setTitleTextAttributes:fontDictionary forState:UIControlStateNormal];
    
    //self.navigationItem.rightBarButtonItems = [[NSArray alloc] initWithObjects:settingsBarButtonItem, searchBarButtonItem, nil];
    
    //self.navigationItem.leftBarButtonItem = settingsBarButtonItem;
    self.navigationItem.rightBarButtonItem = searchBarButtonItem;
    
    UILabel* titleLabel = [[UILabel alloc] init];
    [titleLabel setText:[titleText stringByAppendingString:@"'s Tickets"]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setFont:[UIFont pik_montserratRegWithSize:18.0f]];
    [titleLabel setShadowColor:[UIColor colorWithWhite:0.0 alpha:0.5]];
    [titleLabel setTextAlignment:NSTextAlignmentLeft];
    [titleLabel sizeToFit];
    [titleLabel setTextColor:[UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0f]];
    
    self.navigationItem.titleView = titleLabel;
    
    [self.navigationItem setHidesBackButton:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)searchAction
{
    NSLog(@"search button clicked");
}

-(void)settingsAction
{
    NSLog(@"settings button clicked");
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"showTicketToDisplayTicketSegue" sender:self];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
