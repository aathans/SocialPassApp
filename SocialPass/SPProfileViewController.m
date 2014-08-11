//
//  SPProfileViewController.m
//  SocialPass
//
//  Created by Alexander Athan on 6/25/14.
//  Copyright (c) 2014 Dolo. All rights reserved.
//

#import "SPProfileViewController.h"
#import "SPProfileFeedDataSource.h"
#import "SPProfileFeedCellTableViewCell.h"
#import "SPLoginViewController.h"
#import "SPTransitionManager.h"
#import "SPEventDetailControllerViewController.h"
#import "SPEmptyFeedLabel.h"

@interface SPProfileViewController () <UITableViewDelegate,UINavigationControllerDelegate, NSURLConnectionDelegate>

@property (nonatomic) UIView *background;
@property (nonatomic) UIImageView *profilePicture;
@property (nonatomic) UILabel *name;
@property (nonatomic) UILabel *header;
@property (nonatomic) UILabel *headerTitle;
@property (nonatomic) SPProfileFeedDataSource *profileDataSource;
@property (nonatomic) UIButton *logoutButton;
@property (nonatomic) NSMutableData *imageData;
@property (nonatomic, strong) SPTransitionManager *transitionManager;
@property (nonatomic) UIRefreshControl *refreshControl;

@end

@implementation SPProfileViewController

- (id)init{
    self = [super init];
    if (self) {
        self.profileDataSource = [SPProfileFeedDataSource new];
    }

    return self;
}

- (void)loadView{
    [super loadView];
    
    self.transitionManager = [SPTransitionManager new];;
    self.background = [UIView new];
    self.profilePicture = [UIImageView new];
    self.name = [UILabel new];
    self.header = [UILabel new];
    self.headerTitle = [UILabel new];
    self.logoutButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    self.eventFeed = [UITableView new];
    self.eventFeed.delegate = self;
    self.eventFeed.dataSource = self.profileDataSource;
    [self.eventFeed setRowHeight:75];
    [self.eventFeed registerClass:[SPProfileFeedCellTableViewCell class] forCellReuseIdentifier:@"Cell"];
    
    self.imageData = [NSMutableData new];
    
    [self.view addSubview:self.header];
    [self.header addSubview:self.headerTitle];
    [self.view addSubview:self.profilePicture];
    [self.view addSubview:self.name];
    [self.view addSubview:self.eventFeed];
    [self.view addSubview:self.logoutButton];
    
   // if([[PFUser currentUser] isNew]){
        //[self getFacebookInfo];
    //}
    
    [self setupCharacteristics];
    [self setupConstraints];
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self.profileDataSource fetchFeedForTableInBackground:self.eventFeed];
}

-(void)updateTable:(id)sender{
    [self.profileDataSource fetchFeedForTableInBackground:self.eventFeed];
    [self stopRefreshing];
}

-(void)stopRefreshing{
    [self.refreshControl endRefreshing];
}

#pragma mark - Facebook methods

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    NSLog(@"Appending Data");
    [self.imageData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    self.profilePicture.image = [UIImage imageWithData:self.imageData];
    self.profilePicture.layer.masksToBounds = YES;
    NSLog(@"Retrieved profile picture");
}

-(void)setupCharacteristics{
    [self retrieveUsername];
    [self retrieveProfilePicture];
    [self setupUsername];
    [self setupProfilePicture];
    [self setupEventFeed];
    [self setupHeader];
    [self setupLogout];
}

-(void)retrieveUsername{
    if ([[PFUser currentUser] objectForKey:kSPUserProfile][@"name"]) {
        self.name.text = [[PFUser currentUser] objectForKey:kSPUserProfile][@"name"];
    }
}

-(void)retrieveProfilePicture{
    if ([[PFUser currentUser] objectForKey:kSPUserProfile][@"pictureURL"]) {
        NSURL *pictureURL = [NSURL URLWithString:[[PFUser currentUser] objectForKey:kSPUserProfile][@"pictureURL"]];
        
        NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:pictureURL
                                                                  cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                              timeoutInterval:3.0f];
        // Run network request asynchronously
        NSURLConnection *urlConnection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
        if (!urlConnection) {
            NSLog(@"Failed to download picture");
        }
    }
}

-(void)setupUsername{
    [self.name setFont:[UIFont fontWithName:@"Avenir-Medium" size:18.0f]];
    [self.name setTranslatesAutoresizingMaskIntoConstraints:NO];
}

-(void)setupProfilePicture{
    self.profilePicture.backgroundColor = [UIColor SPGray];
    [self.profilePicture setTranslatesAutoresizingMaskIntoConstraints:NO];
}

#pragma mark - Event information

