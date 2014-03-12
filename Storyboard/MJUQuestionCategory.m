//
//  MJUQuestionCategory.m
//  Storyboard
//
//  Created by Martin Juhasz on 17/01/14.
//  Copyright (c) 2014 Martin Juhasz. All rights reserved.
//

#import "MJUQuestionCategory.h"


@implementation MJUQuestionCategory

@dynamic title;
@dynamic sections;
@dynamic order;

- (NSArray*)sortedSections
{
    [self willAccessValueForKey: @"sections"];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"order" ascending:YES];
    NSArray *returnArray = [self.sections sortedArrayUsingDescriptors:@[sortDescriptor]];
    [self didAccessValueForKey: @"sections"];
    return returnArray;
}

@end
