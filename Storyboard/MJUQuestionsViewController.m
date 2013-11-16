//
//  MJUQuestionsViewController.m
//  Storyboard
//
//  Created by Martin Juhasz on 16/11/13.
//  Copyright (c) 2013 Martin Juhasz. All rights reserved.
//

#import "MJUQuestionsViewController.h"
#import "MJUQuestionHelper.h"
#import "MJUQuestion.h"
#import "MJUSubQuestion.h"
#import "MJUProject.h"
#import "MJUAnswer.h"
#import "MJUQuestionCell.h"
#import "MJUQuestionSelectionViewController.h"
#import "MJUProjectsDataModel.h"

@interface MJUQuestionsViewController ()

@end

@implementation MJUQuestionsViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleDataModelChange:) name:NSManagedObjectContextObjectsDidChangeNotification object:[[MJUProjectsDataModel sharedDataModel] mainContext]];

    
    self.questionHelper = [[MJUQuestionHelper alloc] initWithPList:@"Questions_Contact"];
}


#pragma mark -
#pragma mark UITableViewDelegate

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"QuestionSelectionSegue"]) {
        MJUQuestionSelectionViewController *vc = (MJUQuestionSelectionViewController*)segue.destinationViewController;
        MJUSubQuestion *question = [self.questionHelper subQuestionForIndexPath:(NSIndexPath*)sender];
        MJUAnswer *answer = [self.project getAnswerForQuestion:question];
        vc.question = question;
        vc.answer = answer;
        vc.project = self.project;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MJUSubQuestion *question = [self.questionHelper subQuestionForIndexPath:indexPath];
    if(question.isSelectable) {
        [self performSegueWithIdentifier:@"QuestionSelectionSegue" sender:indexPath];
    }
    
}


#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.questionHelper.questions.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    MJUQuestion *question = [self.questionHelper.questions objectAtIndex:section];
    return question.subQuestions.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    static NSString *SelectableCellIdentifier = @"SelectableQuestionCell";
    static NSString *CellIdentifier = @"QuestionCell";
    MJUSubQuestion *subQuestion = [self.questionHelper subQuestionForIndexPath:indexPath];
    
    if(subQuestion.isSelectable) {
        cell = [tableView dequeueReusableCellWithIdentifier:SelectableCellIdentifier forIndexPath:indexPath];
        [self updateSelectableCell:cell atIndexPath:indexPath];
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        [self updateCell:cell atIndexPath:indexPath];
    }
    return cell;
}

- (void)updateCell:(UITableViewCell*)cell atIndexPath:(NSIndexPath*)indexPath
{
    MJUSubQuestion *subQuestion = [self.questionHelper subQuestionForIndexPath:indexPath];
    MJUAnswer *answer = [self.project getAnswerForQuestion:subQuestion];
    MJUQuestionCell *questionCell = (MJUQuestionCell*)cell;
    
    questionCell.titleLabel.text = subQuestion.title;
    questionCell.textLabel.text = answer.text;
}

- (void)updateSelectableCell:(UITableViewCell*)cell atIndexPath:(NSIndexPath*)indexPath
{
    MJUSubQuestion *subQuestion = [self.questionHelper subQuestionForIndexPath:indexPath];
    MJUAnswer *answer = [self.project getAnswerForQuestion:subQuestion];
    cell.textLabel.text = subQuestion.title;
    
    if(answer) {
        cell.detailTextLabel.text = [subQuestion.selections objectAtIndex:[answer.selected intValue]];
    } else {
        cell.detailTextLabel.text = @"";
    }
    
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    MJUQuestion *question = [self.questionHelper.questions objectAtIndex:section];
    return question.sectionTitle;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MJUSubQuestion *subQuestion = [self.questionHelper subQuestionForIndexPath:indexPath];
    if(!subQuestion.isSelectable) {
        return 100;
    }
    return 44;
}


#pragma mark -
#pragma mark CoreData

- (void)handleDataModelChange:(NSNotification *)note
{
    [self.tableView reloadData];
}


@end
