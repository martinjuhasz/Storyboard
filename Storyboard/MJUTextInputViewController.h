//
//  MJUTextInputViewController.h
//  Storyboard
//
//  Created by Martin Juhasz on 10/11/13.
//  Copyright (c) 2013 Martin Juhasz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MJUTextInputViewController : UIViewController

@property (strong, nonatomic) NSString *inputText;
@property (nonatomic, copy) void (^saveString)(NSString *enteredString);
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *keyboardHeightContraint;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end
