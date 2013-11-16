//
//  MJUQuestion.h
//  Storyboard
//
//  Created by Martin Juhasz on 16/11/13.
//  Copyright (c) 2013 Martin Juhasz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MJUQuestion : NSObject

@property (strong, nonatomic) NSString *sectionTitle;
@property (strong, nonatomic) NSArray *subQuestions;

- (id)initWithDict:(NSDictionary*)dict;

@end
