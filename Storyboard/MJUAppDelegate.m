//
//  MJUAppDelegate.m
//  Storyboard
//
//  Created by Martin Juhasz on 02/11/13.
//  Copyright (c) 2013 Martin Juhasz. All rights reserved.
//

#import "MJUAppDelegate.h"
#import "UIColor+Additions.h"
#import "FICImageCache.h"
#import "MJUPhoto.h"

@interface MJUAppDelegate(HockeyProtocols) < BITHockeyManagerDelegate, FICImageCacheDelegate> {}
@end

@implementation MJUAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [[BITHockeyManager sharedHockeyManager] configureWithBetaIdentifier:@"a0e42c8e25c20224ffd7ed9306d8bef8"
                                                         liveIdentifier:@"a0e42c8e25c20224ffd7ed9306d8bef8"
                                                               delegate:self];
    [[BITHockeyManager sharedHockeyManager] startManager];
    
    [self setStyles];
    [self initImageCache];
    
    return YES;
}

- (void)setStyles
{
    [[UITableView appearance] setBackgroundColor:[UIColor colorWithHexString:@"EDEDE4"]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"navBarBackground"] forBarMetrics:UIBarMetricsDefault];
    [[UIToolbar appearance] setBackgroundImage:[UIImage imageNamed:@"ScenesBarBackground"] forToolbarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{

}

- (void)initImageCache
{
    NSInteger squareImageFormatMaximumCount = 400;
    FICImageFormatDevices squareImageFormatDevices = FICImageFormatDevicePhone | FICImageFormatDevicePad;
    
    // Square Image
    FICImageFormat *smallSquareThumbnailImageFormat = [FICImageFormat formatWithName:MJUSmallSquareThumbnailImageFormatName family:MJUPhotoImageFormatFamily imageSize:MJUSmallSquareThumbnailImageSize style:FICImageFormatStyle32BitBGR maximumCount:squareImageFormatMaximumCount devices:squareImageFormatDevices];
    
    // Default Landscape Image
    CGSize defaultLandscapeImageSize;
    
    if(!IS_RETINA && UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) {
        // nonretina iphone
        defaultLandscapeImageSize = MJUDefaultLandscapeIphoneImageSize;
        
    } else if((IS_RETINA && UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) || (!IS_RETINA && UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)) {
        // retina iPhone or nonretina iPad
        defaultLandscapeImageSize = MJUDefaultLandscapeIphone2xIpadImageSize;
    } else {
        // retina ipad
        defaultLandscapeImageSize = MJUDefaultLandscapeIpad2xImageSize;
    }
    
    FICImageFormat *defaultLandscapeImageFormat = [FICImageFormat formatWithName:MJUDefaultLandscapeImageFormatName family:MJUPhotoImageFormatFamily imageSize:defaultLandscapeImageSize style:FICImageFormatStyle32BitBGR maximumCount:squareImageFormatMaximumCount devices:squareImageFormatDevices];
    
    
    // Configure the image cache
    FICImageCache *sharedImageCache = [FICImageCache sharedImageCache];
    [sharedImageCache setDelegate:self];
    [sharedImageCache setFormats:@[smallSquareThumbnailImageFormat, defaultLandscapeImageFormat]];
    
}

#pragma mark - FICImageCacheDelegate

- (void)imageCache:(FICImageCache *)imageCache wantsSourceImageForEntity:(id<FICEntity>)entity withFormatName:(NSString *)formatName completionBlock:(FICImageRequestCompletionBlock)completionBlock {
    // Images typically come from the Internet rather than from the app bundle directly, so this would be the place to fire off a network request to download the image.
    // For the purposes of this demo app, we'll just access images stored locally on disk.
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UIImage *sourceImage = [(MJUPhoto *)entity sourceImage];
        completionBlock(sourceImage);
    });
}

- (BOOL)imageCache:(FICImageCache *)imageCache shouldProcessAllFormatsInFamily:(NSString *)formatFamily forEntity:(id<FICEntity>)entity {
    return YES;
}

- (void)imageCache:(FICImageCache *)imageCache errorDidOccurWithMessage:(NSString *)errorMessage {
    NSLog(@"%@", errorMessage);
}

@end
