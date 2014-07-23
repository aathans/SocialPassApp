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
@property (nonatomic) UIButton *addEventbutton;

@property (nonatomic) NSMutableArray *profiles;
@property (nonatomic) NSUInteger indexCount;
@property (nonatomic) BOOL didCreateNewEvent;

@property (nonatomic, strong) SPTransitionManager *transitionManager;

@end

@implementation SPMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.indexCount = 0;
        self.didCreateNewEvent = NO;
    }
    return self;
}

-(void)loadView{
    [super loadView];
    
    self.eventCanvas = [SPEventCanvas new];
    self.addEventbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.header = [UILabel new];

    [self.view addSubview:self.eventCanvas];
    [self.view addSubview:self.addEventbutton];
    [self.view addSubview:self.header];
    
    self.transitionManager = [SPTransitionManager new];
    
    [self setCharacteristics];
    [self setConstraints];
    if([PFUser currentUser]){
        [self setupEvents];
    }
    
    
    
}



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if(self.didCreateNewEvent){
        [self setupEvents];
        self.didCreateNewEvent = NO;
    }
    
}

-(void)setupEvents{
    
    //******** CORE DATE*******
    /*
    SPCoreDataStack *dataStack = [SPCoreDataStack defaultStack];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"SPEvent"];
    NSError *error;
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isAttending != YES"];
    [request setPredicate:predicate];
    
    self.profiles = [[NSMutableArray alloc] initWithArray:[dataStack.managedObjectContext executeFetchRequest:request error:&error]];
    
    if ([self.profiles count] == 0){
        return;
    }
    
    SPEvent *event = [self.profiles objectAtIndex:self.indexCount];
    if(event != nil){
        self.eventCanvas.eventPhoto.image = [UIImage imageWithData:event.eventPhoto];
        self.eventCanvas.eventDesc.text = event.eventDesc;
        self.eventCanvas.eventOrganizer.text = [NSString stringWithFormat:@"%@", event.organizerID];
        self.eventCanvas.attendees.text = [NSString stringWithFormat:@"Attendees: %@", event.numAttendees];
        
        if((event.endTime.length != 0) && !([event.startTime isEqualToString:event.endTime])){
            NSLog(@"End Time found");
            self.eventCanvas.eventTime.text = [NSString stringWithFormat:@"Today from %@ to %@", event.startTime, event.endTime];
        }else{
            NSLog(@"Start time only");
            self.eventCanvas.eventTime.text = [NSString stringWithFormat:@"Today at %@", event.startTime];
        }
    }
    */
    //******************************
    
    //****************PARSE**************
    PFQuery *eventQuery = [PFQuery queryWithClassName:@"Event"];
    [eventQuery whereKey:@"AttendeeList" notEqualTo:[PFUser currentUser].objectId];
    [eventQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(error){
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }else{
            self.events = [[NSMutableArray alloc] initWithArray:objects];
            NSLog(@"Retrieved %lu", (unsigned long)[self.events count]);
            
            if([self.events count] == 0){
                NSLog(@"Retrieved none");
                return;
            }
            
            PFObject *SPEvent = [self.events objectAtIndex:self.indexCount];
            if(SPEvent != nil){
                PFFile *eventPhoto = [SPEvent objectForKey:@"EventPhoto"];
                NSURL *imageFileURL = [[NSURL alloc] initWithString:eventPhoto.url];
                NSData *imageData = [NSData dataWithContentsOfURL:imageFileURL];
                self.eventCanvas.eventPhoto.image = [UIImage imageWithData:imageData];
                
                self.eventCanvas.eventDesc.text = [SPEvent objectForKey:@"Description"];
                self.eventCanvas.eventOrganizer.text = [NSString stringWithFormat:@"%@",[SPEvent objectForKey:@"organizerName"]];
                self.eventCanvas.attendees.text = [NSString stringWithFormat:@"Attendees: %@", [SPEvent objectForKey:@"NumAttendees"]];
                
                NSDate *startTime = [SPEvent objectForKey:@"StartTime"];
                NSDate *endTime = nil;
                if(![[SPEvent objectForKey:@"EndTime"] isEqual:[NSNull null]]){
                    endTime = [SPEvent objectForKey:@"EndTime"];
                }
                NSDateFormatter *dateFormatter = [NSDateFormatter new];
                [dateFormatter setDateFormat:@"hh:mm a"];
                if((endTime != nil) && !([startTime isEqualToDate:endTime])){
                    NSLog(@"End Time found");
                    self.eventCanvas.eventTime.text = [NSString stringWithFormat:@"Today from %@ to %@", [dateFormatter stringFromDate:startTime], [dateFormatter stringFromDate:endTime]];
                }else{
                    NSLog(@"Start time only");
                    self.eventCanvas.eventTime.text = [NSString stringWithFormat:@"Today at %@",[dateFormatter stringFromDate:startTime]];
                }
                
            }
        }
    }];
    
    //***********************************
}

