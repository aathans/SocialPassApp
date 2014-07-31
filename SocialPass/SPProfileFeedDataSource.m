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
    NSLog(@"%lu", (unsigned long)self.events.count);
    return self.events.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SPProfileFeedCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    PFObject *event = [self.events objectAtIndex:indexPath.row];
    
    NSString *description = [event objectForKey:@"Description"];
    NSDate *startTime = [event objectForKey:@"StartTime"];
    NSDate *endTime = nil;
    NSString *eventID = [event objectId];
    cell.eventID = eventID;
    
    NSLog(@"EVENT GOT: %@", cell.eventID);
    
    if(![[event objectForKey:@"EndTime"] isEqual:[NSNull null]]){
        endTime = [event objectForKey:@"EndTime"];
    }
    
    NSLog(@"%@", description);
    
    NSString *text = nil;
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"hh:mm a"];
    
    if(endTime != nil){
        text = [NSString stringWithFormat:@"%@ from %@ to %@", description, [dateFormatter stringFromDate:startTime], [dateFormatter stringFromDate:endTime]];
    }else{
        text = [NSString stringWithFormat:@"%@ at %@", description, [dateFormatter stringFromDate:startTime]];
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
