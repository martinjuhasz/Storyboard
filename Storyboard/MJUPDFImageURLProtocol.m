//
//  MJUPDFImageURLProtocol.m
//  Storyboard
//
//  Created by Martin Juhasz on 19/12/13.
//  Copyright (c) 2013 Martin Juhasz. All rights reserved.
//

#import "MJUPDFImageURLProtocol.h"
#import "MJUProjectsDataModel.h"
#import "MJUSceneImage.h"
#import "MJUPhoto.h"
#import "FICImageCache.h"

@implementation MJUPDFImageURLProtocol

+ (BOOL)canInitWithRequest:(NSURLRequest*)theRequest
{
    if ([theRequest.URL.scheme caseInsensitiveCompare:@"mjulocalimage"] == NSOrderedSame) {
        return YES;
    }
    return NO;
}

+ (NSURLRequest*)canonicalRequestForRequest:(NSURLRequest*)theRequest
{
    return theRequest;
}

- (void)startLoading
{
    NSURLResponse *response = [[NSURLResponse alloc] initWithURL:self.request.URL MIMEType:@"image/jpg" expectedContentLength:-1 textEncodingName:nil];
    
    
    NSURL *imageURL = [NSURL URLWithString:[[response.URL absoluteString] stringByReplacingOccurrencesOfString:@"mjulocalimage" withString:@"x-coredata"]];
    NSManagedObjectID *imageObjectID;
    
    @try {
        imageObjectID = [[[MJUProjectsDataModel sharedDataModel] persistentStoreCoordinator] managedObjectIDForURIRepresentation:imageURL];
    }
    @catch (NSException *exception) {
        NSError *uriError = [NSError errorWithDomain:@"MJUPDFImageURLProtocol.InvalidCoreDataURIError" code:1 userInfo:nil];
        [[self client] URLProtocol:self didFailWithError:uriError];
        return;
    }
    
    NSError *error;
    MJUSceneImage *sceneImage = (MJUSceneImage*)[[[MJUProjectsDataModel sharedDataModel] mainContext] existingObjectWithID:imageObjectID error:&error];
    
    if(error) {
        [[self client] URLProtocol:self didFailWithError:error];
        return;
    }
    
    if(!sceneImage) {
        NSError *imageError = [NSError errorWithDomain:@"MJUPDFImageURLProtocol.NoSuchImageError" code:1 userInfo:nil];
        [[self client] URLProtocol:self didFailWithError:imageError];
        return;
    }
    
    MJUPhoto *photo = [MJUPhoto photoForSceneImage:sceneImage];
    
    FICImageCacheCompletionBlock completionBlock = ^(id <FICEntity> entity, NSString *formatName, UIImage *image) {
        [[self client] URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
        NSData *data = UIImageJPEGRepresentation(image, 0.8);
        [[self client] URLProtocol:self didLoadData:data];
        [[self client] URLProtocolDidFinishLoading:self];
    };
    [[FICImageCache sharedImageCache] retrieveImageForEntity:photo withFormatName:MJUDefaultLandscapeImageFormatName completionBlock:completionBlock];
}

- (void)stopLoading
{
    
}

@end
