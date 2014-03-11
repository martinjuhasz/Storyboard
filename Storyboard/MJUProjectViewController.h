//
//  MJUProjectViewController.h
//  Storyboard
//
//  Created by Martin Juhasz on 03/11/13.
//  Copyright (c) 2013 Martin Juhasz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJUProject.h"

@interface MJUProjectViewController : UITableViewController<NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) MJUProject *project;
@property (weak, nonatomic) IBOutlet UILabel *projectTitle;
@property (weak, nonatomic) IBOutlet UILabel *companyTitle;
@property (weak, nonatomic) IBOutlet UILabel *lengthLabel;
@property (weak, nonatomic) IBOutlet UILabel *sceneCountLabel;
@property (weak, nonatomic) IBOutlet UITableViewCell *pdfCreateCell;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@end
