//
//  SPNewEventCanvas.m
//  SocialPass
//
//  Created by Alexander Athan on 6/29/14.
//  Copyright (c) 2014 Dolo. All rights reserved.
//

#import "SPNewEventCanvas.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "SPDayMonth.h"

@interface SPNewEventCanvas() <UITextFieldDelegate>

@property (nonatomic) TPKeyboardAvoidingScrollView *keyboard;
@property (nonatomic) SPDayMonth *dayPicker;

@end

@implementation SPNewEventCanvas

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
        [self setupCharacteristics];
        [self setupConstraints];
    }
    return self;
}

-(void)setupSubviews{
    [self setClipsToBounds:YES];
    
    self.coverPhoto = [UIButton buttonWithType:UIButtonTypeCustom];
    self.coverPhotoHeader = [UILabel new];
    self.descriptionTF = [UITextField new];
    self.day = [UITextField new];
    self.startTime = [UITextField new];
    self.endTime = [UITextField new];
    self.toLabel = [UILabel new];
    self.createEvent = [UIButton buttonWithType:UIButtonTypeCustom];
    self.keyboard = [TPKeyboardAvoidingScrollView new];
    self.dayPicker = [SPDayMonth new];

    [self.keyboard addSubview:self.coverPhoto];
    [self.keyboard addSubview:self.coverPhotoHeader];
    [self.keyboard addSubview:self.descriptionTF];
    [self.keyboard addSubview:self.startTime];
    [self.keyboard addSubview:self.endTime];
    [self.keyboard addSubview:self.toLabel];
    [self.keyboard addSubview:self.day];
    
    [self addSubview:self.keyboard];
    [self addSubview:self.createEvent];
}

-(void)setupCharacteristics{
    self.backgroundColor = [UIColor SPGray];
    [self setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    self.coverPhotoHeader.text = @"Event Cover Photo";
    [self.coverPhotoHeader setFont:[UIFont fontWithName:kSPDefaultFont size:14.0]];
    self.coverPhotoHeader.textAlignment = NSTextAlignmentCenter;
    [self.coverPhotoHeader setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self.coverPhoto setTitle:@"Choose Photo" forState:UIControlStateNormal];
    [self.coverPhoto.titleLabel setFont:[UIFont fontWithName:kSPDefaultFont size:16.0f]];
    [self.coverPhoto setBackgroundColor:[UIColor greenColor]];
    [self.coverPhoto setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self.descriptionTF setPlaceholder:@"Description"];
    [self.descriptionTF setFont:[UIFont fontWithName:kSPDefaultFont size:14.0]];
    [self.descriptionTF setBackgroundColor:[UIColor whiteColor]];
    [self.descriptionTF setBorderStyle:UITextBorderStyleRoundedRect];
    [self.descriptionTF setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self.day setInputView:self.dayPicker];
    [self.day setPlaceholder:@"Date"];
    [self.day setFont:[UIFont fontWithName:kSPDefaultFont size:14.0]];
    [self.day setBorderStyle:UITextBorderStyleRoundedRect];
    [self.day setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self.startTime setPlaceholder:@"Start Time"];
    [self.startTime setFont:[UIFont fontWithName:kSPDefaultFont size:14.0]];
    [self.startTime setBorderStyle:UITextBorderStyleRoundedRect];
    [self.startTime setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    UIDatePicker *datePicker = [UIDatePicker new];
    datePicker.datePickerMode = UIDatePickerModeTime;
    [self.startTime setInputView:datePicker];
    [self.startTime.inputAccessoryView setHidden:NO];
    
    [self.endTime setPlaceholder:@"End Time"];
    [self.endTime setFont:[UIFont fontWithName:kSPDefaultFont size:14.0]];
    [self.endTime setBorderStyle:UITextBorderStyleRoundedRect];
    [self.endTime setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.endTime setInputView:datePicker];
    [self.endTime.inputAccessoryView setHidden:NO];
    
    self.toLabel.text = @"to";
    [self.toLabel setFont:[UIFont fontWithName:kSPDefaultFont size:14.0]];
    self.toLabel.textAlignment = NSTextAlignmentCenter;
    [self.toLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self.createEvent setBackgroundColor:[UIColor colorWithRed:206.0/255.0 green:206.0/255.0 blue:206.0/255.0 alpha:1.0]];
    [self.createEvent setTitle:@"Create Event" forState:UIControlStateNormal];
    [self.createEvent.titleLabel setFont:[UIFont fontWithName:@"Avenir-Medium" size:19.0f]];
    [self.createEvent setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.createEvent setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self.keyboard setTranslatesAutoresizingMaskIntoConstraints:NO];

}

-(void)setupConstraints{
    UIView *imageLabel = self.coverPhotoHeader;
    UIView *eventPhoto = self.coverPhoto;
    UIView *desc = self.descriptionTF;
    UIView *day = self.day;
    UIView *start = self.startTime;
    UIView *end = self.endTime;
    UIView *to = self.toLabel;
    UIView *createEvent = self.createEvent;
    
    UIView *keyboard = self.keyboard;

    NSDictionary *views = NSDictionaryOfVariableBindings(imageLabel, eventPhoto, desc,day, start, end, to, keyboard, createEvent);
    
    NSArray *keyboardConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[keyboard]|" options:0 metrics:nil views:views];
    keyboardConstraints = [keyboardConstraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[keyboard]|" options:0 metrics:nil views:views]];
    
    NSArray *createEventConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[createEvent]|" options:0 metrics:nil views:views];

    createEventConstraints = [createEventConstraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[createEvent(55)]|" options:0 metrics:nil views:views]];
    createEventConstraints = [createEventConstraints arrayByAddingObject:[NSLayoutConstraint constraintWithItem:createEvent attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    
    //Horizontal
    NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[eventPhoto]-|" options:NSLayoutFormatAlignAllCenterX metrics:nil views:views];
    constraints = [constraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[desc]-|" options:0 metrics:nil views:views]];
    constraints = [constraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[day]-|" options:0 metrics:nil views:views]];
    constraints = [constraints arrayByAddingObject:[NSLayoutConstraint constraintWithItem:imageLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:keyboard attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    
    //Vertical
    constraints = [constraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(-15)-[imageLabel]-5-[eventPhoto(180)]-[desc]-5-[day]-10-[to]-|" options:NSLayoutFormatAlignAllCenterX metrics:nil views:views]];
    
    constraints = [constraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[start]-5-[to]-5-[end(==start)]-|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:views]];
    
    [self.keyboard addConstraints:constraints];
    [self addConstraints:keyboardConstraints];
    [self addConstraints:createEventConstraints];
    

}


@end
