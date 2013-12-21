//
//  MJUSpacedTableViewCell.m
//  Storyboard
//
//  Created by Martin Juhasz on 09/12/13.
//  Copyright (c) 2013 Martin Juhasz. All rights reserved.
//

#import "MJUSpacedTableViewCell.h"
#import "UIColor+Additions.h"
#import <QuartzCore/QuartzCore.h>

@implementation MJUSpacedTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setFrame:(CGRect)frame
{
    if(IS_IPAD) {
        frame.origin.x += 30;
        frame.size.width -= 2 * 30;
        [super setFrame:frame];
    } else {
        [super setFrame:frame];
    }
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    // just do on iPad
    if (!IS_IPAD) return;
    
    
    NSPredicate *borderPredicate = [NSPredicate predicateWithFormat:@"name == %@ OR name == %@", @"MJULeftBorderLayer", @"MJURightBorderLayer"];
    for(CALayer *layer in [self.layer.sublayers filteredArrayUsingPredicate:borderPredicate]) {
        [layer removeFromSuperlayer];
    }
    
    CGFloat frameWidth;
    if(IS_RETINA) {
        frameWidth = 0.5f;
    } else {
        frameWidth = 1.0f;
    }
    
    CALayer *leftBorderLayer = [CALayer layer];
    leftBorderLayer.backgroundColor = [UIColor colorWithHexString:@"d3d2d6"].CGColor;
    leftBorderLayer.frame = CGRectMake(0.0f, 0.0f, frameWidth, self.frame.size.height);
    leftBorderLayer.name = @"MJULeftBorderLayer";
    [self.layer addSublayer:leftBorderLayer];
    
    CALayer *rightBorderLayer = [CALayer layer];
    rightBorderLayer.backgroundColor = [UIColor colorWithHexString:@"d3d2d6"].CGColor;
    rightBorderLayer.frame = CGRectMake(self.bounds.size.width, 0.0f, frameWidth, self.frame.size.height);
    rightBorderLayer.name = @"MJURightBorderLayer";
    [self.layer addSublayer:rightBorderLayer];
}


@end
