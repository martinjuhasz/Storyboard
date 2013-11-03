//
//  MJUSceneImage.h
//  Storyboard
//
//  Created by Martin Juhasz on 03/11/13.
//  Copyright (c) 2013 Martin Juhasz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface MJUSceneImage : NSManagedObject

@property (nonatomic, retain) NSData * image;
@property (nonatomic) int32_t order;
@property (nonatomic, retain) NSManagedObject *scene;

@end
