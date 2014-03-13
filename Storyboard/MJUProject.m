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
@dynamic answers;
@dynamic companyLogo;
@synthesize orderedScenes = _orderedScenes;

- (void) awakeFromInsert
{
    [super awakeFromInsert];
    
    // or [self setPrimitiveDate:[NSDate date]];
    // to avoid triggering KVO notifications
    self.createdAt = [NSDate date];
}

- (BOOL)hasScenes
{
    return (self.scenes.count > 0);
}

- (NSArray*)orderedScenes
{
    NSMutableArray *scenes = [NSMutableArray arrayWithArray:[self.scenes allObjects]];
    [scenes sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"order" ascending:YES]]];
    return scenes;
}

- (void)addCompanyLogo:(UIImage*)image
{
    NSData *imageData = UIImageJPEGRepresentation(image, 0.8);
    [self setCompanyLogo:imageData];
    
}

- (int)getTotalTime
{
    int total = 0;
    for (MJUScene* scene in self.scenes) {
        total += scene.time;
    }
    return total;
}

- (UIImage*)getCompanyLogo
{
    return [UIImage imageWithData:self.companyLogo];
}

- (NSString*)projectLogoSRC
{
    return [[[[self objectID] URIRepresentation] absoluteString] stringByReplacingOccurrencesOfString:@"x-coredata://" withString:@"mjulocalprojectimage://"];
}



@end
