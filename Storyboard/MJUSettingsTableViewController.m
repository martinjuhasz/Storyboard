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

- (void)helpButtonClicked
{
    if(![MFMailComposeViewController canSendMail]) return;
    
    NSString *emailTitle = @"Storyboard | Feedback";
    NSArray *toRecipents = [NSArray arrayWithObject:@"info@nico-herrmann.de"];
    
    NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *deviceName = [[UIDevice currentDevice] name];
    NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
    
    NSString *messageBody = [NSString stringWithFormat:@"\n\n\n\nApp-Version: %@\nDevice: %@\nSystem: %@", appVersion, deviceName, systemVersion];
    
    MFMailComposeViewController *mailComposeViewController = [[MFMailComposeViewController alloc] init];
    mailComposeViewController.mailComposeDelegate = self;
    [mailComposeViewController setSubject:emailTitle];
    [mailComposeViewController setMessageBody:messageBody isHTML:NO];
    [mailComposeViewController setToRecipients:toRecipents];
    
    [mailComposeViewController.navigationBar setTintColor:[UIColor whiteColor]];
    
    [self presentViewController:mailComposeViewController animated:YES completion:^{
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }];
}

- (void)howToButtonClicked
{
    NSURL *url = [NSURL URLWithString:@"http://www.nico-herrmann.de/"];
    [[UIApplication sharedApplication] openURL:url];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *clickedCell = [self.tableView cellForRowAtIndexPath:indexPath];
    if(clickedCell == self.helpCell) {
        [self helpButtonClicked];
    } else if(clickedCell == self.howToCell) {
        [self howToButtonClicked];
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}


#pragma mark -
#pragma mark MFMailComposeViewControllerDelegate

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
