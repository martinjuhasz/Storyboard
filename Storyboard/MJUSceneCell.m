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
#import "MJUPhoto.h"
#import "FICImageCache.h"

@implementation MJUSceneCell


- (void)setScene:(MJUScene *)scene
{
    if(scene != _scene) {
        _scene = scene;
    }
    [self setContent];
}

- (void)setContent
{
    self.titleLabel.text = self.scene.title;
    self.timeLabel.text = [MJUHelper secondsToTimeString:self.scene.time includingHours:NO];
    self.sceneImageView.image = nil;
    
    if([self.scene hasImage]) {
        self.accessoryType = UITableViewCellAccessoryNone;
        
        MJUSceneImage *sceneImage = [self.scene getSceneImage];
        if(sceneImage) {
            MJUPhoto *photo = [MJUPhoto photoForSceneImage:[self.scene getSceneImage]];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                FICImageCacheCompletionBlock completionBlock = ^(id <FICEntity> entity, NSString *formatName, UIImage *image) {
                    if(photo == entity) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            self.sceneImageView.image = image;
                        });
                    }
                };
                [[FICImageCache sharedImageCache] retrieveImageForEntity:photo withFormatName:MJUSmallSquareThumbnailImageFormatName completionBlock:completionBlock];
            });
        } else {
            self.imageView.image = nil;
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
