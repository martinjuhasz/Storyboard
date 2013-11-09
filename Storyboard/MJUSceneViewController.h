//
//  MJUSceneViewController.h
//  Storyboard
//
//  Created by Martin Juhasz on 04/11/13.
//  Copyright (c) 2013 Martin Juhasz. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MJUScene;

@interface MJUSceneViewController : UITableViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate>

@property (strong, nonatomic) MJUScene *scene;
@property (weak, nonatomic) IBOutlet UITextView *imageText;
@property (weak, nonatomic) IBOutlet UITextView *soundText;

@end
