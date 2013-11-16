//
//  MJUQuestion.m
//  Storyboard
//
//  Created by Martin Juhasz on 16/11/13.
//  Copyright (c) 2013 Martin Juhasz. All rights reserved.
//

#import "MJUQuestion.h"
#import "MJUSubQuestion.h"

@implementation MJUQuestion

- (id)initWithDict:(NSDictionary*)dict
{
    self = [super init];
    if (self) {
        [self loadDict:dict];
    }
    return self;
}

- (void)loadDict:(NSDictionary*)dict
{
    self.sectionTitle = [dict objectForKey:@"title"];
    NSMutableArray *subQuestionArray = [NSMutableArray array];
    for (NSDictionary *subQuestionDict in [dict objectForKey:@"questions"]) {
        MJUSubQuestion *subQuestion = [[MJUSubQuestion alloc] initWithDict:subQuestionDict];
        [subQuestionArray addObject:subQuestion];
    }
    self.subQuestions = [NSArray arrayWithArray:subQuestionArray];
}

@end
