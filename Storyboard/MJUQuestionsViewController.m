//
//  MJUQuestionsViewController.m
//  Storyboard
//
//  Created by Martin Juhasz on 16/11/13.
//  Copyright (c) 2013 Martin Juhasz. All rights reserved.
//

#import "MJUQuestionsViewController.h"
#import "MJUProject.h"
#import "MJUQuestionCell.h"
#import "MJUProjectsDataModel.h"
#import "MJUTextInputViewController.h"
#import "UILabel+Additions.h"
#import "UITableView+Additions.h"
#import "MJUTableHeaderView.h"
#import "MJUQuestionCategory.h"
#import "MJUQuestion.h"
#import "MJUSelectableQuestion.h"
#import "MJUTextQuestion.h"
#import "MJUQuestionSelectionViewController.h"
#import "MJUTextAnswer.h"
#import "MJUSelectableAnswer.h"
#import "MJUSelectable.h"
#import "MJUQuestionSection.h"

@interface MJUQuestionsViewController ()

@end

@implementation MJUQuestionsViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleDataModelChange:) name:NSManagedObjectContextObjectsDidChangeNotification object:[[MJUProjectsDataModel sharedDataModel] mainContext]];
}


#pragma mark -
#pragma mark UITableViewDelegate

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = (NSIndexPath*)sender;
    NSManagedObjectContext *context = [[MJUProjectsDataModel sharedDataModel] mainContext];
    if([segue.identifier isEqualToString:@"QuestionSelectionSegue"]) {
        MJUQuestionSelectionViewController *vc = (MJUQuestionSelectionViewController*)segue.destinationViewController;
        MJUSelectableQuestion *question = [self.fetchedResultsController objectAtIndexPath:indexPath];
        vc.question = question;
        vc.project = self.project;
    } else if([[segue identifier] isEqualToString:@"TextInputSegue"]) {
        MJUTextQuestion *question = [self.fetchedResultsController objectAtIndexPath:indexPath];
        __block MJUTextAnswer *answer;
        answer = [question getSelectedAnswerForProject:self.project];
        
        MJUTextInputViewController *textViewController = (MJUTextInputViewController*)((UINavigationController*)[segue destinationViewController]).topViewController;
        if(answer) {
            textViewController.inputText = answer.text;
        }
        
        textViewController.saveString = ^(NSString *saveString) {
            if(!answer) {
                answer = (MJUTextAnswer *)[NSEntityDescription insertNewObjectForEntityForName:@"MJUTextAnswer" inManagedObjectContext:context];
                [question addAnswersObject:answer];
                [self.project addAnswersObject:answer];
            }
            
            answer.text = saveString;
            [[[MJUProjectsDataModel sharedDataModel] mainContext] save:nil];
        };
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MJUQuestion *question = [self.fetchedResultsController objectAtIndexPath:indexPath];
    if([question isKindOfClass:[MJUSelectableQuestion class]]) {
        [self performSegueWithIdentifier:@"QuestionSelectionSegue" sender:indexPath];
    } else {
        [self performSegueWithIdentifier:@"TextInputSegue" sender:indexPath];
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    static NSString *SelectableCellIdentifier = @"SelectableQuestionCell";
    static NSString *CellIdentifier = @"QuestionCell";
    
    MJUQuestion *question = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    if([question isKindOfClass:[MJUSelectableQuestion class]]) {
        cell = [tableView dequeueReusableCellWithIdentifier:SelectableCellIdentifier forIndexPath:indexPath];
        [self updateSelectableCell:cell atIndexPath:indexPath];
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        [self updateCell:(MJUQuestionCell*)cell atIndexPath:indexPath];
    }
    return cell;
}

- (void)updateCell:(MJUQuestionCell*)cell atIndexPath:(NSIndexPath*)indexPath
{
    MJUTextQuestion *question = [self.fetchedResultsController objectAtIndexPath:indexPath];
    MJUTextAnswer *answer = [question getSelectedAnswerForProject:self.project];
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.titleLabel.text = question.title;
    
    if(answer) {
        cell.contentLabel.text = answer.text;
    } else {
        cell.contentLabel.text = @"";
    }
}

- (void)updateSelectableCell:(UITableViewCell*)cell atIndexPath:(NSIndexPath*)indexPath
{
    MJUSelectableQuestion *question = [self.fetchedResultsController objectAtIndexPath:indexPath];
    MJUSelectableAnswer *answer = [question getSelectedAnswerForProject:self.project];
    cell.textLabel.text = question.title;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    if(answer) {
        cell.detailTextLabel.text = ((MJUSelectable*)answer.selected).text;
    } else {
        cell.detailTextLabel.text = @"";
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CGFloat height = 44.0f;
    MJUQuestion *question = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    if(![question isKindOfClass:[MJUSelectableQuestion class]]) {
        MJUQuestionCell *metricsCell = (MJUQuestionCell*)[tableView prototypeCellWithReuseIdentifier:@"QuestionCell"];
        metricsCell.contentLabel.text = @"Antwort";
        [metricsCell.contentView setNeedsLayout];
        [metricsCell.contentView layoutIfNeeded];
        CGSize size = [metricsCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        height = size.height + 1.0f;
    }
    return height;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    MJUTableHeaderView *aView = [[MJUTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, tableView.frame.size.width, 20.0f)];
    id<NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController.sections objectAtIndex:section];
    MJUQuestion *question = [[sectionInfo objects] objectAtIndex:0];
    aView.titleLabel.text = question.section.title;
    return aView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 38.0f;
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
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"MJUQuestion"];
    NSSortDescriptor *sortBySectionOrder = [NSSortDescriptor sortDescriptorWithKey:@"section.order" ascending:YES];
    NSSortDescriptor *sortByOrder = [NSSortDescriptor sortDescriptorWithKey:@"order" ascending:YES];
    [fetchRequest setSortDescriptors:@[sortBySectionOrder, sortByOrder]];

    NSPredicate *categoryPredicate = [NSPredicate predicateWithFormat:@"section.category = %@", self.category];
    [fetchRequest setPredicate:categoryPredicate];
    
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[[MJUProjectsDataModel sharedDataModel] mainContext] sectionNameKeyPath:@"section.order" cacheName:nil];
    
    aFetchedResultsController.delegate = self;
    
    NSError *error = nil;
    if (![aFetchedResultsController performFetch:&error]) {
        NSLog(@"%@, %@", error, [error userInfo]);
    }
    
    return aFetchedResultsController;
}

- (void)handleDataModelChange:(NSNotification *)note
{
    [self.tableView reloadData];
}


@end
