//
//  NSError+Additions.h
//  Storyboard
//
//  Created by Martin Juhasz on 11/03/14.
//  Copyright (c) 2014 Martin Juhasz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSError (Additions)

- (NSError *)combineWithError:(NSError *)error;

@end
