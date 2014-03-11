//
//  MJUQuestionSelectionViewController.h
//  Storyboard
//
//  Created by Martin Juhasz on 16/11/13.
//  Copyright (c) 2013 Martin Juhasz. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MJUSelectableQuestion;
@class MJUAnswer;
@class MJUProject;

@interface MJUQuestionSelectionViewController : UITableViewController<NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) MJUSelectableQuestion *question;
@property (strong, nonatomic) MJUProject *project;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@end
