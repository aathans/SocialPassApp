//
//  SPEvent.h
//  SocialPass
//
//  Created by Alexander Athan on 6/29/14.
//  Copyright (c) 2014 Dolo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SPUser;

@interface SPEvent : NSManagedObject

@property (nonatomic, retain) NSString * endTime;
@property (nonatomic, retain) NSString * eventDesc;
@property (nonatomic, retain) NSData * eventPhoto;
@property (nonatomic) BOOL  isPublic;
@property (nonatomic, retain) NSNumber * maxAttendees;
@property (nonatomic, retain) NSNumber * numAttendees;
@property (nonatomic, retain) NSNumber * organizerID;
@property (nonatomic, retain) NSString * startTime;
@property (nonatomic, retain) SPUser *attendees;

@end
