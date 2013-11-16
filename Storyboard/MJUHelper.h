//
//  MJUHelper.h
//  Storyboard
//
//  Created by Martin Juhasz on 14/11/13.
//  Copyright (c) 2013 Martin Juhasz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MJUHelper : NSObject

+ (NSString*)secondsToTimeString:(int)totalSeconds includingHours:(BOOL)includeHours;

@end
