//
//  SPTransitionManger.h
//  SocialPass
//
//  Created by Alex Athan on 06/25/14.
//  Copyright (c) 2014 Dolo. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, TransitionStep){
    INITIAL = 0,
    MODAL
};

@interface SPTransitionManager : NSObject <UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign) TransitionStep transitionTo;

@end
