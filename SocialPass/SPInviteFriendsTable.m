//
//  SPInviteFriendsTable.m
//  SocialPass
//
//  Created by Alexander Athan on 8/15/14.
//  Copyright (c) 2014 Dolo. All rights reserved.
//

#import "SPInviteFriendsTable.h"
#import "SPFriendsTableViewCell.h"
#import "MSCellAccessory.h"

@interface SPInviteFriendsTable()

@property (nonatomic) NSArray *friendsList;

@end

@implementation SPInviteFriendsTable

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.selectedFriends = [NSMutableArray new];
    }
    return self;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    SPFriendsTableViewCell *cell = (SPFriendsTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    PFUser *user = [_friendsList objectAtIndex:indexPath.section][indexPath.row];
    
    if([self selectedFriendsContainsUser:user]){
        cell.accessoryType = UITableViewCellAccessoryNone;
        [self.selectedFriends removeObject:user];
    }else{
        [self.selectedFriends addObject:user];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
}

-(BOOL)selectedFriendsContainsUser:(PFUser *)user{
    return [_selectedFriends containsObject:user];
}

-(void)setFriendsListWithFriends:(NSArray *)friends{
    _friendsList = friends;
}


@end
