//
//  SPInviteFriendsTable.h
//  SocialPass
//
//  Created by Alexander Athan on 8/15/14.
//  Copyright (c) 2014 Dolo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPFriendsTable.h"

@interface SPInviteFriendsTable : SPFriendsTable

-(void)setFriendsListWithFriends:(NSArray *)friends;
-(BOOL)selectedFriendsContainsUser:(PFUser *)user;

@property (nonatomic) NSMutableArray *selectedFriends;

@end
