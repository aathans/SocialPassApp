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
            [self getFacebookInfo];
            [self dismissViewControllerAnimated:YES completion:^{
                
            }];
        }
    }];
}

-(void)getFacebookInfo{
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

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == [alertView firstOtherButtonIndex]){
        SPForgotPasswordViewController *forgotPassword = [[SPForgotPasswordViewController alloc] init];
        [self presentViewController:forgotPassword animated:NO completion:^{
            
        }];
    }
}

@end
