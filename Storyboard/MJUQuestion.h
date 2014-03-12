//
//  MJUQuestion.h
//  Storyboard
//
//  Created by Martin Juhasz on 10/03/14.
//  Copyright (c) 2014 Martin Juhasz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MJUQuestionSection;
//
@interface MJUQuestion : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) MJUQuestionSection *section;
@property (nonatomic) int32_t order;

@end
