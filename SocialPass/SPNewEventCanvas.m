//
//  SPNewEventCanvas.m
//  SocialPass
//
//  Created by Alexander Athan on 6/29/14.
//  Copyright (c) 2014 Dolo. All rights reserved.
//

#import "SPNewEventCanvas.h"
#import "TPKeyboardAvoidingScrollView.h"

@interface SPNewEventCanvas() <UITextFieldDelegate>

@property (nonatomic) TPKeyboardAvoidingScrollView *keyboard;

@end

@implementation SPNewEventCanvas

- (id)initWithFrame:(CGRect)frame
{
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
    [self setClipsToBounds:YES];
    
    //Cover Photo
    self.imageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.imageLabel = [UILabel new];
    
    //Description
    self.descriptionLabel = [UILabel new];
    self.descriptionTF = [UITextField new];
    
    //Times
    self.startTime = [UITextField new];
    self.endTime = [UITextField new];
    self.toLabel = [UILabel new];
    self.timeLabel = [UILabel new];
    
    //Create Button
    self.createEventButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    self.keyboard = [TPKeyboardAvoidingScrollView new];
    
    [self.keyboard addSubview:self.imageButton];
    [self.keyboard addSubview:self.imageLabel];
    [self.keyboard addSubview:self.descriptionLabel];
    [self.keyboard addSubview:self.descriptionTF];
    [self.keyboard addSubview:self.startTime];
    [self.keyboard addSubview:self.endTime];
    [self.keyboard addSubview:self.toLabel];
    [self.keyboard addSubview:self.timeLabel];
    
    [self addSubview:self.keyboard];
    [self addSubview:self.createEventButton];
}

-(void)setupCharacteristics{
    self.backgroundColor = [UIColor SPGray];
    [self setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    //Cover photo header
    self.imageLabel.text = @"Event Cover Photo";
    [self.imageLabel setFont:[UIFont fontWithName:@"Avenir-Light" size:14.0]];
    self.imageLabel.textAlignment = NSTextAlignmentCenter;
    [self.imageLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    //Cover photo picker
    [self.imageButton setTitle:@"No Photo" forState:UIControlStateNormal];
    [self.imageButton.titleLabel setFont:[UIFont fontWithName:@"Avenir-Light" size:16.0f]];
    [self.imageButton setBackgroundColor:[UIColor greenColor]];

    [self.imageButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    //Description header
    self.descriptionLabel.text = @"What do you want to do?";
    [self.descriptionLabel setFont:[UIFont fontWithName:@"Avenir-Light" size:14.0]];
    self.descriptionLabel.textAlignment = NSTextAlignmentCenter;
    [self.descriptionLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    
    //Description
    [self.descriptionTF setPlaceholder:@"Description"];
    [self.descriptionTF setFont:[UIFont fontWithName:@"Avenir-Light" size:14.0]];
    [self.descriptionTF setBackgroundColor:[UIColor whiteColor]];
    [self.descriptionTF setBorderStyle:UITextBorderStyleRoundedRect];
    [self.descriptionTF setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    //Times
    [self.startTime setPlaceholder:@"Start Time"];
    [self.startTime setFont:[UIFont fontWithName:@"Avenir-Light" size:14.0]];
    [self.startTime setBackgroundColor:[UIColor whiteColor]];
    [self.startTime setBorderStyle:UITextBorderStyleRoundedRect];
    [self.startTime setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self.endTime setPlaceholder:@"End Time"];
    [self.endTime setFont:[UIFont fontWithName:@"Avenir-Light" size:14.0]];
    [self.endTime setBackgroundColor:[UIColor whiteColor]];
    [self.endTime setBorderStyle:UITextBorderStyleRoundedRect];
    [self.endTime setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    self.timeLabel.text = @"What time?";
    [self.timeLabel setFont:[UIFont fontWithName:@"Avenir-Light" size:14.0]];
    self.timeLabel.textAlignment = NSTextAlignmentCenter;
    [self.timeLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    self.toLabel.text = @"to";
    [self.toLabel setFont:[UIFont fontWithName:@"Avenir-Light" size:14.0]];
    self.toLabel.textAlignment = NSTextAlignmentCenter;
    [self.toLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    //Create Button
    [self.createEventButton setBackgroundColor:[UIColor colorWithRed:206.0/255.0 green:206.0/255.0 blue:206.0/255.0 alpha:1.0]];
    [self.createEventButton setTitle:@"Create Event" forState:UIControlStateNormal];
    [self.createEventButton.titleLabel setFont:[UIFont fontWithName:@"Avenir-Medium" size:19.0f]];
    [self.createEventButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.createEventButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    //Keyboard
    [self.keyboard setTranslatesAutoresizingMaskIntoConstraints:NO];

}

-(void)setupConstraints{
    UIView *imageLabel = self.imageLabel;
    UIView *eventPhoto = self.imageButton;
    UIView *descLabel = self.descriptionLabel;
    UIView *desc = self.descriptionTF;
    UIView *start = self.startTime;
    UIView *end = self.endTime;
    UIView *to = self.toLabel;
    UIView *timeLabel = self.timeLabel;
    UIView *createEvent = self.createEventButton;
    
    UIView *keyboard = self.keyboard;

    NSDictionary *views = NSDictionaryOfVariableBindings(imageLabel, eventPhoto, descLabel, desc, start, end, to, timeLabel, keyboard, createEvent);
    
    NSArray *keyboardConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[keyboard]|" options:0 metrics:nil views:views];
    keyboardConstraints = [keyboardConstraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[keyboard]|" options:0 metrics:nil views:views]];
    
    NSArray *createEventConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[createEvent]|" options:0 metrics:nil views:views];

    createEventConstraints = [createEventConstraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[createEvent(55)]|" options:0 metrics:nil views:views]];
    createEventConstraints = [createEventConstraints arrayByAddingObject:[NSLayoutConstraint constraintWithItem:createEvent attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    
    //Horizontal
    NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[eventPhoto]-|" options:NSLayoutFormatAlignAllCenterX metrics:nil views:views];
    constraints = [constraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[desc]-|" options:0 metrics:nil views:views]];
    
    constraints = [constraints arrayByAddingObject:[NSLayoutConstraint constraintWithItem:imageLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:keyboard attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    
    //Vertical
    constraints = [constraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[imageLabel]-5-[eventPhoto(180)]-3-[descLabel][desc]-3-[timeLabel]-[to]-|" options:NSLayoutFormatAlignAllCenterX metrics:nil views:views]];
    
    constraints = [constraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[start]-5-[to]-5-[end(==start)]-|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:views]];
    
    [self.keyboard addConstraints:constraints];
    [self addConstraints:keyboardConstraints];
    [self addConstraints:createEventConstraints];
    

}


@end
