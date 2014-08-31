//
//  SPProfilePicture.m
//  SocialPass
//
//  Created by Alexander Athan on 8/31/14.
//  Copyright (c) 2014 Dolo. All rights reserved.
//

#import "SPProfilePicture.h"

@implementation SPProfilePicture

-(id)init{
    self = [super init];
    if(self){
        self.backgroundColor = [UIColor SPGray];
        [self.layer setCornerRadius:3];
        [self setClipsToBounds:YES];
        [self.layer setBorderWidth:0.1f];
        [self.layer setBorderColor:[UIColor grayColor].CGColor];
    }
    return self;
}

@end
