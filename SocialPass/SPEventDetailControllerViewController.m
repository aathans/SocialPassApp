//
//  SPEventDetailControllerViewController.m
//  SocialPass
//
//  Created by Alexander Athan on 6/23/14.
//  Copyright (c) 2014 Dolo. All rights reserved.
//

#import "SPEventDetailControllerViewController.h"
#import "SPEventDetailView.h"
#import "SPProfileViewController.h"
#import "SPHomeViewController.h"

@interface SPEventDetailControllerViewController () <UINavigationControllerDelegate>

@property (nonatomic) SPEventDetailView *eventView;
@property (nonatomic) NSArray *events;
@property (nonatomic) UIButton *returnButton;
@property (nonatomic) PFObject *SPEvent;

@end

@implementation SPEventDetailControllerViewController

-(void)loadView{
    [super loadView];
    self.eventView = [SPEventDetailView new];
    self.returnButton = [UIButton new];
    
    [self.view addSubview:self.returnButton];
    [self.view addSubview:self.eventView];
        
    [self getEvent];
    [self setupCharacteristics];
    [self setupConstraints];
}

-(void)setupCharacteristics{
    [self.eventView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self setupCancelButton];
    [self setupReturnButtonWithTitle:@"Return" andFont:[UIFont fontWithName:kSPDefaultFont size:kSPDefaultNavButtonFontSize]];
}

-(void)setupReturnButtonWithTitle:(NSString *)title andFont:(UIFont *)font{
    [self.returnButton setTitle:title forState:UIControlStateNormal];
    [self.returnButton.titleLabel setFont:font];
    [self.returnButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.returnButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.returnButton addTarget:self action:@selector(returnButton:) forControlEvents:UIControlEventTouchUpInside];
    self.returnButton.titleLabel.textAlignment = NSTextAlignmentCenter;
}

-(void)returnButton:(id)sender{
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

-(void)setupCancelButton{
    [self.eventView.cancelButton addTarget:self action:@selector(cancelButton:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)cancelButton:(id)sender{
    
    PFRelation *attendees = [self.SPEvent relationForKey:kSPEventAttendees];
    NSInteger numAttendees = [[self.SPEvent objectForKey:kSPEventNumAttendees] intValue];

    if(self.SPEvent != nil){
        
        if(numAttendees == 1){
            [self.SPEvent deleteEventually];
        }else{
            numAttendees -= 1;
            [self.SPEvent setObject:[NSNumber numberWithInteger:numAttendees] forKey:kSPEventNumAttendees];
            [attendees removeObject:[PFUser currentUser]];
            [self.SPEvent saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            }];
        }
    }
    SPHomeViewController *presenter = (SPHomeViewController *)self.presentingViewController;
    SPProfileViewController *profileVC = (SPProfileViewController *)presenter.viewControllers[0];
    profileVC.didCancelEvent = YES;
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

-(void)setupConstraints{
    UIView *eventView = self.eventView;
    UIButton *returnButton = self.returnButton;
    
    NSDictionary *views = NSDictionaryOfVariableBindings(eventView, returnButton);
    
    NSArray *eventConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[eventView]-|" options:0 metrics:nil views:views];
    eventConstraints = [eventConstraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[returnButton]-20-|" options:0 metrics:nil views:views]];
    eventConstraints = [eventConstraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[returnButton(22)]-5-[eventView]-|" options:0 metrics:nil views:views]];
    
    [self.view addConstraints:eventConstraints];
}

-(void)getEvent{
    PFQuery *eventQuery = [PFQuery queryWithClassName:kSPEventClass];
    eventQuery.cachePolicy = kPFCachePolicyCacheThenNetwork;
    [eventQuery whereKey:@"objectId" equalTo:self.eventID];
    [eventQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(error){
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }else{
            self.events = [[NSMutableArray alloc] initWithArray:objects];
            NSLog(@"Retrieved %lu", (unsigned long)[self.events count]);
            
            _SPEvent = [self.events objectAtIndex:0];
            _eventView.eventDesc.text = [self.SPEvent objectForKey:kSPEventDescription];
            _eventView.eventOrganizer.text = [self.SPEvent objectForKey:kSPEventOrganizerName];
            _eventView.eventTime.text = [self getTimeText:self.SPEvent];
            [self getEventPhotoForEvent:self.SPEvent];
            _eventView.attendees.text = [NSString stringWithFormat:@"Attendees: %@", [self.SPEvent objectForKey:kSPEventNumAttendees]];
        }
    }];
}

-(void)getEventPhotoForEvent:(PFObject *)SPEvent{
    PFFile *eventPhoto = [SPEvent objectForKey:kSPEventPhoto];
    [eventPhoto getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        NSData *imageData = [NSData dataWithData:data];
        if([imageData length] == 0){
            _eventView.eventPhoto.image = [UIImage imageNamed:kSPDefaultEventPhoto];
        }else{
            _eventView.eventPhoto.image = [UIImage imageWithData:imageData];
        }
    }];
}

-(NSString *)getTimeText:(PFObject *)SPEvent{
    NSString *timeText = [NSString new];
    NSDate *startTime = [SPEvent objectForKey:kSPEventStartTime];
    NSDate *endTime = [SPEvent objectForKey:kSPEventEndTime];
    
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    
    if([startTime isEqualToDate:endTime]){
        [dateFormatter setDateFormat:kSPNoEndTimeFormat];
        timeText = [dateFormatter stringFromDate:startTime];
    }else{
        [dateFormatter setDateFormat:kSPHasEndTimeFormat];
        
        NSDateFormatter *endDateFormatter = [NSDateFormatter new];
        [endDateFormatter setDateFormat:kSPTimeFormat];
        
        timeText = [NSString stringWithFormat:@"%@ to %@", [dateFormatter stringFromDate:startTime], [endDateFormatter stringFromDate:endTime]];
    }
    
    return timeText;
}

@end
