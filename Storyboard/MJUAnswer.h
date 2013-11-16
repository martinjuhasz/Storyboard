//
//  MJUAnswer.h
//  Storyboard
//
//  Created by Martin Juhasz on 16/11/13.
//  Copyright (c) 2013 Martin Juhasz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MJUProject;

@interface MJUAnswer : NSManagedObject

@property (nonatomic, retain) NSNumber * questionID;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSNumber * selected;
@property (nonatomic, retain) MJUProject *project;

@end
