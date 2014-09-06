//
//  SPEventPhoto.h
//  SocialPass
//
//  Created by Alexander Athan on 6/22/14.
//  Copyright (c) 2014 Dolo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SPEventCanvas : UIView

@property (nonatomic) UIButton *skipButton;
@property (nonatomic) UIButton *joinButton;
@property (nonatomic) UILabel *eventDesc;
@property (nonatomic) UILabel *eventOrganizer;
@property (nonatomic) UILabel *eventTime;
@property (nonatomic) UILabel *attendees;
@property (nonatomic) UIImageView *eventPhoto;

-(void)resetCanvas;

@end
