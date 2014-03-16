//
//  MJUQuestionsImporter.h
//  Storyboard
//
//  Created by Martin Juhasz on 12/03/14.
//  Copyright (c) 2014 Martin Juhasz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MJUQuestionsImporter : NSObject

@property(strong, nonatomic) NSManagedObjectContext *context;

- (instancetype)initWithContext:(NSManagedObjectContext*)context;
- (BOOL)import;

@end
