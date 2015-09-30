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
@property (weak, nonatomic) UITableView *tableView;

@property (strong, nonatomic) UIImageView *eventImageView;
@property (strong, nonatomic) UILabel *eventNameLabel;
@property (strong, nonatomic) UILabel *eventDateLabel;
@property (strong, nonatomic) UILabel *eventDateEndLabel;
@property (strong, nonatomic) UITextView *eventDescriptionTextView;
@property (strong, nonatomic) UILabel *eventVenueLabel;

@property (strong, nonatomic) Event *event;
@property (strong, nonatomic) PFObject *eventPFObject;
@property (strong, nonatomic) NSMutableArray *arrayOfQuantities;
@property (assign, nonatomic) NSInteger quantitySelected;

@property (strong, nonatomic) UIVisualEffectView *blurView;
@property (strong, nonatomic) UIView* darkOverlay;

@property (strong, nonatomic) UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *getTicketsButton;
- (IBAction)getTicketsButtonTapped:(id)sender;

@end
