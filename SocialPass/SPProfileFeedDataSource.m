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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numberOfEvents = self.events.count;
    
    if(numberOfEvents != 0)
        tableView.backgroundView.hidden = YES;
    else
        tableView.backgroundView.hidden = NO;
    
    return self.events.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SPProfileFeedCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    PFObject *event = [self.events objectAtIndex:indexPath.row];
    
    NSString *description = [event objectForKey:kSPEventDescription];
    NSDate *startTime = [event objectForKey:kSPEventStartTime];
    NSDate *endTime = [event objectForKey:kSPEventEndTime];
    NSString *eventID = [event objectId];
    cell.eventID = eventID;
    
    NSString *text = nil;
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    
    if([startTime isEqualToDate:endTime]){
        [dateFormatter setDateFormat:@"MMM d' at 'hh:mm a"];
        text = [NSString stringWithFormat:@"%@ on %@", description, [dateFormatter stringFromDate:startTime]];
    }else{
        [dateFormatter setDateFormat:@"MMM d hh:mm a"];
        
        NSDateFormatter *endDateFormatter = [NSDateFormatter new];
        [endDateFormatter setDateFormat:@"hh:mm a"];
        
        text = [NSString stringWithFormat:@"%@ from %@ to %@", description, [dateFormatter stringFromDate:startTime], [endDateFormatter stringFromDate:endTime]];

    }
    
    [cell.contentText setText:text];
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return 1;
}

-(void)fetchFeedForTableInBackground:(UITableView *)table{
    PFQuery *eventQuery = [PFQuery queryWithClassName:kSPEventClass];
    eventQuery.cachePolicy = kPFCachePolicyCacheThenNetwork;
    [eventQuery whereKey:kSPEventAttendees equalTo:[PFUser currentUser]];
    [eventQuery orderByAscending:kSPEventStartTime];
       [eventQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
         self.events = [[NSMutableArray alloc] initWithArray:objects];
        [table reloadData];
     }];
}

@end
