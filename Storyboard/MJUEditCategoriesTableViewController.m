//
//  MJUEditCategoriesTableViewController.m
//  Storyboard
//
//  Created by Martin Juhasz on 17/01/14.
//  Copyright (c) 2014 Martin Juhasz. All rights reserved.
//

#import "MJUEditCategoriesTableViewController.h"
#import "MJUProjectsDataModel.h"
#import "MJUTitleInputViewController.h"
#import "MJUQuestionCategory.h"
#import "MJUEditSectionsViewController.h"
#import "MJUCategoryInputViewController.h"

@interface MJUEditCategoriesTableViewController ()

@end

@implementation MJUEditCategoriesTableViewController

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"TitleInputSegue"]) {
        
        MJUCategoryInputViewController *vc = (MJUCategoryInputViewController*)[((UINavigationController*)segue.destinationViewController) topViewController];
        NSManagedObjectContext *context = [[MJUProjectsDataModel sharedDataModel] mainContext];
        BOOL editMode = self.tableView.editing;
        __block MJUQuestionCategory *category;
        
        if(editMode && [sender isKindOfClass:[NSIndexPath class]]) {
            NSIndexPath *indexPath = (NSIndexPath*)sender;
            category = [self.fetchedResultsController objectAtIndexPath:indexPath];
            vc.inputText = category.title;
            vc.categoryIcon = category.iconID;
        }

        vc.saveCategoryBlock = ^(NSString *saveString, MJUQuestionCategoryIcon icon) {
            
            if(!editMode || ![sender isKindOfClass:[NSIndexPath class]]) {
                category = (MJUQuestionCategory *)[NSEntityDescription insertNewObjectForEntityForName:@"MJUQuestionCategory" inManagedObjectContext:context];
                NSUInteger count = [[[self fetchedResultsController] fetchedObjects] count];
                category.order = (int32_t)count;
            }
            
            category.iconID = icon;
            [category setValue:saveString forKey:@"title"];
            NSError *error;
            [[[MJUProjectsDataModel sharedDataModel] mainContext] save:&error];
            if(error) {
                NSLog(@"%@", [error localizedDescription]);
            }
            
            if(!editMode || ![sender isKindOfClass:[NSIndexPath class]]) {
                [self saveOrder];
            }
        };
    } else if([segue.identifier isEqualToString:@"EditSectionsSegue"]) {
        MJUEditSectionsViewController *vc = (MJUEditSectionsViewController*)[segue destinationViewController];
        NSIndexPath *indexPath = (NSIndexPath*)sender;
        vc.category = [self.fetchedResultsController objectAtIndexPath:indexPath];
    }
}

- (IBAction)actionButtonClicked:(id)sender
{
    NSString *editString = (self.tableView.editing) ? NSLocalizedString(@"stop editing", nil) : NSLocalizedString(@"edit", nil);
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"choose your action", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"add", nil), editString, nil];
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CategoryEditCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    [self updateCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)updateCell:(UITableViewCell*)cell atIndexPath:(NSIndexPath*)indexPath
{
    MJUQuestionCategory *currentCategory = [[self fetchedResultsController] objectAtIndexPath:indexPath];
    cell.imageView.image = currentCategory.icon;
    cell.textLabel.text = currentCategory.title;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.tableView.editing) {
        [self performSegueWithIdentifier:@"TitleInputSegue" sender:indexPath];
    } else {
        [self performSegueWithIdentifier:@"EditSectionsSegue" sender:indexPath];
    }
}

- (NSFetchedResultsController *)newFetchedResultsController
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"MJUQuestionCategory"];
    NSSortDescriptor *sortByName = [NSSortDescriptor sortDescriptorWithKey:@"order" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortByName]];
    
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[[MJUProjectsDataModel sharedDataModel] mainContext] sectionNameKeyPath:Nil cacheName:nil];
    
    aFetchedResultsController.delegate = self;
    
    NSError *error = nil;
    if (![aFetchedResultsController performFetch:&error]) {
        NSLog(@"%@, %@", error, [error userInfo]);
    }
    
    return aFetchedResultsController;
}

@end
