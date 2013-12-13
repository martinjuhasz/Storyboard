//
//  MJUTimePickerViewController.h
//  Storyboard
//
//  Created by Martin Juhasz on 07/12/13.
//  Copyright (c) 2013 Martin Juhasz. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MJUTimePickerViewController;

@protocol MJUTimePickerDelegate<NSObject>
@optional
- (void)didSelectTimeWithMinute:(NSUInteger)minute second:(NSUInteger)second;
@end

@interface MJUTimePickerViewController : UIViewController<UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (strong, nonatomic) NSNumber *presetTime;
@property (nonatomic, weak) id <MJUTimePickerDelegate> delegate;

@end
