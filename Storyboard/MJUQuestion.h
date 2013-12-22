//
//  MJUQuestion.h
//  Storyboard
//
//  Created by Martin Juhasz on 16/11/13.
//  Copyright (c) 2013 Martin Juhasz. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MJUProject;

@interface MJUQuestion : NSObject

@property (strong, nonatomic) NSString *sectionTitle;
@property (strong, nonatomic) NSArray *subQuestions;
@property (strong, nonatomic) MJUProject *project;

- (id)initWithDict:(NSDictionary*)dict;
- (id)initWithDict:(NSDictionary*)dict project:(MJUProject*)project;

@end
