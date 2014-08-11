//
//  SPMainViewController.m
//  SocialPass
//
//  Created by Alexander Athan on 6/22/14.
//  Copyright (c) 2014 Dolo. All rights reserved.
//

#import "SPMainViewController.h"
#import "SPEventCanvas.h"
#import "SPCoreDataStack.h"
#import "SPEvent.h"
#import "SPTransitionManager.h"
#import "SPNewEventViewController.h"
#import <Parse/Parse.h>
#import "SPLoginViewController.h"

@interface SPMainViewController ()

@property (nonatomic) SPEventCanvas *eventCanvas;
@property (nonatomic) UICollectionView *attendeePhotos;
@property (nonatomic) UILabel *header;
@property (nonatomic) UILabel *headerTitle;
@property (nonatomic) UIButton *addEventbutton;
@property (nonatomic) NSMutableArray *profiles;
@property (nonatomic) NSUInteger indexCount;
@property (nonatomic, strong) SPTransitionManager *transitionManager;

@end

@implementation SPMainViewController

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
    
    self.transitionManager = [SPTransitionManager new];
    
    [self setupCharacteristics];
    [self setupButtons];
    [self setConstraints];
    
    if([PFUser currentUser]){
        [self setupEvents];
    }
}

-(void)setupEvents{
    PFQuery *eventQuery = [PFQuery queryWithClassName:@"Event"];
    [eventQuery whereKey:@"AttendeeList" notEqualTo:[PFUser currentUser].objectId];
    [eventQuery orderByAscending:@"StartTime"];
    [eventQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(error){
            NSLog(@"Error: %@ %@", error, [error userInfo]);
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
    [self.headerTitle setFont:[UIFont fontWithName:@"Avenir-Light" size:18]];
    [self.headerTitle setTranslatesAutoresizingMaskIntoConstraints:NO];
}

-(void)setupButtons{
    [self.eventCanvas.skipButton addTarget:self action:@selector(skipButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.eventCanvas.joinButton addTarget:self action:@selector(joinButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.addEventbutton addTarget:self action:@selector(addEventPushed:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.addEventbutton setImage:[UIImage imageNamed:@"icon_eventPlus"] forState:UIControlStateNormal];
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
    newEventVC.transitioningDelegate = self;
    
    [self presentViewController:newEventVC animated:YES completion:^{
        
    }];
}

- (void)skipButtonPressed:(id)sender {
    [self moveToNextEvent];
}

-(void)moveToNextEvent{
    
    if([self areEvents]){
        
        self.indexCount++;
        
        if(self.indexCount >= [self.events count]){
            NSLog(@"Reached end of events");
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"!!!" message:@"End of events." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
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
    PFFile *eventPhoto = [SPEvent objectForKey:@"EventPhoto"];
    NSURL *imageFileURL = [[NSURL alloc] initWithString:eventPhoto.url];
    NSData *imageData = [NSData dataWithContentsOfURL:imageFileURL];

    if([imageData length] == 0){
        NSLog(@"HERE");
        self.eventCanvas.eventPhoto.image = [UIImage imageNamed:@"defaultEventPhoto.jpg"];
    }
    else{
        self.eventCanvas.eventPhoto.image = [UIImage imageWithData:imageData];
    }
    
    self.eventCanvas.eventDesc.text = [SPEvent objectForKey:@"Description"];
    self.eventCanvas.eventOrganizer.text = [NSString stringWithFormat:@"%@",[SPEvent objectForKey:@"organizerName"]];
    
    NSArray *attendees = [SPEvent objectForKey:@"AttendeeList"];
    self.eventCanvas.attendees.text = [NSString stringWithFormat:@"Attendees: %lu", (unsigned long)[attendees count]];
    
    NSDate *startTime = [SPEvent objectForKey:@"StartTime"];
    NSDate *endTime = [SPEvent objectForKey:@"EndTime"];
    
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    
    if([startTime isEqualToDate:endTime]){
        [dateFormatter setDateFormat:@"MMM d' at 'hh:mm a"];
        self.eventCanvas.eventTime.text = [dateFormatter stringFromDate:startTime];
    }else{
        [dateFormatter setDateFormat:@"MMM d hh:mm a"];
        
        NSDateFormatter *endDateFormatter = [NSDateFormatter new];
        [endDateFormatter setDateFormat:@"hh:mm a"];
        
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
    NSNumber *maxAttendees = [event objectForKey:@"MaxAttendees"];
    NSMutableArray *attendees = [event objectForKey:@"AttendeeList"];
    NSNumber *numAttendees = [NSNumber numberWithLong:[attendees count]];
    
    if(event != nil){
        if(numAttendees.intValue < maxAttendees.intValue){
            [attendees addObject:[PFUser currentUser].objectId];
            [event setObject:attendees forKey:@"AttendeeList"];
            [event save];
            [self.events removeObjectAtIndex:self.indexCount];
            self.indexCount--;
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Event Full" message:@"Sorry this event is full." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
}

#pragma mark - UIViewControllerTransitioningDelegate

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                   presentingController:(UIViewController *)presenting
                                                                       sourceController:(UIViewController *)source{
    NSLog(@"Transitioning to create an event");
    self.transitionManager.transitionTo = MODAL; //Going from main to create event
    return self.transitionManager;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    NSLog(@"Transitioning back to main page");
    self.transitionManager.transitionTo = INITIAL; //Going from creating event back to main
    return self.transitionManager;
}

@end
