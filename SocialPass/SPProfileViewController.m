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

@interface SPProfileViewController () <UITableViewDelegate,UINavigationControllerDelegate, NSURLConnectionDelegate>

@property (nonatomic) UIView *background;
@property (nonatomic) UIImageView *profilePicture;
@property (nonatomic) UILabel *name;
@property (nonatomic) UILabel *header;
@property (nonatomic) SPProfileFeedDataSource *profileDataSource;
@property (nonatomic) UIButton *logoutButton;
@property (nonatomic) NSMutableData *imageData;

@end

@implementation SPProfileViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.profileDataSource = [SPProfileFeedDataSource new];
    }

    return self;
}

- (void)loadView
{
    [super loadView];
    self.background = [UIView new];
    self.profilePicture = [UIImageView new];
    self.name = [UILabel new];
    self.header = [UILabel new];
    self.logoutButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    self.eventFeed = [UITableView new];
    self.eventFeed.delegate = self;
    self.eventFeed.dataSource = self.profileDataSource;
    [self.eventFeed setRowHeight:75];
    [self.eventFeed registerClass:[SPProfileFeedCellTableViewCell class] forCellReuseIdentifier:@"Cell"];
    self.imageData = [[NSMutableData alloc] init];
    
    [self.view addSubview:self.header];
    [self.view addSubview:self.profilePicture];
    [self.view addSubview:self.name];
    [self.view addSubview:self.eventFeed];
    [self.view addSubview:self.logoutButton];
    
    [self getFacebookInfo];
    [self setupCharacteristics];
    [self setupConstraints];
    [self.profileDataSource fetchFeedForTable:self.eventFeed];
    
}

-(void)getFacebookInfo{
    FBRequest *request = [FBRequest requestForMe];
    [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            NSDictionary *userData = (NSDictionary *)result;
            
            NSString *facebookID = userData[@"id"];
            
            NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", facebookID]];
            
            NSMutableDictionary *userProfile = [NSMutableDictionary dictionaryWithCapacity:7];
            
            if (facebookID) {
                userProfile[@"facebookId"] = facebookID;
            }
            if (userData[@"name"]) {
                userProfile[@"name"] = userData[@"name"];
            }
            if (userData[@"location"][@"name"]) {
                userProfile[@"location"] = userData[@"location"][@"name"];
            }
            if (userData[@"gender"]) {
                userProfile[@"gender"] = userData[@"gender"];
            }
            if (userData[@"birthday"]) {
                userProfile[@"birthday"] = userData[@"birthday"];
            }
            if (userData[@"relationship_status"]) {
                userProfile[@"relationship"] = userData[@"relationship_status"];
            }
            if ([pictureURL absoluteString]) {
                userProfile[@"pictureURL"] = [pictureURL absoluteString];
                NSLog(@"%@", [pictureURL absoluteString]);
            }
            
            [[PFUser currentUser] setObject:userProfile forKey:@"profile"];
            [[PFUser currentUser] saveInBackground];
            
        } else if ([[[[error userInfo] objectForKey:@"error"] objectForKey:@"type"]
                    isEqualToString: @"OAuthException"]) {
            NSLog(@"The facebook session was invalidated");
            //[self logoutButtonTouchHandler:nil];
        } else {
            NSLog(@"Some other error: %@", error);
        }
    }];
}

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
    if ([[PFUser currentUser] objectForKey:@"profile"][@"name"]) {
        self.name.text = [[PFUser currentUser] objectForKey:@"profile"][@"name"];
        NSLog(@"NAME GOT");
    }
}

-(void)retrieveProfilePicture{
    if ([[PFUser currentUser] objectForKey:@"profile"][@"pictureURL"]) {
        NSLog(@"Getting profile pic");
        NSURL *pictureURL = [NSURL URLWithString:[[PFUser currentUser] objectForKey:@"profile"][@"pictureURL"]];
        
        NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:pictureURL
                                                                  cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                              timeoutInterval:2.0f];
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

-(void)setupEventFeed{
    self.eventFeed.backgroundColor = [UIColor clearColor];
    [self.eventFeed setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.eventFeed setTranslatesAutoresizingMaskIntoConstraints:NO];
}

-(void)setupHeader{
    self.header.text = @"Profile";
    [self.header setTextAlignment:NSTextAlignmentCenter];
    [self.header setBackgroundColor:[UIColor clearColor]];
    [self.header setFont:[UIFont fontWithName:@"Avenir-Light" size:18.0f]];
    [self.header setTranslatesAutoresizingMaskIntoConstraints:NO];
}

-(void)setupLogout{
    [self.logoutButton addTarget:self action:@selector(logoutPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.logoutButton setTitle:@"Log Out" forState:UIControlStateNormal];
    [self.logoutButton.titleLabel setFont:[UIFont fontWithName:@"Avenir-Light" size:16.0f]];
    [self.logoutButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.logoutButton.layer setBorderColor:[UIColor blackColor].CGColor];
    [self.logoutButton.layer setBorderWidth:1.0f];
    [self.logoutButton.layer setCornerRadius:3.0f];
    [self.logoutButton setTranslatesAutoresizingMaskIntoConstraints:NO];
}

-(void)setupConstraints{
    
    UIView *background = self.background;
    UIView *eventFeed = self.eventFeed;
    UIView *profilePicture = self.profilePicture;
    UIView *name = self.name;
    UIView *header = self.header;
    UIView *logout = self.logoutButton;
    
    NSDictionary *views = NSDictionaryOfVariableBindings(background, eventFeed, profilePicture, name, header, logout);
    
    NSArray *profileConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[eventFeed]-|" options:0 metrics:nil views:views];
    
    profileConstraints = [profileConstraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[logout(70)]-|" options:0 metrics:nil views:views]];
    
    profileConstraints = [profileConstraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[logout(22)]" options:0 metrics:nil views:views]];
    
    profileConstraints = [profileConstraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[header]-|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:views]];
    
    profileConstraints = [profileConstraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[profilePicture(60)]-[name(200)]" options:NSLayoutFormatAlignAllCenterY metrics:nil views:views]];
    
    profileConstraints = [profileConstraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[header(22)]-5-[profilePicture(60)]-10-[eventFeed]-|" options:0 metrics:nil views:views]];
    
    [self.view addConstraints:profileConstraints];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.profileDataSource fetchFeedForTableInBackground:self.eventFeed];
}

#pragma mark - Table view delegate methods

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80.0f;
}

#pragma mark - Helper methods

-(void)logoutPressed:(id)sender{
    [PFUser logOut];
    SPLoginViewController *loginVC = [SPLoginViewController new];
    
    [self presentViewController:loginVC animated:NO completion:^{
        
    }];
}

@end
