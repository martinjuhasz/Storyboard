//
//  MJUQuestionSection.h
//  Storyboard
//
//  Created by Martin Juhasz on 17/01/14.
//  Copyright (c) 2014 Martin Juhasz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MJUQuestion, MJUQuestionCategory;

@interface MJUQuestionSection : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) MJUQuestionCategory *category;
@property (nonatomic, retain) NSSet *questions;
@property (nonatomic) int32_t order;

- (NSArray*)sortedQuestions;

@end

@interface MJUQuestionSection (CoreDataGeneratedAccessors)

- (void)addQuestionsObject:(MJUQuestion *)value;
- (void)removeQuestionsObject:(MJUQuestion *)value;
- (void)addQuestions:(NSSet *)values;
- (void)removeQuestions:(NSSet *)values;

@end
