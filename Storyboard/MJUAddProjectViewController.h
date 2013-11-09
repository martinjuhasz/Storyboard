//
//  MJUAddProjectViewController.h
//  Storyboard
//
//  Created by Martin Juhasz on 08/11/13.
//  Copyright (c) 2013 Martin Juhasz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MJUAddProjectViewController : UITableViewController<UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *companyField;
@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UIImageView *imageField;

@end