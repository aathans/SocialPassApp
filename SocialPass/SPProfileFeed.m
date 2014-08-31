//
//  SPProfileFeed.m
//  SocialPass
//
//  Created by Alexander Athan on 8/31/14.
//  Copyright (c) 2014 Dolo. All rights reserved.
//

#import "SPProfileFeed.h"
#import "SPEmptyFeedLabel.h"

@implementation SPProfileFeed

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        
        SPEmptyFeedLabel *emptyLabel = [SPEmptyFeedLabel new];
        emptyLabel.font = [UIFont fontWithName:kSPDefaultFont size:kSPDefaultEventFontSize];
        emptyLabel.alpha = 0.5f;
        emptyLabel.textAlignment = NSTextAlignmentCenter;
        emptyLabel.text = @"No Upcoming Events";
        self.backgroundView = emptyLabel;
    }
    return self;
}

@end
