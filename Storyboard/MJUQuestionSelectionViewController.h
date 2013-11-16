//
//  MJUQuestionSelectionViewController.h
//  Storyboard
//
//  Created by Martin Juhasz on 16/11/13.
//  Copyright (c) 2013 Martin Juhasz. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MJUSubQuestion;
@class MJUAnswer;
@class MJUProject;

@interface MJUQuestionSelectionViewController : UITableViewController

@property (strong, nonatomic) MJUAnswer *answer;
@property (strong, nonatomic) MJUSubQuestion *question;
@property (strong, nonatomic) MJUProject *project;

@end
