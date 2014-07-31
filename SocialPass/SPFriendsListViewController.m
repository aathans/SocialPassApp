//
//  FriendsListViewController.m
//  SocialPass
//
//  Created by Alexander Athan on 6/26/14.
//  Copyright (c) 2014 Dolo. All rights reserved.
//

#import "SPFriendsListViewController.h"
#import "SPFriendsTableViewCell.h"
#import "SPFriendsTable.h"
#import "SPFriendsTableDataSource.h"

@interface SPFriendsListViewController ()

@property (nonatomic) SPFriendsTable *friendsList;
@property (nonatomic) SPFriendsTableDataSource *friendsListDataSource;
@property (nonatomic) UILabel *header;
@property (nonatomic) UILabel *headerTitle;

-(void)setupConstraints;
-(void)setupCharacteristics;

@end

@implementation SPFriendsListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)loadView{
    [super loadView];
    self.header = [UILabel new];
    self.headerTitle = [UILabel new];
    
    self.friendsListDataSource = [[SPFriendsTableDataSource alloc] init];
    self.friendsList = [[SPFriendsTable alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    self.friendsList.dataSource = self.friendsListDataSource;
    self.friendsList.backgroundColor = [UIColor clearColor];
    
    [self.header addSubview:self.headerTitle];
    [self.view addSubview:self.header];
    [self.view addSubview:self.friendsList];
    
    [self setupCharacteristics];
    [self setupConstraints];
    [self.friendsListDataSource fetchFeedForTable:self.friendsList];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.friendsList reloadData];
}

-(void)setupCharacteristics{
    [self setupHeader];
    [self setupFriendsList];
}

-(void)setupHeader{
    self.header.backgroundColor = [UIColor clearColor];
    [self.header setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self.headerTitle setBackgroundColor:[UIColor clearColor]];
    [self.headerTitle setText:@"Friends"];
    [self.headerTitle setTextAlignment:NSTextAlignmentCenter];
    [self.headerTitle setFont:[UIFont fontWithName:@"Avenir-Light" size:18]];
    [self.headerTitle setTranslatesAutoresizingMaskIntoConstraints:NO];
}

-(void)setupFriendsList{
    [self.friendsList setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.friendsList setTranslatesAutoresizingMaskIntoConstraints:NO];
}

-(void)setupConstraints{
    UIView *feed = self.friendsList;
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
