//
//  MJUScenesTableViewController.m
//  Storyboard
//
//  Created by Martin Juhasz on 08/11/13.
//  Copyright (c) 2013 Martin Juhasz. All rights reserved.
//

#import "MJUScenesTableViewController.h"
#import "MJUProject.h"
#import "MJUScene.h"
#import "MJUProjectsDataModel.h"
#import "MJUSceneViewController.h"

@interface MJUScenesTableViewController () {
    bool userDrivenModelChange;
}
@end

@implementation MJUScenesTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    userDrivenModelChange = NO;
    
    // Bar Button Items
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addButtonClicked:)];
    UIBarButtonItem *moveButon = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:self action:@selector(moveButtonClicked:)];
    self.navigationItem.rightBarButtonItems = @[addButton, moveButon];
}

#pragma mark -
#pragma mark Button Actions

- (IBAction)addButtonClicked:(id)sender
{
    NSManagedObjectContext *context = [[MJUProjectsDataModel sharedDataModel] mainContext];
    MJUScene *scene = (MJUScene *)[NSEntityDescription insertNewObjectForEntityForName:@"MJUScene" inManagedObjectContext:context];
    
    int lowerBound = 1;
    int upperBound = 100;
    int rndValue = lowerBound + arc4random() % (upperBound - lowerBound);
    
    scene.imageText = [NSString stringWithFormat:@"%d", rndValue];
    scene.order = [[[self fetchedResultsController] fetchedObjects] count];
    [self.project addScenesObject:scene];
    [context save:nil];
    [self saveOrder];
}

- (IBAction)moveButtonClicked:(id)sender
{
    [self.tableView setEditing:!self.tableView.editing animated:YES];
}



#pragma mark -
#pragma mark UITableViewDelegate

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"SceneDetailSegue"]) {
        MJUSceneViewController *sceneViewController = [segue destinationViewController];
        sceneViewController.scene = [[self fetchedResultsController] objectAtIndexPath:(NSIndexPath*)sender];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"SceneDetailSegue" sender:indexPath];
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[[self fetchedResultsController] sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id<NSFetchedResultsSectionInfo> sectionInfo = [[[self fetchedResultsController] sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SceneCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    [self updateCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)updateCell:(UITableViewCell*)cell atIndexPath:(NSIndexPath*)indexPath
{
    MJUScene *currentScene = [[self fetchedResultsController] objectAtIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"Scene #%@", currentScene.imageText];
}

#pragma mark Deleting

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        MJUScene *scene = [[self fetchedResultsController] objectAtIndexPath:indexPath];
        [[[MJUProjectsDataModel sharedDataModel] mainContext] deleteObject:scene];
        [[[MJUProjectsDataModel sharedDataModel] mainContext] save:nil];
        [self saveOrder];
    }
}

#pragma mark Moving

- (UITableViewCellEditingStyle) tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.tableView.editing) {
        return UITableViewCellEditingStyleNone;
    }
    return UITableViewCellEditingStyleDelete;
}

- (BOOL) tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void) tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    NSMutableArray *things = [[self.fetchedResultsController fetchedObjects] mutableCopy];
    NSManagedObject *thing = [[self fetchedResultsController] objectAtIndexPath:sourceIndexPath];
    
    [things removeObject:thing];
    [things insertObject:thing atIndex:[destinationIndexPath row]];
    
    [self saveOrderToItems:things];

    
    
    
    
//    NSUInteger fromIndex = sourceIndexPath.row;
//    NSUInteger toIndex = destinationIndexPath.row;
//    
//    if (fromIndex == toIndex) {
//        return;
//    }
//    
//    MJUScene *affectedObject = [self.fetchedResultsController.fetchedObjects objectAtIndex:fromIndex];
//    affectedObject.order = toIndex;
//    
//    NSUInteger start, end;
//    int delta;
//    
//    if (fromIndex < toIndex) {
//        // move was down, need to shift up
//        delta = -1;
//        start = fromIndex + 1;
//        end = toIndex;
//    } else { // fromIndex > toIndex
//        // move was up, need to shift down
//        delta = 1;
//        start = toIndex;
//        end = fromIndex - 1;
//    }
//    
//    for (NSUInteger i = start; i <= end; i++) {
//        MJUScene *otherObject = [self.fetchedResultsController.fetchedObjects objectAtIndex:i];
//        otherObject.order += delta;
//    }
//    
//    userDrivenModelChange = YES;
//    [[[MJUProjectsDataModel sharedDataModel] mainContext] save:nil];
//    userDrivenModelChange = NO;
    
}


#pragma mark -
#pragma mark Core Data

- (void)saveOrder
{
    NSArray *items = [[self fetchedResultsController] fetchedObjects];
    [self saveOrderToItems:items];
}

- (void)saveOrderToItems:(NSArray*)items
{
    int i = 0;
    for (NSManagedObject *mo in items) {
        [mo setValue:[NSNumber numberWithInt:i++] forKey:@"order"];
    }
    userDrivenModelChange = YES;
    [[[MJUProjectsDataModel sharedDataModel] mainContext] save:nil];
    userDrivenModelChange = NO;
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


#pragma mark -
#pragma mark NSFetchedResultsControllerDelegate

-(void) controllerWillChangeContent:(NSFetchedResultsController *)controller {
    if(userDrivenModelChange) return;
    [self.tableView beginUpdates];
}

-(void) controllerDidChangeContent:(NSFetchedResultsController *)controller {
    if(userDrivenModelChange) return;
    [self.tableView endUpdates];
}

-(void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    
    if(userDrivenModelChange) return;
    
    UITableView *tableView = self.tableView;
    
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate: {
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            [self updateCell:cell atIndexPath:indexPath];
        }
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

-(void) controller:(NSFetchedResultsController *)controller didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    if(userDrivenModelChange) return;
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


@end