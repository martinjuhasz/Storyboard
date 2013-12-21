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
#import "MJUTextInputViewController.h"
#import "UILabel+Additions.h"
#import "UITableView+Additions.h"
#import "MJUTableHeaderView.h"

@interface MJUQuestionsViewController ()

@end

@implementation MJUQuestionsViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleDataModelChange:) name:NSManagedObjectContextObjectsDidChangeNotification object:[[MJUProjectsDataModel sharedDataModel] mainContext]];

    
    self.questionHelper = [[MJUQuestionHelper alloc] initWithPList:self.plist];
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
    } else if([[segue identifier] isEqualToString:@"TextInputSegue"]) {
        MJUSubQuestion *question = [self.questionHelper subQuestionForIndexPath:(NSIndexPath*)sender];
        MJUAnswer *answer = [self.project getAnswerForQuestion:question];
        MJUTextInputViewController *textViewController = (MJUTextInputViewController*)((UINavigationController*)[segue destinationViewController]).topViewController;
        textViewController.inputText = answer.text;
        textViewController.saveString = ^(NSString *saveString) {
            answer.text = saveString;
            [[[MJUProjectsDataModel sharedDataModel] mainContext] save:nil];
        };
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MJUSubQuestion *question = [self.questionHelper subQuestionForIndexPath:indexPath];
    if(question.isSelectable) {
        [self performSegueWithIdentifier:@"QuestionSelectionSegue" sender:indexPath];
    } else {
        [self performSegueWithIdentifier:@"TextInputSegue" sender:indexPath];
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
        [self updateCell:(MJUQuestionCell*)cell atIndexPath:indexPath];
    }
    return cell;
}

- (void)updateCell:(MJUQuestionCell*)cell atIndexPath:(NSIndexPath*)indexPath
{
    MJUSubQuestion *subQuestion = [self.questionHelper subQuestionForIndexPath:indexPath];
    MJUAnswer *answer = [self.project getAnswerForQuestion:subQuestion];
    MJUQuestionCell *questionCell = (MJUQuestionCell*)cell;
    
    questionCell.accessoryType = UITableViewCellAccessoryNone;
    questionCell.titleLabel.text = subQuestion.title;
    questionCell.contentLabel.text = answer.text;
}

- (void)updateSelectableCell:(UITableViewCell*)cell atIndexPath:(NSIndexPath*)indexPath
{
    MJUSubQuestion *subQuestion = [self.questionHelper subQuestionForIndexPath:indexPath];
    MJUAnswer *answer = [self.project getAnswerForQuestion:subQuestion];
    cell.textLabel.text = subQuestion.title;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    if(answer && [answer.selected intValue] >= 0) {
        cell.detailTextLabel.text = [subQuestion.selections objectAtIndex:[answer.selected intValue]];
    } else {
        cell.detailTextLabel.text = @"";
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    MJUSubQuestion *subQuestion = [self.questionHelper subQuestionForIndexPath:indexPath];
//    MJUAnswer *answer = [self.project getAnswerForQuestion:subQuestion];
//    if(!subQuestion.isSelectable) {
//
//        MJUQuestionCell *cell = (MJUQuestionCell*)[tableView prototypeCellWithReuseIdentifier:@"QuestionCell"];
//        cell.textLabel.text = answer.text;
//        CGRect size = [cell.textLabel expectedSize];
//        
//        return (size.size.height > 100.0f) ? size.size.height + 55 : 100.0f;
//    }
//    return 44;

    
    CGFloat height = 44.0f;
    
    MJUSubQuestion *subQuestion = [self.questionHelper subQuestionForIndexPath:indexPath];
    MJUAnswer *answer = [self.project getAnswerForQuestion:subQuestion];
    
    if(!subQuestion.isSelectable) {
        MJUQuestionCell *metricsCell = (MJUQuestionCell*)[tableView prototypeCellWithReuseIdentifier:@"QuestionCell"];
        metricsCell.contentLabel.text = answer.text;

        
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
    MJUQuestion *question = [self.questionHelper.questions objectAtIndex:section];
    aView.titleLabel.text = question.sectionTitle;
    return aView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 38.0f;
}


#pragma mark -
#pragma mark CoreData

- (void)handleDataModelChange:(NSNotification *)note
{
    [self.tableView reloadData];
}


@end
