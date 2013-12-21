//
//  MJUCell.h
//  Storyboard
//
//  Created by Martin Juhasz on 14/12/13.
//  Copyright (c) 2013 Martin Juhasz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJUSpacedTableViewCell.h"

@interface MJUTextViewCell : MJUSpacedTableViewCell

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end
