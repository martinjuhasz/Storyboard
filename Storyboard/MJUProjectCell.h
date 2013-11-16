//
//  MJUProjectCell.h
//  Storyboard
//
//  Created by Martin Juhasz on 14/11/13.
//  Copyright (c) 2013 Martin Juhasz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MJUProjectCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *companyLabel;
@property (weak, nonatomic) IBOutlet UIImageView *companyLogo;

@end
