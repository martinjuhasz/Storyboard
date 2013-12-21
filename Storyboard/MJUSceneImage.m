//
//  MJUSceneImage.m
//  Storyboard
//
//  Created by Martin Juhasz on 03/11/13.
//  Copyright (c) 2013 Martin Juhasz. All rights reserved.
//

#import "MJUSceneImage.h"


@implementation MJUSceneImage

@dynamic image;
@dynamic order;
@dynamic scene;

- (void)addImage:(UIImage*)image
{
    NSData *imageData = UIImageJPEGRepresentation(image, 0.8);
    [self setImage:imageData];
    
}

- (UIImage*)getImage
{
    return [UIImage imageWithData:self.image];
}

- (NSString*)getObjectIDAsString
{
    return [[[self objectID] URIRepresentation] absoluteString];
}

@end
