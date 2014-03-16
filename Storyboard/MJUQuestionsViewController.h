//
//  MJUQuestionsViewController.h
//  Storyboard
//
//  Created by Martin Juhasz on 16/11/13.
//  Copyright (c) 2013 Martin Juhasz. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MJUProject;
@class MJUQuestionCategory;


@interface MJUQuestionsViewController : UITableViewController<NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) MJUProject *project;
@property (strong, nonatomic) MJUQuestionCategory *category;
@property (strong, nonatomic) NSString *plist;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@end
