//
//  MJUTextQuestion.h
//  Storyboard
//
//  Created by Martin Juhasz on 10/03/14.
//  Copyright (c) 2014 Martin Juhasz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "MJUQuestion.h"

@class MJUTextAnswer;

@interface MJUTextQuestion : MJUQuestion

@property (nonatomic, retain) NSSet *answers;
@end

@interface MJUTextQuestion (CoreDataGeneratedAccessors)

- (void)addAnswersObject:(MJUTextAnswer *)value;
- (void)removeAnswersObject:(MJUTextAnswer *)value;
- (void)addAnswers:(NSSet *)values;
- (void)removeAnswers:(NSSet *)values;

@end
