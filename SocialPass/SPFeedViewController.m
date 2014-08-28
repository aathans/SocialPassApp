//
//  SPMainViewController.m
//  SocialPass
//
//  Created by Alexander Athan on 6/22/14.
//  Copyright (c) 2014 Dolo. All rights reserved.
//

#import "SPFeedViewController.h"
#import "SPEventCanvas.h"
#import "SPNewEventViewController.h"

@interface SPFeedViewController ()

@property (nonatomic) SPEventCanvas *eventCanvas;
@property (nonatomic) UICollectionView *attendeePhotos;
@property (nonatomic) UILabel *header;
@property (nonatomic) UILabel *headerTitle;
@property (nonatomic) UIButton *addEventbutton;
@property (nonatomic) NSMutableArray *profiles;
@property (nonatomic) NSUInteger indexCount;

@end

@implementation SPFeedViewController

- (id)init{
    self = [super init];
    if (self) {
        self.indexCount = 0;
    }
    return self;
}

-(void)loadView{
    [super loadView];
    
    self.eventCanvas = [SPEventCanvas new];
    self.addEventbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.header = [UILabel new];
    self.headerTitle = [UILabel new];

    [self.view addSubview:self.eventCanvas];
    [self.view addSubview:self.addEventbutton];
    [self.header addSubview:self.headerTitle];
    [self.view addSubview:self.header];
    
    [self setupCharacteristics];
    [self setupButtons];
    [self setConstraints];
    
    if([PFUser currentUser]){
        [self setupEvents];
    }
}

-(void)setupEvents{
    PFQuery *eventQuery = [PFQuery queryWithClassName:kSPEventClass];
    [eventQuery whereKey:kSPEventInvitees equalTo:[PFUser currentUser]];
    [eventQuery orderByAscending:kSPEventStartTime];
    [eventQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(error){
            NSLog(@"Error: %@ %@", error, [error userInfo]);
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"No network connection" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }else{
            self.events = [[NSMutableArray alloc] initWithArray:objects];
            NSLog(@"Retrieved %lu", (unsigned long)[self.events count]);
            
            self.indexCount = 0;

            if([self areEvents]){
                PFObject *SPEvent = [self.events objectAtIndex:self.indexCount];
                [self setupEvent:SPEvent];
            }else{
                NSLog(@"Retrieved none");
                return;
            }
        }
    }];
}

-(void)setupCharacteristics{
//    UIGraphicsBeginImageContext(self.view.frame.size);
//    [[UIImage imageNamed:@"BackgroundImage.jpg"] drawInRect:self.view.bounds];
//    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    
//    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
    [self setupHeader];
}

-(void)setupHeader{
    self.header.backgroundColor = [UIColor clearColor];
    [self.header setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self.headerTitle setBackgroundColor:[UIColor clearColor]];
    [self.headerTitle setText:@"SocialPass"];
    [self.headerTitle setTextAlignment:NSTextAlignmentCenter];
    [self.headerTitle setFont:[UIFont fontWithName:kSPDefaultFont size:kSPDefaultHeaderFontSize]];
    [self.headerTitle setTranslatesAutoresizingMaskIntoConstraints:NO];
}

