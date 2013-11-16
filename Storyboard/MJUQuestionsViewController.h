//
//  MJUQuestionsViewController.h
//  Storyboard
//
//  Created by Martin Juhasz on 16/11/13.
//  Copyright (c) 2013 Martin Juhasz. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MJUQuestionHelper;
@class MJUProject;


@interface MJUQuestionsViewController : UITableViewController

@property (strong, nonatomic) MJUProject *project;
@property (strong, nonatomic) MJUQuestionHelper *questionHelper;

@end
