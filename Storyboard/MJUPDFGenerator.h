//
//  MJUPDFGenerator.h
//  Storyboard
//
//  Created by Martin Juhasz on 21/11/13.
//  Copyright (c) 2013 Martin Juhasz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NDHTMLtoPDF.h"



@class MJUProject;

@interface MJUPDFGenerator : NSObject<NDHTMLtoPDFDelegate>

@property (strong, nonatomic) MJUProject * project;
@property (strong, nonatomic) NDHTMLtoPDF *pdfCreator;

- (id)initWithProject:(MJUProject*)project;
- (void)generatePDFWithSuccess:(NDHTMLtoPDFCompletionBlock)success error:(NDHTMLtoPDFCompletionBlock)error;

@end
