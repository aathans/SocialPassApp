//
//  SPProfileFeedCellTableViewCell.m
//  SocialPass
//
//  Created by Alexander Athan on 6/26/14.
//  Copyright (c) 2014 Dolo. All rights reserved.
//

#import "SPProfileFeedCellTableViewCell.h"

@implementation SPProfileFeedCellTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor SPLightGray];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.layer.borderColor = [UIColor grayColor].CGColor;
        self.layer.cornerRadius = 3;
        self.layer.borderWidth = 0.1f;
        self.contentText = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.origin.x+10, self.frame.origin.y, self.frame.size.width-80, self.frame.size.height)];
        [self.contentText setLineBreakMode:NSLineBreakByTruncatingTail];
        [self.contentText setNumberOfLines:2];
        [self.contentText setFont:[UIFont fontWithName:kSPDefaultFont size:kSPDefaultLabelFontSize]];

        // Creates second box to hold profile picture **IF WE WANT THEM SEPARATE**
        /*
         UIView *whiteRoundedProfileView = [[UIView alloc] initWithFrame:CGRectMake(210, 0, 65, 65)];
         whiteRoundedProfileView.backgroundColor = [UIColor colorWithRed:170.0/255.0 green:170.0/255.0 blue:170.0/255.0 alpha:0.13];
         [whiteRoundedProfileView.layer setCornerRadius:3];
         
         [cell.contentView addSubview:whiteRoundedProfileView];
         [cell.contentView sendSubviewToBack:whiteRoundedProfileView];
         */
        //[self.contentView addSubview:self.backgroundLayerView];
        //[self.contentView sendSubviewToBack:self.backgroundLayerView];
        [self addSubview:self.contentText];
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    frame.size.height = 65;
    [super setFrame:frame];
}

@end
