//
//  MJUSortedDataTableViewController.h
//  Storyboard
//
//  Created by Martin Juhasz on 12/03/14.
//  Copyright (c) 2014 Martin Juhasz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MJUSortedDataTableViewController : UITableViewController<NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

- (void)saveOrder;
- (void)saveOrderToItems:(NSArray*)items;

@end
