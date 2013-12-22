//
//  MJUTextInputViewController.m
//  Storyboard
//
//  Created by Martin Juhasz on 10/11/13.
//  Copyright (c) 2013 Martin Juhasz. All rights reserved.
//

#import "MJUTextInputViewController.h"

@interface MJUTextInputViewController ()

@end

@implementation MJUTextInputViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.textView.textContainerInset = UIEdgeInsetsMake(15.0f, 10.0f, 15.0f, 10.0f);
    self.textView.text = self.inputText;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    
    [self.textView becomeFirstResponder];
}

- (IBAction)cancelButtonClicked:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)saveButtonClicked:(id)sender
{
    if(self.saveString) {
        self.saveString(self.textView.text);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary *info = [notification userInfo];
    NSValue *kbFrame = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    NSTimeInterval animationDuration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect keyboardFrame = [kbFrame CGRectValue];
    
    BOOL isPortrait = UIDeviceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation);
    CGFloat height = isPortrait ? keyboardFrame.size.height : keyboardFrame.size.width;

    
    self.keyboardHeightContraint.constant = height + 1.0f;
    
    [UIView animateWithDuration:animationDuration animations:^{
        [self.view layoutIfNeeded];
    }completion:^(BOOL finished) {
        self.textView.scrollEnabled = NO;
        self.textView.scrollEnabled = YES;
    }];
}

@end
