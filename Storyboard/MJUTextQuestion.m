//
//  MJUTextQuestion.m
//  Storyboard
//
//  Created by Martin Juhasz on 10/03/14.
//  Copyright (c) 2014 Martin Juhasz. All rights reserved.
//

#import "MJUTextQuestion.h"
#import "MJUTextAnswer.h"
#import "MJUProject.h"

@implementation MJUTextQuestion

@dynamic answers;

- (BOOL)hasAnswerForProject:(MJUProject*)project
{
    MJUTextAnswer *answer = [self getSelectedAnswerForProject:project];
    return (answer != nil);
}

- (MJUTextAnswer*)getSelectedAnswerForProject:(MJUProject*)project
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"MJUTextAnswer"];
    [fetchRequest setFetchLimit:1];
    
    NSPredicate *projectPredicate = [NSPredicate predicateWithFormat:@"project = %@", project];
    NSPredicate *questionPredicate = [NSPredicate predicateWithFormat:@"question = %@", self];
    
    NSPredicate *compoundPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[projectPredicate, questionPredicate]];
    [fetchRequest setPredicate:compoundPredicate];
    
    NSError *fetchError = nil;
    NSArray *results = [[self managedObjectContext] executeFetchRequest:fetchRequest error:&fetchError];
    if(results && results.count > 0) {
        return [results objectAtIndex:0];
    } else if(fetchError) {
        NSLog(@"Error: %@", [fetchError localizedDescription]);
    }
    return nil;
}

@end
