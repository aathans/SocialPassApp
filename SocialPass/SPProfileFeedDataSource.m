//
//  SPProfileFeedDataSource.m
//  SocialPass
//
//  Created by Alexander Athan on 6/26/14.
//  Copyright (c) 2014 Dolo. All rights reserved.
//

#import "SPProfileFeedDataSource.h"
#import "SPProfileFeedCellTableViewCell.h"
#import "SPEvent.h"
#import "SPCoreDataStack.h"

@interface SPProfileFeedDataSource() <NSFetchedResultsControllerDelegate>

@property (nonatomic) NSFetchedResultsController *fetchController;

@end

@implementation SPProfileFeedDataSource

-(id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numberOfEvents = self.events.count;
    NSLog(@"%ld", (long)numberOfEvents);
    
    if(numberOfEvents != 0){
        tableView.backgroundView.hidden = YES;
    }else{
        tableView.backgroundView.hidden = NO;
    }
    
    return self.events.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SPProfileFeedCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    PFObject *event = [self.events objectAtIndex:indexPath.row];
    
    NSString *description = [event objectForKey:@"Description"];
    NSString *startTime = [event objectForKey:@"StartTime"];
    NSString *endTime = nil;
    NSString *eventID = [event objectId];
    cell.eventID = eventID;
    
    if(![[event objectForKey:@"EndTime"] isEqual:[NSNull null]]){
        endTime = [event objectForKey:@"EndTime"];
    }
    
    NSLog(@"%@", description);
    
    NSString *text = nil;
    
    if(endTime != nil && ![endTime isEqualToString:startTime]){
        text = [NSString stringWithFormat:@"%@ from %@ to %@", description, startTime, endTime];
    }else{
        text = [NSString stringWithFormat:@"%@ at %@", description, startTime];
    }
    
    [cell.contentText setText:text];
    //[cell.textLabel setFont:[UIFont fontWithName:@"Avenir-Light" size:16.0f]];
    NSLog(@"returning cell: %@", text);
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return 1;
}

-(void)fetchFeedForTableInBackground:(UITableView *)table{
    PFQuery *eventQuery = [PFQuery queryWithClassName:@"Event"];
    eventQuery.cachePolicy = kPFCachePolicyCacheThenNetwork;
    [eventQuery whereKey:@"AttendeeList" equalTo:[PFUser currentUser].objectId];
    [eventQuery orderByAscending:@"StartTime"];
       [eventQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
         self.events = [[NSMutableArray alloc] initWithArray:objects];
        [table reloadData];
     }];
}

@end
