//
//  MJUScenesTableViewController.h
//  Storyboard
//
//  Created by Martin Juhasz on 08/11/13.
//  Copyright (c) 2013 Martin Juhasz. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MJUProject;

@interface MJUScenesTableViewController : UITableViewController<NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) MJUProject *project;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) UILabel *totalTimeLabel;
@property (strong, nonatomic) UIBarButtonItem *editModeButton;

@end
