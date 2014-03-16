//
//  MJUTitleInputViewController.h
//  Storyboard
//
//  Created by Martin Juhasz on 17/01/14.
//  Copyright (c) 2014 Martin Juhasz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJUTextInputCell.h"

@interface MJUTitleInputViewController : UITableViewController

@property (weak, nonatomic) IBOutlet MJUTextInputCell *titleCell;
@property (strong, nonatomic) NSString *inputText;
@property (nonatomic, copy) void (^saveBlock)(NSString *enteredString);
@property (nonatomic, copy) void (^cancelBlock)();

@end
