//
//  SPTextField.m
//  SocialPass
//
//  Created by Alexander Athan on 7/22/14.
//  Copyright (c) 2014 Dolo. All rights reserved.
//

#import "SPAdvancedOptionsAttendeeTextField.h"

@implementation SPAdvancedOptionsAttendeeTextField

#define NUMBERS_ONLY @"1234567890"
#define CHARACTER_LIMIT 3

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.numAttendeeFormatter = [NSNumberFormatter new];
        self.minAttendees = [NSNumber numberWithInt:2];
        self.maxAttendees = [NSNumber numberWithInt:500];
        self.delegate = self;
    }
    return self;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self changeTextToDefault];
    [textField resignFirstResponder];
    return YES;
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string  {
    
    NSLog(@"shouldChange!");
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS_ONLY] invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    
    return (([string isEqualToString:filtered])&&(newLength <= CHARACTER_LIMIT));
    
}


-(void)textFieldDidEndEditing:(UITextField *)textField{
    [self changeTextToDefault];
}

-(void)changeTextToDefault{
    NSNumber *numAttendees = [self.numAttendeeFormatter numberFromString:self.text];
    NSLog(@"Number of max attendees: %@", numAttendees);
    
    if([numAttendees intValue] > [self.maxAttendees intValue]){
        self.text = [self.maxAttendees stringValue];
    }else if([numAttendees intValue] < [self.minAttendees intValue]){
        self.text = [self.minAttendees stringValue];
    }
}


@end
