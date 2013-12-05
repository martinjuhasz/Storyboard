//
//  MJUPhoto.h
//  Storyboard
//
//  Created by Martin Juhasz on 04/12/13.
//  Copyright (c) 2013 Martin Juhasz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FICEntity.h"
#import "MJUSceneImage.h"

extern NSString *const MJUPhotoImageFormatFamily;

extern NSString *const MJUSmallSquareThumbnailImageFormatName;
extern NSString *const MJUDefaultSceneImageFormatName;

extern CGSize const MJUSmallSquareThumbnailImageSize;
extern CGSize const MJUDefaultSceneImageSize;

@interface MJUPhoto : NSObject <FICEntity>

@property (nonatomic, strong) MJUSceneImage *sceneImage;
@property (nonatomic, strong, readonly) UIImage *sourceImage;

+ (MJUPhoto*)photoForSceneImage:(MJUSceneImage*)aSceneImage;

@end
