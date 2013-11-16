//
//  MJUHelper.m
//  Storyboard
//
//  Created by Martin Juhasz on 14/11/13.
//  Copyright (c) 2013 Martin Juhasz. All rights reserved.
//

#import "MJUHelper.h"

@implementation MJUHelper

+ (NSString*)secondsToTimeString:(int)totalSeconds includingHours:(BOOL)includeHours
{
    int seconds = totalSeconds % 60;
    
    if(!includeHours) {
        int minutes = totalSeconds / 60;
        return [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
    }
    
    int minutes = (totalSeconds / 60) % 60;
    int hours = totalSeconds / 3600;
    return [NSString stringWithFormat:@"%02d:%02d:%02d",hours, minutes, seconds];
    
}

@end
