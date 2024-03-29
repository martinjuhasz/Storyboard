//
//  MJUEditQuestionsViewController.m
//  Storyboard
//
//  Created by Martin Juhasz on 09/03/14.
//  Copyright (c) 2014 Martin Juhasz. All rights reserved.
//

#import "MJUEditQuestionsViewController.h"
#import "MJUQuestionSection.h"
#import "MJUProjectsDataModel.h"
#import "MJUQuestion.h"
#import "MJUTitleInputViewController.h"
#import "MJUTextQuestion.h"
#import "MJUSelectableQuestion.h"
#import "MJUEditSelectionViewController.h"

@interface MJUEditQuestionsViewController ()

@end

@implementation MJUEditQuestionsViewController

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"TitleInputSegue"]) {
        
        MJUTitleInputViewController *vc = (MJUTitleInputViewController*)[((UINavigationController*)segue.destinationViewController) topViewController];
        NSManagedObjectContext *context = [[MJUProjectsDataModel sharedDataModel] mainContext];
        BOOL editMode = self.tableView.editing;
        __block MJUQuestion *question;
        
        if(editMode && [sender isKindOfClass:[NSIndexPath class]]) {
            NSIndexPath *indexPath = (NSIndexPath*)sender;
            question = [self.fetchedResultsController objectAtIndexPath:indexPath];
            vc.inputText = question.title;
        }
        
        vc.saveBlock = ^(NSString *saveString) {
            
            if(!editMode || ![sender isKindOfClass:[NSIndexPath class]]) {
                NSNumber *selectedOption = (NSNumber*)sender;
                if([selectedOption integerValue] == 0) {
                    question = (MJUTextQuestion *)[NSEntityDescription insertNewObjectForEntityForName:@"MJUTextQuestion" inManagedObjectContext:context];
                } else if([selectedOption integerValue] == 1) {
                    question = (MJUSelectableQuestion *)[NSEntityDescription insertNewObjectForEntityForName:@"MJUSelectableQuestion" inManagedObjectContext:context];
                }
                NSUInteger count = [[[self fetchedResultsController] fetchedObjects] count];
                question.order = (int32_t)count;
                [self.section addQuestionsObject:question];
            }
            
            [question setValue:saveString forKey:@"title"];
            NSError *error;
            [[[MJUProjectsDataModel sharedDataModel] mainContext] save:&error];
            
            if(error) {
                NSLog(@"%@", [error localizedDescription]);
            }
            
            if(!editMode || ![sender isKindOfClass:[NSIndexPath class]]) {
                [self saveOrder];
            }
            
        };
    } else if([segue.identifier isEqualToString:@"EditSelectablesSegue"]) {
        MJUEditSelectionViewController *vc = (MJUEditSelectionViewController*)[segue destinationViewController];
        NSIndexPath *indexPath = (NSIndexPath*)sender;
        vc.question = [self.fetchedResultsController objectAtIndexPath:indexPath];
    }
}

- (IBAction)actionButtonClicked:(id)sender
{
    NSString *editString = (self.tableView.editing) ? NSLocalizedString(@"stop editing", nil) : NSLocalizedString(@"edit", nil);
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"choose your action", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"add text Question", nil), NSLocalizedString(@"add selectable Question", nil), editString, nil];
    [actionSheet showInView:self.tableView];
}


#pragma mark -
#pragma mark Action Sheet

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0 || buttonIndex == 1) {
        [self performSegueWithIdentifier:@"TitleInputSegue" sender:[NSNumber numberWithInteger:buttonIndex]];
    } else if(buttonIndex == 2) {
        self.tableView.editing = !self.tableView.editing;
    }
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(!_section) return 0;
    return [super numberOfSectionsInTableView:tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(!_section) return 0;
    return [super tableView:tableView numberOfRowsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"QuestionEditCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    [self updateCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)updateCell:(UITableViewCell*)cell atIndexPath:(NSIndexPath*)indexPath
{
    MJUQuestion *currentQuestion = [[self fetchedResultsController] objectAtIndexPath:indexPath];
    cell.textLabel.text = currentQuestion.title;
    if([currentQuestion class] == [MJUSelectableQuestion class]) {
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(self.tableView.editing) {
        [self performSegueWithIdentifier:@"TitleInputSegue" sender:indexPath];
    } else {
        MJUQuestion *currentQuestion = [[self fetchedResultsController] objectAtIndexPath:indexPath];
        if([currentQuestion class] != [MJUSelectableQuestion class]) return;
        
        [self performSegueWithIdentifier:@"EditSelectablesSegue" sender:indexPath];
    }
}

#pragma mark -
#pragma mark Core Data

- (NSFetchedResultsController *)newFetchedResultsController
{
    if(!_section) return nil;
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"MJUQuestion"];
    NSSortDescriptor *sortByName = [NSSortDescriptor sortDescriptorWithKey:@"order" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortByName]];
    
    NSPredicate *projectPredicate = [NSPredicate predicateWithFormat:@"section == %@", self.section];
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
