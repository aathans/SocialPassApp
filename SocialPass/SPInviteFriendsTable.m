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

@property (nonatomic) UIColor *disclosureColor;
@property (nonatomic) NSArray *friendsList;

@end

@implementation SPInviteFriendsTable

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = self;
        _disclosureColor = [UIColor blackColor];
        self.selectedFriends = [NSMutableArray new];
    }
    return self;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80.0f;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    SPFriendsTableViewCell *cell = (SPFriendsTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    PFUser *user = [_friendsList objectAtIndex:indexPath.row];
    
    UIView* checkmark = [MSCellAccessory accessoryWithType:FLAT_CHECKMARK color:_disclosureColor];
    checkmark.frame = CGRectMake(cell.frame.size.width-70, 0, 70, 50);
    checkmark.tag = 42;

    if([_selectedFriends containsObject:user]){
        [[cell.contentView viewWithTag:42] removeFromSuperview];
        [self.selectedFriends removeObject:user];
    }else{
        [self.selectedFriends addObject:user];
        [cell.contentView addSubview:checkmark];
    }
}

-(void)setFriendsListWithFriends:(NSArray *)friends{
    _friendsList = friends;
}


@end
