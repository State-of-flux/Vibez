//
//  IntroductionViewController.h
//  Vibez
//
//  Created by Harry Liddell on 09/12/2015.
//  Copyright © 2015 Pikture. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <EAIntroView/EAIntroView.h>

@interface IntroductionViewController : UIViewController <EAIntroDelegate>

@property (strong, nonatomic) EAIntroView *intro;
@property (strong, nonatomic) MPMoviePlayerController *moviePlayer;

@property (strong, nonatomic) UIImageView *imageViewLogo;
@property (strong, nonatomic) UIView *viewDarkOverlay;
@property (strong, nonatomic) UIButton *buttonLogin;
@property (strong, nonatomic) UIButton *buttonSignup;

@end
