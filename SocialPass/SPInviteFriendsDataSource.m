//
//  SPInviteFriendsDataSource.m
//  SocialPass
//
//  Created by Alexander Athan on 8/15/14.
//  Copyright (c) 2014 Dolo. All rights reserved.
//

#import "SPInviteFriendsDataSource.h"
#import "SPInviteFriendsTable.h"
#import "SPFriendsTableViewCell.h"
#import "MSCellAccessory.h"

@interface SPInviteFriendsDataSource()

@end

@implementation SPInviteFriendsDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.friends count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    SPFriendsTableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[SPFriendsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    PFUser *user = [self.friends objectAtIndex:indexPath.row];
    cell.contentText.text = [user objectForKey:kSPUserProfile][kSPUserProfileName];
    cell.username = user.username;

    return cell;
}

- (void)fetchFeedForTable:(SPInviteFriendsTable *)table{
    self.friends = [[SPCache sharedCache] facebookFriends];
    [table setFriendsListWithFriends:self.friends];
    [table reloadData];
}

@end
