//
//  SPSignUpViewController.m
//  SocialPass
//
//  Created by Alexander Athan on 6/25/14.
//  Copyright (c) 2014 Alex. All rights reserved.
//

#import "SPSignUpViewController.h"
#import "TPKeyboardAvoidingScrollView.h"
#import <Parse/Parse.h>

@interface SPSignUpViewController ()

@property(nonatomic)UITextField *usernameField;
@property(nonatomic)UITextField *passwordField;
@property(nonatomic)UITextField *emailField;

@end

@implementation SPSignUpViewController

- (id)init
{
    self = [super init];
    if (self) {
        
        // Custom initialization
        UISwipeGestureRecognizer * swiperight=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swiperight:)];
        swiperight.direction=UISwipeGestureRecognizerDirectionRight;
        
        [self.view addGestureRecognizer:swiperight];
        
        self.view.backgroundColor = [UIColor whiteColor];
        
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

-(void)loadView{
    [super loadView];
    //Username field
    self.usernameField = [[UITextField alloc] init];//WithFrame:CGRectMake(60, 100, 200, 40)];
    self.usernameField.placeholder = @"Username";
    self.usernameField.backgroundColor = [UIColor whiteColor];
    [self.usernameField setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.usernameField setBorderStyle:UITextBorderStyleRoundedRect];
    
    //Password field
    self.passwordField = [[UITextField alloc] init]; //WithFrame:CGRectMake(60, self.usernameField.frame.origin.y+50, 200, 40)];
    
    self.passwordField.placeholder = @"Password";
    self.passwordField.backgroundColor = [UIColor whiteColor];
    [self.passwordField setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.passwordField setBorderStyle:UITextBorderStyleRoundedRect];
    [self.passwordField setSecureTextEntry:YES];
    
    
    
    //Email field
    self.emailField = [[UITextField alloc] init];//WithFrame:CGRectMake(60, self.passwordField.frame.origin.y+50, 200, 40)];
    self.emailField.placeholder = @"Email Address";
    self.emailField.backgroundColor = [UIColor whiteColor];
    [self.emailField setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.emailField setBorderStyle:UITextBorderStyleRoundedRect];
    
    //Signup button
    UIButton *signUpButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [signUpButton addTarget:self action:@selector(signUp:) forControlEvents:UIControlEventTouchUpInside];
    [signUpButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [signUpButton setTitle:@"Sign Up!" forState:UIControlStateNormal];
    [signUpButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [signUpButton.layer setBorderWidth:0.5f];
    [signUpButton.layer setCornerRadius:3.0f];
    
    //Pushes fields up with keyboard
    TPKeyboardAvoidingScrollView *keyboardAvoidingScrollView = [[TPKeyboardAvoidingScrollView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [keyboardAvoidingScrollView addSubview:self.usernameField];
    [keyboardAvoidingScrollView addSubview:self.passwordField];
    [keyboardAvoidingScrollView addSubview:self.emailField];
    [keyboardAvoidingScrollView addSubview:signUpButton];
    
    //Cancel button
    UIButton *cancelButton = [[UIButton alloc] init];//WithFrame:CGRectMake(275, 20, 44, 44)];
    [cancelButton setImage:[UIImage imageNamed:@"icon_x"] forState:UIControlStateNormal];
    [cancelButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [cancelButton addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:keyboardAvoidingScrollView];
    [self.view addSubview:cancelButton];
    
    UITextField *usernameField = self.usernameField;
    UITextField *passwordField = self.passwordField;
    UITextField *emailField = self.emailField;
    UIView *superView = keyboardAvoidingScrollView;
    
    NSDictionary *views = NSDictionaryOfVariableBindings(usernameField, passwordField, emailField, signUpButton, cancelButton, superView);
    
    //Vertical
    NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[superView]-150-[usernameField(44)]-[passwordField(44)]-[emailField(44)]-[signUpButton(44)]" options:NSLayoutFormatAlignAllCenterX metrics:nil views:views];
    constraints = [constraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-30-[cancelButton(44)]" options:0 metrics:nil views:views]];
    
    //Horizontal
    constraints = [constraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[usernameField(200)]" options:0 metrics:nil views:views]];
    constraints = [constraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[passwordField(200)]" options:0 metrics:nil views:views]];
    constraints = [constraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[emailField(200)]" options:0 metrics:nil views:views]];
    constraints = [constraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[signUpButton(200)]" options:0 metrics:nil views:views]];
    constraints = [constraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[cancelButton(44)]-|" options:0 metrics:nil views:views]];
    
    [self.view addConstraints:constraints];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //[self.usernameField becomeFirstResponder];
}

-(void)cancel:(id)sender{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)signUp:(id)sender {
    NSString *username = [self.usernameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *password = [self.passwordField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSString *email = [self.emailField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([username length] == 0 || [password length] == 0 || [email length] == 0){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops" message:@"Make sure you enter a username, password, and email" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
    } else {
        PFUser *newUser = [PFUser user];
        newUser.username = username;
        newUser.password = password;
        newUser.email = email;
        
        [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if(error){
                UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Sorry" message:[error.userInfo objectForKey:@"error"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [errorAlert show];
            } else {
                [self dismissViewControllerAnimated:YES completion:^{
                    
                }];
                //[self.navigationController popToRootViewControllerAnimated:YES];
            }
        }];
    }
    
    
}


-(void)swiperight:(UISwipeGestureRecognizer*)gestureRecognizer{
    [self dismissViewControllerAnimated:YES completion:^{
    }];
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
