//
//  SPUtility.m
//  SocialPass
//
//  Created by Alexander Athan on 8/11/14.
//  Copyright (c) 2014 Dolo. All rights reserved.
//

#import "SPUtility.h"

@implementation SPUtility

+ (void)processFacebookProfilePictureData:(NSData *)data{
    
}

+ (BOOL)userHasValidFacebookData:(PFUser *)user{
    return YES;
}

+ (BOOL)userHasProfilePictures:(PFUser *)user{
    return YES;
}

+ (NSString *)firstNameForDisplayName:(NSString *)displayName{
    return @"";
}


@end
