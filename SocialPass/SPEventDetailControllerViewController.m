//
//  SPEventDetailControllerViewController.m
//  SocialPass
//
//  Created by Alexander Athan on 6/23/14.
//  Copyright (c) 2014 Dolo. All rights reserved.
//

#import "SPEventDetailControllerViewController.h"
#import "SPEventDetailView.h"

@interface SPEventDetailControllerViewController ()

@property SPEventDetailView *eventView;

@end

@implementation SPEventDetailControllerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)loadView{
    [super loadView];
    self.eventView = [SPEventDetailView new];
    [self.view addSubview:self.eventView];
}

@end
