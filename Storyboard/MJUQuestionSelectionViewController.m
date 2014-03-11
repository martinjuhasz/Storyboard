//
//  MJUQuestionSelectionViewController.m
//  Storyboard
//
//  Created by Martin Juhasz on 16/11/13.
//  Copyright (c) 2013 Martin Juhasz. All rights reserved.
//

#import "MJUQuestionSelectionViewController.h"
#import "MJUAnswer.h"
#import "MJUProject.h"
#import "MJUProjectsDataModel.h"
#import "UITableView+Additions.h"
#import "MJUSelectable.h"

@interface MJUQuestionSelectionViewController ()

@end

@implementation MJUQuestionSelectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView hideEmptyCells];
}

#pragma mark -
#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSManagedObjectContext *context = [[MJUProjectsDataModel sharedDataModel] mainContext];
    MJUSelectable *selectable = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    MJUSelectableAnswer *answer = (MJUSelectableAnswer *)[NSEntityDescription insertNewObjectForEntityForName:@"MJUSelectableAnswer" inManagedObjectContext:context];
    [selectable addAnswersObject:answer];
    [self.project addAnswersObject:(MJUAnswer*)answer];
    
    NSError *error;
    [context save:&error];
    
    if(error) NSLog(@"%@", [error localizedDescription]);
    
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(!self.question) return 0;
    
    return [[[self fetchedResultsController] sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id<NSFetchedResultsSectionInfo> sectionInfo = [[[self fetchedResultsController] sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"QuestionSelectionCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    [self updateCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)updateCell:(UITableViewCell*)cell atIndexPath:(NSIndexPath*)indexPath
{
    MJUSelectable *selectable = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.textLabel.text = selectable.text;
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
    if(!self.question) return nil;
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"MJUSelectable"];
    NSSortDescriptor *sortByName = [NSSortDescriptor sortDescriptorWithKey:@"text" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortByName]];
    
    NSPredicate *categoryPredicate = [NSPredicate predicateWithFormat:@"question = %@", self.question];
    [fetchRequest setPredicate:categoryPredicate];
    
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[[MJUProjectsDataModel sharedDataModel] mainContext] sectionNameKeyPath:nil cacheName:nil];
    
    aFetchedResultsController.delegate = self;
    
    NSError *error = nil;
    if (![aFetchedResultsController performFetch:&error]) {
        NSLog(@"%@, %@", error, [error userInfo]);
    }
    
    return aFetchedResultsController;
}
@end
