//
//  SPNewEventViewController.m
//  SocialPass
//
//  Created by Alexander Athan on 6/22/14.
//  Copyright (c) 2014 Dolo. All rights reserved.
//

#import "SPNewEventViewController.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "SPNewEvent.h"
#import "SPCoreDataStack.h"
#import "SPNewEventCanvas.h"
#import "SPAdvancedOptionsCanvas.h"
#import "SPInviteFriends.h"

@interface SPNewEventViewController () <UINavigationControllerDelegate, UITextFieldDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate>

@property (nonatomic) UIButton *cancelButton;
@property (nonatomic) SPNewEventCanvas *eventNewCanvas;
@property (nonatomic) SPAdvancedOptionsCanvas *advancedOptions;
@property (nonatomic) TPKeyboardAvoidingScrollView *keyboard;
@property (nonatomic) UIImage *pickedImage;
@property (nonatomic) UITextField *currentTextField;
@property (nonatomic) BOOL advancedIsOpen;

@property (nonatomic) NSDateComponents *startDateComps;
@property (nonatomic) NSDateComponents *endDateComps;
@property (nonatomic) BOOL endTimeExists;

@property (nonatomic) SPNewEvent *myEvent;

@end

@implementation SPNewEventViewController

- (id)init {
    self = [super init];
    self.startDateComps = [NSDateComponents new];
    self.endDateComps = [NSDateComponents new];
    _endTimeExists = NO;
    
    return self;
}

-(void)loadView{
    [super loadView];
    
    self.myEvent = [SPNewEvent new];
    
    self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    self.eventNewCanvas = [SPNewEventCanvas new];
    self.eventNewCanvas.startTime.delegate = self;
    self.eventNewCanvas.endTime.delegate = self;
    self.eventNewCanvas.day.delegate = self;
    
    self.advancedIsOpen = NO;
    self.advancedOptions = [SPAdvancedOptionsCanvas new];
    [self addAdvancedOptionsGesture];
    
    [self.eventNewCanvas addSubview:self.advancedOptions];
    [self.eventNewCanvas bringSubviewToFront:self.eventNewCanvas.createEvent];
    
    [self.eventNewCanvas.createEvent addTarget:self action:@selector(createEventPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.eventNewCanvas];
    [self.view addSubview:self.cancelButton];
    
    [self setCharacteristics];
    [self setConstraints];
    
}

-(void)addAdvancedOptionsGesture{
    UITapGestureRecognizer *advancedOptionsTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(advancedOptionsTapped:)];
    
    [self.advancedOptions.advancedLabel addGestureRecognizer:advancedOptionsTap];
}

#pragma mark - setup methods

-(void)setCharacteristics{

    [self setupBackgroundWithColor:[UIColor whiteColor] andAlpha:1.0];
    [self setupImageButton];
    [self setupCancelButtonWithTitle:@"Cancel" andFont:[UIFont fontWithName:kSPDefaultFont size:kSPDefaultNavButtonFontSize]];
    
    UIToolbar *keyboardToolbar = [UIToolbar new];
    keyboardToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
    [keyboardToolbar setBarStyle:UIBarStyleDefault];
    
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(formatDate:)];
    [done setTintColor:[UIColor blackColor]];
    [keyboardToolbar setItems:[[NSArray alloc] initWithObjects: flexSpace, done, nil]];
    
    self.eventNewCanvas.startTime.inputAccessoryView = keyboardToolbar;
    self.eventNewCanvas.endTime.inputAccessoryView = keyboardToolbar;
    self.eventNewCanvas.day.inputAccessoryView = keyboardToolbar;

}

