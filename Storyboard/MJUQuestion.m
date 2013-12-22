//
//  MJUQuestion.m
//  Storyboard
//
//  Created by Martin Juhasz on 16/11/13.
//  Copyright (c) 2013 Martin Juhasz. All rights reserved.
//

#import "MJUQuestion.h"
#import "MJUSubQuestion.h"
#import "MJUProject.h"

@implementation MJUQuestion

- (id)initWithDict:(NSDictionary*)dict
{
    self = [super init];
    if (self) {
        [self loadDict:dict];
    }
    return self;
}

- (id)initWithDict:(NSDictionary*)dict project:(MJUProject*)project
{
    self = [super init];
    if (self) {
        self.project = project;
        [self loadDict:dict];
    }
    return self;
}

- (void)loadDict:(NSDictionary*)dict
{
    self.sectionTitle = [dict objectForKey:@"title"];
    NSMutableArray *subQuestionArray = [NSMutableArray array];
    for (NSDictionary *subQuestionDict in [dict objectForKey:@"questions"]) {
        MJUSubQuestion *subQuestion = [[MJUSubQuestion alloc] initWithDict:subQuestionDict project:self.project];
        [subQuestionArray addObject:subQuestion];
    }
    self.subQuestions = [NSArray arrayWithArray:subQuestionArray];
}

@end
