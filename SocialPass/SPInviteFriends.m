//
//  SPInviteFriends.m
//  SocialPass
//
//  Created by Alexander Athan on 8/13/14.
//  Copyright (c) 2014 Dolo. All rights reserved.
//

#import "SPInviteFriends.h"
#import "SPFriendsTableViewCell.h"
#import "SPInviteFriendsTable.h"
#import "SPInviteFriendsDataSource.h"

@interface SPInviteFriends()

@property (nonatomic) SPInviteFriendsTable *friends;
@property (nonatomic) SPInviteFriendsDataSource *friendsData;
@property (nonatomic) SPNewEvent *myEvent;

@property (nonatomic) UILabel *header;
@property (nonatomic) UILabel *headerTitle;
@property (nonatomic) UIButton *done;
@property (nonatomic) UIButton *back;

@end

@implementation SPInviteFriends

-(id)initWithEvent:(SPNewEvent *)myEvent{
    self = [super init];
    
    if(self){
        self.myEvent = myEvent;
        self.view.backgroundColor = [UIColor whiteColor];
    }
    
    return self;
}

- (void)loadView
{
    [super loadView];
    
    self.friends = [SPInviteFriendsTable new];
    [self.friends registerClass:[SPFriendsTableViewCell class] forCellReuseIdentifier:@"Cell"];
    self.friendsData = [SPInviteFriendsDataSource new];
    self.friends.dataSource = self.friendsData;
    
    self.done = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.done addTarget:self action:@selector(doneButton:) forControlEvents:UIControlEventTouchUpInside];
    
    self.back = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.back addTarget:self action:@selector(backButton:) forControlEvents:UIControlEventTouchUpInside];

    self.header = [UILabel new];
    self.headerTitle = [UILabel new];
    [self.header addSubview:self.headerTitle];
    [self.view addSubview:self.header];
    [self.view addSubview:self.friends];
    [self.view addSubview:self.done];
    [self.view addSubview:self.back];
    
    [self setupCharacteristics];
    [self setupConstraints];
    [self.friendsData fetchFeedForTable:self.friends];
}

-(void)doneButton:(id)sender{
    self.myEvent.eventAttendees = self.friends.selectedFriends;
    [self.myEvent saveEvent];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)backButton:(id)sender{
    //[[SPCache sharedCache] setInvitedFriends:self.friends.selectedFriends];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)setupCharacteristics{
    [self setupHeader];
    [self setupButton:self.done withTitle:@"Done" andFont:[UIFont fontWithName:kSPDefaultFont size:17.0f]];
    [self setupButton:self.back withTitle:@"Back" andFont:[UIFont fontWithName:kSPDefaultFont size:17.0f]];
    [self.friends setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.friends setTranslatesAutoresizingMaskIntoConstraints:NO];
}

-(void)setupHeader{
    self.header.backgroundColor = [UIColor clearColor];
    [self.header setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self.headerTitle setBackgroundColor:[UIColor clearColor]];
    [self.headerTitle setText:@"Invite Friends"];
    [self.headerTitle setTextAlignment:NSTextAlignmentCenter];
    [self.headerTitle setFont:[UIFont fontWithName:kSPDefaultFont size:18]];
    [self.headerTitle setTranslatesAutoresizingMaskIntoConstraints:NO];
}

-(void)setupButton:(UIButton *)button withTitle:(NSString *)title andFont:(UIFont *)font{
    [button setTitle:title forState:UIControlStateNormal];
    [button.titleLabel setFont:font];
    [button setTranslatesAutoresizingMaskIntoConstraints:NO];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
}

-(void)setupConstraints{
    UIView *feed = self.friends;
    UIView *header = self.header;
    UIView *headerTitle = self.headerTitle;
    UIView *done = self.done;
    UIView *back = self.back;
    
    NSDictionary *headerViews = NSDictionaryOfVariableBindings(headerTitle);
    NSDictionary *views = NSDictionaryOfVariableBindings(feed, header, done, back);
    
    NSArray *feedConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[feed]-|" options:0 metrics:nil views:views];
    
    feedConstraints = [feedConstraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[header(47)]-5-[feed]-|" options:0 metrics:nil views:views]];
    
    NSArray *headerConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[header]|" options:0 metrics:nil views:views];
    
    NSArray *headerTitleConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[headerTitle]|" options:0 metrics:nil views:headerViews];
    headerTitleConstraints = [headerTitleConstraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-15-[headerTitle(32)]" options:0 metrics:nil views:headerViews]];
    
    NSArray *doneConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[done]-|" options:0 metrics:nil views:views];
    doneConstraints = [doneConstraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[done(22)]" options:0 metrics:nil views:views]];
    
    NSArray *backConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[back]" options:0 metrics:nil views:views];
    backConstraints = [backConstraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[back(22)]" options:0 metrics:nil views:views]];
    
    
    [self.header addConstraints:headerTitleConstraints];
    [self.view addConstraints:headerConstraints];
    [self.view addConstraints:feedConstraints];
    [self.view addConstraints:doneConstraints];
    [self.view addConstraints:backConstraints];
}

@end
