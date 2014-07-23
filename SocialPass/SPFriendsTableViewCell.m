//
//  SPFriendsTableViewCell.m
//  SocialPass
//
//  Created by Alexander Athan on 6/26/14.
//  Copyright (c) 2014 Dolo. All rights reserved.
//

#import "SPFriendsTableViewCell.h"

@implementation SPFriendsTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        self.layer.contents = (id)[UIImage imageNamed:@"ShadowLayer"].CGImage;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.contentView.backgroundColor = [UIColor clearColor];
        
        self.backgroundLayerView = [[UIView alloc] initWithFrame:CGRectMake(3,0,270,65)];
        self.backgroundLayerView.backgroundColor = [UIColor SPGray];
        [self.backgroundLayerView.layer setCornerRadius:3];
        
        
        self.contentText = [[UILabel alloc] initWithFrame:CGRectMake(self.backgroundLayerView.frame.origin.x+10, self.backgroundLayerView.frame.origin.y, self.backgroundLayerView.frame.size.width-10, self.backgroundLayerView.frame.size.height)];
        self.contentText.backgroundColor = [UIColor clearColor];
        
        [self.contentText setFont:[UIFont fontWithName:@"Avenir-Light" size:16.0f]];
        [self.backgroundLayerView addSubview:self.contentText];

        //Future use for profile picture box
        //UIView *profilePictureBox = [self createProfilePictureBox];
        //[self addProfilePictureBoxToBack:profilePictureBox];
        
        [self.contentView addSubview:self.backgroundLayerView];
        [self.contentView sendSubviewToBack:self.backgroundLayerView];
    }
    return self;
}

-(UIView *)createProfilePictureBox
{
    UIView *whiteRoundedProfileView = [[UIView alloc] initWithFrame:CGRectMake(210, 0, 65, 65)];
    whiteRoundedProfileView.backgroundColor = [UIColor colorWithRed:170.0/255.0 green:170.0/255.0 blue:170.0/255.0 alpha:0.13];
    [whiteRoundedProfileView.layer setCornerRadius:3];
    
    return whiteRoundedProfileView;
}

-(void)addProfilePictureBoxToBack:(UIView *)profilePictureBoxView
{
    [self.contentView addSubview:profilePictureBoxView];
    [self.contentView sendSubviewToBack:profilePictureBoxView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
