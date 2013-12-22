//
//  MJUSubQuestion.m
//  Storyboard
//
//  Created by Martin Juhasz on 16/11/13.
//  Copyright (c) 2013 Martin Juhasz. All rights reserved.
//

#import "MJUSubQuestion.h"
#import "MJUProject.h"

@implementation MJUSubQuestion

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

- (BOOL)isSelectable
{
    return !!self.selections;
}

- (MJUAnswer*)answer
{
    if(self.project) {
        return [self.project getAnswerForQuestion:self];
    }
    return nil;
}

- (void)loadDict:(NSDictionary*)dict
{
    self.questionID = [NSNumber numberWithInt:[[dict objectForKey:@"id"] intValue]];
    self.title = [dict objectForKey:@"title"];
    NSArray *selectionsDict = [dict objectForKey:@"selections"];
    NSMutableArray *selections = [NSMutableArray array];
    
    if([selectionsDict count] > 0) {
        for (NSString *selection in selectionsDict) {
            [selections addObject:selection];
        }
    }
    
    if(selections.count > 0) {
        self.selections = [NSArray arrayWithArray:selections];
    } else {
        self.selections = nil;
    }
    
}

@end
