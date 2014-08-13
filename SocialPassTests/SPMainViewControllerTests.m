//
//  SPMainViewControllerTests.m
//  SocialPass
//
//  Created by Alexander Athan on 7/21/14.
//  Copyright (c) 2014 Dolo. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface SPMainViewControllerTests : XCTestCase

@property (nonatomic) PFUser *user;

@end

@implementation SPMainViewControllerTests

- (void)setUp
{
    [super setUp];
    self.user = [PFUser new];
    [_user setObjectId:@"i1234566"];
    [_user setUsername:@"V2pcfjAg3XsASkXV5uP7BtL03"];
    
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample
{
   // XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
    
}

@end
