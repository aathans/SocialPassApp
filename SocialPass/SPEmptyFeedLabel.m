//
//  SPEmptyFeedLabel.m
//  SocialPass
//
//  Created by Alexander Athan on 7/31/14.
//  Copyright (c) 2014 Dolo. All rights reserved.
//

#import "SPEmptyFeedLabel.h"

@implementation SPEmptyFeedLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawTextInRect:(CGRect)rect {
    UIEdgeInsets insets = {0, 0, 119, 0};
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, insets)];
}

@end
