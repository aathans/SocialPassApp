//
//  SPInviteFriends.m
//  SocialPass
//
//  Created by Alexander Athan on 8/13/14.
//  Copyright (c) 2014 Dolo. All rights reserved.
//

#import "SPInviteFriends.h"
//#import "MSCellAccessory/MSCellAccessory.h"

@interface SPInviteFriends()

@property (nonatomic) PFUser *currentUser;
@property(nonatomic, strong) NSArray *allUsers;
@property(nonatomic, strong) NSMutableArray *friends;

@end

@implementation SPInviteFriends

-(id)init{
    self = [super init];
    
    if(self){
        
    }
    
    return self;
}

-(void)loadView{
    [super loadView];
    
}

//
//  EditFriendsTableViewController.m
//  Ribbit
//
//  Created by Alexander Athan on 5/24/14.
//  Copyright (c) 2014 Alex. All rights reserved.
//


UIColor *disclosureColor;

- (void)viewDidLoad
{
    [super viewDidLoad];
    PFQuery *query = [PFUser query];
    [query orderByAscending:@"username"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(error){
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }else{
            self.allUsers = objects;
            [self.tableView reloadData];
        }
    }];
    self.currentUser = [PFUser currentUser];
    
    disclosureColor = [UIColor colorWithRed:0.553 green:0.439 blue:0.718 alpha:1.0];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.allUsers count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    PFUser *user = [self.allUsers objectAtIndex:indexPath.row];
    cell.textLabel.text = user.username;
    // Configure the cell...
    
    
    if([self isFriend:user]){
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        //cell.accessoryView = [MSCellAccessory accessoryWithType:FLAT_CHECKMARK color:disclosureColor];
        
    }else{
        cell.accessoryView = nil;
    }
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    PFUser *user = [self.allUsers objectAtIndex:indexPath.row];
    
    PFRelation *friendsRelation = [self.currentUser relationForKey:@"friendsRelation"];
    
    
    if([self isFriend:user]){
        //Remove them
        //1. Remove checkmark
        cell.accessoryView = nil;
        
        //2. Remove from array of friends
        for(PFUser *friend in self.friends){
            if([friend.objectId isEqualToString:user.objectId]){
                [self.friends removeObject:friend];
                break;
            }
        }
        
        //3. Remove from backend
        [friendsRelation removeObject:user];
        
        
    }else{
        //cell.accessoryView = [MSCellAccessory accessoryWithType:FLAT_CHECKMARK color:disclosureColor];
        
        [self.friends addObject:user];
        [friendsRelation addObject:user];
        
    }
    
    [self.currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if(error){
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

#pragma mark - Helper methods
-(BOOL)isFriend:(PFUser *)user{
    for(PFUser *friend in self.friends){
        if([friend.objectId isEqualToString:user.objectId]){
            return YES;
        }
    }
    return NO;
}

@end
