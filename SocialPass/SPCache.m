//
//  SPCache.m
//  SocialPass
//
//  Created by Alexander Athan on 8/11/14.
//  Copyright (c) 2014 Dolo. All rights reserved.
//

#import "SPCache.h"

@interface SPCache()

@property (nonatomic)NSCache *cache;

@end

@implementation SPCache

+(id)sharedCache{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [self new];
    });
    return _sharedObject;
}

-(id)init{
    self = [super init];
    if(self){
        self.cache = [NSCache new];
    }
    return self;
}

#pragma mark - SPCache

-(void)clear{
    [self.cache removeAllObjects];
}

-(void)setFacebookFriends:(NSArray *)friends{
    [self.cache setObject:friends forKey:kSPFriendsList];
}

-(NSArray *)facebookFriends{
    if([self.cache objectForKey:kSPFriendsList])
        return [self.cache objectForKey:kSPFriendsList];
    return nil;
}

-(void)setInvitedFriends:(NSArray *)selectedFriends{
    [self.cache setObject:selectedFriends forKey:kSPInvitedFriends];
}

-(NSArray *)invitedFriends{
    if([self.cache objectForKey:kSPInvitedFriends])
        return [self.cache objectForKey:kSPInvitedFriends];
    return nil;
}

@end
