//
//  MJUEditSectionsViewController.m
//  Storyboard
//
//  Created by Martin Juhasz on 09/03/14.
//  Copyright (c) 2014 Martin Juhasz. All rights reserved.
//

#import "MJUEditSectionsViewController.h"
#import "MJUProjectsDataModel.h"
#import "MJUQuestionSection.h"
#import "MJUTitleInputViewController.h"
#import "MJUEditQuestionsViewController.h"

@interface MJUEditSectionsViewController ()

@end

@implementation MJUEditSectionsViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleDataModelChange:) name:NSManagedObjectContextObjectsDidChangeNotification object:[[MJUProjectsDataModel sharedDataModel] mainContext]];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"TitleInputSegue"]) {
        
        MJUTitleInputViewController *vc = (MJUTitleInputViewController*)[((UINavigationController*)segue.destinationViewController) topViewController];
        NSManagedObjectContext *context = [[MJUProjectsDataModel sharedDataModel] mainContext];
        BOOL editMode = self.tableView.editing;
        __block MJUQuestionSection *section;
        
        if(editMode && [sender isKindOfClass:[NSIndexPath class]]) {
            NSIndexPath *indexPath = (NSIndexPath*)sender;
            section = [self.fetchedResultsController objectAtIndexPath:indexPath];
            vc.inputText = section.title;
        }
        
        vc.saveBlock = ^(NSString *saveString) {
            if(!editMode || ![sender isKindOfClass:[NSIndexPath class]]) {
                section = (MJUQuestionSection *)[NSEntityDescription insertNewObjectForEntityForName:@"MJUQuestionSection" inManagedObjectContext:context];
                [self.category addSectionsObject:section];
            }
            [section setValue:saveString forKey:@"title"];
            NSError *error;
            [[[MJUProjectsDataModel sharedDataModel] mainContext] save:&error];
            if(error) {
                NSLog(@"%@", [error localizedDescription]);
            }
        };
    } else if([segue.identifier isEqualToString:@"EditQuestionsSegue"]) {
        MJUEditQuestionsViewController *vc = (MJUEditQuestionsViewController*)[segue destinationViewController];
        NSIndexPath *indexPath = (NSIndexPath*)sender;
        vc.section = [self.fetchedResultsController objectAtIndexPath:indexPath];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(!_category) return 0;
    return [[[self fetchedResultsController] sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(!_category) return 0;
    id<NSFetchedResultsSectionInfo> sectionInfo = [[[self fetchedResultsController] sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SectionEditCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    MJUQuestionSection *currentSection = [[self fetchedResultsController] objectAtIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.text = currentSection.title;
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        MJUQuestionSection *section = [[self fetchedResultsController] objectAtIndexPath:indexPath];
        [[[MJUProjectsDataModel sharedDataModel] mainContext] deleteObject:section];
        NSError *error;
        [[[MJUProjectsDataModel sharedDataModel] mainContext] save:&error];
        if(error) {
            NSLog(@"%@", [error localizedDescription]);
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.tableView.editing) {
        [self performSegueWithIdentifier:@"TitleInputSegue" sender:indexPath];
    } else {
        [self performSegueWithIdentifier:@"EditQuestionsSegue" sender:indexPath];
    }
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
    if(!self.category) return nil;
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"MJUQuestionSection"];
    NSSortDescriptor *sortByName = [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortByName]];
    
    NSPredicate *projectPredicate = [NSPredicate predicateWithFormat:@"category == %@", self.category];
    [fetchRequest setPredicate:projectPredicate];
    
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[[MJUProjectsDataModel sharedDataModel] mainContext] sectionNameKeyPath:Nil cacheName:nil];
    
    aFetchedResultsController.delegate = self;
    
    NSError *error = nil;
    if (![aFetchedResultsController performFetch:&error]) {
        NSLog(@"%@, %@", error, [error userInfo]);
    }
    
    return aFetchedResultsController;
}

#pragma mark -
#pragma mark CoreData

- (void)handleDataModelChange:(NSNotification *)note
{
    // TODO: why doesnt fetchedResultsController update itself?
    _fetchedResultsController = nil;
    [self.tableView reloadData];
}

@end
