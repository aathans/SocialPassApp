//
//  SPFriendsTable.m
//  SocialPass
//
//  Created by Alexander Athan on 6/29/14.
//  Copyright (c) 2014 Dolo. All rights reserved.
//

#import "SPFriendsTable.h"
#import "SPFriendsTableViewCell.h"

@implementation SPFriendsTable

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.delegate = self;
    }
    return self;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80.0f;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SPFriendsTableViewCell *cell = (SPFriendsTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.backgroundLayerView.backgroundColor = [UIColor SPGraySelected];
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    SPFriendsTableViewCell *cell = (SPFriendsTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.backgroundLayerView.backgroundColor = [UIColor SPGray];
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    SPFriendsTableViewCell *currentCell = (SPFriendsTableViewCell *)cell;
    if([cell isSelected]){
        currentCell.backgroundLayerView.backgroundColor = [UIColor SPGraySelected];
    }else{
        currentCell.backgroundLayerView.backgroundColor = [UIColor SPGray];
    }
}


@end
