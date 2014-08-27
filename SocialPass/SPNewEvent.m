//
//  SPNewEvent.m
//  SocialPass
//
//  Created by Alexander Athan on 8/18/14.
//  Copyright (c) 2014 Dolo. All rights reserved.
//

#import "SPNewEvent.h"

@implementation SPNewEvent

-(void)saveEvent{
    PFFile *eventPhoto = [PFFile fileWithData:_eventImage];
    PFObject *event = [PFObject objectWithClassName:kSPEventClass];

    PFRelation *attendees = [event relationForKey:kSPEventAttendees];
    [attendees addObject:[PFUser currentUser]];

    PFRelation *invitees = [event relationForKey:kSPEventInvitees];

    for(PFUser *friend in _eventAttendees){
        [invitees addObject:friend];
    }

    [event setObject:[PFUser currentUser].objectId forKey:kSPEventOrganizerID];
    [event setObject:_eventDescription forKey:kSPEventDescription];
    [event setObject:_eventStartTime forKey:kSPEventStartTime];
    [event setObject:_eventEndTime forKey:kSPEventEndTime];
    [event setObject:_maxAttendees forKey:kSPEventMaxAttendees];
    [event setObject:eventPhoto forKey:kSPEventPhoto];
    [event setObject:_eventOrganizer forKey:kSPEventOrganizerName];
    [event setObject:_numAttendees forKey:kSPEventNumAttendees];
    
    PFACL *ACL = [PFACL ACLWithUser:[PFUser currentUser]];
    [ACL setPublicReadAccess:YES];
    [ACL setPublicWriteAccess:YES];
    event.ACL = ACL;
    
    [event saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        NSLog(@"Saved Event");
    }];
};

@end
