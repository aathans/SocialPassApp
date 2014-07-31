//
//  SPFriendsTableDataSource.m
//  SocialPass
//
//  Created by Alexander Athan on 6/29/14.
//  Copyright (c) 2014 Dolo. All rights reserved.
//

#import "SPFriendsTableDataSource.h"
#import "SPFriendsTableViewCell.h"

@implementation SPFriendsTableDataSource


-(id)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 20;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *cellID1=@"CellOne";
    
    SPFriendsTableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:cellID1];
    
    if (cell == nil)
    {
        cell = [[SPFriendsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID1];
    }
    
    
    
    cell.contentText.text = @"Greg A.";
    
    
    return cell;
}

- (void)fetchFeedForTable:(UITableView *)table{
    NSLog(@"Fetching feed for friends table");

    
}


@end
