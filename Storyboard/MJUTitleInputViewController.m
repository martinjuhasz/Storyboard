//
//  MJUTitleInputViewController.m
//  Storyboard
//
//  Created by Martin Juhasz on 17/01/14.
//  Copyright (c) 2014 Martin Juhasz. All rights reserved.
//

#import "MJUTitleInputViewController.h"

@interface MJUTitleInputViewController ()

@end

@implementation MJUTitleInputViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    if(self.inputText) {
        self.titleCell.textInput.text = self.inputText;
    }
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (IBAction)saveButtonClicked:(id)sender
{
    if(self.saveBlock) {
        self.saveBlock(self.titleCell.textInput.text);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cancelButtonClicked:(id)sender
{
    if(self.cancelBlock) {
        self.cancelBlock();
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
