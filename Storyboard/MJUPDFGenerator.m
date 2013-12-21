//
//  MJUPDFGenerator.m
//  Storyboard
//
//  Created by Martin Juhasz on 21/11/13.
//  Copyright (c) 2013 Martin Juhasz. All rights reserved.
//

#import "MJUPDFGenerator.h"
#import "MJUProject.h"
#import "MJUScene.h"
#import "MJUPDFImageURLProtocol.h"
#import "MJUSceneImage.h"


@implementation MJUPDFGenerator

- (id)initWithProject:(MJUProject*)project
{
    if(self) {
        self.project = project;
        [NSURLProtocol registerClass:[MJUPDFImageURLProtocol class]];
    }
    return self;
}

- (void)dealloc
{
    [NSURLProtocol unregisterClass:[MJUPDFImageURLProtocol class]];
}

- (void)generatePDFWithSuccess:(NDHTMLtoPDFCompletionBlock)success error:(NDHTMLtoPDFCompletionBlock)error
{
    NSString *htmlContent = [self generateHTML];
    
    dispatch_async(dispatch_get_main_queue(), ^(){
        self.pdfCreator = [NDHTMLtoPDF createPDFWithHTML:htmlContent pathForPDF:nil pageSize:kPaperSizeA4 margins:UIEdgeInsetsMake(10, 5, 10, 5) successBlock:success errorBlock:error];
    });
    
}

- (void)HTMLtoPDFDidSucceed:(NDHTMLtoPDF*)htmlToPDF
{
    NSLog(@"HTMLtoPDF did succeed (%@ / %@)", htmlToPDF, htmlToPDF.PDFpath);
}

- (void)HTMLtoPDFDidFail:(NDHTMLtoPDF*)htmlToPDF
{
    NSLog(@"HTMLtoPDF did fail (%@)", htmlToPDF);
}



- (NSString*)generateHTML
{
    NSString *header = [self getHeader];
    NSString *footer = [self getFooter];
    NSString *content = [self getContent];
    
    NSString *pdfContent = [NSString stringWithFormat:@"%@ %@ %@", header, content, footer];
    
    return pdfContent;
}

- (NSString*)getHeader
{
    NSString *header = [self getFile:@"pdf_header"];
    
    header = [self replace:@"PROJECT_TITLE" to:self.project.title in:header];
//    header = [self insertImage:[self.project getCompanyLogo] replace:@"IMAGE_LOGO" in:header];
    
    return header;
}

- (NSString*)getContent
{
    NSString* content = [self getFile:@"pdf_content"];
    NSString *sceneRows = [self getSceneRows];
    content = [self replace:@"SCENE_ROWS" to:sceneRows in:content];
    
    
    return content;
}

- (NSString*)getFooter
{
    NSString *footer = [self getFile:@"pdf_footer"];
    return footer;
}

- (NSString*)getSceneRows
{
    NSMutableString *rows = [NSMutableString string];
    for (MJUScene *scene in self.project.orderedScenes) {
        NSString *row = [self getSceneRowForScene:scene];
        [rows appendString:row];
    }
    return [NSString stringWithString:rows];
}

- (NSString*)getSceneRowForScene:(MJUScene*)scene
{
    NSString *sceneRow = [self getFile:@"pdf_scene-row"];
    sceneRow = [self replace:@"SCENE_NUMBER" to:[NSString stringWithFormat:@"%d", scene.order+1] in:sceneRow];
    sceneRow = [self insertImage:[scene getSceneImage] replace:@"IMAGE" in:sceneRow];
    sceneRow = [self replace:@"IMAGE_TEXT" to:scene.imageText in:sceneRow];
    sceneRow = [self replace:@"SOUND_TEXT" to:scene.soundText in:sceneRow];
    
    return sceneRow;
}


- (NSString*)getFile:(NSString*)fileName
{
    NSError *error;
    NSString *htmlFilePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"html"];
    NSString *htmlContent = [NSString stringWithContentsOfFile:htmlFilePath encoding:NSUTF8StringEncoding error:&error];
    return htmlContent;
}

- (NSURL *)pathForFile:(NSString*)file
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *thePath = [documentsDirectory stringByAppendingPathComponent:file];
    return [NSURL fileURLWithPath:thePath isDirectory:NO];
}

- (NSString*)replace:(NSString*)from to:(NSString*)to in:(NSString*)content
{
    if(!to) to = @"";
    
    return [content stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"###%@###",from] withString:to];
}

- (NSString*)insertImage:(MJUSceneImage*)image replace:(NSString*)replace in:(NSString*)content
{
    if(!image) {
        return [content stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"###%@###",replace] withString:@""];
    }
    
    NSString *imageURL = [[image getObjectIDAsString] stringByReplacingOccurrencesOfString:@"x-coredata://" withString:@""];
    NSString *htmlImg = [NSString stringWithFormat:@"<img src='mjulocalimage://%@' />", imageURL];
    return [content stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"###%@###",replace] withString:htmlImg];
}



@end
