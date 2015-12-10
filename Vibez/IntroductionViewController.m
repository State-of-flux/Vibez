//
//  IntroductionViewController.m
//  Vibez
//
//  Created by Harry Liddell on 09/12/2015.
//  Copyright © 2015 Pikture. All rights reserved.
//

#import "IntroductionViewController.h"
#import "UIColor+Piktu.h"
#import "UIFont+PIK.h"


@interface IntroductionViewController ()

@end

@implementation IntroductionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self playBackgroundMovie];
    [self setupandShowIntro];
    [self createAndAddLoginButton];
    [self createAndAddSignupButton];
    [self createAndAddLogo];
}

- (void)playBackgroundMovie {
    [[self navigationController] setNavigationBarHidden:YES];
    NSString *mediaPath = [[NSBundle mainBundle] pathForResource:@"vibesBackgroundVideo" ofType:@"mp4"];

    if ([[NSFileManager defaultManager] fileExistsAtPath:mediaPath]) {
        [self setMoviePlayer:[[MPMoviePlayerController alloc] initWithContentURL:[NSURL URLWithString:@"http://www.ebookfrenzy.com/ios_book/movie/movie.mov"]]];
        [[self moviePlayer] prepareToPlay];
        [[[self moviePlayer] view] setFrame:[[self view] frame]];
        [[self moviePlayer] setRepeatMode:MPMovieRepeatModeOne];
        [[self moviePlayer] setFullscreen:YES];
        [[self moviePlayer] setControlStyle:MPMovieControlStyleNone];
        [[self moviePlayer] setScalingMode:MPMovieScalingModeFill];
        
        [self setViewDarkOverlay:[[UIView alloc] initWithFrame:[[self view] frame]]];
        [[self viewDarkOverlay] setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.8f]];
        [[self view] addSubview:[self viewDarkOverlay]];
        [[self view] addSubview:[[self moviePlayer] view]];
        [[self view] sendSubviewToBack:[[self moviePlayer] view]];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(moviePlayBackDidFinish:)
                                                     name:MPMoviePlayerPlaybackDidFinishNotification
                                                   object:[self moviePlayer]];
        
        [[self moviePlayer] setInitialPlaybackTime:-1.0];
        [[self moviePlayer] play];
        [[self moviePlayer] setShouldAutoplay:YES];
    } else {
        NSLog(@"Movie not found at path: %@", mediaPath);
    }
}

- (void)createAndAddLogo {
    
    CGFloat widthScreen = [[self view] frame].size.width;
    CGFloat widthLogo = 200.f;
    CGFloat a = (widthScreen - widthLogo) / 2;
    
    [self setImageViewLogo:[[UIImageView alloc] initWithFrame:CGRectMake(a, 50, widthLogo, 100)]];
    [[self imageViewLogo] setImage:[UIImage imageNamed:@"logo"]];
    [[self imageViewLogo] setContentMode:UIViewContentModeScaleAspectFit];
    [[self view] addSubview:[self imageViewLogo]];
    [[self view] bringSubviewToFront:[self imageViewLogo]];
}

