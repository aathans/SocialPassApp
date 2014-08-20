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
@property (nonatomic) NSArray *indexList;

- (void)fetchFeedForTable:(UITableView *)table;
-(void)reloadFriendsForTable:(UITableView *)table;

@end
