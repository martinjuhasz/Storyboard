//
//  MJUSceneViewController.h
//  Storyboard
//
//  Created by Martin Juhasz on 04/11/13.
//  Copyright (c) 2013 Martin Juhasz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJUTimePickerViewController.h"
#import "PECropViewController.h"

@class MJUScene;
@class MJUTimeSelectionView;

@interface MJUSceneViewController : UITableViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate, UIActionSheetDelegate, MJUTimePickerDelegate, PECropViewControllerDelegate>

@property (strong, nonatomic) MJUScene *scene;
@property (strong, nonatomic) MJUTimeSelectionView *selectionView;

@property (weak, nonatomic) IBOutlet UITableViewCell *titleCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *timeCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *imageViewCell;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITableViewCell *imageTextCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *soundTextCell;


@end
