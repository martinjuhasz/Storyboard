//
//  MJUSceneCell.m
//  Storyboard
//
//  Created by Martin Juhasz on 11/11/13.
//  Copyright (c) 2013 Martin Juhasz. All rights reserved.
//

#import "MJUSceneCell.h"
#import "MJUScene.h"
#import "MJUHelper.h"

@implementation MJUSceneCell


- (void)setScene:(MJUScene *)scene
{
    if(scene != _scene) {
        _scene = scene;
        [self setContent];
    }
}

- (void)setContent
{
    self.titleLabel.text = self.scene.title;
    self.timeLabel.text = [MJUHelper secondsToTimeString:self.scene.time includingHours:NO];
    if([self.scene hasImage]) {
        self.accessoryType = UITableViewCellAccessoryNone;
        self.sceneImageView.image = [self.scene getImage];
    } else {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
}

//- (void)setSelected:(BOOL)selected animated:(BOOL)animated
//{
//    [super setSelected:selected animated:animated];
//
//    // Configure the view for the selected state
//}

@end
