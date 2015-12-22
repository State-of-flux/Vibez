//
//  AboutTableViewController.m
//  Vibez
//
//  Created by Harry Liddell on 21/12/2015.
//  Copyright © 2015 Pikture. All rights reserved.
//

#import "AboutTableViewController.h"

@interface AboutTableViewController ()

@end

@implementation AboutTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[self navigationItem] setTitle:NSLocalizedString(@"About", nil)];
}

#pragma mark - UITableView Delegate Methods

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = (UITableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    switch ([cell tag]) {
        case 1:
            
            break;
            
        case 2:
        
            break;

        case 3:
            
            break;

        default:
            break;
    }
}

- (void)licensesSelected {
    
}

- (void)termsAndConditionsSelected {
    
}

- (void)privacyPolicySelected {
    
}

@end
