//
//  Project.h
//  Storyboard
//
//  Created by Martin Juhasz on 02/11/13.
//  Copyright (c) 2013 Martin Juhasz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MJUScene;

@interface MJUProject : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * companyName;
@property (nonatomic, retain) NSData * companyLogo;
@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSSet *scenes;
@property (nonatomic, retain) NSArray *orderedScenes;

- (void)addCompanyLogo:(UIImage*)image;
- (UIImage*)getCompanyLogo;

@end

@interface MJUProject (CoreDataGeneratedAccessors)

- (void)addScenesObject:(MJUScene *)value;
- (void)removeScenesObject:(MJUScene *)value;
- (void)addScenes:(NSSet *)values;
- (void)removeScenes:(NSSet *)values;

@end
