//
//  SPNewEventViewController.m
//  SocialPass
//
//  Created by Alexander Athan on 6/22/14.
//  Copyright (c) 2014 Dolo. All rights reserved.
//

#import "SPNewEventViewController.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "SPEvent.h"
#import "SPCoreDataStack.h"
#import "SPNewEventCanvas.h"
#import "SPAdvancedOptionsCanvas.h"

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
    [self setupCancelButtonWithTitle:@"Cancel" andFont:[UIFont fontWithName:@"Avenir-Light" size:17.0f]];
    
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
        NSDateComponents *current = [cal components:NSMonthCalendarUnit | NSDayCalendarUnit fromDate:[NSDate new]];
        
        NSInteger month = [datePicker selectedRowInComponent:0] + [current month];
        if(month > 12)
            month -= 12;
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
        [dateFormatter setDateFormat:@"h:mm a"];
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
    
    backgroundConstraints = [backgroundConstraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[cancel(22)]-5-[background]-|" options:0 metrics:nil views:views]];
    backgroundConstraints = [backgroundConstraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[cancel]-20-|" options:0 metrics:nil views:views]];
    
    NSArray *createEventConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[advanced]|" options:0 metrics:nil views:views];
    createEventConstraints = [createEventConstraints arrayByAddingObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[advanced(30)][createEvent(55)]" options:0 metrics:nil views:views]];
    
    [self.eventNewCanvas addConstraints:createEventConstraints];
    [self.view addConstraints:backgroundConstraints];
    
    //Event info constraints
    
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
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark - create event button 

- (void)createEventPressed:(id)sender {
    NSLog(@"Did tap create event");
    if((self.eventNewCanvas.descriptionTF.text.length == 0) || (self.eventNewCanvas.startTime.text.length == 0)){
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Make sure event has a description and start time" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
        
    }else{
       
        //Initialize attendee information
        NSNumberFormatter *numAttendeeFormatter = [NSNumberFormatter new];
        NSNumber *maxAttendees = [numAttendeeFormatter numberFromString:self.advancedOptions.numAttendees.text];
        NSNumber *isPublicNum = [NSNumber numberWithBool:[self.advancedOptions.publicSwitch isOn]];
        
        NSMutableArray *attendeeList = [[NSMutableArray alloc] initWithObjects:[PFUser currentUser].objectId, nil];
        
        NSString *description = self.eventNewCanvas.descriptionTF.text;
        
        //Start and end time
        NSDateFormatter *dateFormatter = [NSDateFormatter new];
        [dateFormatter setDateFormat:@"hh:mm a"];
        
        NSCalendar *gregorian = [[NSCalendar alloc]
                                 initWithCalendarIdentifier:NSGregorianCalendar];
        
        NSDate *startTime = [gregorian dateFromComponents:_startDateComps];
        NSDate *endTime = [gregorian dateFromComponents:_endDateComps];
        
        if((_startDateComps.hour == _endDateComps.hour) && (_startDateComps.minute == _endDateComps.minute) && _endTimeExists){
            NSDateComponents *dayComponent = [NSDateComponents new];
            dayComponent.day = 1;
            
            endTime = [gregorian dateByAddingComponents:dayComponent toDate:endTime options:0];
        }
        
        //Set event photo
        NSData *eventPhotoData = UIImageJPEGRepresentation(self.pickedImage, 0.2);
        PFFile *eventPhoto = [PFFile fileWithData:eventPhotoData];
        PFObject *event = [PFObject objectWithClassName:@"Event"];
        
        [event setObject:[PFUser currentUser].objectId forKey:@"OrganizerID"];
        [event setObject:attendeeList forKey:@"AttendeeList"];
        [event setObject:description forKey:@"Description"];
        [event setObject:startTime forKey:@"StartTime"];
        if(_endTimeExists){
            [event setObject:endTime forKey:@"EndTime"];
        } else {
            [event setObject:startTime forKey:@"EndTime"];
        }
        [event setObject:maxAttendees forKey:@"MaxAttendees"];
        [event setObject:isPublicNum forKey:@"IsPublic"];
        [event setObject:eventPhoto forKey:@"EventPhoto"];
        [event setObject:[[PFUser currentUser] objectForKey:@"profile"][@"name"] forKey:@"organizerName"];
        
        PFACL *ACL = [PFACL ACLWithUser:[PFUser currentUser]];
        [ACL setPublicReadAccess:YES];
        [ACL setPublicWriteAccess:YES];
        event.ACL = ACL;
        
        [event saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            NSLog(@"Saving");
        }];
        
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
}

#pragma mark - Cover photo helper methods

//********COVER PHOTO PICKER****************
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
        //[self.advancedOptions setFrame:CGRectMake(0, self.imageButton.frame.origin.y+self.imageButton.frame.size.height+5, self.background.frame.size.width, self.createEventButton.frame.origin.y - (self.imageButton.frame.origin.y+self.imageButton.frame.size.height))];
        [self.advancedOptions setBackgroundColor:[UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:0.98f]];
        [self.advancedOptions.maxAttendeesLabel setAlpha:1.0];
        } completion:^(BOOL finished) {
        }];
}

-(void)collapseAdvancedOptions{
    [UIView animateWithDuration:0.8f animations:^{
        [self.advancedOptions setFrame:CGRectMake(0, self.eventNewCanvas.createEvent.frame.origin.y-30, self.eventNewCanvas.frame.size.width, 30)];
        [self.advancedOptions setBackgroundColor:[UIColor colorWithRed:220.0/255.0 green:220.0/255.0 blue:220.0/255.0 alpha:0.9f]];
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
