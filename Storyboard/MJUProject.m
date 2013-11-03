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
@dynamic createdAt;
@dynamic scenes;
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



@end
