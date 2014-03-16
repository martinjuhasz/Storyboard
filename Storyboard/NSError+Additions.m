//
//  NSError+Additions.m
//  Storyboard
//
//  Created by Martin Juhasz on 11/03/14.
//  Copyright (c) 2014 Martin Juhasz. All rights reserved.
//

#import "NSError+Additions.h"

@implementation NSError (Additions)

- (NSError *)combineWithError:(NSError *)error
{
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    NSMutableArray *errors = [NSMutableArray arrayWithObject:error];
    
    if ([self code] == NSValidationMultipleErrorsError) {
        [userInfo addEntriesFromDictionary:[self userInfo]];
        [errors addObjectsFromArray:[userInfo objectForKey:NSDetailedErrorsKey]];
    }
    else {
        [errors addObject:self];
    }
    
    [userInfo setObject:errors forKey:NSDetailedErrorsKey];
    
    return [NSError errorWithDomain:NSCocoaErrorDomain
                               code:NSValidationMultipleErrorsError
                           userInfo:userInfo];
}

@end
