//
//  MJUStoryboardViewController.m
//  Storyboard
//
//  Created by Martin Juhasz on 03/11/13.
//  Copyright (c) 2013 Martin Juhasz. All rights reserved.
//

#import "MJUStoryboardViewController.h"
#import "MJUProject.h"
#import "MJUScene.h"
#import "MJUProjectsDataModel.h"
#import "MJUSceneViewController.h"

@interface MJUStoryboardViewController ()

@end

@implementation MJUStoryboardViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // Gesture Recognizer for Delete
    UILongPressGestureRecognizer *deleteRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    deleteRecognizer.minimumPressDuration = 1.0;
    deleteRecognizer.delegate = self;
    [self.collectionView addGestureRecognizer:deleteRecognizer];
    
}


#pragma mark -
#pragma mark Button Actions

- (IBAction)addButtonClicked:(id)sender
{
    NSManagedObjectContext *context = [[MJUProjectsDataModel sharedDataModel] mainContext];
    MJUScene *scene = (MJUScene *)[NSEntityDescription insertNewObjectForEntityForName:@"MJUScene" inManagedObjectContext:context];
    scene.order = [[[self fetchedResultsController] fetchedObjects] count];
    [self.project addScenesObject:scene];
    [context save:nil];
    [self saveOrderToItems];
}

-(void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) return;
    
    
    CGPoint p = [gestureRecognizer locationInView:self.collectionView];
    
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:p];
    if (indexPath == nil) return;
    
    MJUScene *scene = [[self fetchedResultsController] objectAtIndexPath:indexPath];
    [[[MJUProjectsDataModel sharedDataModel] mainContext] deleteObject:scene];
    [[[MJUProjectsDataModel sharedDataModel] mainContext] save:nil];
    [self saveOrderToItems];
}


#pragma mark -
#pragma mark UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"SceneDetailSegue" sender:indexPath];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"SceneDetailSegue"]) {
        MJUSceneViewController *sceneViewController = [segue destinationViewController];
        sceneViewController.scene = [[self fetchedResultsController] objectAtIndexPath:(NSIndexPath*)sender];
    }
}


#pragma mark -
#pragma mark UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [[[self fetchedResultsController] sections] count];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    id<NSFetchedResultsSectionInfo> sectionInfo = [[[self fetchedResultsController] sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

//// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SceneCell" forIndexPath:indexPath];
    MJUScene *currentScene = [[self fetchedResultsController] objectAtIndexPath:indexPath];
    UILabel *titleLabel = (UILabel*)[cell viewWithTag:1301];
    
    titleLabel.text = [NSString stringWithFormat:@"Scene #%d", currentScene.order+1];
    
    return cell;
}



- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 10, 10, 10);
}


#pragma mark -
#pragma mark Core Data

- (void)saveOrderToItems
{
    int count = 0;
    NSArray *items = [[self fetchedResultsController] fetchedObjects];
    for (MJUScene *scene in items) {
        scene.order = count++;
    }
    [[[MJUProjectsDataModel sharedDataModel] mainContext] save:nil];
}


- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController == nil)
    {
        _fetchedResultsController = [self newFetchedResultsController];
    }
    return _fetchedResultsController;
}

- (NSFetchedResultsController *)newFetchedResultsController
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"MJUScene"];
    NSSortDescriptor *sortByName = [NSSortDescriptor sortDescriptorWithKey:@"order" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortByName]];
    
    NSPredicate *projectPredicate = [NSPredicate predicateWithFormat:@"project == %@", self.project];
    [fetchRequest setPredicate:projectPredicate];
    
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[[MJUProjectsDataModel sharedDataModel] mainContext] sectionNameKeyPath:Nil cacheName:nil];
    
    aFetchedResultsController.delegate = self;
    
    NSError *error = nil;
    if (![aFetchedResultsController performFetch:&error]) {
        NSLog(@"%@, %@", error, [error userInfo]);
    }
    
    return aFetchedResultsController;
}


@end
