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
    return [self.friendUsers count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *cellID1=@"CellOne";
    
    SPFriendsTableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:cellID1];
    
    if (cell == nil)
    {
        cell = [[SPFriendsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID1];
    }
    
    PFUser *user = [self.friendUsers objectAtIndex:0];
    cell.contentText.text = [user objectForKey:kSPUserProfile][kSPUserProfileName];
    cell.username = [user objectForKey:@"username"];

    return cell;
}

- (void)fetchFeedForTable:(UITableView *)table{
    self.friendUsers = [[SPCache sharedCache] facebookFriends];
    
    if(self.friendUsers == nil){
        [self reloadFriendsForTable:table];
    }else{
        [table reloadData];
    }
}

-(void)reloadFriendsForTable:(UITableView *)table{
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
                self.friendUsers = objects;
                [[SPCache sharedCache] setFacebookFriends:self.friendUsers];
                [table reloadData];
            }];
        }
    }];
}


@end
