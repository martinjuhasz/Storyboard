//
//  MJUSortedDataTableViewController.m
//  Storyboard
//
//  Created by Martin Juhasz on 12/03/14.
//  Copyright (c) 2014 Martin Juhasz. All rights reserved.
//

#import "MJUSortedDataTableViewController.h"
#import "MJUProjectsDataModel.h"
#import "UIAlertView+BlocksKit.h"

@interface MJUSortedDataTableViewController () {
    bool userDrivenModelChange;
}

@end

@implementation MJUSortedDataTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    userDrivenModelChange = NO;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if(self.tableView.editing) {
        self.tableView.editing = NO;
    }
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

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Delete", nil)
                                                            message:NSLocalizedString(@"After deletation all related answers in all projects will be irrevocably deleted. Are you sure you want to delete?", nil)
                                                           delegate:nil
                                                  cancelButtonTitle:NSLocalizedString(@"cancel", nil)
                                                  otherButtonTitles:NSLocalizedString(@"delete", nil), nil];
        
        [alertView bk_setDidDismissBlock:^(UIAlertView *av, NSInteger i) {
            self.tableView.editing = NO;
        }];
        
        [alertView bk_setHandler:^{
            NSManagedObject *selectedObject = [[self fetchedResultsController] objectAtIndexPath:indexPath];
            [[[MJUProjectsDataModel sharedDataModel] mainContext] deleteObject:selectedObject];
            NSError *error;
            [[[MJUProjectsDataModel sharedDataModel] mainContext] save:&error];
            if(error) {
                NSLog(@"%@", [error localizedDescription]);
            }
            [self saveOrder];
        } forButtonAtIndex:1];
        
        [alertView show];

    }
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
}

- (void)updateCell:(UITableViewCell*)cell atIndexPath:(NSIndexPath*)indexPath
{

}





#pragma mark -
#pragma mark CoreData

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController == nil)
    {
        _fetchedResultsController = [self newFetchedResultsController];
        _fetchedResultsController.delegate = self;
    }
    return _fetchedResultsController;
}

- (NSFetchedResultsController *)newFetchedResultsController
{
    return nil;
}



#pragma mark -
#pragma mark Sorting

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
    NSError *error;
    [[[MJUProjectsDataModel sharedDataModel] mainContext] save:&error];
    if(error) {
        NSLog(@"%@", [error localizedDescription]);
    }
    userDrivenModelChange = NO;
    [self.tableView reloadData];
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
