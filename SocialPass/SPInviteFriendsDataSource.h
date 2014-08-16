//
//  SPInviteFriendsDataSource.h
//  SocialPass
//
//  Created by Alexander Athan on 8/15/14.
//  Copyright (c) 2014 Dolo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SPInviteFriendsDataSource : NSObject <UITableViewDataSource>

@property(nonatomic, strong) NSArray *friends;

- (void)fetchFeedForTable:(UITableView *)table;


@end
