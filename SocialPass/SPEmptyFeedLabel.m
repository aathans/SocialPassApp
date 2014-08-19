//
//  SPEmptyFeedLabel.m
//  SocialPass
//
//  Created by Alexander Athan on 7/31/14.
//  Copyright (c) 2014 Dolo. All rights reserved.
//

#import "SPEmptyFeedLabel.h"

@implementation SPEmptyFeedLabel

- (void)drawTextInRect:(CGRect)rect {
    UIEdgeInsets insets = {0, 0, 119, 0};
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, insets)];
}

@end
