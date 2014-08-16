//
//  SPInviteFriends.m
//  SocialPass
//
//  Created by Alexander Athan on 8/13/14.
//  Copyright (c) 2014 Dolo. All rights reserved.
//

#import "SPInviteFriends.h"
#import "SPInviteFriendsTable.h"
#import "SPInviteFriendsDataSource.h"

@interface SPInviteFriends()

@property (nonatomic) SPInviteFriendsTable *friends;
@property (nonatomic) SPInviteFriendsDataSource *friendsData;

@property (nonatomic) UILabel *header;
@property (nonatomic) UILabel *headerTitle;
@property (nonatomic) UIButton *done;
@property (nonatomic) UIButton *back;

@end

@implementation SPInviteFriends

-(id)init{
    self = [super init];
    
    if(self){
    }
    
    return self;
}

- (void)loadView
{
    [super loadView];
    
    self.friends = [SPInviteFriendsTable new];
    self.friendsData = [SPInviteFriendsDataSource new];
    self.friends.dataSource = self.friendsData;
    
    self.done = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.done addTarget:self action:@selector(doneButton:) forControlEvents:UIControlEventTouchUpInside];

    self.header = [UILabel new];
    self.headerTitle = [UILabel new];
    [self.header addSubview:self.headerTitle];
    [self.header addSubview:self.done];
    [self.view addSubview:self.header];
    [self.view addSubview:self.friends];
    
    [self setupCharacteristics];
    [self setupConstraints];
    [self.friendsData fetchFeedForTable:self.friends];
}

-(void)doneButton:(id)sender{
    [self dismissViewControllerAnimated:YES completion:^{
        [self.presentingViewController dismissViewControllerAnimated:NO completion:^{
            
        }];
    }];
}

-(void)setupCharacteristics{
    [self setupHeader];
    [self setupButtonWithTitle:@"Done" andFont:[UIFont fontWithName:@"Avenir-Light" size:17.0f]];
    [self.friends setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.friends setTranslatesAutoresizingMaskIntoConstraints:NO];
}

-(void)setupHeader{
    self.header.backgroundColor = [UIColor clearColor];
    [self.header setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self.headerTitle setBackgroundColor:[UIColor clearColor]];
    [self.headerTitle setText:@"Invite Friends"];
    [self.headerTitle setTextAlignment:NSTextAlignmentCenter];
    [self.headerTitle setFont:[UIFont fontWithName:@"Avenir-Light" size:18]];
    [self.headerTitle setTranslatesAutoresizingMaskIntoConstraints:NO];
}

-(void)setupButtonWithTitle:(NSString *)title andFont:(UIFont *)font{
    [self.done setTitle:title forState:UIControlStateNormal];
    [self.done.titleLabel setFont:font];
    [self.done setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.done setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.done.titleLabel.textAlignment = NSTextAlignmentCenter;
}

-(void)setupConstraints{
    UIView *feed = self.friends;
    UIView *header = self.header;
    UIView *headerTitle = self.headerTitle;
    
    NSDictionary *headerViews = NSDictionaryOfVariableBindings(headerTitle);
    NSDictionary *views = NSDictionaryOfVariableBindings(feed, header);
    
    NSArray *feedConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[feed]-|" options:0 metrics:nil views:views];
    
    feedConstraints = [feedConstraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[header(47)]-5-[feed]-|" options:0 metrics:nil views:views]];
    
    NSArray *headerConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[header]|" options:0 metrics:nil views:views];
    
    NSArray *headerTitleConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[headerTitle]|" options:0 metrics:nil views:headerViews];
    headerTitleConstraints = [headerTitleConstraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-15-[headerTitle(32)]" options:0 metrics:nil views:headerViews]];
    
    [self.header addConstraints:headerTitleConstraints];
    [self.view addConstraints:headerConstraints];
    [self.view addConstraints:feedConstraints];
}

@end
