//
//  MJUSelectableAnswer.m
//  Storyboard
//
//  Created by Martin Juhasz on 10/03/14.
//  Copyright (c) 2014 Martin Juhasz. All rights reserved.
//

#import "MJUSelectableAnswer.h"
#import "NSError+Additions.h"
#import "MJUSelectable.h"


@implementation MJUSelectableAnswer

@dynamic selected;


/*
- (BOOL)validateForInsert:(NSError **)error
{
    BOOL propertiesValid = [super validateForUpdate:error];
    BOOL uniquenessValid = [self validateUniqueness:error];
    return (propertiesValid && uniquenessValid);
}

- (BOOL)validateForUpdate:(NSError **)error
{
    BOOL propertiesValid = [super validateForUpdate:error];
    BOOL uniquenessValid = [self validateUniqueness:error];
    return (propertiesValid && uniquenessValid);
}

- (BOOL)validateUniqueness:(NSError **)error
{
    BOOL answerExists = [self answerExistsForSelectable:(MJUSelectable*)self.selected];
    if(answerExists) {
        
        // create error
        NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
        [userInfo setObject:@"there should only be one selection for this question and project" forKey:NSLocalizedFailureReasonErrorKey];
        [userInfo setObject:self forKey:NSValidationObjectErrorKey];
        
        NSError *isUniqueError = [NSError errorWithDomain:@"de.martinjuhasz.storyboard"
                                                     code:NSManagedObjectValidationError
                                                 userInfo:userInfo];
        
        if (*error == nil) {
            *error = isUniqueError;
        } else {
            *error = [*error combineWithError:isUniqueError];
        }
        
        return NO;
    }
    return YES;
}

- (BOOL)answerExistsForSelectable:(MJUSelectable*)selectable
{
    if(!selectable || ![selectable isKindOfClass:[MJUSelectable class]]) {
        return NO;
    }
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"MJUSelectableAnswer"];
    [fetchRequest setFetchLimit:1];
    
    NSPredicate *projectPredicate = [NSPredicate predicateWithFormat:@"project = %@", self.project];
    NSPredicate *questionPredicate = [NSPredicate predicateWithFormat:@"selected.question = %@", selectable.question];
    
    NSPredicate *compoundPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[projectPredicate, questionPredicate]];
    [fetchRequest setPredicate:compoundPredicate];
    
    NSError *error = nil;
    NSArray *results = [[self managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    if(results && results.count == 1) {
        MJUSelectableAnswer *answer = [results objectAtIndex:0];
        if(answer == self) {
            return NO;
        } else {
            return YES;
        }
    } else if(results && results.count > 1) {
        return YES;
    } else {
        NSLog(@"Error: %@", error);
    }
    return NO;
}
*/

@end
