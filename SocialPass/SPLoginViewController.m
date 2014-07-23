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

    //self.username = [UITextField new];
    //self.password = [UITextField new];
    //self.registerNow = [UILabel new];
    double offset = (self.view.frame.size.width-200)/2;
    
    
    self.loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.loginButton.frame = CGRectMake(offset, 250, 200, 40);
    self.loginButton.backgroundColor = [UIColor SPGray];
    //self.signupButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //self.loginView = [[FBLoginView alloc] init];

    //Pushes login fields up with keyboard
    //self.keyboardView = [[TPKeyboardAvoidingScrollView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    //[_keyboardView addSubview:self.username];
    //[_keyboardView addSubview:self.password];
    //[_keyboardView addSubview:self.loginButton];
    
    //[self.view addSubview:self.keyboardView];
    //[self.view addSubview:self.registerNow];
    //[self.view addSubview:self.signupButton];
    [self.view addSubview:self.loginButton];

    [self setupCharacteristics];
    //[self setupConstraints];
    
}

-(void)setupCharacteristics{
    
    /*
    //USERNAME FIELD
    //UIView *spacerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    _username.textColor = [UIColor colorWithRed:0/256.0 green:84/256.0 blue:129/256.0 alpha:1.0];
    _username.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
    _username.backgroundColor=[UIColor whiteColor];
    _username.placeholder=@"Username";
    //_username.layer.borderColor = [UIColor blackColor].CGColor;
    //_username.layer.borderWidth = 0.5f;
    //_username.layer.cornerRadius = 3.0f;
    [_username setBorderStyle:UITextBorderStyleRoundedRect];
    //   [_username setLeftViewMode:UITextFieldViewModeAlways];
    //    [_username setLeftView:spacerView];
    [self.username setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    //PASSWORD FIELD
    //UIView *spacer2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    _password.textColor = [UIColor colorWithRed:0/256.0 green:84/256.0 blue:129/256.0 alpha:1.0];
    _password.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
    _password.backgroundColor=[UIColor whiteColor];
    _password.placeholder=@"Password";
    //_password.layer.borderColor = [UIColor blackColor].CGColor;
    //_password.layer.borderWidth = 0.5;
    //_password.layer.cornerRadius = 3.0f;
    // [_password setLeftViewMode:UITextFieldViewModeAlways];
    // [_password setLeftView:spacer2];
    [self.password setBorderStyle:UITextBorderStyleRoundedRect];
    [self.password setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.password setSecureTextEntry:YES];
    
    //Register now text
    _registerNow.text = @"Not registered?";
    _registerNow.font = [UIFont fontWithName:@"Helvetica" size:15];
    [_registerNow setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    //Sign up button
    [_signupButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_signupButton setTitle:@"Sign Up!" forState:UIControlStateNormal];
    [_signupButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_signupButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    */
    
    //Login button
    [_loginButton addTarget:self action:@selector(loginClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_loginButton setTitle:@"Login With Facebook" forState:UIControlStateNormal];
    [_loginButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _loginButton.layer.borderWidth = 0.5f;
    _loginButton.layer.cornerRadius = 3.0f;
    //[_loginButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    
    
    //FB Login
 //   self.loginView.frame = CGRectOffset(self.loginView.frame, (self.view.center.x - (self.loginView.frame.size.width / 2)), 5);
}

/*

-(void)setupConstraints{
    //UIView *username = self.username;
    //UIView *password = self.password;
    UIView *loginButton = self.loginButton;
    //UIView *registerNow = self.registerNow;
    //UIView *signUp = self.signupButton;
    //UIView *keyboard = self.keyboardView;
    
    NSDictionary *views = NSDictionaryOfVariableBindings(username, password, loginButton, registerNow, signUp, keyboard);
    
    //Vertical
    NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[keyboard]-200-[username(44)]-[password(44)]-[loginButton(44)]" options:NSLayoutFormatAlignAllCenterX metrics:nil views:views];
    
    //Horizontal
    constraints = [constraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[username(200)]" options:0 metrics:nil views:views]];
    constraints = [constraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[password(200)]" options:0 metrics:nil views:views]];
    constraints = [constraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[loginButton(120)]" options:0 metrics:nil views:views]];
    
    constraints = [constraints arrayByAddingObject:[NSLayoutConstraint constraintWithItem:registerNow attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-40]];
    
    
    //Sign Up/Register
    constraints = [constraints arrayByAddingObject:[NSLayoutConstraint constraintWithItem:registerNow attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:-110]];
    
    constraints = [constraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[registerNow(110)]-[signUp(70)]" options:NSLayoutFormatAlignAllCenterY metrics:nil views:views]];
    
    [self.view addConstraints:constraints];
}
*/

#pragma mark - Helper methods

-(void)buttonClicked:(id)sender{
    NSLog(@"HI");
    SPSignUpViewController *signUpViewController = [[SPSignUpViewController alloc] init];
    [self presentViewController:signUpViewController animated:YES completion:^{
    }];
}

-(void)loginClicked:(id)sender{
    /*
    NSString *username = [self.username.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *password = [self.password.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([username length] == 0 || [password length] == 0){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops" message:@"Make sure you enter a username, and password" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Forgot Password?", nil];
        [alertView show];
    } else {
        [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser *user, NSError *error) {
            if(error){
                UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Sorry" message:[error.userInfo objectForKey:@"error"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Forgot Password", nil];
                [errorAlert show];
            } else {
                [self dismissViewControllerAnimated:YES completion:^{
                }];
            }
        }];
    }
     */
    
    // Set permissions required from the facebook user account
    NSArray *permissionsArray = @[ @"user_about_me", @"user_relationships", @"user_birthday", @"user_location"];
    
    // Login PFUser using facebook
    [PFFacebookUtils logInWithPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
        //[_activityIndicator stopAnimating]; // Hide loading indicator
        
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
    
    //[_activityIndicator startAnimating]; // Show loading indicator until login is finished
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == [alertView firstOtherButtonIndex]){
        SPForgotPasswordViewController *forgotPassword = [[SPForgotPasswordViewController alloc] init];
        [self presentViewController:forgotPassword animated:NO completion:^{
            
        }];
    }
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
