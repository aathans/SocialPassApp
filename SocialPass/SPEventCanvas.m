//
//  SPEventPhoto.m
//  SocialPass
//
//  Created by Alexander Athan on 6/22/14.
//  Copyright (c) 2014 Dolo. All rights reserved.
//

#import "SPEventCanvas.h"

@implementation SPEventCanvas

-(id)init{
    self = [super initWithFrame:CGRectZero];
    [self setupSubviews];
    [self setupCharacteristics];
    [self setupConstraints];
    return self;
}

-(void)setupSubviews{
    self.eventPhoto = [UIImageView new];
    self.skipButton = [UIButton new];
    self.joinButton = [UIButton new];
    self.eventDesc = [UILabel new];
    self.eventOrganizer = [UILabel new];
    self.eventTime = [UILabel new];
    self.attendees = [UILabel new];
    
    [self addSubview:self.eventPhoto];
    [self addSubview:self.eventDesc];
    [self addSubview:self.eventOrganizer];
    [self addSubview:self.eventTime];
    [self addSubview:self.skipButton];
    [self addSubview:self.joinButton];
    [self addSubview:self.attendees];
}


-(void)setupCharacteristics{
    [self setupBackground];
    [self setupSkipButton];
    [self setupJoinButton];
    [self setupEventPhoto];
    [self setupEventDescr];
    [self setupEventOrganizer];
    [self setupEventTime];
    [self setupEventAttendees];
}

-(void)setupBackground{
    self.backgroundColor = [UIColor SPGray];
    self.layer.borderWidth = 0.1f;
    self.layer.borderColor = [UIColor grayColor].CGColor;
    self.clipsToBounds = YES;
    [self.layer setCornerRadius:3];
    [self setTranslatesAutoresizingMaskIntoConstraints:NO];
}

-(void)setupSkipButton{
    self.skipButton.backgroundColor = [UIColor SPSkipRed];
    [self.skipButton setTitle:@"SKIP" forState:UIControlStateNormal];
    [self.skipButton.titleLabel setFont:[UIFont fontWithName:@"Avenir-Medium" size:20.0f]];
    self.skipButton.titleLabel.textColor = [UIColor whiteColor];
    self.skipButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.skipButton.layer setCornerRadius:3];
    [self.skipButton setTranslatesAutoresizingMaskIntoConstraints:NO];
}

-(void)setupJoinButton{
    self.joinButton.backgroundColor = [UIColor SPJoinGreen];
    [self.joinButton setTitle:@"JOIN" forState:UIControlStateNormal];
    [self.joinButton.titleLabel setFont:[UIFont fontWithName:@"Avenir-Medium" size:20.0f]];
    self.joinButton.titleLabel.textColor = [UIColor whiteColor];
    self.joinButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.joinButton.layer setCornerRadius:3];
    [self.joinButton setTranslatesAutoresizingMaskIntoConstraints:NO];
}

-(void)setupEventPhoto{
    self.eventPhoto.backgroundColor = [UIColor whiteColor];
    self.eventPhoto.alpha = 1.0;
    [self.eventPhoto setClipsToBounds:YES];
    [self.eventPhoto.layer setCornerRadius:3];
    [self.eventPhoto.layer setBorderWidth:0.1f];
    [self.eventPhoto.layer setBorderColor:[UIColor grayColor].CGColor];
    [self.eventPhoto setTranslatesAutoresizingMaskIntoConstraints:NO];
}

-(void)setupEventDescr{
    //self.eventDesc.text = @"Drinks at Treehouse";
    [self.eventDesc setFont:[UIFont fontWithName:kSPDefaultFont size:17.0]];
    self.eventDesc.textColor = [UIColor blackColor];
    self.eventDesc.textAlignment = NSTextAlignmentCenter;
    [self.eventDesc setTranslatesAutoresizingMaskIntoConstraints:NO];
}

-(void)setupEventOrganizer{
    //self.eventOrganizer.text = @"Alex Athan";
    [self.eventOrganizer setFont:[UIFont fontWithName:@"Avenir-LightOblique" size:13.0]];
    self.eventOrganizer.textColor = [UIColor blackColor];
    self.eventOrganizer.textAlignment = NSTextAlignmentCenter;
    [self.eventOrganizer setTranslatesAutoresizingMaskIntoConstraints:NO];
}

-(void)setupEventTime{
    //self.eventTime.text = @"Today from 4:00PM to 11:00PM";
    [self.eventTime setFont:[UIFont fontWithName:kSPDefaultFont size:17.0]];
    self.eventTime.textColor = [UIColor blackColor];
    self.eventTime.textAlignment = NSTextAlignmentCenter;
    [self.eventTime setTranslatesAutoresizingMaskIntoConstraints:NO];
}

-(void)setupEventAttendees{
    //self.attendees.text = @"Attendees: 25 (20 Mutual)";
    [self.attendees setFont:[UIFont fontWithName:kSPDefaultFont size:17.0]];
    self.attendees.textColor = [UIColor blackColor];
    self.attendees.textAlignment = NSTextAlignmentCenter;
    [self.attendees setTranslatesAutoresizingMaskIntoConstraints:NO];
}
-(void)setupConstraints{
    UIView *eventPhoto = self.eventPhoto;
    UIView *skipButton = self.skipButton;
    UIView *joinButton = self.joinButton;
    UIView *eventDesc = self.eventDesc;
    UIView *eventOrg = self.eventOrganizer;
    UIView *eventTime = self.eventTime;
    UIView *attendees = self.attendees;
    
    NSDictionary *views = NSDictionaryOfVariableBindings(eventPhoto, skipButton, joinButton, eventDesc, eventOrg, eventTime, attendees);
    
    NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[eventPhoto]-|" options:0 metrics:nil views:views];
    
    constraints = [constraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[eventPhoto(180)]-5-[eventDesc][eventOrg]-[eventTime][attendees]" options:NSLayoutFormatAlignAllCenterX metrics:nil views:views]];
    
    constraints = [constraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[skipButton(50)]-10-|" options:0 metrics:nil views:views]];
    
    constraints = [constraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[joinButton(==skipButton)]" options:0 metrics:nil views:views]];
    
    constraints = [constraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[skipButton]-[joinButton(==skipButton)]-|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:views]];
    
    [self addConstraints:constraints];

}

@end
