//
//  MJUSceneViewController.h
//  Storyboard
//
//  Created by Martin Juhasz on 04/11/13.
//  Copyright (c) 2013 Martin Juhasz. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MJUScene;

@interface MJUSceneViewController : UITableViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) MJUScene *scene;

@end
