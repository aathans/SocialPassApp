//
//  SPUtility.h
//  SocialPass
//
//  Created by Alexander Athan on 8/11/14.
//  Copyright (c) 2014 Dolo. All rights reserved.
//

@interface SPUtility : NSObject

+ (void)processFacebookProfilePictureData:(NSData *)data;

+ (BOOL)userHasValidFacebookData:(PFUser *)user;
+ (BOOL)userHasProfilePictures:(PFUser *)user;

+ (NSString *)firstNameForDisplayName:(NSString *)displayName;


@end
