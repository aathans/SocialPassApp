//
//  SPFriendsTableViewCell.m
//  SocialPass
//
//  Created by Alexander Athan on 6/26/14.
//  Copyright (c) 2014 Dolo. All rights reserved.
//

#import "SPFriendsTableViewCell.h"

@implementation SPFriendsTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.username = [NSString new];
        self.backgroundColor = [UIColor SPLightGray];
        self.tintColor = [UIColor blackColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.layer.borderColor = [UIColor grayColor].CGColor;
        self.layer.cornerRadius = 3;
        self.layer.borderWidth = 0.1f;
        
        self.contentText = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.origin.x+10, self.frame.origin.y, self.frame.size.width-10, self.frame.size.height)];
        self.contentText.backgroundColor = [UIColor clearColor];
        
        [self.contentText setFont:[UIFont fontWithName:kSPDefaultFont size:kSPDefaultLabelFontSize]];
        [self addSubview:self.contentText];
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    frame.size.width -= 20;
    frame.size.height = 65;
    [super setFrame:frame];
}


@end
