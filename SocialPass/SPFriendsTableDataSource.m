//
//  SPFriendsTableDataSource.m
//  SocialPass
//
//  Created by Alexander Athan on 6/29/14.
//  Copyright (c) 2014 Dolo. All rights reserved.
//

#import "SPFriendsTable.h"
#import "SPFriendsTableDataSource.h"
#import "SPFriendsTableViewCell.h"

@interface SPFriendsTableDataSource()

@property (nonatomic) UITableView *tableView;

@end

@implementation SPFriendsTableDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.friendUsers count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.friendUsers[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier=@"Cell";
    
    SPFriendsTableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
    {
        cell = [[SPFriendsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    PFUser *user =  self.friendUsers[indexPath.section][indexPath.row];
    cell.contentText.text = [user objectForKey:kSPUserProfile][kSPUserProfileName];
    cell.username = [user objectForKey:@"username"];

    return cell;
}

- (void)fetchFeedForTable:(UITableView *)table{
    self.friendUsers = [[SPCache sharedCache] facebookFriends];
    self.tableView = table;
    
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
                NSSortDescriptor *alphaDesc = [[NSSortDescriptor alloc] initWithKey:@"profile.name" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)];
                NSArray *facebookFriends = [objects sortedArrayUsingDescriptors:[NSArray arrayWithObjects:alphaDesc, nil]];
                self.friendUsers = facebookFriends;
                [[SPCache sharedCache] setFacebookFriends:facebookFriends];
                
                [table reloadData];
            }];
        }
    }];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return self.indexList[section];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return self.indexList;
}

-(void)setFriendUsers:(NSArray *)friendUsers{
    _friendUsers = [self arrayForSections:friendUsers];
}

- (NSArray *)arrayForSections:(NSArray *)objects {
    if(objects == nil){
        return nil;
    }
    
    SEL selector = @selector(self);
    UILocalizedIndexedCollation *collation = [UILocalizedIndexedCollation currentCollation];

    NSInteger sectionTitlesCount = [[collation sectionTitles] count];
    
    NSMutableArray *mutableSections = [[NSMutableArray alloc] initWithCapacity:sectionTitlesCount];
    for (NSUInteger idx = 0; idx < sectionTitlesCount; idx++) {
        [mutableSections addObject:[NSMutableArray array]];
    }
    
    for (id object in objects) {
        NSInteger sectionNumber = [collation sectionForObject:[object objectForKey:kSPUserProfile][kSPUserProfileName] collationStringSelector:selector];
        [[mutableSections objectAtIndex:sectionNumber] addObject:object];
    }
    
//    for (unsigned int i = 1; i < 27; i++){
//        PFUser *newuser = [objects objectAtIndex:0];
//        [[mutableSections objectAtIndex:i] addObject:newuser];
//    }
//    
//    for (unsigned int i = 0; i < 10; i++){
//        PFUser *newuser = [objects objectAtIndex:0];
//        [[mutableSections objectAtIndex:0] addObject:newuser];
//    }
    
    for (NSUInteger idx = 0; idx < sectionTitlesCount; idx++) {
        NSArray *objectsForSection = [mutableSections objectAtIndex:idx];
        NSSortDescriptor *alphaDesc = [[NSSortDescriptor alloc] initWithKey:@"profile.name" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)];

        [mutableSections replaceObjectAtIndex:idx withObject:[objectsForSection sortedArrayUsingDescriptors:[NSArray arrayWithObjects:alphaDesc, nil]]];
    }
    
    NSMutableArray *existTitleSections = [NSMutableArray array];
    
    for (NSArray *section in mutableSections) {
        if ([section count] > 0) {
            [existTitleSections addObject:section];
        }
    }
    
    NSMutableArray *existTitles = [NSMutableArray array];
    NSArray *allSections = [collation sectionIndexTitles];
    
    for (NSUInteger i = 0; i < [allSections count]; i++) {
        if ([mutableSections[ i ] count] > 0) {
            [existTitles addObject:allSections[ i ]];
        }
    }
    
    self.indexList = existTitles;
    
    return existTitleSections;
}

-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    return index;
}


@end
