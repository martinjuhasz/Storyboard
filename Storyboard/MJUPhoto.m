//
//  MJUPhoto.m
//  Storyboard
//
//  Created by Martin Juhasz on 04/12/13.
//  Copyright (c) 2013 Martin Juhasz. All rights reserved.
//

#import "MJUPhoto.h"
#import "FICUtilities.h"
#import "UIImage+Resizing.h"

NSString *const MJUPhotoImageFormatFamily = @"MJUPhotoImageFormatFamily";

NSString *const MJUSmallSquareThumbnailImageFormatName = @"MJUSmallSquareThumbnailImageFormatName";
NSString *const MJUDefaultLandscapeImageFormatName = @"MJUDefaultLandscapeImageFormatName";

CGSize const MJUSmallSquareThumbnailImageSize = {140, 140};
CGSize const MJUDefaultLandscapeIphoneImageSize = {320, 180};
CGSize const MJUDefaultLandscapeIphone2xIpadImageSize = {640, 360};
CGSize const MJUDefaultLandscapeIpad2xImageSize = {1280, 720};


@interface MJUPhoto () {
    NSString *_UUID;
}

@end


@implementation MJUPhoto


+ (MJUPhoto*)photoForSceneImage:(MJUSceneImage*)aSceneImage
{
    
    MJUPhoto *newPhoto = [[MJUPhoto alloc] init];
    newPhoto.sceneImage = aSceneImage;
    return  newPhoto;
}

- (UIImage *)sourceImage {
    UIImage *sourceImage = [self.sceneImage getImage];
    return sourceImage;
}

#pragma mark - FICImageCacheEntity

- (NSString *)UUID {
    if (_UUID == nil) {
        // MD5 hashing is expensive enough that we only want to do it once
        CFUUIDBytes UUIDBytes = FICUUIDBytesFromMD5HashOfString([[[self.sceneImage objectID] URIRepresentation] absoluteString]);
        _UUID = FICStringWithUUIDBytes(UUIDBytes);
    }
    
    return _UUID;
}

- (NSString *)sourceImageUUID {
    return [self UUID];
}

- (NSURL *)sourceImageURLWithFormatName:(NSString *)formatName {
    return [[self.sceneImage objectID] URIRepresentation];
}

- (FICEntityImageDrawingBlock)drawingBlockForImage:(UIImage *)image withFormatName:(NSString *)formatName {
    FICEntityImageDrawingBlock drawingBlock = ^(CGContextRef contextRef, CGSize contextSize) {
        
        CGRect contextBounds = CGRectZero;
        contextBounds.size = contextSize;
        CGContextClearRect(contextRef, contextBounds);
        
        // Fill with white Background
        CGContextSetFillColorWithColor(contextRef, [[UIColor whiteColor] CGColor]);
        CGContextFillRect(contextRef, contextBounds);
        
        if([formatName isEqualToString:MJUSmallSquareThumbnailImageFormatName]) {
            
            UIImage *squareImage = _FICDSquareImageFromImage(image);
            
            UIGraphicsPushContext(contextRef);
            [squareImage drawInRect:contextBounds];
            UIGraphicsPopContext();
            
        } else {
            UIImage *newImage = [image scaleToCoverSize:contextSize];
            NSLog(@"expected Size: %@", NSStringFromCGSize(contextSize));
            NSLog(@"result Size: %@", NSStringFromCGSize(newImage.size));
            UIGraphicsPushContext(contextRef);
            [newImage drawInRect:contextBounds];
            UIGraphicsPopContext();
        }
    };
    
    return drawingBlock;
}

static UIImage * _FICDSquareImageFromImage(UIImage *image) {
    UIImage *squareImage = nil;
    CGSize imageSize = [image size];
    
    if (imageSize.width == imageSize.height) {
        squareImage = image;
    } else {
        // Compute square crop rect
        CGFloat smallerDimension = MIN(imageSize.width, imageSize.height);
        CGRect cropRect = CGRectMake(0, 0, smallerDimension, smallerDimension);
        
        // Center the crop rect either vertically or horizontally, depending on which dimension is smaller
        if (imageSize.width <= imageSize.height) {
            cropRect.origin = CGPointMake(0, rintf((imageSize.height - smallerDimension) / 2.0));
        } else {
            cropRect.origin = CGPointMake(rintf((imageSize.width - smallerDimension) / 2.0), 0);
        }
        
        CGImageRef croppedImageRef = CGImageCreateWithImageInRect([image CGImage], cropRect);
        squareImage = [UIImage imageWithCGImage:croppedImageRef];
        CGImageRelease(croppedImageRef);
    }
    
    return squareImage;
}


@end
