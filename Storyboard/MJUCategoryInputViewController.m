//
//  MJUCategoryInputViewController.m
//  Storyboard
//
//  Created by Martin Juhasz on 13/03/14.
//  Copyright (c) 2014 Martin Juhasz. All rights reserved.
//

#import "MJUCategoryInputViewController.h"


@interface MJUCategoryInputViewController ()

@end

@implementation MJUCategoryInputViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if(self.categoryIcon) {
        self.iconView.image = [MJUQuestionCategory icon:self.categoryIcon];
    }
}

- (IBAction)didSelectIcon:(id)sender
{
    if(![sender isKindOfClass:[UIButton class]]) return;
    
    int icon = (int)((UIButton*)sender).tag - 3100;
    if(icon >= 0) {
        self.iconView.image = [MJUQuestionCategory icon:icon];
        self.categoryIcon = icon;
    }
    
}

- (IBAction)saveButtonClicked:(id)sender
{
    if(self.saveCategoryBlock) {
        self.saveCategoryBlock(self.titleCell.textInput.text, self.categoryIcon);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
