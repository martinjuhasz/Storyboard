//
//  MJUSettingsTableViewController.m
//  Storyboard
//
//  Created by Martin Juhasz on 11/03/14.
//  Copyright (c) 2014 Martin Juhasz. All rights reserved.
//

#import "MJUSettingsTableViewController.h"
#import "UITableView+Additions.h"

@interface MJUSettingsTableViewController ()

@end

@implementation MJUSettingsTableViewController

- (void)viewDidLoad
{
    [self.tableView hideEmptyCells];
    [super viewDidLoad];
}

-(IBAction)doneButtonClicked:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
