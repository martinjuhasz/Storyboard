//
//  MJUSplitViewController.m
//  Storyboard
//
//  Created by Martin Juhasz on 06/12/13.
//  Copyright (c) 2013 Martin Juhasz. All rights reserved.
//

#import "MJUSplitViewController.h"

@interface MJUSplitViewController ()

@end

@implementation MJUSplitViewController


-(BOOL)splitViewController:(UISplitViewController *)svc shouldHideViewController:(UIViewController *)vc inOrientation:(UIInterfaceOrientation)orientation
{
    return NO;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.delegate = self;
}

//- (void)viewDidLayoutSubviews
//{
//    CGFloat kMasterViewWidth;
//    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
//    if (UIInterfaceOrientationIsPortrait(interfaceOrientation)) {
//        kMasterViewWidth = 320.0f;
//    } else {
//        kMasterViewWidth = 410.0f;
//    }
//    
//    
//    UIViewController *masterViewController = [self.viewControllers objectAtIndex:0];
//    UIViewController *detailViewController = [self.viewControllers objectAtIndex:1];
//    
//    // Adjust the width of the master view
//    CGRect masterViewFrame = masterViewController.view.frame;
//    CGFloat deltaX = masterViewFrame.size.width - kMasterViewWidth;
//    masterViewFrame.size.width -= deltaX;
//    masterViewController.view.frame = masterViewFrame;
//    
//    // Adjust the width of the detail view
//    CGRect detailViewFrame = detailViewController.view.frame;
//    detailViewFrame.origin.x -= deltaX;
//    detailViewFrame.size.width += deltaX;
//    detailViewController.view.frame = detailViewFrame;
//    
//    [masterViewController.view setNeedsLayout];
//    [detailViewController.view setNeedsLayout];
//}




@end
