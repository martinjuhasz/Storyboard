//
//  MJUEditQuestionsViewController.h
//  Storyboard
//
//  Created by Martin Juhasz on 09/03/14.
//  Copyright (c) 2014 Martin Juhasz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJUSortedDataTableViewController.h"

@class MJUQuestionSection;

@interface MJUEditQuestionsViewController : MJUSortedDataTableViewController<UIActionSheetDelegate>

@property (strong, nonatomic) MJUQuestionSection *section;

@end
