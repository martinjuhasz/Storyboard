//
//  MJUSelectable.h
//  Storyboard
//
//  Created by Martin Juhasz on 10/03/14.
//  Copyright (c) 2014 Martin Juhasz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MJUSelectableAnswer, MJUSelectableQuestion;

@interface MJUSelectable : NSManagedObject

@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSSet *answers;
@property (nonatomic, retain) MJUSelectableQuestion *question;
@end

@interface MJUSelectable (CoreDataGeneratedAccessors)

- (void)addAnswersObject:(MJUSelectableAnswer *)value;
- (void)removeAnswersObject:(MJUSelectableAnswer *)value;
- (void)addAnswers:(NSSet *)values;
- (void)removeAnswers:(NSSet *)values;

@end
