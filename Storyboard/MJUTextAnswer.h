//
//  MJUTextAnswer.h
//  Storyboard
//
//  Created by Martin Juhasz on 10/03/14.
//  Copyright (c) 2014 Martin Juhasz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "MJUAnswer.h"


@interface MJUTextAnswer : MJUAnswer

@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSManagedObject *question;

@end
