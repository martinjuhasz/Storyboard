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
#import "MJUProject.h"

@implementation MJUPDFImageURLProtocol

+ (BOOL)canInitWithRequest:(NSURLRequest*)theRequest
{
    if ([theRequest.URL.scheme caseInsensitiveCompare:@"mjulocalsceneimage"] == NSOrderedSame || [theRequest.URL.scheme caseInsensitiveCompare:@"mjulocalprojectimage"] == NSOrderedSame) {
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
    if ([self.request.URL.scheme caseInsensitiveCompare:@"mjulocalsceneimage"] == NSOrderedSame) {
        [self startLoadingSceneImage];
    } else {
        [self startLoadingProjectImage];
    }
}

- (void)startLoadingProjectImage
{
    NSURLResponse *response = [[NSURLResponse alloc] initWithURL:self.request.URL MIMEType:@"image/jpg" expectedContentLength:-1 textEncodingName:nil];
    
    
    NSURL *imageURL = [NSURL URLWithString:[[response.URL absoluteString] stringByReplacingOccurrencesOfString:@"mjulocalprojectimage" withString:@"x-coredata"]];
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
    MJUProject *project = (MJUProject*)[[[MJUProjectsDataModel sharedDataModel] mainContext] existingObjectWithID:imageObjectID error:&error];
    
    if(error) {
        [[self client] URLProtocol:self didFailWithError:error];
        return;
    }
    
    if(!project || !project.companyLogo) {
        NSError *imageError = [NSError errorWithDomain:@"MJUPDFImageURLProtocol.NoSuchImageError" code:1 userInfo:nil];
        [[self client] URLProtocol:self didFailWithError:imageError];
        return;
    }
    
    [[self client] URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
    [[self client] URLProtocol:self didLoadData:project.companyLogo];
    [[self client] URLProtocolDidFinishLoading:self];
    
}

- (void)startLoadingSceneImage
{
    NSURLResponse *response = [[NSURLResponse alloc] initWithURL:self.request.URL MIMEType:@"image/jpg" expectedContentLength:-1 textEncodingName:nil];
    
    NSURL *imageURL = [NSURL URLWithString:[[response.URL absoluteString] stringByReplacingOccurrencesOfString:@"mjulocalsceneimage" withString:@"x-coredata"]];
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
    
    [[self client] URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
    [[self client] URLProtocol:self didLoadData:sceneImage.image];
    [[self client] URLProtocolDidFinishLoading:self];
    
}

- (void)stopLoading
{
    
}

@end
