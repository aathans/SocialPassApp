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
#import "SPSignUpViewController.h"
#import "SPForgotPasswordViewController.h"

@interface SPLoginViewController () <UIAlertViewDelegate, FBLoginViewDelegate>
@property (nonatomic)UITextField *username;
@property (nonatomic)UITextField *password;
@property (nonatomic)UILabel *registerNow;
@property (nonatomic)UIButton *loginButton;
@property (nonatomic)UIButton *signupButton;
@property (nonatomic)TPKeyboardAvoidingScrollView *keyboardView;


@end

@implementation SPLoginViewController

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
    }
    return self;
}


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
    _loginButton.layer.borderWidth = 0.5f;
    _loginButton.layer.cornerRadius = 3.0f;
}

#pragma mark - Helper methods

-(void)buttonClicked:(id)sender{
    NSLog(@"HI");
    SPSignUpViewController *signUpViewController = [[SPSignUpViewController alloc] init];
    [self presentViewController:signUpViewController animated:YES completion:^{
    }];
}

-(void)loginClicked:(id)sender{
    NSArray *permissionsArray = @[ @"user_about_me", @"user_relationships", @"user_birthday", @"user_location"];
    
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

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == [alertView firstOtherButtonIndex]){
        SPForgotPasswordViewController *forgotPassword = [[SPForgotPasswordViewController alloc] init];
        [self presentViewController:forgotPassword animated:NO completion:^{
            
        }];
    }
}

@end
