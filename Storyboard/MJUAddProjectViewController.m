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

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"select a Photo" delegate:self cancelButtonTitle:@"cancel" destructiveButtonTitle:nil otherButtonTitles:@"add Photo from Library", @"take Photo", nil];
        [actionSheet showInView:self.tableView];
    }
}

- (IBAction)didClickCancel:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)didClickSave:(id)sender
{
    if([NSString isEmptyString:_companyField.text] || [NSString isEmptyString:_titleField.text]) return;
    
    NSManagedObjectContext *context = [[MJUProjectsDataModel sharedDataModel] mainContext];
    MJUProject *project = (MJUProject *)[NSEntityDescription insertNewObjectForEntityForName:@"MJUProject" inManagedObjectContext:context];
    
    project.title = _titleField.text;
    project.companyName = _companyField.text;
    
    if(_imageField.image) {
        [project addCompanyLogo:_imageField.image];
    }
    
    [context save:nil];
    
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
    picker.allowsEditing = YES;
    picker.sourceType = type;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    if(!chosenImage) return;
    
    _imageField.image = chosenImage;
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}


@end
