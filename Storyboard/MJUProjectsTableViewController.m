//
//  MJUProjectsTableViewController.m
//  Storyboard
//
//  Created by Martin Juhasz on 08/11/13.
//  Copyright (c) 2013 Martin Juhasz. All rights reserved.
//

#import "MJUProjectsTableViewController.h"
#import "MJUProjectsDataModel.h"
#import "MJUProject.h"
#import "MJUProjectViewController.h"
#import "UITableView+NXEmptyView.h"
#import "UITableView+Additions.h"
#import "MJUProjectCell.h"
#import "UIColor+Additions.h"

@interface MJUProjectsTableViewController ()

@end

@implementation MJUProjectsTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView hideEmptyCells];
    
    // load emtpy view
    UIView *emptyView = [[[NSBundle mainBundle] loadNibNamed:@"EmptyProjectView" owner:self options:nil] objectAtIndex:0];
    self.tableView.nxEV_emptyView = emptyView;

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if(IS_IPAD) {
        [self.navigationController performSegueWithIdentifier:@"DefaultDetailSegue" sender:self];
    }
}

#pragma mark -
#pragma mark Button Actions

- (IBAction)addButtonClicked:(id)sender
{
    NSManagedObjectContext *context = [[MJUProjectsDataModel sharedDataModel] mainContext];
    MJUProject *project = (MJUProject *)[NSEntityDescription insertNewObjectForEntityForName:@"MJUProject" inManagedObjectContext:context];
    
    project.title = [NSString stringWithFormat:@"Project #%d", ((int)[[[self fetchedResultsController] fetchedObjects] count]) + 1];
    
    [context save:nil];
}



#pragma mark -
#pragma mark UITableViewDelegate

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if(![sender isKindOfClass:[MJUProject class]]) return;
    
    if ([[segue identifier] isEqualToString:@"ProjectDetailSegue"]) {
        MJUProjectViewController *projectViewController = [segue destinationViewController];
        projectViewController.project = (MJUProject*)sender;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MJUProject *selectedProject = [[self fetchedResultsController] objectAtIndexPath:indexPath];
    [self performSegueWithIdentifier:@"ProjectDetailSegue" sender:selectedProject];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0f;
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
    static NSString *CellIdentifier = @"ProjectViewCell";
    MJUProjectCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    [self updateCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)updateCell:(UITableViewCell*)cell atIndexPath:(NSIndexPath*)indexPath
{
    MJUProject *currentProject = [[self fetchedResultsController] objectAtIndexPath:indexPath];
    ((MJUProjectCell*)cell).titleLabel.text = currentProject.title;
    ((MJUProjectCell*)cell).companyLabel.text = currentProject.companyName;
}

# pragma mark Deleting

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        MJUProject *project = [[self fetchedResultsController] objectAtIndexPath:indexPath];
        [[[MJUProjectsDataModel sharedDataModel] mainContext] deleteObject:project];
        NSError *error;
        [[[MJUProjectsDataModel sharedDataModel] mainContext] save:&error];
        if(error) {
            NSLog(@"%@", [error localizedDescription]);
        }
        
        if(IS_IPAD) {
            [self.navigationController performSegueWithIdentifier:@"DefaultDetailSegue" sender:indexPath];
        }
        
        
    }
}



#pragma mark -
#pragma mark Core Data

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
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"MJUProject"];
    NSSortDescriptor *sortByName = [NSSortDescriptor sortDescriptorWithKey:@"createdAt" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortByName]];
    
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
    [self.tableView beginUpdates];
}

-(void) controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}

-(void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    
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
