//
//  MJUQuestionsImporter.m
//  Storyboard
//
//  Created by Martin Juhasz on 12/03/14.
//  Copyright (c) 2014 Martin Juhasz. All rights reserved.
//

#import "MJUQuestionsImporter.h"
#import "MJUQuestionCategory.h"
#import "MJUQuestionSection.h"
#import "MJUQuestion.h"
#import "MJUSelectableQuestion.h"
#import "MJUTextQuestion.h"
#import "MJUSelectable.h"


@implementation MJUQuestionsImporter

- (instancetype)initWithContext:(NSManagedObjectContext*)context
{
    self = [super init];
    if (self) {
        self.context = context;
    }
    return self;
}

- (BOOL)import
{
    NSArray *categories = [[NSMutableArray alloc] initWithContentsOfFile:[self getPathForFile:@"questions"]];
    
    [self importCategories:categories];
    
    NSError *error;
    [self.context save:&error];
    if(error) {
        NSLog(@"%@", [error localizedDescription]);
        return NO;
    }
    return YES;
    
}

- (void)importCategories:(NSArray*)categories
{
    [categories enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSDictionary *categoryDict = (NSDictionary*)obj;
        MJUQuestionCategory *category = (MJUQuestionCategory *)[NSEntityDescription insertNewObjectForEntityForName:@"MJUQuestionCategory" inManagedObjectContext:self.context];
        category.order = idx;
        category.title = [categoryDict objectForKey:@"title"];
        category.iconID = [(NSNumber*)[categoryDict objectForKey:@"icon"] intValue];
        [self importSections:[categoryDict objectForKey:@"section"] intoCategory:category];
    }];
}

- (void)importSections:(NSArray*)sections intoCategory:(MJUQuestionCategory*)category
{
    [sections enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSDictionary *sectionDict = (NSDictionary*)obj;
        MJUQuestionSection *section = (MJUQuestionSection *)[NSEntityDescription insertNewObjectForEntityForName:@"MJUQuestionSection" inManagedObjectContext:self.context];
        section.order = idx;
        section.title = [sectionDict objectForKey:@"title"];
        [category addSectionsObject:section];
        
        [self importQuestions:[sectionDict objectForKey:@"questions"] intoSection:section];
    }];
}

- (void)importQuestions:(NSArray*)questions intoSection:(MJUQuestionSection*)section
{
    [questions enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSDictionary *questionDict = (NSDictionary*)obj;
        NSArray *selections = [questionDict objectForKey:@"selections"];
        MJUQuestion *question;
        if(selections) {
            question = (MJUSelectableQuestion *)[NSEntityDescription insertNewObjectForEntityForName:@"MJUSelectableQuestion" inManagedObjectContext:self.context];
        } else {
            question = (MJUTextQuestion *)[NSEntityDescription insertNewObjectForEntityForName:@"MJUTextQuestion" inManagedObjectContext:self.context];
        }
        question.title = [questionDict objectForKey:@"title"];
        question.order = idx;
        [section addQuestionsObject:question];
        
        if(selections) {
            [self importSelections:selections intoQuestion:(MJUSelectableQuestion*)question];
        }
    }];
}

- (void)importSelections:(NSArray*)selections intoQuestion:(MJUSelectableQuestion*)question
{
    [selections enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *title = (NSString*)obj;
        MJUSelectable *selectable = (MJUSelectable *)[NSEntityDescription insertNewObjectForEntityForName:@"MJUSelectable" inManagedObjectContext:self.context];
        selectable.text = title;
        selectable.order = idx;
        [question addSelectablesObject:selectable];
    }];
}

- (NSString*)getPathForFile:(NSString*)file
{
    NSString *path = [[NSBundle mainBundle] pathForResource:file ofType:@"plist"];
    return path;
}

@end