-(void)formatDate:(id)sender{
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    if(self.currentTextField == self.eventNewCanvas.day){
        [dateFormatter setDateFormat:@"MMM d"];
        UIPickerView *datePicker = (UIPickerView *)self.currentTextField.inputView;
        
        NSCalendar *cal = [NSCalendar currentCalendar];
        NSDateComponents *current = [cal components:NSMonthCalendarUnit | NSDayCalendarUnit | NSYearCalendarUnit fromDate:[NSDate new]];
        
        NSInteger month = [datePicker selectedRowInComponent:0] + [current month];
        NSInteger year = [current year];
        if(month > 12){
            month -= 12;
            [_startDateComps setYear:year+1]; //Event is next year
            [_endDateComps setYear:year+1];
        }else{
            [_startDateComps setYear:year];
            [_endDateComps setYear:year];
        }
        
        NSInteger day = [datePicker selectedRowInComponent:1] + 1;
        
        if(month == [current month])
            day += [current day] - 1;
        
        [_startDateComps setMonth:month];
        [_startDateComps setDay:day];
        [_endDateComps setMonth:month];
        [_endDateComps setDay:day];
        
        NSDate *date = [gregorian dateFromComponents:_startDateComps];
    
        self.currentTextField.text = [dateFormatter stringFromDate:date];
    }else{
        [dateFormatter setDateFormat:kSPTimeFormat];
        UIDatePicker *datePicker = (UIDatePicker *)self.currentTextField.inputView;
        NSDateComponents *timeComponents = [gregorian components:NSHourCalendarUnit | NSMinuteCalendarUnit fromDate:datePicker.date];
        
        if(self.currentTextField == self.eventNewCanvas.startTime){
            [_startDateComps setMinute:[timeComponents minute]];
            [_startDateComps setHour:[timeComponents hour]];
        }else{
            [_endDateComps setMinute:[timeComponents minute]];
            [_endDateComps setHour:[timeComponents hour]];
            _endTimeExists = YES;
        }
        
        self.currentTextField.text = [dateFormatter stringFromDate:datePicker.date];
    }
    
    [self.currentTextField resignFirstResponder];
}


-(void)setupBackgroundWithColor:(UIColor *)color andAlpha:(double)alpha{
    self.view.backgroundColor = color;
    self.view.alpha = alpha;
}

