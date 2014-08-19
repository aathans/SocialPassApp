//
//  SPNewEvent.h
//  SocialPass
//
//  Created by Alexander Athan on 8/18/14.
//  Copyright (c) 2014 Dolo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SPNewEvent : NSObject

@property (nonatomic) NSString *eventOrganizer;
@property (nonatomic) NSString *eventDescription;
@property (nonatomic) NSDate *eventStartTime;
@property (nonatomic) NSDate *eventEndTime;
@property (nonatomic) NSNumber *maxAttendees;
@property (nonatomic) BOOL isPublic;
@property (nonatomic) NSString *location;
@property (nonatomic) NSData *eventImage;
@property (nonatomic) NSArray *eventAttendees;

-(void)saveEvent;

@end
