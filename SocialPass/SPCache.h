//
//  SPCache.h
//  SocialPass
//
//  Created by Alexander Athan on 8/11/14.
//  Copyright (c) 2014 Dolo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SPCache : NSObject

+(id)sharedCache;
-(void)clear;
-(void)setFacebookFriends:(NSArray *)friends;
-(NSArray *)facebookFriends;

@end
