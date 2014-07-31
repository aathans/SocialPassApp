//
//  SPEventDetailControllerViewController.m
//  SocialPass
//
//  Created by Alexander Athan on 6/23/14.
//  Copyright (c) 2014 Dolo. All rights reserved.
//

#import "SPEventDetailControllerViewController.h"
#import "SPEventDetailView.h"

@interface SPEventDetailControllerViewController () <UINavigationControllerDelegate>

@property (nonatomic) SPEventDetailView *eventView;
@property (nonatomic) NSArray *events;
@property (nonatomic) UIButton *returnButton;

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

-(void)setupConstraints{
    UIView *eventView = _eventView;
    UIButton *returnButton = _returnButton;
    
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
            
            PFObject *SPEvent = [self.events objectAtIndex:0];
            self.eventView.eventName.text = [SPEvent objectForKey:@"Description"];
            self.eventView.eventOrganizer.text = [SPEvent objectForKey:@"organizerName"];
            NSArray *attendees = [SPEvent objectForKey:@"AttendeeList"];
            self.eventView.eventAttendees.text = [NSString stringWithFormat:@"Attendees: %lu", (unsigned long)[attendees count]];
        }
    }];
}

@end
