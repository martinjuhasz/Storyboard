//
//  MJUSubQuestion.h
//  Storyboard
//
//  Created by Martin Juhasz on 16/11/13.
//  Copyright (c) 2013 Martin Juhasz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MJUSubQuestion : NSObject

@property (strong, nonatomic) NSNumber *questionID;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSArray *selections;
@property (assign, nonatomic, readonly) BOOL isSelectable;


- (id)initWithDict:(NSDictionary*)dict;

@end
