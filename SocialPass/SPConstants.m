//
//  SPConstants.m
//  SocialPass
//
//  Created by Alexander Athan on 8/11/14.
//  Copyright (c) 2014 Dolo. All rights reserved.
//

#pragma mark - Fonts
NSString *const kSPDefaultFont = @"Avenir-Light";
float const kSPDefaultHeaderFontSize = 18.0;
float const kSPDefaultEventFontSize = 17.0;
float const kSPDefaultNavButtonFontSize = 16.0;
float const kSPDefaultLabelFontSize = 16.0;

#pragma mark - Cache
NSString *const kSPFriendsList = @"friendsList";
NSString *const kSPInvitedFriends = @"invitedFriends";

#pragma mark - PFObject User Class
NSString *const kSPUserProfile = @"profile";
NSString *const kSPUserFacebookId = @"facebookId";
NSString *const kSPUserProfileName = @"name";
NSString *const kSPUserProfilePictureURL = @"pictureURL";

#pragma mark - PFObject Event Class
NSString *const kSPEventClass = @"Event";
NSString *const kSPEventDescription = @"description";
NSString *const kSPEventPhoto = @"eventPhoto";
NSString *const kSPEventMaxAttendees = @"maxAttendees";
NSString *const kSPEventOrganizerID = @"organizerID";
NSString *const kSPEventStartTime = @"startTime";
NSString *const kSPEventEndTime = @"endTime";
NSString *const kSPEventAttendees = @"attendees";
NSString *const kSPEventInvitees = @"invitees";
NSString *const kSPEventOrganizerName = @"organizerName";
NSString *const kSPEventNumAttendees = @"numAttendees";

#pragma mark - Time format
NSString *const kSPTimeFormat = @"h:mma";
NSString *const kSPNoEndTimeFormat = @"MMM. d' at 'h:mma";
NSString *const kSPHasEndTimeFormat = @"MMM. d h:mma";

#pragma mark - Images
NSString *const kSPDefaultEventPhoto = @"defaultEventPhoto.jpg";
NSString *const kSPAddEventIcon = @"icon_eventPlus";