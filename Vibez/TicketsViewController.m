//
//  TicketsViewController.m
//  Vibez
//
//  Created by Harry Liddell on 10/07/2015.
//  Copyright (c) 2015 Pikture. All rights reserved.
//

#import "TicketsViewController.h"
#import "UIFont+PIK.h"
#import "TicketsFetchedTableViewController.h"

@interface TicketsViewController ()
{
    PFUser* user;
    TicketsFetchedTableViewController *fetchVC;
}
@end

@implementation TicketsViewController

#pragma mark - General Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavBar:@"Tickets"];
    
    fetchVC = self.childViewControllers[0];
    
    user = [PFUser currentUser];
    
}

-(void)setNavBar:(NSString*)titleText
{
    UILabel* titleLabel = [[UILabel alloc] init];
    [titleLabel setText:[titleText stringByAppendingString:@""]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setFont:[UIFont pik_avenirNextRegWithSize:18.0f]];
    [titleLabel setShadowColor:[UIColor colorWithWhite:0.0 alpha:0.5]];
    [titleLabel setTextAlignment:NSTextAlignmentLeft];
    [titleLabel sizeToFit];
    [titleLabel setTextColor:[UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0f]];
    
    self.navigationItem.titleView = titleLabel;
}

#pragma mark - Navigation

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"whatsOnToContainerViewSegue"])
    {
        
    }
}

- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
