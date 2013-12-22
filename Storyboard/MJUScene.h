//
//  MJUScene.h
//  Storyboard
//
//  Created by Martin Juhasz on 03/11/13.
//  Copyright (c) 2013 Martin Juhasz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MJUProject, MJUSceneImage;

@interface MJUScene : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * imageText;
@property (nonatomic) int32_t sceneNumber;
@property (nonatomic, retain) NSString * soundText;
@property (nonatomic) int32_t time;
@property (nonatomic) int32_t order;
@property (nonatomic, retain) NSSet *images;
@property (nonatomic, retain) MJUProject *project;
@property (nonatomic, retain, readonly) NSString *sceneImageSRC;

- (BOOL)hasImage;
- (UIImage*)getImage;
- (MJUSceneImage*)getSceneImage;

@end

@interface MJUScene (CoreDataGeneratedAccessors)

- (void)addImagesObject:(MJUSceneImage *)value;
- (void)removeImagesObject:(MJUSceneImage *)value;
- (void)addImages:(NSSet *)values;
- (void)removeImages:(NSSet *)values;

@end
