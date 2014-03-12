//
//  MJUQuestionSection.m
//  Storyboard
//
//  Created by Martin Juhasz on 17/01/14.
//  Copyright (c) 2014 Martin Juhasz. All rights reserved.
//

#import "MJUQuestionSection.h"
#import "MJUQuestion.h"
#import "MJUQuestionCategory.h"


@implementation MJUQuestionSection

@dynamic title;
@dynamic category;
@dynamic questions;
@dynamic order;

- (NSArray*)sortedQuestions
{
    [self willAccessValueForKey: @"questions"];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"order" ascending:YES];
    NSArray *returnArray = [self.questions sortedArrayUsingDescriptors:@[sortDescriptor]];
    [self didAccessValueForKey: @"questions"];
    return returnArray;
}

@end
