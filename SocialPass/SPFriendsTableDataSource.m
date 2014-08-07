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
    cell.contentText.text = [user objectForKey:@"profile"][@"name"];
    
    return cell;
}

- (void)fetchFeedForTable:(UITableView *)table{
    NSLog(@"Fetching feed for friends table");
    // Issue a Facebook Graph API request to get your user's friend list
    [FBRequestConnection startForMyFriendsWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            // result will contain an array with your user's friends in the "data" key
            NSArray *friendObjects = [result objectForKey:@"data"];
            NSMutableArray *friendIds = [NSMutableArray arrayWithCapacity:friendObjects.count];
            // Create a list of friends' Facebook IDs
            for (NSDictionary *friendObject in friendObjects) {
                [friendIds addObject:[friendObject objectForKey:@"id"]];
            }

            // Construct a PFUser query that will find friends whose facebook ids
            // are contained in the current user's friend list.
            PFQuery *friendQuery = [PFUser query];
            [friendQuery whereKey:@"facebookId" containedIn:friendIds];
            
            // findObjects will return a list of PFUsers that are friends
            // with the current user
            self.friendUsers = [friendQuery findObjects];
            
            [table reloadData];
        }
    }];
}


@end
