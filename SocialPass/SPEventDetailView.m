//
//  SPEventDetailView.m
//  SocialPass
//
//  Created by Alexander Athan on 7/10/14.
//  Copyright (c) 2014 Dolo. All rights reserved.
//

#import "SPEventDetailView.h"

@implementation SPEventDetailView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setupSubviews];
        [self setupCharacteristics];
        [self setupConstraints];
        
    }
    return self;
}

-(void)setupSubviews{
    _eventName = [UILabel new];
    _eventOrganizer = [UILabel new];
    _eventTime = [UILabel new];
    _eventAttendees = [UILabel new];
    _eventPhoto = [UIImageView new];
    
    [self addSubview:_eventName];
    [self addSubview:_eventOrganizer];
    [self addSubview:_eventTime];
    [self addSubview:_eventAttendees];
    [self addSubview:_eventPhoto];
}

-(void) setupCharacteristics{
    self.backgroundColor = [UIColor SPGray];
    [self setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self.eventName setFont:[UIFont fontWithName:@"Avenir-Light" size:17.0]];
    _eventName.textColor = [UIColor blackColor];
    _eventName.textAlignment = NSTextAlignmentCenter;
    [_eventName setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self.eventOrganizer setFont:[UIFont fontWithName:@"Avenir-Light" size:17.0]];
    _eventOrganizer.textColor = [UIColor blackColor];
    _eventOrganizer.textAlignment = NSTextAlignmentCenter;
    [_eventOrganizer setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self.eventTime setFont:[UIFont fontWithName:@"Avenir-Light" size:17.0]];
    _eventTime.textColor = [UIColor blackColor];
    _eventTime.textAlignment = NSTextAlignmentCenter;
    [_eventTime setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self.eventAttendees setFont:[UIFont fontWithName:@"Avenir-Light" size:17.0]];
    _eventAttendees.textColor = [UIColor blackColor];
    _eventAttendees.textAlignment = NSTextAlignmentCenter;
    [_eventAttendees setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [_eventPhoto setTranslatesAutoresizingMaskIntoConstraints:NO];
    
}

-(void)setupConstraints{
    UIView *eventName = self.eventName;
    UIView *eventOrganizer = _eventOrganizer;
    UIView *eventTime = _eventTime;
    UIView *eventAttendees = _eventAttendees;
    //UIView *eventPhoto = _eventPhoto;
    
    NSDictionary *views = NSDictionaryOfVariableBindings(eventName, eventOrganizer, eventTime, eventAttendees);
    
    NSArray *eventConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[eventName]|" options:0 metrics:nil views:views];
    eventConstraints = [eventConstraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[eventName]-[eventOrganizer]-[eventTime]-[eventAttendees]" options:NSLayoutFormatAlignAllCenterX metrics:nil views:views]];
    
    
    [self addConstraints:eventConstraints];
}

@end
