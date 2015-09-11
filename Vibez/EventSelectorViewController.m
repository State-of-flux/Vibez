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
    [self.navigationItem setTitle:@"Select an Event"];
    
    UIBarButtonItem *barButtonCancel = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleDone target:self action:@selector(cancelPressed)];
    
    [self.navigationItem setLeftBarButtonItem:barButtonCancel];
    
    eventVC = self.childViewControllers.firstObject;
}

- (void)cancelPressed {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)loadAllTicketData:(completion) compblock {
    compblock(YES);
}

@end
