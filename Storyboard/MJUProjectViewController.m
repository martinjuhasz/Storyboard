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
        
//        [sceneImage addImage:[UIImage imageNamed:@"dummyImage.jpg"]];
        [scene addImagesObject:sceneImage];
        
        [self.project addScenesObject:scene];
    }
    [context save:nil];
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
        
        MJUQuestionsViewController *questionsViewController;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            UINavigationController *navController =[segue destinationViewController];
            questionsViewController = (MJUQuestionsViewController*)[navController topViewController];
        }
        else {
            questionsViewController = [segue destinationViewController];
        }
        questionsViewController.project = self.project;
        questionsViewController.plist = [self questionFileForIndexPath:(NSIndexPath*)sender];
        
        
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
    if(indexPath.section == 1) {
        [self performSegueWithIdentifier:@"QuestionsSegue" sender:indexPath];
    } else if(indexPath.section == 2) {
        [self performSegueWithIdentifier:@"PDFSegue" sender:indexPath];
    } else if(indexPath.section == 3) {
        [self addDummyContent];
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

- (NSString*)questionFileForIndexPath:(NSIndexPath*)indexPath
{
    switch (indexPath.row) {
        case 0:
            return @"Questions_Contact";
            break;
        
        case 1:
            return @"Questions_Parameter";
            break;
        
        case 2:
            return @"Questions_Organisation";
            break;
            
        case 3:
            return @"Questions_PostProduction";
            break;
        
        default:
            return nil;
            break;
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
