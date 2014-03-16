//
//  MJUCategoryInputViewController.h
//  Storyboard
//
//  Created by Martin Juhasz on 13/03/14.
//  Copyright (c) 2014 Martin Juhasz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJUTitleInputViewController.h"
#import "MJUQuestionCategory.h"

@interface MJUCategoryInputViewController : MJUTitleInputViewController

@property (nonatomic, copy) void (^saveCategoryBlock)(NSString *enteredString, MJUQuestionCategoryIcon icon);
@property (assign, nonatomic) MJUQuestionCategoryIcon categoryIcon;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;

@end
