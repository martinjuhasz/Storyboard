//
//  MJUSceneImage.m
//  Storyboard
//
//  Created by Martin Juhasz on 03/11/13.
//  Copyright (c) 2013 Martin Juhasz. All rights reserved.
//

#import "MJUSceneImage.h"
#import "UIImage+Resizing.h"


@implementation MJUSceneImage

@dynamic image;
@dynamic order;
@dynamic scene;
@dynamic thumbnail;

- (void)addImage:(UIImage*)image
{
    NSData *imageData = UIImageJPEGRepresentation(image, 0.8);
    UIImage *squareImage = [_FICDSquareImageFromImage(image) scaleToFillSize:CGSizeMake(140.0f, 140.0f)];
    NSData *thumbnailData = UIImageJPEGRepresentation(squareImage, 0.8);
    [self setThumbnail:thumbnailData];
    [self setImage:imageData];
}

- (UIImage*)getImage
{
    return [UIImage imageWithData:self.image];
}

- (UIImage*)getThumbnail
{
    return [UIImage imageWithData:self.thumbnail];
}

- (NSString*)getObjectIDAsString
{
    return [[[self objectID] URIRepresentation] absoluteString];
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
