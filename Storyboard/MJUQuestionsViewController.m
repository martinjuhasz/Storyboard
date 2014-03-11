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
    if([segue.identifier isEqualToString:@"QuestionSelectionSegue"]) {
        MJUQuestionSelectionViewController *vc = (MJUQuestionSelectionViewController*)segue.destinationViewController;
        MJUSelectableQuestion *question = [self.fetchedResultsController objectAtIndexPath:indexPath];
        vc.question = question;
        vc.project = self.project;
    } else if([[segue identifier] isEqualToString:@"TextInputSegue"]) {
//        MJUSubQuestion *question = [self.questionHelper subQuestionForIndexPath:(NSIndexPath*)sender];
//        MJUAnswer *answer = [self.project getAnswerForQuestion:question];
//        MJUTextInputViewController *textViewController = (MJUTextInputViewController*)((UINavigationController*)[segue destinationViewController]).topViewController;
//        textViewController.inputText = answer.text;
//        textViewController.saveString = ^(NSString *saveString) {
//            answer.text = saveString;
//            [[[MJUProjectsDataModel sharedDataModel] mainContext] save:nil];
//        };
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
    MJUSelectableQuestion *question = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.titleLabel.text = question.title;
    cell.contentLabel.text = @"antwort";

//    MJUSubQuestion *subQuestion = [self.questionHelper subQuestionForIndexPath:indexPath];
//    MJUAnswer *answer = [self.project getAnswerForQuestion:subQuestion];
//    MJUQuestionCell *questionCell = (MJUQuestionCell*)cell;
//    
//    questionCell.accessoryType = UITableViewCellAccessoryNone;
//    questionCell.titleLabel.text = subQuestion.title;
//    questionCell.contentLabel.text = answer.text;
}

- (void)updateSelectableCell:(UITableViewCell*)cell atIndexPath:(NSIndexPath*)indexPath
{
    MJUTextQuestion *question = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = question.title;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    cell.detailTextLabel.text = @"antwort";
    
//    MJUSubQuestion *subQuestion = [self.questionHelper subQuestionForIndexPath:indexPath];
//    MJUAnswer *answer = [self.project getAnswerForQuestion:subQuestion];
//    cell.textLabel.text = subQuestion.title;
//    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//    
//    if(answer && [answer.selected intValue] >= 0) {
//        cell.detailTextLabel.text = [subQuestion.selections objectAtIndex:[answer.selected intValue]];
//    } else {
//        cell.detailTextLabel.text = @"";
//    }
//    
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

//    CGFloat height = 44.0f;
//    
//    MJUSubQuestion *subQuestion = [self.questionHelper subQuestionForIndexPath:indexPath];
//    MJUAnswer *answer = [self.project getAnswerForQuestion:subQuestion];
//    
//    if(!subQuestion.isSelectable) {
//        MJUQuestionCell *metricsCell = (MJUQuestionCell*)[tableView prototypeCellWithReuseIdentifier:@"QuestionCell"];
//        metricsCell.contentLabel.text = answer.text;
//
//        
//        [metricsCell.contentView setNeedsLayout];
//        [metricsCell.contentView layoutIfNeeded];
//        
//        CGSize size = [metricsCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
//        height = size.height + 1.0f;
//    }
//    
//    return height;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    MJUTableHeaderView *aView = [[MJUTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, tableView.frame.size.width, 20.0f)];
    id<NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController.sections objectAtIndex:section];
    aView.titleLabel.text = [sectionInfo name];
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
    NSSortDescriptor *sortByName = [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortByName]];

    NSPredicate *categoryPredicate = [NSPredicate predicateWithFormat:@"section.category = %@", self.category];
    [fetchRequest setPredicate:categoryPredicate];
    
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[[MJUProjectsDataModel sharedDataModel] mainContext] sectionNameKeyPath:@"section.title" cacheName:nil];
    
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