-(void)setupEventFeed{
    self.eventFeed.backgroundColor = [UIColor clearColor];
    [self.eventFeed setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.eventFeed setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    SPEmptyFeedLabel *emptyLabel = [[SPEmptyFeedLabel alloc] init];
    emptyLabel.font = [UIFont fontWithName:@"Avenir-Light" size:17.0f];
    emptyLabel.alpha = 0.5f;
    emptyLabel.textAlignment = NSTextAlignmentCenter;
    emptyLabel.text = @"No Upcoming Events";
    self.eventFeed.backgroundView = emptyLabel;
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc]
                                        init];
    [refreshControl addTarget:self action:@selector(updateTable:) forControlEvents:UIControlEventValueChanged];
    
    self.refreshControl = refreshControl;
    [self.eventFeed addSubview:self.refreshControl];
    
    [self.profileDataSource fetchFeedForTableInBackground:self.eventFeed];
}

#pragma mark - Header

-(void)setupHeader{
    [self.header setBackgroundColor:[UIColor clearColor]];
    [self.header setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self.headerTitle setBackgroundColor:[UIColor clearColor]];
    [self.headerTitle setText:@"Profile"];
    [self.headerTitle setTextAlignment:NSTextAlignmentCenter];
    [self.headerTitle setFont:[UIFont fontWithName:@"Avenir-Light" size:18]];
    [self.headerTitle setTranslatesAutoresizingMaskIntoConstraints:NO];
}

#pragma mark - Logout

-(void)setupLogout{
    [self.logoutButton addTarget:self action:@selector(logoutPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.logoutButton setTitle:@"Log Out" forState:UIControlStateNormal];
    [self.logoutButton.titleLabel setFont:[UIFont fontWithName:@"Avenir-Light" size:16.0f]];
    [self.logoutButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.logoutButton.layer setBorderColor:[UIColor blackColor].CGColor];
    [self.logoutButton.layer setBorderWidth:0.5f];
    [self.logoutButton.layer setCornerRadius:3.0f];
    [self.logoutButton setTranslatesAutoresizingMaskIntoConstraints:NO];
}

-(void)logoutPressed:(id)sender{
    [PFUser logOut];
    SPLoginViewController *loginVC = [SPLoginViewController new];
    
    [self presentViewController:loginVC animated:NO completion:^{
        
    }];
}

#pragma mark - Constraints


-(void)setupConstraints{
    
    UIView *background = self.background;
    UIView *eventFeed = self.eventFeed;
    UIView *profilePicture = self.profilePicture;
    UIView *name = self.name;
    UIView *header = self.header;
    UIView *logout = self.logoutButton;
    UIView *headerTitle = self.headerTitle;
    
    NSDictionary *views = NSDictionaryOfVariableBindings(background, eventFeed, profilePicture, name, header, logout);
    
    NSDictionary *headerViews = NSDictionaryOfVariableBindings(headerTitle);
    
    NSArray *profileConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[eventFeed]-|" options:0 metrics:nil views:views];
    
    profileConstraints = [profileConstraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[logout(70)]-|" options:0 metrics:nil views:views]];
    
    profileConstraints = [profileConstraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[logout(22)]" options:0 metrics:nil views:views]];
    
    profileConstraints = [profileConstraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[header]|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:views]];
    
    profileConstraints = [profileConstraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[profilePicture(60)]-[name(200)]" options:NSLayoutFormatAlignAllCenterY metrics:nil views:views]];
    
    profileConstraints = [profileConstraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[header(47)]-5-[profilePicture(60)]-10-[eventFeed]-|" options:0 metrics:nil views:views]];
    
    NSArray *headerConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[headerTitle]|" options:0 metrics:nil views:headerViews];
    headerConstraints = [headerConstraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-15-[headerTitle(32)]" options:0 metrics:nil views:headerViews]];
    
    [self.header addConstraints:headerConstraints];
    [self.view addConstraints:profileConstraints];
    
}


#pragma mark - Table view delegate methods

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80.0f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SPProfileFeedCellTableViewCell *cell = (SPProfileFeedCellTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    [self presentEventDetailsWithEventID:cell.eventID];
}

-(void)presentEventDetailsWithEventID:(NSString *)eventID{
    SPEventDetailControllerViewController *newEventVC = [SPEventDetailControllerViewController new];
    newEventVC.modalPresentationStyle = UIModalPresentationCustom;
    newEventVC.transitioningDelegate = self;
    newEventVC.eventID = eventID;
    
    [self presentViewController:newEventVC animated:YES completion:^{
        
    }];

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
    if(_didCancelEvent){
        [self.profileDataSource fetchFeedForTableInBackground:self.eventFeed];
        self.didCancelEvent = NO;
    }
    return self.transitionManager;
}

@end