- (void)createAndAddLoginButton {
    
    CGFloat halfWidth = [[self view] frame].size.width / 2;
    CGFloat yValue = [[self view] frame].size.height - 50.0f;
    
    [self setButtonLogin:[UIButton buttonWithType:UIButtonTypeCustom]];
    [[self buttonLogin] setBackgroundColor:[UIColor pku_lightBlackAndAlpha:0.8f]];
    [[self buttonLogin] setFrame:CGRectMake(0, yValue, halfWidth, 50)];
    [[self buttonLogin] setTitle:NSLocalizedString(@"LOG IN", nil) forState:UIControlStateNormal];
    [[[self buttonLogin] titleLabel] setFont:[UIFont systemFontOfSize:18.0f weight:UIFontWeightBold]];
    [[self buttonLogin] setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [[self buttonLogin] addTarget:self action:@selector(buttonLoginPressed) forControlEvents:UIControlEventTouchUpInside];
    [[self view] addSubview:[self buttonLogin]];
    [[self view] bringSubviewToFront:[self buttonLogin]];
}

- (void)createAndAddSignupButton {
    CGFloat halfWidth = [[self view] frame].size.width / 2;
    CGFloat yValue = [[self view] frame].size.height - 50.0f;
    
    [self setButtonSignup:[UIButton buttonWithType:UIButtonTypeCustom]];
    [[self buttonSignup] setBackgroundColor:[UIColor pku_purpleColorandAlpha:0.8f]];
    [[self buttonSignup] setFrame:CGRectMake(halfWidth, yValue, halfWidth, 50)];
    [[self buttonSignup] setTitle:NSLocalizedString(@"REGISTER", nil) forState:UIControlStateNormal];
    [[[self buttonSignup] titleLabel] setFont:[UIFont systemFontOfSize:18.0f weight:UIFontWeightBold]];
    [[self buttonSignup] setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [[self buttonSignup] addTarget:self action:@selector(buttonSignupPressed) forControlEvents:UIControlEventTouchUpInside];
    [[self view] addSubview:[self buttonSignup]];
    [[self view] bringSubviewToFront:[self buttonSignup]];
}

- (void)moviePlayBackDidFinish:(id)sender {
    NSLog(@"Movie finished");
}

- (void)buttonLoginPressed {
    [[self navigationController] setNavigationBarHidden:NO];
    [self performSegueWithIdentifier:@"introToLogin" sender:self];
}

- (void)buttonSignupPressed {
    [[self navigationController] setNavigationBarHidden:NO];
    [self performSegueWithIdentifier:@"introToRegister" sender:self];
}

#pragma mark - EAIntroView

- (void)setupandShowIntro {
    
    NSMutableArray *pages = [NSMutableArray array];
    NSArray *onboardingData = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"OnboardingData" ofType:@"plist"]];
    
    for (NSDictionary *object in onboardingData) {
        EAIntroPage *page = [EAIntroPage page];
        page.title = [object objectForKey:@"titleText"];
        page.titleFont = [UIFont systemFontOfSize:18.0f weight:UIFontWeightBold];
        page.titleColor = [UIColor whiteColor];
        page.titlePositionY = 175.0f;
        page.desc = [object objectForKey:@"descText"];
        page.descFont = [UIFont systemFontOfSize:14.0f weight:UIFontWeightLight];
        page.descPositionY = 175.0f;
        page.bgColor = [UIColor clearColor];
        [pages addObject:page];
    }
    
    [self setIntro:[[EAIntroView alloc] initWithFrame:[[self view] bounds] andPages:pages]];
    [[self intro] setDelegate:self];
    [[self intro] setSkipButton:nil];
    [[self intro] setPageControlY:100.0f];
    
    [[self intro] setUseMotionEffects:YES];
    [[self intro] setSwipeToExit:NO];
    [[self intro] showInView:[self view] animateDuration:1.0];
    [self performSelector:@selector(shiftPageWithIndex:) withObject:[NSNumber numberWithInteger:0] afterDelay:3.0];
}

- (void)intro:(EAIntroView *)introView pageStartScrolling:(EAIntroPage *)page withIndex:(NSUInteger)pageIndex {
    NSLog(@"Start Scrolling with Index: %lu", (unsigned long)pageIndex);
}

- (void)intro:(EAIntroView *)introView pageEndScrolling:(EAIntroPage *)page withIndex:(NSUInteger)pageIndex {
    NSLog(@"End Scrolling with Index: %lu", (unsigned long)pageIndex);
    
    //[self performSelector:@selector(shiftPageWithIndex:) withObject:[NSNumber numberWithInteger:pageIndex] afterDelay:3.0];
}

- (void)shiftPageWithIndex:(NSNumber *)pageIndex {
    
    NSInteger counter = [pageIndex integerValue] + 1;
    
    NSLog(@"Current index: %lu", (unsigned long)counter);
    
    if (counter == 5) {
        [[self intro] setCurrentPageIndex:0 animated:YES];
        [self performSelector:@selector(shiftPageWithIndex:) withObject:[NSNumber numberWithInteger:0] afterDelay:3.0];
        return;
    }
    
    [[self intro] setCurrentPageIndex:counter animated:YES];
    
    [self performSelector:@selector(shiftPageWithIndex:) withObject:[NSNumber numberWithInteger:counter] afterDelay:3.0];
}

@end
