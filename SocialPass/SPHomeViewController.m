//
//  SPHomeViewController.m
//  SocialPass
//
//  Created by Alexander Athan on 6/22/14.
//  Copyright (c) 2014 Dolo. All rights reserved.
//

#import "SPHomeViewController.h"
#import "SPFeedViewController.h"
#import "SPProfileViewController.h"
#import "SPLoginViewController.h"
#import "SPFriendsListViewController.h"

@interface SPHomeViewController () <UIPageViewControllerDataSource>

@property (nonatomic) NSArray *pages;

@end

@implementation SPHomeViewController

- (id)init{
    self = [super initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                    navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    return self;
}

-(void)loadView{
    [super loadView];

    [self setupPages];
    
    self.dataSource = self;

    [self setViewControllers:@[_pages[1]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:^(BOOL finished) {
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    PFUser *currentUser = [PFUser currentUser];
    
    if(!currentUser){
        SPLoginViewController *loginViewController = [SPLoginViewController new];
        [self presentViewController:loginViewController animated:NO completion:^{
        }];
    }
    
    [self getMyFacebookInfo];
    [self getFriends];
    
}

- (void)setupPages {
    SPFeedViewController *feedVC = [SPFeedViewController new];
    UINavigationController *mainController = [[UINavigationController alloc] initWithRootViewController:feedVC];
    [mainController setNavigationBarHidden:YES];
    SPProfileViewController *profileVC = [SPProfileViewController new];
    SPFriendsListViewController *friendsVC = [SPFriendsListViewController new];
    
    _pages = @[friendsVC, mainController, profileVC];
}


#pragma mark - UIPageViewControllerDataSource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    if (nil == viewController) {
        return _pages[0];
    }
    
    NSInteger idx = [_pages indexOfObject:viewController];
    NSParameterAssert(idx != NSNotFound);
    
    if (idx >= [_pages count] - 1) {
        return nil;
    }
    
    return _pages[idx + 1];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    if (nil == viewController) {
        return _pages[0];
    }
    
    NSInteger idx = [_pages indexOfObject:viewController];
    NSParameterAssert(idx != NSNotFound);
    
    if (idx <= 0) {
        return nil;
    }
    
    return _pages[idx - 1];
}

#pragma mark - facebook 

-(void)getMyFacebookInfo{
    FBRequest *request = [FBRequest requestForMe];
    [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            NSDictionary *userData = (NSDictionary *)result;
            
            NSString *facebookID = userData[@"id"];
            
            NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", facebookID]];
            
            NSMutableDictionary *userProfile = [NSMutableDictionary dictionaryWithCapacity:5];
            
            if (facebookID) {
                userProfile[@"facebookId"] = facebookID;
            }
            if (userData[@"name"]) {
                userProfile[@"name"] = userData[@"name"];
            }
            if (userData[@"gender"]) {
                userProfile[@"gender"] = userData[@"gender"];
            }
            if (userData[@"birthday"]) {
                userProfile[@"birthday"] = userData[@"birthday"];
            }
            if ([pictureURL absoluteString]) {
                userProfile[@"pictureURL"] = [pictureURL absoluteString];
                NSLog(@"%@", [pictureURL absoluteString]);
            }
            
            [[PFUser currentUser] setObject:[result objectForKey:@"id"]
                                     forKey:@"facebookId"];
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

-(void)getFriends{
    [FBRequestConnection startForMyFriendsWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            NSArray *friendObjects = [result objectForKey:@"data"];
            NSMutableArray *friendIds = [NSMutableArray arrayWithCapacity:friendObjects.count];
            
            for (NSDictionary *friendObject in friendObjects) {
                [friendIds addObject:[friendObject objectForKey:@"id"]];
            }
            
            PFQuery *friendQuery = [PFUser query];
            [friendQuery setCachePolicy:kPFCachePolicyCacheElseNetwork];
            [friendQuery whereKey:@"facebookId" containedIn:friendIds];
            
            [friendQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                [[SPCache sharedCache] setFacebookFriends:objects];
            }];
        }
    }];
    
}


@end
