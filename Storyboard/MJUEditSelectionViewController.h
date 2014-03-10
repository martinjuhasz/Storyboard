//
//  MJUEditSelectionViewController.h
//  Storyboard
//
//  Created by Martin Juhasz on 10/03/14.
//  Copyright (c) 2014 Martin Juhasz. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MJUSelectableQuestion;

@interface MJUEditSelectionViewController : UITableViewController<NSFetchedResultsControllerDelegate, UIActionSheetDelegate>

@property (strong, nonatomic) MJUSelectableQuestion *question;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@end
