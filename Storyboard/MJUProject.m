//
//  Project.m
//  Storyboard
//
//  Created by Martin Juhasz on 02/11/13.
//  Copyright (c) 2013 Martin Juhasz. All rights reserved.
//

#import "MJUProject.h"
#import "MJUScene.h"
#import "MJUAnswer.h"
#import "MJUSubQuestion.h"

@implementation MJUProject

@dynamic title;
@dynamic companyName;
@dynamic createdAt;
@dynamic scenes;
@dynamic answers;
@dynamic companyLogo;
@synthesize orderedScenes = _orderedScenes;

- (void) awakeFromInsert
{
    [super awakeFromInsert];
    
    // or [self setPrimitiveDate:[NSDate date]];
    // to avoid triggering KVO notifications
    self.createdAt = [NSDate date];
}

- (NSArray*)orderedScenes
{
    return [self.scenes allObjects];
}

- (void)addCompanyLogo:(UIImage*)image
{
    NSData *imageData = UIImageJPEGRepresentation(image, 0.8);
    [self setCompanyLogo:imageData];
    
}

- (int)getTotalTime
{
    int total = 0;
    for (MJUScene* scene in self.scenes) {
        total += scene.time;
    }
    return total;
}

- (UIImage*)getCompanyLogo
{
    return [UIImage imageWithData:self.companyLogo];
}

- (MJUAnswer*)getAnswerForQuestion:(MJUSubQuestion*)question
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"MJUAnswer"];
    
    NSPredicate *projectPredicate = [NSPredicate predicateWithFormat:@"project == %@", self];
    NSPredicate *idPredicate = [NSPredicate predicateWithFormat:@"questionID == %@", question.questionID];
    NSPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[projectPredicate, idPredicate]];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *array = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (array == nil || error || array.count <= 0) return nil;
    return [array objectAtIndex:0];
}



@end
