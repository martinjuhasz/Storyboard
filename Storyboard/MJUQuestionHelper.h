//
//  MJUQuestionHelper.h
//  Storyboard
//
//  Created by Martin Juhasz on 16/11/13.
//  Copyright (c) 2013 Martin Juhasz. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MJUProject;
@class MJUSubQuestion;

@interface MJUQuestionHelper : NSObject

@property (nonatomic, strong) NSString *plistPath;
@property (nonatomic, strong) NSArray *questions;
@property (nonatomic, strong) MJUProject *project;

- (id)initWithPList:(NSString*)plistFile;
- (id)initWithPList:(NSString*)plistFile project:(MJUProject*)project;
- (MJUSubQuestion*)subQuestionForIndexPath:(NSIndexPath*)indexPath;

@end
