//
//  MJUQuestionHelper.h
//  Storyboard
//
//  Created by Martin Juhasz on 16/11/13.
//  Copyright (c) 2013 Martin Juhasz. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MJUSubQuestion;

@interface MJUQuestionHelper : NSObject

@property (nonatomic, strong) NSString *plistPath;
@property (nonatomic, strong) NSArray *questions;

- (id)initWithPList:(NSString*)plistFile;
- (MJUSubQuestion*)subQuestionForIndexPath:(NSIndexPath*)indexPath;

@end
