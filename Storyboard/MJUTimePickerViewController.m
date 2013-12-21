//
//  MJUTimePickerViewController.m
//  Storyboard
//
//  Created by Martin Juhasz on 07/12/13.
//  Copyright (c) 2013 Martin Juhasz. All rights reserved.
//

#import "MJUTimePickerViewController.h"

@interface MJUTimePickerViewController ()

@end

@implementation MJUTimePickerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    if(self.presetTime) {
        int minutes = [self.presetTime intValue] / 60;
        int seconds = [self.presetTime intValue] % 60;
        [self.pickerView selectRow:minutes inComponent:0 animated:NO];
        [self.pickerView selectRow:seconds inComponent:2 animated:NO];
        [self setTimeLabelTextWithMinutes:minutes seconds:seconds];
    }
}

- (void)setTimeLabelTextWithMinutes:(NSUInteger)minutes seconds:(NSUInteger)seconds
{
     self.timeLabel.text = [NSString stringWithFormat:@"%02lu min %02lu sec", (unsigned long)minutes, (unsigned long)seconds];
}


#pragma mark -
#pragma mark UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 4;
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    // min + sec title
    if(component == 1 || component == 3) {
        return 1;
    }
    
    // min
    if(component == 0) {
        return 100;
    }
    
    return 60;
}



#pragma mark -
#pragma mark UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if(component == 1) {
        return @"min";
    } else if(component == 3) {
        return @"sec";
    }
    
    return [NSString stringWithFormat:@"%02ld", (long)row];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    // min + sec title
    if(component == 1 || component == 3) {
        return 100.0f;
    }
    
    return 50.0f;
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [self setTimeLabelTextWithMinutes:[pickerView selectedRowInComponent:0] seconds:[pickerView selectedRowInComponent:2]];
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(didSelectTimeWithMinute:second:)]) {
        [self.delegate didSelectTimeWithMinute:[pickerView selectedRowInComponent:0] second:[pickerView selectedRowInComponent:2]];
    }
}


@end
