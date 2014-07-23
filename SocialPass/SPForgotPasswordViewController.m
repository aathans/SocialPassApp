//
//  SPForgotPasswordViewController.m
//  SocialPass
//
//  Created by Alexander Athan on 6/25/14.
//  Copyright (c) 2014 Dolo. All rights reserved.
//

#import "SPForgotPasswordViewController.h"
#import "TPKeyboardAvoidingScrollView.h"
#import <QuartzCore/QuartzCore.h>
#import <Parse/Parse.h>

@interface SPForgotPasswordViewController ()

@property (nonatomic)UITextField *emailField;
@property (nonatomic)UIButton *cancelButton;
@property (nonatomic)UIButton *sendEmailButton;
@property (nonatomic)TPKeyboardAvoidingScrollView *keyboardView;

@end

@implementation SPForgotPasswordViewController

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
    
    self.emailField = [UITextField new];
    self.sendEmailButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    //Keyboard
    self.keyboardView = [[TPKeyboardAvoidingScrollView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    [_keyboardView addSubview:self.emailField];
    [_keyboardView addSubview:self.sendEmailButton];
    
    [self.view addSubview:self.keyboardView];
    [self.view addSubview:self.cancelButton];
    
    [self setupCharacteristics];
    [self setupConstraints];
    
}

-(void)setupCharacteristics{
    //Email field
    _emailField.backgroundColor = [UIColor whiteColor];
    _emailField.placeholder = @"Email Address";
    [self.emailField setBorderStyle:UITextBorderStyleRoundedRect];
    [self.emailField setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    //Send email button
    [_sendEmailButton addTarget:self action:@selector(sendPassword:) forControlEvents:UIControlEventTouchUpInside];
    [_sendEmailButton setTitle:@"Send Password" forState:UIControlStateNormal];
    [_sendEmailButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _sendEmailButton.layer.borderWidth = 0.5f;
    _sendEmailButton.layer.cornerRadius = 3.0f;
    [_sendEmailButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    //Cancel Button
    [_cancelButton setImage:[UIImage imageNamed:@"icon_x"] forState:UIControlStateNormal];
    [_cancelButton addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    [_cancelButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    
}

-(void)setupConstraints{
    //***CONSTRAINTS***
    UIView *email = self.emailField;
    UIView *cancel = self.cancelButton;
    UIView *sendEmailButton = self.sendEmailButton;
    
    
    NSDictionary *views = NSDictionaryOfVariableBindings(email, sendEmailButton, cancel);
    
    NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[email(200)]" options:0 metrics:nil views:views];
    
    constraints = [constraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[sendEmailButton(140)]" options:0 metrics:nil views:views]];
    
    //Vertical
    constraints = [constraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-170-[email(44)]-[sendEmailButton(44)]" options:NSLayoutFormatAlignAllCenterX metrics:nil views:views]];
    
    constraints = [constraints arrayByAddingObject:[NSLayoutConstraint constraintWithItem:email attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    
    constraints = [constraints arrayByAddingObject:[NSLayoutConstraint constraintWithItem:sendEmailButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    
    //Cancel Button
    constraints = [constraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[cancel]-|" options:0 metrics:nil views:views]];
    constraints = [constraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-30-[cancel]" options:0 metrics:nil views:views]];
    
    [self.view addConstraints:constraints];
    
    //************
}
-(void)sendPassword:(id)sender{
    NSString *email = [self.emailField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    [PFUser requestPasswordResetForEmailInBackground:email];
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

-(void)cancel:(id)sender{
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
