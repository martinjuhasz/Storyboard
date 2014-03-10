//
//  MJUSelectableQuestion.h
//  Storyboard
//
//  Created by Martin Juhasz on 10/03/14.
//  Copyright (c) 2014 Martin Juhasz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "MJUQuestion.h"


@interface MJUSelectableQuestion : MJUQuestion

@property (nonatomic, retain) NSSet *selectables;
@end

@interface MJUSelectableQuestion (CoreDataGeneratedAccessors)

- (void)addSelectablesObject:(NSManagedObject *)value;
- (void)removeSelectablesObject:(NSManagedObject *)value;
- (void)addSelectables:(NSSet *)values;
- (void)removeSelectables:(NSSet *)values;

@end
