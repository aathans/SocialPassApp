//
//  SPInviteFriendsDataSource.h
//  SocialPass
//
//  Created by Alexander Athan on 8/15/14.
//  Copyright (c) 2014 Dolo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SPFriendsTableDataSource.h"
#import "SPInviteFriendsTable.h"

@interface SPInviteFriendsDataSource : SPFriendsTableDataSource

- (void)fetchFeedForTable:(SPInviteFriendsTable *)table;

@end
