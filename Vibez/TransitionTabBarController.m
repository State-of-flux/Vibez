//
//  TransitionTabBarController.m
//  Vibez
//
//  Created by Harry Liddell on 01/06/2015.
//  Copyright (c) 2015 Pikture. All rights reserved.
//

#import "TransitionTabBarController.h"
#import "CEPanAnimationController.h"
//#import "CEFoldAnimationController.h"
#import "CEHorizontalSwipeInteractionController.h"

@interface TransitionTabBarController () <UITabBarControllerDelegate>

@end

@implementation TransitionTabBarController{
    //CEFoldAnimationController *_animationController;
    CEPanAnimationController *_panAnimationController;
    CEHorizontalSwipeInteractionController *_swipeInteractionController;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.delegate = self;
        [[UITabBar appearance] setTintColor:[UIColor colorWithRed:184.0f/255.0f green:42.0f/255.0f blue:255.0f/255.0f alpha:1.0f]];
        // create the interaction / animation controllers
        _swipeInteractionController = [CEHorizontalSwipeInteractionController new];
        _panAnimationController = [CEPanAnimationController new];
        //_panAnimationController.reverse = true;
        //_animationController.folds = 3;
        
        // observe changes in the currently presented view controller
        [self addObserver:self
               forKeyPath:@"selectedViewController"
                  options:NSKeyValueObservingOptionNew
                  context:nil];
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if ([keyPath isEqualToString:@"selectedViewController"] )
    {
        // wire the interaction controller to the view controller
        [_swipeInteractionController wireToViewController:self.selectedViewController
                                             forOperation:CEInteractionOperationTab];
    }
}



- (id <UIViewControllerAnimatedTransitioning>)tabBarController:(UITabBarController *)tabBarController
            animationControllerForTransitionFromViewController:(UIViewController *)fromVC
                                              toViewController:(UIViewController *)toVC {
    
    NSUInteger fromVCIndex = [tabBarController.viewControllers indexOfObject:fromVC];
    NSUInteger toVCIndex = [tabBarController.viewControllers indexOfObject:toVC];
    
    _panAnimationController.reverse = fromVCIndex > toVCIndex;
    return _panAnimationController;
}

-(id<UIViewControllerInteractiveTransitioning>)tabBarController:(UITabBarController *)tabBarController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController
{
    return _swipeInteractionController.interactionInProgress ? _swipeInteractionController : nil;
}

@end
