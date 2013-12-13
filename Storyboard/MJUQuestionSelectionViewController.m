//
//  MJUQuestionSelectionViewController.m
//  Storyboard
//
//  Created by Martin Juhasz on 16/11/13.
//  Copyright (c) 2013 Martin Juhasz. All rights reserved.
//

#import "MJUQuestionSelectionViewController.h"
#import "MJUSubQuestion.h"
#import "MJUAnswer.h"
#import "MJUProject.h"
#import "MJUProjectsDataModel.h"
#import "UITableView+Additions.h"

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
    
    if(!self.answer) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    self.answer.selected = [NSNumber numberWithInt:indexPath.row];
    
    NSError *error;
    [context save:&error];
    
    if(error) NSLog(@"%@", [error localizedDescription]);
    
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.question.selections.count;
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
    cell.textLabel.text = [self.question.selections objectAtIndex:indexPath.row];
}
@end
