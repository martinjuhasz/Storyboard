//
//  MJUStoryboardViewController.h
//  Storyboard
//
//  Created by Martin Juhasz on 03/11/13.
//  Copyright (c) 2013 Martin Juhasz. All rights reserved.
//

#import "MJUCollectionViewController.h"

@class MJUProject;

@interface MJUStoryboardViewController : MJUCollectionViewController<UIGestureRecognizerDelegate>

@property (nonatomic, strong) MJUProject *project;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@end
