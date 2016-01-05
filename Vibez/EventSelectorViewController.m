//
//  EventSelectorViewController.m
//  Vibez
//
//  Created by Harry Liddell on 06/09/2015.
//  Copyright (c) 2015 Pikture. All rights reserved.
//

#import "EventSelectorViewController.h"
#import "EventSelectorFetchedCollectionViewController.h"
#import "ScannerViewController.h"
#import "Event+Additions.h"

@interface EventSelectorViewController ()
{
    EventSelectorFetchedCollectionViewController* eventVC;
}
@end

@implementation EventSelectorViewController

+ (instancetype)create {
    
    UIStoryboard *storyboardTicketReading = [UIStoryboard storyboardWithName:@"TicketReading" bundle:nil];
    
    EventSelectorViewController *instance = (EventSelectorViewController *)[storyboardTicketReading instantiateViewControllerWithIdentifier:NSStringFromClass([EventSelectorViewController class])];
    
    return instance;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"SELECT EVENT"];
    
    UIBarButtonItem *barButtonCancel = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleDone target:self action:@selector(cancelPressed)];
    
    [self.navigationItem setLeftBarButtonItem:barButtonCancel];
    
    eventVC = self.childViewControllers.firstObject;
}

- (void)cancelPressed {
    if([Event eventIdForAdmin]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Are you sure?" message:@"No event has been selected." preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* logoutAction = [UIAlertAction actionWithTitle:@"Continue without event" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        
        UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
        
        [alertController addAction:logoutAction];
        [alertController addAction:cancelAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

-(void)loadAllTicketData:(completion) compblock {
    compblock(YES);
}

@end
