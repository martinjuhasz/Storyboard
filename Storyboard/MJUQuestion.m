//
//  MJUQuestion.m
//  Storyboard
//
//  Created by Martin Juhasz on 10/03/14.
//  Copyright (c) 2014 Martin Juhasz. All rights reserved.
//

#import "MJUQuestion.h"
#import "MJUQuestionSection.h"
#import "MJUProject.h"

@implementation MJUQuestion

@dynamic title;
@dynamic section;
@dynamic order;

- (BOOL)hasAnswerForProject:(MJUProject*)project {
    return NO;
}

@end
