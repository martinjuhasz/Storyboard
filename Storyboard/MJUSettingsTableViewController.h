//
//  MJUSettingsTableViewController.h
//  Storyboard
//
//  Created by Martin Juhasz on 11/03/14.
//  Copyright (c) 2014 Martin Juhasz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface MJUSettingsTableViewController : UITableViewController<MFMailComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableViewCell *howToCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *helpCell;

@end
