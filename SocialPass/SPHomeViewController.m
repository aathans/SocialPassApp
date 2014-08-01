//
//  SPHomeViewController.m
//  SocialPass
//
//  Created by Alexander Athan on 6/22/14.
//  Copyright (c) 2014 Dolo. All rights reserved.
//

#import "SPHomeViewController.h"
#import "SPMainViewController.h"
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

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    PFUser *currentUser = [PFUser currentUser];
    if(!currentUser){
        SPLoginViewController *loginViewController = [[SPLoginViewController alloc] init];
        
        [self presentViewController:loginViewController animated:NO completion:^{
        }];
    }
}

- (void)setupPages {
    SPMainViewController *mainVC = [SPMainViewController new];    
    SPProfileViewController *profileVC = [SPProfileViewController new];
    SPFriendsListViewController *friendsVC = [SPFriendsListViewController new];
    
    _pages = @[friendsVC, mainVC, profileVC];
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

@end
