//
//  MJUImagePickerController.m
//  Storyboard
//
//  Created by Martin Juhasz on 13/12/13.
//  Copyright (c) 2013 Martin Juhasz. All rights reserved.
//

#import "MJUImagePickerController.h"

@interface MJUImagePickerController ()

@end

@implementation MJUImagePickerController

- (NSUInteger)supportedInterfaceOrientations{
    if(IS_IPAD) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    }
    return UIInterfaceOrientationMaskPortrait;
    
}

@end
