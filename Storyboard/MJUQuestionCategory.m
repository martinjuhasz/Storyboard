//
//  MJUQuestionCategory.m
//  Storyboard
//
//  Created by Martin Juhasz on 17/01/14.
//  Copyright (c) 2014 Martin Juhasz. All rights reserved.
//

#import "MJUQuestionCategory.h"
#import "MJUProject.h"
#import "MJUQuestionSection.h"


@implementation MJUQuestionCategory

@dynamic title;
@dynamic sections;
@dynamic order;
@dynamic iconID;

- (NSArray*)sortedSections
{
    [self willAccessValueForKey: @"sections"];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"order" ascending:YES];
    NSArray *returnArray = [self.sections sortedArrayUsingDescriptors:@[sortDescriptor]];
    [self didAccessValueForKey: @"sections"];
    return returnArray;
}

- (BOOL)hasAnswersForCategoryInProject:(MJUProject*)project
{
    for (MJUQuestionSection *section in self.sections) {
        BOOL hasAnswer = [section hasAnswersForSectionInProject:project];
        if(hasAnswer) return YES;
    }
    return NO;
}

- (UIImage*)icon
{
    return [MJUQuestionCategory icon:self.iconID];
}

+ (UIImage*)icon:(MJUQuestionCategoryIcon)icon
{
    switch (icon) {
        case MJUQuestionCategoryIconContact:
            return [UIImage imageNamed:@"ProjectDetailIconContact"];
            break;
        case MJUQuestionCategoryIconCalendar:
            return [UIImage imageNamed:@"ProjectDetailIconCalendar"];
            break;
        case MJUQuestionCategoryIconQuestionMark:
            return [UIImage imageNamed:@"ProjectDetailIconParams"];
            break;
        case MJUQuestionCategoryIconStick:
            return [UIImage imageNamed:@"ProjectDetailIconPostProduction"];
            break;
        case MJUQuestionCategoryIconAudio:
            return [UIImage imageNamed:@"ProjectDetailIconAudio"];
            break;
        case MJUQuestionCategoryIconPaperClip:
            return [UIImage imageNamed:@"ProjectDetailIconOrganisation"];
            break;
        case MJUQuestionCategoryIconPhoto:
            return [UIImage imageNamed:@"ProjectDetailIconPhotos"];
            break;
        default:
            break;
    }
    return nil;
}

@end
