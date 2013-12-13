//
//  MJUTableHeaderView.m
//  Storyboard
//
//  Created by Martin Juhasz on 09/12/13.
//  Copyright (c) 2013 Martin Juhasz. All rights reserved.
//

#import "MJUTableHeaderView.h"
#import "UIColor+Additions.h"

@implementation MJUTableHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        CGRect titleFrame = frame;
        titleFrame.origin.y = 10.0f;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            titleFrame.origin.x = 42.0f;
        } else {
            titleFrame.origin.x = 12.0f;
        }
        
        self.titleLabel = [[UILabel alloc] initWithFrame:titleFrame];
        self.titleLabel.font = [UIFont systemFontOfSize:12.0f];
        self.titleLabel.textColor = [UIColor colorWithHexString:@"959589"];
        
        [self addSubview:self.titleLabel];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