-(void)setupButtons{
    [self.eventCanvas.skipButton addTarget:self action:@selector(skipButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.eventCanvas.joinButton addTarget:self action:@selector(joinButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.addEventbutton addTarget:self action:@selector(addEventPushed:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.addEventbutton setImage:[UIImage imageNamed:kSPAddEventIcon] forState:UIControlStateNormal];
    [self.addEventbutton setTranslatesAutoresizingMaskIntoConstraints:NO];
}

-(void)setConstraints{
    UIView *background = self.eventCanvas;
    UIView *addEvent = self.addEventbutton;
    UIView *header = self.header;
    UIView *headerTitle = self.headerTitle;

    NSDictionary *titleView = NSDictionaryOfVariableBindings(headerTitle);
    NSDictionary *views = NSDictionaryOfVariableBindings(background, header, addEvent);
    
    NSArray *headerConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[header]|" options:0 metrics:nil views:views];
    headerConstraints = [headerConstraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[header(47)]-5-[background]-|" options:0 metrics:nil views:views]];
    
    NSArray *titleConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[headerTitle]|" options:0 metrics:nil views:titleView];
    titleConstraints = [titleConstraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-15-[headerTitle(32)]" options:0 metrics:nil views:titleView]];
    
    NSArray *backgroundConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[background]-|" options:0 metrics:nil views:views];
    
    backgroundConstraints = [backgroundConstraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[addEvent(22)]" options:0 metrics:nil views:views]];
    backgroundConstraints = [backgroundConstraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[addEvent(22)]-30-|" options:0 metrics:nil views:views]];

    [self.view addConstraints:headerConstraints];
    [self.header addConstraints:titleConstraints];
    [self.view addConstraints:backgroundConstraints];
    
}

-(void)addEventPushed:(id)sender{
    [self presentNewEventVC];
}

-(void)presentNewEventVC{
    SPNewEventViewController *newEventVC = [SPNewEventViewController new];
    newEventVC.modalPresentationStyle = UIModalPresentationCustom;
    
    [UIView transitionWithView:self.navigationController.view duration:0.8 options:UIViewAnimationOptionTransitionFlipFromRight animations:^{
        [self.navigationController pushViewController:newEventVC animated:NO];
    } completion:nil];
}

- (void)skipButtonPressed:(id)sender {
    [self moveToNextEvent];
}

-(void)moveToNextEvent{
    
    if([self areEvents]){
        
        self.indexCount++;
        
        if(self.indexCount >= [self.events count]){
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry" message:@"End of events." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertView show];
            [self setupEvents];
            self.indexCount = 0;
            if([self.events count] == 1){
                return;
            }
        }
        
        PFObject *SPEvent = [self.events objectAtIndex:self.indexCount];
        
        if(SPEvent != nil){
            [self setupEvent:SPEvent];
        }
    } else {
        [self makeEventVariablesNil];
        [self setupEvents];
    }
}

-(void)setupEvent:(PFObject *)SPEvent{
    PFFile *eventPhoto = [SPEvent objectForKey:kSPEventPhoto];
    NSURL *imageFileURL = [[NSURL alloc] initWithString:eventPhoto.url];
    NSData *imageData = [NSData dataWithContentsOfURL:imageFileURL];

    if([imageData length] == 0){
        self.eventCanvas.eventPhoto.image = [UIImage imageNamed:kSPDefaultEventPhoto];
    }
    else{
        self.eventCanvas.eventPhoto.image = [UIImage imageWithData:imageData];
    }
    
    self.eventCanvas.eventDesc.text = [SPEvent objectForKey:kSPEventDescription];
    self.eventCanvas.eventOrganizer.text = [NSString stringWithFormat:@"%@",[SPEvent objectForKey:kSPEventOrganizerName]];
    
    self.eventCanvas.attendees.text = [NSString stringWithFormat:@"Attendees: %@", [SPEvent objectForKey:@"numAttendees"]];
    
    NSDate *startTime = [SPEvent objectForKey:kSPEventStartTime];
    NSDate *endTime = [SPEvent objectForKey:kSPEventEndTime];
    
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    
    if([startTime isEqualToDate:endTime]){
        [dateFormatter setDateFormat:kSPNoEndTimeFormat];
        self.eventCanvas.eventTime.text = [dateFormatter stringFromDate:startTime];
    }else{
        [dateFormatter setDateFormat:kSPHasEndTimeFormat];
        
        NSDateFormatter *endDateFormatter = [NSDateFormatter new];
        [endDateFormatter setDateFormat:kSPTimeFormat];
        
        self.eventCanvas.eventTime.text = [NSString stringWithFormat:@"%@ to %@", [dateFormatter stringFromDate:startTime], [endDateFormatter stringFromDate:endTime]];
    }

}

-(void)joinButtonPressed:(id)sender{
    if([self areEvents] == NO){
        [self makeEventVariablesNil];
        [self setupEvents];
    } else {
        [self joinEvent];
        [self moveToNextEvent];
    }
}

-(BOOL)areEvents{
    return ([self.events count]) ? YES:NO;
}

-(void)makeEventVariablesNil{
    NSLog(@"There are currently no events");
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"No more events." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertView show];
    self.indexCount = 0;
    self.eventCanvas.eventPhoto.image = nil;
    self.eventCanvas.eventDesc.text = nil;
    self.eventCanvas.eventOrganizer.text = nil;
    self.eventCanvas.eventTime.text = nil;
    self.eventCanvas.attendees.text = nil;
}

-(void)joinEvent{
    PFObject *event = [self.events objectAtIndex:self.indexCount];
    NSInteger maxAttendees = [[event objectForKey:kSPEventMaxAttendees] intValue];
    PFRelation *attendees = [event relationForKey:kSPEventAttendees];
    PFRelation *invitees = [event relationForKey:kSPEventInvitees];
    NSInteger numAttendees = [[event objectForKey:kSPEventNumAttendees] intValue];
    
    if(event != nil){
        if(numAttendees < maxAttendees){
            [attendees addObject:[PFUser currentUser]];
            [invitees removeObject:[PFUser currentUser]];
            numAttendees++;
            [event setObject:[NSNumber numberWithInteger:numAttendees] forKey:kSPEventNumAttendees];
            [event saveEventually];
            [self.events removeObjectAtIndex:self.indexCount];
            self.indexCount--;
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Event Full" message:@"Sorry this event is full." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
}

@end
