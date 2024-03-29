//
//  MJUQuestionCategory.h
//  Storyboard
//
//  Created by Martin Juhasz on 17/01/14.
//  Copyright (c) 2014 Martin Juhasz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MJUProject;

typedef NS_ENUM(NSInteger, MJUQuestionCategoryIcon) {
    MJUQuestionCategoryIconContact,
    MJUQuestionCategoryIconCalendar,
    MJUQuestionCategoryIconQuestionMark,
    MJUQuestionCategoryIconStick,
    MJUQuestionCategoryIconAudio,
    MJUQuestionCategoryIconPaperClip,
    MJUQuestionCategoryIconPhoto
};

@interface MJUQuestionCategory : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSSet *sections;
@property (nonatomic) int32_t order;
@property (nonatomic) int32_t iconID;

- (NSArray*)sortedSections;
- (UIImage*)icon;
+ (UIImage*)icon:(MJUQuestionCategoryIcon)icon;
- (BOOL)hasAnswersForCategoryInProject:(MJUProject*)project;

@end

@interface MJUQuestionCategory (CoreDataGeneratedAccessors)

- (void)addSectionsObject:(NSManagedObject *)value;
- (void)removeSectionsObject:(NSManagedObject *)value;
- (void)addSections:(NSSet *)values;
- (void)removeSections:(NSSet *)values;

@end
