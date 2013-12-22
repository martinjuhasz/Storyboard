//
//  MJUQuestionHelper.m
//  Storyboard
//
//  Created by Martin Juhasz on 16/11/13.
//  Copyright (c) 2013 Martin Juhasz. All rights reserved.
//

#import "MJUQuestionHelper.h"
#import "MJUQuestion.h"
#import "MJUSubQuestion.h"
#import "MJUProject.h"

@implementation MJUQuestionHelper

- (id)initWithPList:(NSString*)plistFile
{
    self = [super init];
    if (self) {
        self.plistPath = [self getPathForFile:plistFile];
        [self loadQuestions];
    }
    return self;
}

- (id)initWithPList:(NSString*)plistFile project:(MJUProject*)project
{
    self = [super init];
    if (self) {
        self.plistPath = [self getPathForFile:plistFile];
        self.project = project;
        [self loadQuestions];
    }
    return self;
}

- (NSString*)getPathForFile:(NSString*)file
{
    NSString *path = [[NSBundle mainBundle] pathForResource:file ofType:@"plist"];
    return path;
}

- (void)loadQuestions
{
    NSMutableArray *plistQuestions = [[NSMutableArray alloc] initWithContentsOfFile:self.plistPath];
    NSMutableArray *questions = [NSMutableArray array];
    
    for (NSDictionary *questionDict in plistQuestions) {
        MJUQuestion *question = [[MJUQuestion alloc] initWithDict:questionDict project:self.project];
        [questions addObject:question];
    }
    self.questions = [NSArray arrayWithArray:questions];
}

- (MJUSubQuestion*)subQuestionForIndexPath:(NSIndexPath*)indexPath
{
    MJUQuestion *question = [self.questions objectAtIndex:indexPath.section];
    return [question.subQuestions objectAtIndex:indexPath.row];
}


@end
