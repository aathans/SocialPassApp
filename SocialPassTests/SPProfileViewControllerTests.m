//
//  SPProfileViewControllerTests.m
//  SocialPass
//
//  Created by Alexander Athan on 8/12/14.
//  Copyright (c) 2014 Dolo. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SPMainViewController.h"

@interface SPProfileViewControllerTests : XCTestCase

@property (nonatomic) SPMainViewController *mainVC;
@property (nonatomic) PFUser *currentUser;

@end

@implementation SPProfileViewControllerTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.mainVC = [SPMainViewController new];
    self.currentUser = [PFUser currentUser];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample
{
    XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
}

@end
