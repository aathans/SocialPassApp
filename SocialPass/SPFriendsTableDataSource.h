//
//  SPFriendsTableDataSource.h
//  SocialPass
//
//  Created by Alexander Athan on 6/29/14.
//  Copyright (c) 2014 Dolo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SPFriendsTableDataSource : NSObject <UITableViewDataSource>

@property (nonatomic) NSArray *friendUsers;

- (void)fetchFeedForTable:(UITableView *)table;

@end
