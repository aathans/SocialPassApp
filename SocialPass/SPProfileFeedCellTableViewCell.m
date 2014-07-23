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
        
        self.backgroundColor = [UIColor clearColor];
        self.layer.contents = (id)[UIImage imageNamed:@"ShadowLayer"].CGImage;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        // Initialization code
        self.contentView.backgroundColor = [UIColor clearColor];
        
        self.backgroundLayerView = [[UIView alloc] initWithFrame:CGRectMake(3,0,270,65)];
        self.backgroundLayerView.backgroundColor = [UIColor SPGray];
        [self.backgroundLayerView.layer setCornerRadius:3];
        
        self.contentText = [[UILabel alloc] initWithFrame:CGRectMake(self.backgroundLayerView.frame.origin.x+10, self.backgroundLayerView.frame.origin.y, self.backgroundLayerView.frame.size.width-10, self.backgroundLayerView.frame.size.height)];
        self.contentText.backgroundColor = [UIColor clearColor];

        [self.contentText setFont:[UIFont fontWithName:@"Avenir-Light" size:16.0f]];
        [self.backgroundLayerView addSubview:self.contentText];
        // Creates second box to hold profile picture **IF WE WANT THEM SEPARATE**
        /*
         UIView *whiteRoundedProfileView = [[UIView alloc] initWithFrame:CGRectMake(210, 0, 65, 65)];
         whiteRoundedProfileView.backgroundColor = [UIColor colorWithRed:170.0/255.0 green:170.0/255.0 blue:170.0/255.0 alpha:0.13];
         [whiteRoundedProfileView.layer setCornerRadius:3];
         
         [cell.contentView addSubview:whiteRoundedProfileView];
         [cell.contentView sendSubviewToBack:whiteRoundedProfileView];
         */
        
        
        [self.contentView addSubview:self.backgroundLayerView];
        [self.contentView sendSubviewToBack:self.backgroundLayerView];
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
