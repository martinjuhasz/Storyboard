//
//  MJUEditQuestionsViewController.h
//  Storyboard
//
//  Created by Martin Juhasz on 09/03/14.
//  Copyright (c) 2014 Martin Juhasz. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MJUQuestionSection;

@interface MJUEditQuestionsViewController : UITableViewController<NSFetchedResultsControllerDelegate, UIActionSheetDelegate>

@property (strong, nonatomic) MJUQuestionSection *section;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@end
