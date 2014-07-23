//
//  SPTransitionManger.m
//  SocialPass
//
//  Created by Alex Athan on 06/25/14.
//  Copyright (c) 2014 Dolo. All rights reserved.
//

#import "SPTransitionManager.h"

@implementation SPTransitionManager


#pragma mark - UIViewControllerAnimatedTransitioning -

-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    return 0.8;
}


- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];

    UIViewAnimationOptions flipAnimation = ([toVC.presentedViewController isEqual:fromVC])?UIViewAnimationOptionTransitionFlipFromLeft:UIViewAnimationOptionTransitionFlipFromRight;
    
    [fromVC viewWillDisappear:YES];
    [toVC viewWillAppear:YES];
    
    [UIView transitionFromView:fromVC.view
                        toView:toVC.view
                      duration:[self transitionDuration:transitionContext]
                       options:flipAnimation
                    completion:^(BOOL finished) {
                        [transitionContext completeTransition:YES];
                    }];
    
}

@end
