//
//  MJUPDFViewController.m
//  Storyboard
//
//  Created by Martin Juhasz on 02/12/13.
//  Copyright (c) 2013 Martin Juhasz. All rights reserved.
//

#import "MJUPDFViewController.h"
#import "NDHTMLtoPDF.h"
#import "MJUPDFGenerator.h"
#import "UIBarButtonItem+BlocksKit.h"

@interface MJUPDFViewController ()

@end

@implementation MJUPDFViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    NSError *error;
    NSString *htmlFilePath = [[NSBundle mainBundle] pathForResource:@"loading" ofType:@"html"];
    NSString *htmlContent = [NSString stringWithContentsOfFile:htmlFilePath encoding:NSUTF8StringEncoding error:&error];
    [self.webView loadHTMLString:htmlContent baseURL:[[NSBundle mainBundle] bundleURL]];
    
    [self setConditionsForPDF:NO];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // Share Icon
    UIImage *shareImage = [[UIImage imageNamed:@"IconShare"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithImage:shareImage style:UIBarButtonItemStylePlain target:self action:@selector(shareButtonClicked:)];
    self.navigationItem.rightBarButtonItem = shareButton;
    
    // Load PDF
    if(self.project) {
        [self setConditionsForPDF:NO];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            self.pdfGenerator = [[MJUPDFGenerator alloc] initWithProject:self.project];
            [self.pdfGenerator generatePDFWithSuccess:^(NDHTMLtoPDF *htmlToPDF) {
                
                dispatch_async(dispatch_get_main_queue(), ^(){
                    [self.webView loadData:htmlToPDF.PDFdata MIMEType:@"application/pdf" textEncodingName:@"utf-8" baseURL:nil];
                    [self setConditionsForPDF:YES];
                });
                
            } error:^(NDHTMLtoPDF *htmlToPDF) {
                dispatch_async(dispatch_get_main_queue(), ^(){
                    [self dismissViewControllerAnimated:YES completion:nil];
                });
            }];
        });
    }
}

- (void)setConditionsForPDF:(BOOL)isPDF
{
    if(isPDF) {
        self.shareButton.enabled = YES;
        self.webView.scalesPageToFit = YES;
        self.webView.scrollView.scrollEnabled = YES;
    } else {
        self.shareButton.enabled = NO;
        self.webView.scalesPageToFit = NO;
        self.webView.scrollView.scrollEnabled = NO;
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"%@", [error localizedDescription]);
}

- (IBAction)shareButtonClicked:(id)sender
{
    UIActivityViewController *controller = [[UIActivityViewController alloc] initWithActivityItems:@[@"", self.pdfGenerator.pdfCreator.PDFdata] applicationActivities:nil];
    [self presentViewController:controller animated:YES completion:nil];
}

- (IBAction)doneButtonClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
