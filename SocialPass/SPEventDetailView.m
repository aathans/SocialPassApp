//
//  SPEventDetailView.m
//  SocialPass
//
//  Created by Alexander Athan on 7/10/14.
//  Copyright (c) 2014 Dolo. All rights reserved.
//

#import "SPEventDetailView.h"

@implementation SPEventDetailView

-(id)init{
    self = [super init];
    
    if(self){
        [self setupSubviews];
        [self setupCharacteristics];
        [self setupConstraints];
    }
    
    return self;
}

-(void)setupSubviews{
    self.eventPhoto = [UIImageView new];
    self.cancelButton = [UIButton new];
    self.eventDesc = [UILabel new];
    self.eventOrganizer = [UILabel new];
    self.eventTime = [UILabel new];
    self.attendees = [UILabel new];
    
    [self addSubview:self.eventPhoto];
    [self addSubview:self.eventDesc];
    [self addSubview:self.eventOrganizer];
    [self addSubview:self.eventTime];
    [self addSubview:self.cancelButton];
    [self addSubview:self.attendees];
}


-(void)setupCharacteristics{
    [self setupBackground];
    [self setupCancelButton];
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

-(void)setupCancelButton{
    self.cancelButton.backgroundColor = [UIColor SPSkipRed];
    [self.cancelButton setTitle:@"CANCEL" forState:UIControlStateNormal];
    [self.cancelButton.titleLabel setFont:[UIFont fontWithName:@"Avenir-Medium" size:20.0f]];
    self.cancelButton.titleLabel.textColor = [UIColor whiteColor];
    self.cancelButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.cancelButton.layer setCornerRadius:3];
    [self.cancelButton setTranslatesAutoresizingMaskIntoConstraints:NO];
}

-(void)setupEventPhoto{
    self.eventPhoto.backgroundColor = [UIColor whiteColor];
    self.eventPhoto.alpha = 1.0;
    [self.eventPhoto.layer setCornerRadius:3];
    [self.eventPhoto.layer setBorderColor:[UIColor grayColor].CGColor];
    [self.eventPhoto.layer setBorderWidth:0.1f];
    [self.eventPhoto setClipsToBounds:YES];
    [self.eventPhoto setTranslatesAutoresizingMaskIntoConstraints:NO];
}

-(void)setupEventDescr{
    [self.eventDesc setFont:[UIFont fontWithName:kSPDefaultFont size:kSPDefaultEventFontSize]];
    self.eventDesc.textAlignment = NSTextAlignmentCenter;
    self.eventDesc.numberOfLines = 2;
    [self.eventDesc setLineBreakMode:NSLineBreakByTruncatingTail];
    [self.eventDesc setTranslatesAutoresizingMaskIntoConstraints:NO];
}

-(void)setupEventOrganizer{
    [self.eventOrganizer setFont:[UIFont fontWithName:@"Avenir-LightOblique" size:14.0]];
    self.eventOrganizer.textColor = [UIColor blackColor];
    self.eventOrganizer.textAlignment = NSTextAlignmentCenter;
    [self.eventOrganizer setTranslatesAutoresizingMaskIntoConstraints:NO];
}

-(void)setupEventTime{
    [self.eventTime setFont:[UIFont fontWithName:kSPDefaultFont size:kSPDefaultEventFontSize]];
    self.eventTime.textColor = [UIColor blackColor];
    self.eventTime.textAlignment = NSTextAlignmentCenter;
    [self.eventTime setTranslatesAutoresizingMaskIntoConstraints:NO];
}

-(void)setupEventAttendees{
    [self.attendees setFont:[UIFont fontWithName:kSPDefaultFont size:kSPDefaultEventFontSize]];
    self.attendees.textColor = [UIColor blackColor];
    self.attendees.textAlignment = NSTextAlignmentJustified;
    [self.attendees setTranslatesAutoresizingMaskIntoConstraints:NO];
}
-(void)setupConstraints{
    UIView *eventPhoto = self.eventPhoto;
    UIView *cancelButton = self.cancelButton;
    UIView *eventDesc = self.eventDesc;
    UIView *eventOrg = self.eventOrganizer;
    UIView *eventTime = self.eventTime;
    UIView *attendees = self.attendees;
    
    NSDictionary *views = NSDictionaryOfVariableBindings(eventPhoto, cancelButton, eventDesc, eventOrg, eventTime, attendees);
    
    NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[eventPhoto]-|" options:0 metrics:nil views:views];
    
    constraints = [constraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[eventPhoto(180)]-5-[eventDesc][eventOrg]-[eventTime][attendees]" options:NSLayoutFormatAlignAllCenterX metrics:nil views:views]];
    
    constraints = [constraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[cancelButton(50)]-10-|" options:0 metrics:nil views:views]];
    
    constraints = [constraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[cancelButton]-|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:views]];
    
    constraints = [constraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[eventDesc]|" options:0 metrics:nil views:views]];
    
    [self addConstraints:constraints];
    
}

@end
