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
#import "MJUSceneImage.h"

@implementation MJUSceneCell


- (void)setScene:(MJUScene *)scene forIndexPath:(NSIndexPath*)indexPath
{
    if(scene != _scene) {
        _scene = scene;
    }
    [self setContentForIndexPath:indexPath];
}

- (void)setContentForIndexPath:(NSIndexPath*)indexPath
{
    self.titleLabel.text = self.scene.title;
    self.timeLabel.text = [MJUHelper secondsToTimeString:self.scene.time includingHours:NO];
    self.sceneImageView.image = nil;
    
    if([_scene hasImage]) {
        self.accessoryType = UITableViewCellAccessoryNone;
        
        MJUSceneImage *sceneImage = [_scene getSceneImage];
        
        if(sceneImage) {
            self.sceneImageView.image = [sceneImage getThumbnail];
        } else {
            self.sceneImageView.image = nil;
        }
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
