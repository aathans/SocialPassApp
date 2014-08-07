//
//  SPDayMonth.m
//  SocialPass
//
//  Created by Alexander Athan on 8/6/14.
//  Copyright (c) 2014 Dolo. All rights reserved.
//

#import "SPDayMonth.h"

@interface SPDayMonth()

@property (nonatomic) NSArray *monthNames;

@end

@implementation SPDayMonth

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.delegate = self;
        
        NSDateFormatter * df = [[NSDateFormatter alloc] init];
        [df setLocale:[[NSLocale alloc] initWithLocaleIdentifier:[[NSLocale preferredLanguages] objectAtIndex:0]]];
        
        self.monthNames = [df monthSymbols];

        self.showsSelectionIndicator = YES;
        
    }
    
    return self;
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

-(NSInteger)pickerView:pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSUInteger number = 0;
    if (component == 0) {
        number = 6;
    } else {
        NSDateComponents *comps = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:[NSDate date]];
        
        NSUInteger month = [pickerView selectedRowInComponent:0]+[comps month];
        if(month > 12)
            month = month - 12;
        
        NSUInteger actualYear = [comps year];
        
        NSUInteger day = 1;
        if(month == [comps month])
            day = [comps day];
        
        NSDateComponents *selectMothComps = [[NSDateComponents alloc] init];
        selectMothComps.year = actualYear;
        selectMothComps.month = month;
        selectMothComps.day = day;
        
        NSDateComponents *nextMothComps = [[NSDateComponents alloc] init];
        nextMothComps.year = actualYear;
        nextMothComps.month = month+1;
        nextMothComps.day = 1;
        
        NSDate *thisMonthDate = [[NSCalendar currentCalendar] dateFromComponents:selectMothComps];
        NSDate *nextMonthDate = [[NSCalendar currentCalendar] dateFromComponents:nextMothComps];
        
        NSDateComponents *differnce = [[NSCalendar currentCalendar]  components:NSDayCalendarUnit
                                                                       fromDate:thisMonthDate
                                                                         toDate:nextMonthDate
                                                                        options:0];
        
        number = [differnce day];
    }
    
    return number;
}

-(void)pickerView:pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {
        [pickerView reloadComponent:1];
        [pickerView selectRow:0 inComponent:1 animated:NO];
    }
    
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *result;
    
    NSDate *currentDate = [NSDate new];

    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *comps = [cal components:NSMonthCalendarUnit | NSDayCalendarUnit fromDate:currentDate];
    
    if (component == 0) {

        NSInteger index = row + comps.month - 1;
        if(index > 11){
            index = index - 12;
        }
        
        result = [self.monthNames objectAtIndex:index];
    } else {
        if ([pickerView selectedRowInComponent:0] == 0)
            result = [NSString stringWithFormat:@"%d", comps.day+row];
        else
            result = [NSString stringWithFormat:@"%d", row + 1];
    }
    
    return result;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
