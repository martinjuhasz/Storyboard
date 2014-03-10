//
//  MJUEditSectionsViewController.h
//  Storyboard
//
//  Created by Martin Juhasz on 09/03/14.
//  Copyright (c) 2014 Martin Juhasz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJUQuestionCategory.h"

@interface MJUEditSectionsViewController : UITableViewController<NSFetchedResultsControllerDelegate, UIActionSheetDelegate>

@property (strong, nonatomic) MJUQuestionCategory *category;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@end
