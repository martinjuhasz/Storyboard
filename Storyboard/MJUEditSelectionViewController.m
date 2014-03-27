//
//  MJUEditSelectionViewController.m
//  Storyboard
//
//  Created by Martin Juhasz on 10/03/14.
//  Copyright (c) 2014 Martin Juhasz. All rights reserved.
//

#import "MJUEditSelectionViewController.h"
#import "MJUSelectableQuestion.h"
#import "MJUProjectsDataModel.h"
#import "MJUTitleInputViewController.h"
#import "MJUSelectable.h"

@interface MJUEditSelectionViewController ()

@end

@implementation MJUEditSelectionViewController

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"TitleInputSegue"]) {
        
        MJUTitleInputViewController *vc = (MJUTitleInputViewController*)[((UINavigationController*)segue.destinationViewController) topViewController];
        NSManagedObjectContext *context = [[MJUProjectsDataModel sharedDataModel] mainContext];
        BOOL editMode = self.tableView.editing;
        __block MJUSelectable *selectable;
        
        if(editMode && [sender isKindOfClass:[NSIndexPath class]]) {
            NSIndexPath *indexPath = (NSIndexPath*)sender;
            selectable = [self.fetchedResultsController objectAtIndexPath:indexPath];
            vc.inputText = selectable.text;
        }
        
        vc.saveBlock = ^(NSString *saveString) {
            
            if(!editMode || ![sender isKindOfClass:[NSIndexPath class]]) {
                selectable = (MJUSelectable *)[NSEntityDescription insertNewObjectForEntityForName:@"MJUSelectable" inManagedObjectContext:context];
                NSUInteger count = [[[self fetchedResultsController] fetchedObjects] count];
                selectable.order = (int32_t)count;
                [self.question addSelectablesObject:selectable];
            }
            
            [selectable setValue:saveString forKey:@"text"];
            NSError *error;
            [[[MJUProjectsDataModel sharedDataModel] mainContext] save:&error];
            
            if(error) {
                NSLog(@"%@", [error localizedDescription]);
            }
            
            if(!editMode || ![sender isKindOfClass:[NSIndexPath class]]) {
                [self saveOrder];
            }
        };
    }
}

- (IBAction)actionButtonClicked:(id)sender
{
    NSString *editString = (self.tableView.editing) ? NSLocalizedString(@"stop editing", nil) : NSLocalizedString(@"edit", nil);
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"choose your action", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"add Answer", nil), editString, nil];
    [actionSheet showInView:self.tableView];
}


#pragma mark -
#pragma mark Action Sheet

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0) {
        [self performSegueWithIdentifier:@"TitleInputSegue" sender:actionSheet];
    } else if(buttonIndex == 1) {
        self.tableView.editing = !self.tableView.editing;
    }
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(!_question) return 0;
    return [super numberOfSectionsInTableView:tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(!_question) return 0;
    return [super tableView:tableView numberOfRowsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SelectableEditCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    [self updateCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)updateCell:(UITableViewCell*)cell atIndexPath:(NSIndexPath*)indexPath
{
    MJUSelectable *currentSelectable = [[self fetchedResultsController] objectAtIndexPath:indexPath];
    cell.textLabel.text = currentSelectable.text;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.tableView.editing) {
        [self performSegueWithIdentifier:@"TitleInputSegue" sender:indexPath];
    }
}

#pragma mark -
#pragma mark Core Data

- (NSFetchedResultsController *)newFetchedResultsController
{
    if(!_question) return nil;
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"MJUSelectable"];
    NSSortDescriptor *sortByName = [NSSortDescriptor sortDescriptorWithKey:@"order" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortByName]];
    
    NSPredicate *projectPredicate = [NSPredicate predicateWithFormat:@"question == %@", self.question];
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
