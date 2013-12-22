//
//  MJUScene.m
//  Storyboard
//
//  Created by Martin Juhasz on 03/11/13.
//  Copyright (c) 2013 Martin Juhasz. All rights reserved.
//

#import "MJUScene.h"
#import "MJUProject.h"
#import "MJUSceneImage.h"


@implementation MJUScene

@dynamic imageText;
@dynamic sceneNumber;
@dynamic soundText;
@dynamic time;
@dynamic order;
@dynamic images;
@dynamic project;
@dynamic title;
@dynamic sceneImageSRC;

- (BOOL)hasImage
{
    return self.images.count > 0;
}
- (UIImage*)getImage
{
    return [[self getSceneImage] getImage];
}

- (MJUSceneImage*)getSceneImage
{
    return ((MJUSceneImage*)[self.images anyObject]);
}

- (NSString*)sceneImageSRC
{
    return [[(MJUSceneImage*)[self.images anyObject] getObjectIDAsString] stringByReplacingOccurrencesOfString:@"x-coredata://" withString:@"mjulocalsceneimage://"];
}

@end
