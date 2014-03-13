//
//  MJUAddProjectViewController.m
//  Storyboard
//
//  Created by Martin Juhasz on 08/11/13.
//  Copyright (c) 2013 Martin Juhasz. All rights reserved.
//

#import "MJUAddProjectViewController.h"
#import "MJUProjectsDataModel.h"
#import "MJUProject.h"
#import "NSString+Additions.h"

@interface MJUAddProjectViewController ()

@end

@implementation MJUAddProjectViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.imageButton setBackgroundImage:[UIImage imageNamed:@"newProjectAddImage"] forState:UIControlStateNormal];
    _imageField.image = nil;
    
    if(self.project) {
        _titleField.text = self.project.title;
        _companyField.text = self.project.companyName;
        if([self.project getCompanyLogo]) {
            _imageField.image = [self.project getCompanyLogo];
            [self.imageButton setBackgroundImage:nil forState:UIControlStateNormal];
        }
        self.title = NSLocalizedString(@"edit Project", nil);
    }

}
- (IBAction)didClickImage:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"select a Photo", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"add Photo from Library", nil), NSLocalizedString(@"take Photo", nil), nil];
    [actionSheet showInView:self.tableView];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

- (IBAction)didClickCancel:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)didClickSave:(id)sender
{
    if([NSString isEmptyString:_companyField.text] || [NSString isEmptyString:_titleField.text]) return;
    
    NSManagedObjectContext *context = [[MJUProjectsDataModel sharedDataModel] mainContext];
    
    if(!self.project) {
        self.project = (MJUProject *)[NSEntityDescription insertNewObjectForEntityForName:@"MJUProject" inManagedObjectContext:context];
    }
    
    self.project.title = _titleField.text;
    self.project.companyName = _companyField.text;
    
    if(_imageField.image) {
        [self.project addCompanyLogo:_imageField.image];
    }
    
    NSError *error;
    [context save:&error];
    if(error) {
        NSLog(@"%@", [error localizedDescription]);
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0) {
        [self showPhotoPickerForType:UIImagePickerControllerSourceTypePhotoLibrary];
    } else if(buttonIndex == 1) {
        [self showPhotoPickerForType:UIImagePickerControllerSourceTypeCamera];
    }
}

-(void)showPhotoPickerForType:(UIImagePickerControllerSourceType)type
{
    if(type == UIImagePickerControllerSourceTypeCamera && ![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        return;
    }
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = NO;
    picker.sourceType = type;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
    if(chosenImage) {
        _imageField.image = chosenImage;
        [self.imageButton setBackgroundImage:nil forState:UIControlStateNormal];
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}


@end
