//
//  MJUProjectsViewController.h
//  Storyboard
//
//  Created by Martin Juhasz on 02/11/13.
//  Copyright (c) 2013 Martin Juhasz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJUCollectionViewController.h"

@interface MJUProjectsViewController : MJUCollectionViewController<UIGestureRecognizerDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@end
