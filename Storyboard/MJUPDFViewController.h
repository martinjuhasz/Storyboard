//
//  MJUPDFViewController.h
//  Storyboard
//
//  Created by Martin Juhasz on 02/12/13.
//  Copyright (c) 2013 Martin Juhasz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "MJUProject.h"

@class MJUPDFGenerator;

@interface MJUPDFViewController : UIViewController<UIWebViewDelegate, MFMailComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *shareButton;
@property (strong, nonatomic) MJUProject *project;
@property (strong, nonatomic) MJUPDFGenerator *pdfGenerator;

@end
