//
//  SPProfileFeedDataSource.h
//  SocialPass
//
//  Created by Alexander Athan on 6/26/14.
//  Copyright (c) 2014 Dolo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SPProfileFeedDataSource : NSObject <UITableViewDataSource>

@property (nonatomic) NSMutableArray *events;

- (void)fetchFeedForTable:(UITableView *)table;
- (void)fetchFeedForTableInBackground:(UITableView *)table;

@end
