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

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = self;
        self.backgroundColor = [UIColor whiteColor];
        self.sectionIndexColor = [UIColor SPGraySelected];
        self.sectionIndexMinimumDisplayRowCount = 10;
        self.sectionIndexTrackingBackgroundColor = [UIColor SPLightGray];
        self.sectionIndexBackgroundColor = [UIColor clearColor];
    }
    return self;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80.0f;
}

-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
    view.tintColor = [UIColor whiteColor];
    
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    header.textLabel.font = [UIFont fontWithName:kSPDefaultFont size:kSPDefaultEventFontSize];
}

@end
