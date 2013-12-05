//
//  UILabel+Additions.m
//  Storyboard
//
//  Created by Martin Juhasz on 19/11/13.
//  Copyright (c) 2013 Martin Juhasz. All rights reserved.
//

#import "UILabel+Additions.h"

@implementation UILabel (Additions)

- (CGRect)expectedSize
{
    CGSize maxSize = CGSizeMake(self.frame.size.width, MAXFLOAT);
    CGRect labelRect = [self.text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.font} context:nil];
    return labelRect;
}

@end
