//
//  MJUEditCategoriesTableViewController.h
//  Storyboard
//
//  Created by Martin Juhasz on 17/01/14.
//  Copyright (c) 2014 Martin Juhasz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MJUEditCategoriesTableViewController : UITableViewController<NSFetchedResultsControllerDelegate, UIActionSheetDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@end
