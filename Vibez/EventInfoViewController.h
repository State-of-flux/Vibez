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

@interface EventInfoViewController : GlobalViewController <UIActionSheetDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet UIImageView *eventImageView;
@property (strong, nonatomic) IBOutlet UILabel *eventNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *eventDateLabel;
@property (strong, nonatomic) IBOutlet UILabel *eventDateEndLabel;
@property (strong, nonatomic) IBOutlet UITextView *eventDescriptionTextView;
@property (strong, nonatomic) IBOutlet UILabel *eventVenueLabel;

@property (strong, nonatomic) Event *event;
@property (strong, nonatomic) PFObject *eventPFObject;
@property (strong, nonatomic) NSMutableArray *arrayOfQuantities;
@property (assign, nonatomic) NSInteger quantitySelected;

@property (strong, nonatomic) UIVisualEffectView *blurView;
@property (strong, nonatomic) UIView* darkOverlay;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *getTicketsButton;
- (IBAction)getTicketsButtonTapped:(id)sender;

@end
