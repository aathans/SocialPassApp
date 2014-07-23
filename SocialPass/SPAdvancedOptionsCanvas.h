//
//  SPAlternateOptionsView.h
//  SocialPass
//
//  Created by Alexander Athan on 6/29/14.
//  Copyright (c) 2014 Dolo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPAdvancedOptionsAttendeeTextField.h"

@interface SPAdvancedOptionsCanvas : UIView 

@property (nonatomic) UILabel *advancedLabel;
@property (nonatomic) UILabel *maxAttendeesLabel;
@property (nonatomic) SPAdvancedOptionsAttendeeTextField *numAttendees;
@property (nonatomic) UILabel *publicLabel;
@property (nonatomic) UISwitch *publicSwitch;

@end
