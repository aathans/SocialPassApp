//
//  SPUser.h
//  SocialPass
//
//  Created by Alexander Athan on 6/29/14.
//  Copyright (c) 2014 Dolo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SPEvent;

@interface SPUser : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * userID;
@property (nonatomic, retain) NSString * pictureURL;
@property (nonatomic, retain) SPEvent *eventsJoined;

@end
