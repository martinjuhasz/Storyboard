//
//  MJUSceneCell.h
//  Storyboard
//
//  Created by Martin Juhasz on 11/11/13.
//  Copyright (c) 2013 Martin Juhasz. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MJUScene;

@interface MJUSceneCell : UITableViewCell

@property (strong, nonatomic) MJUScene *scene;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UIImageView *sceneImageView;

@end
