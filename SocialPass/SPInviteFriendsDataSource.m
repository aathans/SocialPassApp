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

@property (nonatomic) SPInviteFriendsTable *tableView;

@end

@implementation SPInviteFriendsDataSource

- (void)fetchFeedForTable:(SPInviteFriendsTable *)table{
    self.friendUsers = [[SPCache sharedCache] facebookFriends];
    self.tableView = table;
    
    if(self.friendUsers == nil){
        [self reloadFriendsForTable:table];
    }else{
        [table setFriendsListWithFriends:self.friendUsers];
        [table reloadData];
    }
}

-(void)reloadFriendsForTable:(SPInviteFriendsTable *)table{
    [FBRequestConnection startForMyFriendsWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            NSArray *friendObjects = [result objectForKey:@"data"];
            NSMutableArray *friendIds = [NSMutableArray arrayWithCapacity:friendObjects.count];
            
            for (NSDictionary *friendObject in friendObjects) {
                [friendIds addObject:[friendObject objectForKey:@"id"]];
            }
            
            PFQuery *friendQuery = [PFUser query];
            [friendQuery setCachePolicy:kPFCachePolicyCacheElseNetwork];
            [friendQuery whereKey:kSPUserFacebookId containedIn:friendIds];
            [friendQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                NSSortDescriptor *alphaDesc = [[NSSortDescriptor alloc] initWithKey:@"profile.name" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)];
                NSArray *facebookFriends = [NSArray arrayWithArray:[objects sortedArrayUsingDescriptors:[NSArray arrayWithObjects:alphaDesc, nil]]];
                self.friendUsers = [NSArray arrayWithArray:facebookFriends];
                [[SPCache sharedCache] setFacebookFriends:facebookFriends];
                [table setFriendsListWithFriends:self.friendUsers];
                [table reloadData];
            }];
        }
    }];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SPFriendsTableViewCell *cell = (SPFriendsTableViewCell *)[super tableView:tableView cellForRowAtIndexPath:indexPath];
    
    PFUser *user = [self.friendUsers objectAtIndex:indexPath.section][indexPath.row];
    
    if([self.tableView selectedFriendsContainsUser:user]){
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }

    return cell;
}

@end
