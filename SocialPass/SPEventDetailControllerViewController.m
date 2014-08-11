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

- (id)init{
    self = [super init];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)loadView{
    [super loadView];
    self.eventView = [SPEventDetailView new];
    self.returnButton = [UIButton new];
    
    [self.view addSubview:self.returnButton];
    [self.view addSubview:self.eventView];
    
    NSLog(@"EVENT ID: %@",self.eventID);
    
    [self getEvent];
    [self setupCharacteristics];
    [self setupConstraints];
}

-(void)setupCharacteristics{
    [self.eventView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self setupCancelButton];
    [self setupReturnButtonWithTitle:@"Return" andFont:[UIFont fontWithName:@"Avenir-Light" size:17.0f]];
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
    
    NSMutableArray *attendees = [self.SPEvent objectForKey:@"AttendeeList"];
    NSUInteger numAttendees = [attendees count];
    
    if(self.SPEvent != nil){
        
        if(numAttendees == 1){
            [self.SPEvent deleteEventually];
        }else{
            numAttendees -= 1;
            [attendees removeObject:[PFUser currentUser].objectId];
            [self.SPEvent setObject:attendees forKey:@"AttendeeList"];
            [self.SPEvent saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                NSLog(@"Saving");
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
    PFQuery *eventQuery = [PFQuery queryWithClassName:@"Event"];
    eventQuery.cachePolicy = kPFCachePolicyCacheThenNetwork;
    [eventQuery whereKey:@"objectId" equalTo:self.eventID];
    [eventQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(error){
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }else{
            self.events = [[NSMutableArray alloc] initWithArray:objects];
            NSLog(@"Retrieved %lu", (unsigned long)[self.events count]);
            
            _SPEvent = [self.events objectAtIndex:0];
            //_eventView.eventPhoto.image = [self getEventPhoto:self.SPEvent];
            _eventView.eventDesc.text = [self.SPEvent objectForKey:@"Description"];
            _eventView.eventOrganizer.text = [self.SPEvent objectForKey:@"organizerName"];
            _eventView.eventTime.text = [self getTimeText:self.SPEvent];
            _eventView.eventPhoto.image = [UIImage imageNamed:@"defaultEventPhoto.jpg"];
            NSArray *attendees = [self.SPEvent objectForKey:@"AttendeeList"];
            _eventView.attendees.text = [NSString stringWithFormat:@"Attendees: %lu", (unsigned long)[attendees count]];
        }
    }];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    _eventView.eventPhoto.image = [self getEventPhoto:self.SPEvent];
}

-(UIImage *)getEventPhoto:(PFObject *)SPEvent{
    PFFile *eventPhoto = [SPEvent objectForKey:@"EventPhoto"];
    NSURL *imageFileURL = [[NSURL alloc] initWithString:eventPhoto.url];
    NSData *imageData = [NSData dataWithContentsOfURL:imageFileURL];
    if([imageData length] == 0)
        return [UIImage imageNamed:@"defaultEventPhoto.jpg"];
    UIImage *eventImage;
    eventImage = [UIImage imageWithData:imageData];
    
    return eventImage;
}

-(NSString *)getTimeText:(PFObject *)SPEvent{
    NSString *timeText = [NSString new];
    NSDate *startTime = [SPEvent objectForKey:@"StartTime"];
    NSDate *endTime = [SPEvent objectForKey:@"EndTime"];
    
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    
    if([startTime isEqualToDate:endTime]){
        [dateFormatter setDateFormat:@"MMM d' at 'hh:mm a"];
        timeText = [dateFormatter stringFromDate:startTime];
    }else{
        [dateFormatter setDateFormat:@"MMM d hh:mm a"];
        
        NSDateFormatter *endDateFormatter = [NSDateFormatter new];
        [endDateFormatter setDateFormat:@"hh:mm a"];
        
        timeText = [NSString stringWithFormat:@"%@ to %@", [dateFormatter stringFromDate:startTime], [endDateFormatter stringFromDate:endTime]];
    }
    
    return timeText;
}

@end
