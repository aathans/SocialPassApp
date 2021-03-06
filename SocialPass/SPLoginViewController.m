//
//  OPNLoginViewController.m
//  open
//
//  Created by Alexander Athan on 6/9/14.
//  Copyright (c) 2014 Alex. All rights reserved.
//

#import "SPLoginViewController.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "UIScrollView+TPKeyboardAvoidingAdditions.h"

@interface SPLoginViewController () <UIAlertViewDelegate, FBLoginViewDelegate>

@property (nonatomic)UILabel *registerNow;
@property (nonatomic)UIButton *loginButton;
@property (nonatomic)UIButton *signupButton;
@property (nonatomic)TPKeyboardAvoidingScrollView *keyboardView;

@end

@implementation SPLoginViewController

-(void)loadView{
    [super loadView];

    double offset = (self.view.frame.size.width-200)/2;
    
    self.loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.loginButton.frame = CGRectMake(offset, 250, 200, 40);
    self.loginButton.backgroundColor = [UIColor SPGray];

    [self.view addSubview:self.loginButton];

    [self setupCharacteristics];
}

-(void)setupCharacteristics{
    [_loginButton addTarget:self action:@selector(loginClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_loginButton setTitle:@"Login With Facebook" forState:UIControlStateNormal];
    [_loginButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_loginButton.layer setBorderWidth:0.5f];
    [_loginButton.layer setCornerRadius:3.0f];
}

#pragma mark - Helper methods

-(void)loginClicked:(id)sender{
    NSArray *permissionsArray = @[@"user_about_me"];
    [PFFacebookUtils logInWithPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
        if (!user) {
            if (!error) {
                NSLog(@"Uh oh. The user cancelled the Facebook login.");
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Log In Error" message:@"Uh oh. The user cancelled the Facebook login." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Dismiss", nil];
                [alert show];
            } else {
                NSLog(@"Uh oh. An error occurred: %@", error);
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Log In Error" message:[error description] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Dismiss", nil];
                [alert show];
            }
        } else if (user.isNew) {
            NSLog(@"User with facebook signed up and logged in!");
            [self dismissViewControllerAnimated:YES completion:^{
                
            }];
        } else {
            NSLog(@"User with facebook logged in!");
            [self dismissViewControllerAnimated:YES completion:^{
                
            }];
        }
    }];
}


@end
