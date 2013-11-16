//
//  MJUProjectViewController.m
//  Storyboard
//
//  Created by Martin Juhasz on 03/11/13.
//  Copyright (c) 2013 Martin Juhasz. All rights reserved.
//

#import "MJUProjectViewController.h"
#import "MJUScenesTableViewController.h"
#import "UITableView+Additions.h"
#import "MJUQuestionsViewController.h"

@interface MJUProjectViewController ()

@end

@implementation MJUProjectViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView hideEmptyCells];
    
    self.title = _project.title;
}


#pragma mark -
#pragma mark UITableViewDelegate

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    [self performSegueWithIdentifier:@"StoryboardSegue" sender:indexPath];
//}
//
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"StoryboardSegue"]) {
        MJUScenesTableViewController *scenesViewController = [segue destinationViewController];
        scenesViewController.project = self.project;
    } else if([[segue identifier] isEqualToString:@"QuestionsSegue"]) {
        MJUQuestionsViewController *questionsViewController = [segue destinationViewController];
        questionsViewController.project = self.project;
    }
}
//
//#pragma mark -
//#pragma mark UITableViewDataSource
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return 1;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return 1;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *CellIdentifier = @"StoryboardCell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
//    
//    return cell;
//}



@end
