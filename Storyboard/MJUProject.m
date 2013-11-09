//
//  Project.m
//  Storyboard
//
//  Created by Martin Juhasz on 02/11/13.
//  Copyright (c) 2013 Martin Juhasz. All rights reserved.
//

#import "MJUProject.h"
#import "MJUScene.h"

@implementation MJUProject

@dynamic title;
@dynamic companyName;
@dynamic createdAt;
@dynamic scenes;
@dynamic companyLogo;
@synthesize orderedScenes = _orderedScenes;

- (void) awakeFromInsert
{
    [super awakeFromInsert];
    
    // or [self setPrimitiveDate:[NSDate date]];
    // to avoid triggering KVO notifications
    self.createdAt = [NSDate date];
}

- (NSArray*)orderedScenes
{
    return [self.scenes allObjects];
}

- (void)addCompanyLogo:(UIImage*)image
{
    NSData *imageData = UIImageJPEGRepresentation(image, 0.8);
    [self setCompanyLogo:imageData];
    
}

- (UIImage*)getCompanyLogo
{
    return [UIImage imageWithData:self.companyLogo];
}



@end
