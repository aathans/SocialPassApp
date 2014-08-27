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
        
        self.layer.borderColor = [UIColor grayColor].CGColor;
        self.layer.cornerRadius = 3;
        self.layer.borderWidth = 0.1f;
        
        self.contentText = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.origin.x+10, self.frame.origin.y, self.frame.size.width-10, self.frame.size.height)];
        self.contentText.backgroundColor = [UIColor clearColor];
        
        [self.contentText setFont:[UIFont fontWithName:kSPDefaultFont size:16.0f]];
        [self addSubview:self.contentText];
        //[self.backgroundLayerView addSubview:self.contentText];

        //Future use for profile picture box
        //UIView *profilePictureBox = [self createProfilePictureBox];
        //[self addProfilePictureBoxToBack:profilePictureBox];
        
        //[self.contentView addSubview:self.backgroundLayerView];
        //[self.contentView sendSubviewToBack:self.backgroundLayerView];
    }
    return self;
}

-(UIView *)createProfilePictureBox{
    UIView *whiteRoundedProfileView = [[UIView alloc] initWithFrame:CGRectMake(210, 0, 65, 65)];
    whiteRoundedProfileView.backgroundColor = [UIColor colorWithRed:170.0/255.0 green:170.0/255.0 blue:170.0/255.0 alpha:0.13];
    [whiteRoundedProfileView.layer setCornerRadius:3];
    
    return whiteRoundedProfileView;
}

-(void)addProfilePictureBoxToBack:(UIView *)profilePictureBoxView{
    [self.contentView addSubview:profilePictureBoxView];
    [self.contentView sendSubviewToBack:profilePictureBoxView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:animated];
}

- (void)setFrame:(CGRect)frame {
    frame.origin.x += 3;
    frame.size.width -= 50;
    frame.size.height = 65;
    [super setFrame:frame];
}

@end
