//
//  MJUSelectableAnswer.h
//  Storyboard
//
//  Created by Martin Juhasz on 10/03/14.
//  Copyright (c) 2014 Martin Juhasz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "MJUAnswer.h"


@interface MJUSelectableAnswer : MJUAnswer

@property (nonatomic, retain) NSManagedObject *selected;

@end
