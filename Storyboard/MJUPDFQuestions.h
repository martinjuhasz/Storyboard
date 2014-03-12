//
//  MJUPDFQuestions.h
//  Storyboard
//
//  Created by Martin Juhasz on 12/03/14.
//  Copyright (c) 2014 Martin Juhasz. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MJUProject;

@interface MJUPDFQuestions : NSObject

@property (strong, nonatomic) MJUProject *project;

- (id)initWithProject:(MJUProject*)project;

@end
