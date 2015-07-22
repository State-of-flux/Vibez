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
    self.navigationItem.title = titleText;
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
