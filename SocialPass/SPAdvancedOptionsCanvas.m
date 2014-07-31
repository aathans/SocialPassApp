//
//  SPAlternateOptionsView.m
//  SocialPass
//
//  Created by Alexander Athan on 6/29/14.
//  Copyright (c) 2014 Dolo. All rights reserved.
//

#import "SPAdvancedOptionsCanvas.h"

@implementation SPAdvancedOptionsCanvas

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
    self.advancedLabel = [UILabel new];
    self.advancedLabel.userInteractionEnabled = YES;
    self.maxAttendeesLabel = [UILabel new];
    self.numAttendees = [SPAdvancedOptionsAttendeeTextField new];
    self.publicLabel = [UILabel new];
    self.publicSwitch = [UISwitch new];
    
    [self addSubview:self.advancedLabel];
    [self addSubview:self.maxAttendeesLabel];
    [self addSubview:self.numAttendees];
    [self addSubview:self.publicSwitch];
    [self addSubview:self.publicLabel];
}

-(void)setupCharacteristics{
    [self setBackgroundColor:[UIColor colorWithRed:220.0/255.0 green:220.0/255.0 blue:220.0/255.0 alpha:0.9]];
    [self setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self.advancedLabel setText:@"Advanced Options"];
    [self.advancedLabel setTextAlignment:NSTextAlignmentCenter];
    [self.advancedLabel setBackgroundColor:[UIColor colorWithRed:220.0/255.0 green:220.0/255.0 blue:220.0/255.0 alpha:1.0]];
    [self.advancedLabel setTextColor:[UIColor blackColor]];
    [self.advancedLabel setFont:[UIFont fontWithName:@"Avenir-Light" size:14.0]];
    [self.advancedLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self.maxAttendeesLabel setFrame:CGRectMake(10, 60, 165, 40)];
    [self.maxAttendeesLabel setFont:[UIFont fontWithName:@"Avenir-Light" size:16.0]];
    [self.maxAttendeesLabel setText:@"Max Attendees(2-500):"];
    [self.maxAttendeesLabel setTextAlignment:NSTextAlignmentRight];
    [self.maxAttendeesLabel setTextColor:[UIColor blackColor]];
    [self.maxAttendeesLabel setAlpha:0.3];
    
    
    [self.numAttendees setFrame:CGRectMake(180, 65, 60, 30)];
    [self.numAttendees setBorderStyle:UITextBorderStyleRoundedRect];
    [self.numAttendees setBackgroundColor:[UIColor whiteColor]];
    [self.numAttendees setText:@"25"];
    
    [self.publicLabel setFrame:CGRectMake(10, 110, 165, 40)];
    [self.publicLabel setText:@"Public:"];
    [self.publicLabel setTextAlignment:NSTextAlignmentRight];
    [self.publicLabel setFont:[UIFont fontWithName:@"Avenir-Light" size:16.0]];
    
    [self.publicSwitch setFrame:CGRectMake(185, 115, 60, 30)];
    //self.publicSwitch.transform = CGAffineTransformMakeScale(1.25, 1.25);
    self.publicSwitch.backgroundColor = [UIColor whiteColor];
    self.publicSwitch.layer.cornerRadius = 16.0;
    [self.publicSwitch setOn:NO];
    
}

-(void)setupConstraints{
    UIView *advancedLabel = self.advancedLabel;
    
    NSDictionary *views = NSDictionaryOfVariableBindings(advancedLabel);
    
    NSArray *advancedConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[advancedLabel]|" options:0 metrics:nil views:views];
    advancedConstraints = [advancedConstraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[advancedLabel(30)]" options:0 metrics:nil views:views]];
    
    [self addConstraints:advancedConstraints];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    [self endEditing:YES];
}


@end