-(void)setupImageButton{
    [self.eventNewCanvas.coverPhoto addTarget:self action:@selector(eventPhotoPressed:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)setupCancelButtonWithTitle:(NSString *)title andFont:(UIFont *)font{
    [self.cancelButton setTitle:title forState:UIControlStateNormal];
    [self.cancelButton.titleLabel setFont:font];
    [self.cancelButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.cancelButton addTarget:self action:@selector(cancelButton:) forControlEvents:UIControlEventTouchUpInside];
    self.cancelButton.titleLabel.textAlignment = NSTextAlignmentCenter;
}

-(void)setConstraints{
    UIView *background = self.eventNewCanvas;
    UIView *cancel = self.cancelButton;
    UIView *advanced = self.advancedOptions;
    UIView *createEvent = self.eventNewCanvas.createEvent;
    
    NSDictionary *views = NSDictionaryOfVariableBindings(background, cancel, advanced, createEvent);
    

    //Constraints on Background, for self.view
    NSArray *backgroundConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[background]-|" options:0 metrics:nil views:views];
    
    backgroundConstraints = [backgroundConstraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[cancel(22)]-5-[background]-|" options:0 metrics:nil views:views]];
    backgroundConstraints = [backgroundConstraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[cancel]-|" options:0 metrics:nil views:views]];
    
    NSArray *createEventConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[advanced]|" options:0 metrics:nil views:views];
    createEventConstraints = [createEventConstraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[advanced(30)][createEvent]" options:0 metrics:nil views:views]];
    
    [self.eventNewCanvas addConstraints:createEventConstraints];
    [self.view addConstraints:backgroundConstraints];
}

#pragma mark - text field delegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesEnded:touches withEvent:event];    
    [self.currentTextField endEditing:YES];
}


-(void)textFieldDidBeginEditing:(UITextField *)textField{
    self.currentTextField = textField;
}

#pragma mark - cancel button

- (void)cancelButton:(id)sender {
    [UIView transitionWithView:self.navigationController.view duration:0.8 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
        [self.navigationController popToRootViewControllerAnimated:NO];
    } completion:nil];
}

#pragma mark - create event button 

- (void)createEventPressed:(id)sender {
    if([self isMissingEventDetails]){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Make sure event has a description and start time" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
    }else{
        [self setupEventWithDetails];
    }
}

-(BOOL)isMissingEventDetails{
    return (self.eventNewCanvas.descriptionTF.text.length == 0 || self.eventNewCanvas.startTime.text.length == 0);
}

-(void)setupEventWithDetails{
    self.myEvent.eventOrganizer = [[PFUser currentUser] objectForKey:kSPUserProfile][kSPUserProfileName];
    self.myEvent.eventDescription = self.eventNewCanvas.descriptionTF.text;
    self.myEvent.eventStartTime = [self formattedDateFromDateComponents:_startDateComps];
    self.myEvent.numAttendees = [NSNumber numberWithInt:1];
    if(_endTimeExists == NO)
        _endDateComps = _startDateComps;
    
    self.myEvent.eventEndTime = [self formattedDateFromDateComponents:_endDateComps];
    self.myEvent.isPublic = [self.advancedOptions.publicSwitch isOn];
    
    NSNumberFormatter *numAttendeeFormatter = [NSNumberFormatter new];
    NSString *maxAttendees = self.advancedOptions.numAttendees.text;
    self.myEvent.maxAttendees = [numAttendeeFormatter numberFromString:maxAttendees];
    
    if(self.myEvent.isPublic)
        [self savePublicEvent];
    else
        [self presentInviteFriends];
}

-(NSDate *)formattedDateFromDateComponents:(NSDateComponents *)dateComponents{
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
            [dateFormatter setDateFormat:kSPTimeFormat];
    
    NSCalendar *gregorian = [[NSCalendar alloc]
            initWithCalendarIdentifier:NSGregorianCalendar];
    
    return [gregorian dateFromComponents:dateComponents];
}

-(BOOL)endTimeIsLessThanStartTime{
    return ([self.myEvent.eventEndTime compare:self.myEvent.eventStartTime] == NSOrderedAscending);
}

-(NSDate *)addDayToDate:(NSDate *)date{
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *dayComponent = [NSDateComponents new];
    dayComponent.day = 1;
    
    return [gregorian dateByAddingComponents:dayComponent toDate:date options:0];
}

-(void)savePublicEvent{
    self.myEvent.eventAttendees = [self retrieveFriends];
    [self.myEvent saveEvent];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(NSArray *)retrieveFriends{
    return [[SPCache sharedCache] facebookFriends];
}

-(void)presentInviteFriends{
    SPInviteFriends *inviteFriendsVC = [[SPInviteFriends alloc] initWithEvent:self.myEvent];
    [self.navigationController pushViewController:inviteFriendsVC animated:YES];
}

#pragma mark - Cover photo helper methods

-(void)promptForSource{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Image Source" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera", @"Photo Roll", nil];
    [actionSheet showInView:self.eventNewCanvas];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{

    if(buttonIndex != actionSheet.cancelButtonIndex){
        if(buttonIndex == actionSheet.firstOtherButtonIndex){
            [self promptForCamera];
        }else{
            [self promptForPhotoRoll];
        }
    }
}

-(void)promptForCamera{
    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
    controller.sourceType = UIImagePickerControllerSourceTypeCamera;
    controller.delegate = self;
    controller.modalPresentationStyle = UIModalPresentationCurrentContext;
    [self presentViewController:controller animated:YES completion:nil];
}

-(void)promptForPhotoRoll{
    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
    controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    controller.delegate = self;
    controller.modalPresentationStyle = UIModalPresentationCurrentContext;
    [self presentViewController:controller animated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    self.pickedImage = image;
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)setPickedImage:(UIImage *)pickedImage{
    _pickedImage = pickedImage;
    if(_pickedImage == nil){
    }else{
        [self.eventNewCanvas.coverPhoto setImage:pickedImage forState:UIControlStateNormal];
    }
}
- (void)eventPhotoPressed:(id)sender {
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        [self promptForSource];
    }else{
        [self promptForPhotoRoll];
    }
}

#pragma mark - Advanced options

-(void)expandAdvancedOptions{
    [UIView animateWithDuration:0.8f animations:^{
        [self.advancedOptions setFrame:CGRectMake(0, 0, self.eventNewCanvas.frame.size.width, (self.eventNewCanvas.frame.size.height-self.eventNewCanvas.createEvent.frame.size.height))];
        [self.advancedOptions setBackgroundColor:[UIColor SPAdvancedOptionsExpandedGray]];
        [self.advancedOptions.maxAttendeesLabel setAlpha:1.0];
        } completion:^(BOOL finished) {
    }];
}

-(void)collapseAdvancedOptions{
    [UIView animateWithDuration:0.8f animations:^{
        [self.advancedOptions setFrame:CGRectMake(0, self.eventNewCanvas.createEvent.frame.origin.y-30, self.eventNewCanvas.frame.size.width, 30)];
        [self.advancedOptions setBackgroundColor:[UIColor SPAdvancedOptionsCollapsedGray]];
        [self.advancedOptions.maxAttendeesLabel setAlpha:0.9f];
        } completion:^(BOOL finished) {
    }];
}

-(void)advancedOptionsTapped:(id)sender{
    if(self.advancedIsOpen){
        [self collapseAdvancedOptions];
        self.advancedIsOpen = NO;
    }else{
        [self expandAdvancedOptions];
        self.advancedIsOpen = YES;
    }
}

@end
