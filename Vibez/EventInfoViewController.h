//
//  EventInfoViewController.h
//  Vibez
//
//  Created by Harry Liddell on 17/04/2015.
//  Copyright (c) 2015 Pikture. All rights reserved.
//

#import "GlobalViewController.h"
#import "Event.h"
#import "Ticket+Additions.h"

@interface EventInfoViewController : GlobalViewController

@property (strong, nonatomic) UIImageView *eventImageView;
@property (strong, nonatomic) UILabel *eventNameLabel;
@property (strong, nonatomic) UILabel *eventDateLabel;
@property (strong, nonatomic) UILabel *eventDateEndLabel;
@property (strong, nonatomic) UITextView *eventDescriptionTextView;
@property (strong, nonatomic) UILabel *eventVenueLabel;

@property (strong, nonatomic) Event *event;

@property (strong, nonatomic) UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *getTicketsButton;
- (IBAction)getTicketsButtonTapped:(id)sender;

@end
