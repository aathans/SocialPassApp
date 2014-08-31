//
//  SPProfileViewController.h
//  SocialPass
//
//  Created by Alexander Athan on 6/25/14.
//  Copyright (c) 2014 Dolo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPProfileFeed.h"

@interface SPProfileViewController : UIViewController <UIViewControllerTransitioningDelegate>

@property (nonatomic) SPProfileFeed *eventFeed;
@property (nonatomic) BOOL didCancelEvent;

@end
