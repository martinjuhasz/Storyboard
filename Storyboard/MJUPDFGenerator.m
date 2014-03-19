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
#import "GRMustache.h"
#import "MJUQuestionCategory.h"
#import "MJUProjectsDataModel.h"
#import "MJUQuestion.h"
#import "MJUTextQuestion.h"
#import "MJUTextAnswer.h"
#import "MJUSelectableQuestion.h"
#import "MJUSelectableAnswer.h"
#import "MJUSelectable.h"
#import "MJUQuestionSection.h"
#import "MJUQuestionCategory.h"

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
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"MJUQuestionCategory"];
    NSSortDescriptor *sortByName = [NSSortDescriptor sortDescriptorWithKey:@"order" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortByName]];

    NSError *fetchError = nil;
    NSArray *categories = [[[MJUProjectsDataModel sharedDataModel] mainContext] executeFetchRequest:fetchRequest error:&fetchError];
    if(fetchError) {
        NSLog(@"Error: %@", [fetchError localizedDescription]);
    }
    
    id data = @{ @"project": self.project,
                 @"categories": categories
            };
    
    id extraKeys = @{
                     @"answerForProject": [GRMustacheRendering renderingObjectWithBlock:^NSString *(GRMustacheTag *tag, GRMustacheContext *context, BOOL *HTMLSafe, NSError *__autoreleasing *error) {
                         
        // load the question, and the project from the context stack
        MJUProject *project = [context valueForMustacheKey:@"project"];
        MJUQuestion *question = [context topMustacheObject];
        
        if(!project || !question || ![project isKindOfClass:[MJUProject class]] || ![question isKindOfClass:[MJUQuestion class]]) {
            return nil;
        }
        
        NSString *answerString = nil;
        if([question isKindOfClass:[MJUTextQuestion class]]) {
            MJUTextAnswer *answer = [(MJUTextQuestion*)question getSelectedAnswerForProject:project];
            if(!answer) return nil;
            answerString = answer.text;
        } else if([question isKindOfClass:[MJUSelectableQuestion class]]) {
            MJUSelectableAnswer *answer = [(MJUSelectableQuestion*)question getSelectedAnswerForProject:project];
            if(!answer) return nil;
            answerString = ((MJUSelectable*)answer.selected).text;
        }
        return answerString;
    }],
                     @"hasTextAnswer": [GRMustacheFilter variadicFilterWithBlock:^id(NSArray *arguments) {
                         MJUQuestion *question = arguments[0];
                         MJUProject *project = arguments[1];
                         
                         if(!project || !question || ![project isKindOfClass:[MJUProject class]] || ![question isKindOfClass:[MJUTextQuestion class]]) {
                             return nil;
                         }
                         
                         MJUTextAnswer *answer = [(MJUTextQuestion*)question getSelectedAnswerForProject:project];
                         return answer;
                     }],
                     @"hasSelectableAnswer": [GRMustacheFilter variadicFilterWithBlock:^id(NSArray *arguments) {
                         MJUQuestion *question = arguments[0];
                         MJUProject *project = arguments[1];
                         
                         if(!project || !question || ![project isKindOfClass:[MJUProject class]] || ![question isKindOfClass:[MJUSelectableQuestion class]]) {
                             return nil;
                         }
                         
                         MJUSelectableAnswer *answer = [(MJUSelectableQuestion*)question getSelectedAnswerForProject:project];
                         return answer;
                     }],
                     @"sectionHasAnswer": [GRMustacheFilter variadicFilterWithBlock:^id(NSArray *arguments) {
                         MJUQuestionSection *section = arguments[0];
                         MJUProject *project = arguments[1];
                         
                         if(!project || !section || ![project isKindOfClass:[MJUProject class]] || ![section isKindOfClass:[MJUQuestionSection class]]) {
                             return nil;
                         }
                         
                         BOOL hasAnswer = [section hasAnswersForSectionInProject:project];
                         if(hasAnswer) {
                             return section;
                         }
                         return nil;
                     }],
                     @"categoryHasAnswer": [GRMustacheFilter variadicFilterWithBlock:^id(NSArray *arguments) {
                         MJUQuestionCategory *category = arguments[0];
                         MJUProject *project = arguments[1];
                         
                         if(!project || !category || ![project isKindOfClass:[MJUProject class]] || ![category isKindOfClass:[MJUQuestionCategory class]]) {
                             return nil;
                         }
                         
                         BOOL hasAnswer = [category hasAnswersForCategoryInProject:project];
                         if(hasAnswer) {
                             return category;
                         }
                         return nil;
                     }],
                     @"nl2br": [GRMustacheRendering renderingObjectWithBlock:^NSString *(GRMustacheTag *tag, GRMustacheContext *context, BOOL *HTMLSafe, NSError *__autoreleasing *error) {
                         NSString *rawRendering = [tag renderContentWithContext:context HTMLSafe:HTMLSafe error:error];
                         
                         return [rawRendering stringByReplacingOccurrencesOfString:@"\n" withString:@"<br />"];
                     }]
    };
    
    GRMustacheTemplate *template = [GRMustacheTemplate templateFromResource:@"pdf_content" bundle:nil error:nil];
    NSString *htmlContent = [template renderObjectsFromArray:@[data, extraKeys] error:nil];
    
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


@end
