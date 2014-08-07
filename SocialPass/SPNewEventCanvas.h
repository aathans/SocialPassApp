//
//  SPNewEventCanvas.h
//  SocialPass
//
//  Created by Alexander Athan on 6/29/14.
//  Copyright (c) 2014 Dolo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SPNewEventCanvas : UIView

@property (nonatomic) UIButton *coverPhoto;
@property (nonatomic) UILabel *coverPhotoHeader;
@property (nonatomic) UITextField *descriptionTF;
@property (nonatomic) UITextField *day;
@property (nonatomic) UITextField *startTime;
@property (nonatomic) UITextField *endTime;
@property (nonatomic) UILabel *toLabel;
@property (nonatomic) UIButton *createEvent;

@end
