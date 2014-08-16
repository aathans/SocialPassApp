//
//  SPInviteFriendsTable.h
//  SocialPass
//
//  Created by Alexander Athan on 8/15/14.
//  Copyright (c) 2014 Dolo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SPInviteFriendsTable : UITableView <UITableViewDelegate>

-(void)setFriendsListWithFriends:(NSArray *)friends;
@property (nonatomic) NSMutableArray *selectedFriends;

@end
