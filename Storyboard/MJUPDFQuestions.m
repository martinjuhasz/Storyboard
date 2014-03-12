//
//  MJUPDFQuestions.m
//  Storyboard
//
//  Created by Martin Juhasz on 12/03/14.
//  Copyright (c) 2014 Martin Juhasz. All rights reserved.
//

#import "MJUPDFQuestions.h"
#import "MJUProject.h"

@implementation MJUPDFQuestions

- (id)initWithProject:(MJUProject*)project
{
    self = [super init];
    if (self) {
        self.project = project;
    }
    return self;
}

@end
