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
#import "MJUPDFViewController.h"
#import "MJUProjectsDataModel.h"
#import "MJUScene.h"
#import "MJUSceneImage.h"
#import "MJUHelper.h"
#import "MJUAddProjectViewController.h"
#import "MJUQuestionCategory.h"

@interface MJUProjectViewController ()

@end

@implementation MJUProjectViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Background IMage
    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ProjectDetailBackground"]];
    bgImageView.contentMode = UIViewContentModeTop;
    [self.tableView setBackgroundView:bgImageView];
    
    [self.tableView hideEmptyCells];
    
    self.title = _project.title;
    self.projectTitle.text = _project.title;
    self.companyTitle.text = _project.companyName;
    [self updateHeader];
    [self checkExportButton];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleDataModelChange:) name:NSManagedObjectContextObjectsDidChangeNotification object:[[MJUProjectsDataModel sharedDataModel] mainContext]];
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)updateHeader
{
    self.lengthLabel.text = [MJUHelper secondsToTimeString:[self.project getTotalTime] includingHours:YES];
    self.sceneCountLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)_project.scenes.count];
}

- (void)checkExportButton
{
    BOOL enabled = (self.project.scenes.count > 0);
    [self.pdfCreateCell setUserInteractionEnabled:enabled];
    [self.pdfCreateCell.textLabel setEnabled:enabled];
}



#pragma mark -
#pragma mark Core Data Changes

- (void)handleDataModelChange:(NSNotification *)note;
{
    [self updateHeader];
    [self checkExportButton];
}

#pragma mark -
#pragma mark Button Actions

- (IBAction)editButtonClicked:(id)sender
{
    
}

- (void)addDummyContent
{
    NSManagedObjectContext *context = [[MJUProjectsDataModel sharedDataModel] mainContext];
    NSUInteger preCount = [[self.project scenes] count] + 1;
    
    for(int i = 0; i <25;i++) {
        
        MJUScene *scene = (MJUScene *)[NSEntityDescription insertNewObjectForEntityForName:@"MJUScene" inManagedObjectContext:context];
        scene.title = [NSString stringWithFormat:@"Scene %d", (int)(preCount + i)];
        scene.order = preCount + i;
        
        MJUSceneImage *sceneImage = (MJUSceneImage *)[NSEntityDescription insertNewObjectForEntityForName:@"MJUSceneImage" inManagedObjectContext:context];
        
        NSString *imageURL = [NSString stringWithFormat:@"http://placehold.it/1280x720&text=%d%d%d%d%d",arc4random()%9,arc4random()%9,arc4random()%9,arc4random()%9,arc4random()%9];
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]];
        UIImage *resultImage = [UIImage imageWithData:imageData];
        [sceneImage addImage:resultImage];
        [scene addImagesObject:sceneImage];
        
        [self.project addScenesObject:scene];
    }
    NSError *error;
    [context save:&error];
    if(error) {
        NSLog(@"%@", [error localizedDescription]);
    }
}


#pragma mark -
#pragma mark UITableViewDelegate

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"StoryboardSegue"]) {
        MJUScenesTableViewController *scenesViewController = [segue destinationViewController];
        scenesViewController.project = self.project;
        
    } else if([[segue identifier] isEqualToString:@"QuestionsSegue"]) {
        MJUQuestionsViewController *questionsViewController;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            UINavigationController *navController =[segue destinationViewController];
            questionsViewController = (MJUQuestionsViewController*)[navController topViewController];
        }
        else {
            questionsViewController = [segue destinationViewController];
        }
        questionsViewController.project = self.project;
        NSIndexPath *indexPath = (NSIndexPath*)sender;
        questionsViewController.category = [self getCategoryForRow:indexPath.row];
        
    } else if([[segue identifier] isEqualToString:@"PDFSegue"]) {
        MJUPDFViewController *pdfViewController;
        UINavigationController *navController =[segue destinationViewController];
        pdfViewController = (MJUPDFViewController*)[navController topViewController];
        pdfViewController.project = self.project;
    } else if([[segue identifier] isEqualToString:@"EditProjectSegue"]) {
        MJUAddProjectViewController *addProjectViewController = (MJUAddProjectViewController*)[[segue destinationViewController] topViewController];
        addProjectViewController.project = self.project;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0) {
        [self performSegueWithIdentifier:@"StoryboardSegue" sender:indexPath];
    }else if(indexPath.section == 1) {
        [self performSegueWithIdentifier:@"QuestionsSegue" sender:indexPath];
    } else if(indexPath.section == 2) {
        [self performSegueWithIdentifier:@"PDFSegue" sender:indexPath];
    } else if(indexPath.section == 3) {
        [self addDummyContent];
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}


#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 1) {
        id<NSFetchedResultsSectionInfo> sectionInfo = [[[self fetchedResultsController] sections] objectAtIndex:0];
        return [sectionInfo numberOfObjects];
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"StoryboardCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if(indexPath.section == 0) {
        cell.textLabel.text = NSLocalizedString(@"Storyboard", nil);
        cell.imageView.image = [UIImage imageNamed:@"ProjectDetailIconStoryboard"];
    }else if(indexPath.section == 1) {
        [self configureCell:cell atIndexPath:indexPath];
    } else if(indexPath.section == 2) {
        cell.textLabel.text = NSLocalizedString(@"generate PDF", nil);
        cell.imageView.image = [UIImage imageNamed:@"ProjectDetailIconPDF"];
    }
    
    return cell;
}

- (void)configureCell:(UITableViewCell*)cell atIndexPath:(NSIndexPath *)indexPath
{
    MJUQuestionCategory *category = [self getCategoryForRow:indexPath.row];
    cell.textLabel.text = category.title;
    cell.imageView.image = category.icon;
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

- (MJUQuestionCategory*)getCategoryForRow:(NSInteger)row
{
    NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:row inSection:0];
    MJUQuestionCategory *category = [self.fetchedResultsController objectAtIndexPath:newIndexPath];
    return category;
}



@end