-(void)setCharacteristics{
    
    //Skip Button
    [self.eventCanvas.skipButton addTarget:self action:@selector(skipButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    //Join Button
    [self.eventCanvas.joinButton addTarget:self action:@selector(joinButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    //Add Event Button (Upper Right)
    [self.addEventbutton setImage:[UIImage imageNamed:@"icon_eventPlus"] forState:UIControlStateNormal];
    [self.addEventbutton addTarget:self action:@selector(addEventPushed:) forControlEvents:UIControlEventTouchUpInside];
    [self.addEventbutton setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    //Header
    self.header.backgroundColor = [UIColor clearColor];
    [self.header setFont:[UIFont fontWithName:@"Avenir-Light" size:18]];
    [self.header setText:@"SocialPass"];
    [self.header setTextAlignment:NSTextAlignmentCenter];
    [self.header setTranslatesAutoresizingMaskIntoConstraints:NO];
}

-(void)setConstraints{
    UIView *background = self.eventCanvas;
    UIView *addEvent = self.addEventbutton;
    UIView *header = self.header;

    NSDictionary *headerView = NSDictionaryOfVariableBindings(header);
    
    NSDictionary *views = NSDictionaryOfVariableBindings(background, addEvent);
    
    //Header constraints
    
    NSArray *headerConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[header]-|" options:0 metrics:nil views:headerView];
    headerConstraints = [headerConstraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[header(22)]" options:0 metrics:nil views:headerView]];
    
    //Background constraints
    NSArray *backgroundConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[background]-|" options:0 metrics:nil views:views];
    
    backgroundConstraints = [backgroundConstraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[addEvent(22)]-5-[background]-|" options:0 metrics:nil views:views]];
    backgroundConstraints = [backgroundConstraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[addEvent(22)]-30-|" options:0 metrics:nil views:views]];

    [self.view addConstraints:headerConstraints];
    [self.view addConstraints:backgroundConstraints];
    
}

//Presents the new event view controller, user can create an event from here
-(void)addEventPushed:(id)sender{
    
    self.didCreateNewEvent = YES;
    
    SPNewEventViewController *newEventVC = [SPNewEventViewController new];
    newEventVC.modalPresentationStyle = UIModalPresentationCustom;
    newEventVC.transitioningDelegate = self;
    
    [self presentViewController:newEventVC animated:YES completion:^{
        
    }];
}



//Skip to the next event, if there is no more alert them and return to the beginning
- (void)skipButtonPressed:(id)sender {

    [self skipEvent];
}

-(void)skipEvent{
    
    if([self.events count] == 0){
        NSLog(@"There are currently no events");
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"No more events." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
        self.eventCanvas.eventPhoto.image = nil;
        self.eventCanvas.eventDesc.text = nil;
        self.eventCanvas.eventOrganizer.text = nil;
        self.eventCanvas.eventTime.text = nil;
        self.eventCanvas.attendees.text = nil;
        
        return;
    }
    
    self.indexCount++;
    
    if(self.indexCount >= [self.events count]){
        NSLog(@"Reached end of events");
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"No more events." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
        self.indexCount = 0;
        if([self.events count] == 1){
            return;
        }
    }

    
    //************ CORE DATA *******
    /*
    
    SPEvent *event = [self.profiles objectAtIndex:self.indexCount];
    
    if(event != nil){
        if (event.eventPhoto != nil){
            self.eventCanvas.eventPhoto.image = [UIImage imageWithData:event.eventPhoto];
        }else{
            self.eventCanvas.eventPhoto.backgroundColor = [UIColor whiteColor];
        }
        
        self.eventCanvas.eventDesc.text = event.eventDesc;
        self.eventCanvas.eventOrganizer.text = [NSString stringWithFormat:@"%@", event.organizerID];
        
        if((event.endTime.length != 0) && !([event.startTime isEqualToString:event.endTime])){
            self.eventCanvas.eventTime.text = [NSString stringWithFormat:@"Today from %@ to %@", event.startTime, event.endTime];
        }else{
            self.eventCanvas.eventTime.text = [NSString stringWithFormat:@"Today at %@", event.startTime];
        }
    } else {
        NSLog(@"Error skipping event");
    }
    */
    
    //***********************************
    
    //****************PARSE**************

    PFObject *SPEvent = [self.events objectAtIndex:self.indexCount];
    
    if(SPEvent != nil){
        
        // *** Retreive event photo ***
        PFFile *eventPhoto = [SPEvent objectForKey:@"EventPhoto"];
        NSURL *imageFileURL = [[NSURL alloc] initWithString:eventPhoto.url];
        NSData *imageData = [NSData dataWithContentsOfURL:imageFileURL];
        self.eventCanvas.eventPhoto.image = [UIImage imageWithData:imageData];
        // *** *** *** *** *** *** ***
        
        
        //Description
        self.eventCanvas.eventDesc.text = [SPEvent objectForKey:@"Description"];
        //Organizer Name
        self.eventCanvas.eventOrganizer.text = [NSString stringWithFormat:@"%@",[SPEvent objectForKey:@"organizerName"]];
        
        //Number of attendees (Eventually mutual friends)
        self.eventCanvas.attendees.text = [NSString stringWithFormat:@"Attendees: %@", [SPEvent objectForKey:@"NumAttendees"]];
        
        // *** Times ***
        NSDate *startTime = [SPEvent objectForKey:@"StartTime"];
        NSDate *endTime = nil;
        if(![[SPEvent objectForKey:@"EndTime"] isEqual:[NSNull null]]){
            endTime = [SPEvent objectForKey:@"EndTime"];
        }
        NSDateFormatter *dateFormatter = [NSDateFormatter new];
        [dateFormatter setDateFormat:@"hh:mm a"];
        if((endTime != nil) && !([startTime isEqualToDate:endTime])){
            NSLog(@"End Time found");
            self.eventCanvas.eventTime.text = [NSString stringWithFormat:@"Today from %@ to %@", [dateFormatter stringFromDate:startTime], [dateFormatter stringFromDate:endTime]];
        }else{
            NSLog(@"Start time only");
            self.eventCanvas.eventTime.text = [NSString stringWithFormat:@"Today at %@",[dateFormatter stringFromDate:startTime]];
        }
        // *** *** *** *** *** *** ***
        
    }
}

-(void)joinButtonPressed:(id)sender{
    
    if([self.events count] == 0){
        NSLog(@"There are currently no events");
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"No more events." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
        self.eventCanvas.eventPhoto.image = nil;
        self.eventCanvas.eventDesc.text = nil;
        self.eventCanvas.eventOrganizer.text = nil;
        self.eventCanvas.eventTime.text = nil;
        self.eventCanvas.attendees.text = nil;
        
        return;
    }
    
    //SPCoreDataStack *dataStack = [SPCoreDataStack defaultStack];
    
    //SPEvent *event = [self.profiles objectAtIndex:self.indexCount];
    
    PFObject *event = [self.events objectAtIndex:self.indexCount];
    NSNumber *numAttendees = [event objectForKey:@"NumAttendees"];
    NSNumber *maxAttendees = [event objectForKey:@"MaxAttendees"];
    NSMutableArray *attendees = [event objectForKey:@"AttendeeList"];
    
    //NSUInteger joinedIndex = self.indexCount;
    
    if(event != nil){
        NSLog(@"Num Attendees: %@ Max Attendees: %@", numAttendees, maxAttendees);
        
        if(numAttendees.intValue < maxAttendees.intValue){
            numAttendees = @(numAttendees.intValue + 1);
            [attendees addObject:[PFUser currentUser].objectId];
            [event setObject:numAttendees forKey:@"NumAttendees"];
            [event setObject:attendees forKey:@"AttendeeList"];
            [event saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                NSLog(@"Saving");
            }];
            [self.events removeObjectAtIndex:self.indexCount];
            self.indexCount--;
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Event Full" message:@"Sorry this event is full." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
    

    [self skipEvent];
    
    //[dataStack saveContext];
    
}

#pragma mark - UIViewControllerTransitioningDelegate

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                   presentingController:(UIViewController *)presenting
                                                                       sourceController:(UIViewController *)source{
    NSLog(@"Transitioning to create an event");
    self.transitionManager.transitionTo = MODAL; //Going from main to create event
    return self.transitionManager;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    NSLog(@"Transitioning back to main page");
    self.transitionManager.transitionTo = INITIAL; //Going from creating event back to main
    return self.transitionManager;
}

@end
