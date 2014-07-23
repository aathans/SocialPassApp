//
//  SPNewEventCanvas.h
//  SocialPass
//
//  Created by Alexander Athan on 6/29/14.
//  Copyright (c) 2014 Dolo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SPNewEventCanvas : UIView

//Event stuff
@property (nonatomic) UIButton *imageButton;
@property (nonatomic) UILabel *imageLabel;
@property (nonatomic) UILabel *descriptionLabel;
@property (nonatomic) UITextField *descriptionTF;
@property (nonatomic) UITextField *startTime;
@property (nonatomic) UITextField *endTime;
@property (nonatomic) UILabel *timeLabel;
@property (nonatomic) UILabel *toLabel;
@property (nonatomic) UIButton *createEventButton;

@end
