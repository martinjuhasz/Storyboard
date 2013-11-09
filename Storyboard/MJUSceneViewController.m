//
//  MJUSceneViewController.m
//  Storyboard
//
//  Created by Martin Juhasz on 04/11/13.
//  Copyright (c) 2013 Martin Juhasz. All rights reserved.
//

#import "MJUSceneViewController.h"
#import "MJUProjectsDataModel.h"
#import "MJUSceneImage.h"
#import "MJUScene.h"

@interface MJUSceneViewController ()

@end

@implementation MJUSceneViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark -
#pragma mark Photos

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    if(!chosenImage) return;
    
    NSManagedObjectContext *context = [[MJUProjectsDataModel sharedDataModel] mainContext];
    MJUSceneImage *sceneImage = (MJUSceneImage *)[NSEntityDescription insertNewObjectForEntityForName:@"MJUSceneImage" inManagedObjectContext:context];
    [sceneImage addImage:chosenImage];
    [self.scene addImagesObject:sceneImage];
    [context save:nil];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    [self.tableView reloadData];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
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

- (void) textViewDidChange:(UITextView *)textView
{
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    
    NSIndexPath *indexPath;
    if(textView == _imageText) {
        indexPath = [NSIndexPath indexPathForItem:0 inSection:1];
    } else {
        indexPath = [NSIndexPath indexPathForItem:0 inSection:2];
    }
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}


#pragma mark -
#pragma mark UITableViewDataSource

//- (CGFloat)heightForTextView:(UITextView*)textView containingString:(NSString*)string
//{
//    float horizontalPadding = 24;
//    float verticalPadding = 16;
//    float widthOfTextView = textView.contentSize.width - horizontalPadding;
//    float height = [string sizeWithFont:[UIFont systemFontOfSize:14.0f] constrainedToSize:CGSizeMake(widthOfTextView, 999999.0f) lineBreakMode:NSLineBreakByWordWrapping].height + verticalPadding;
//    
//    return height;
//}
//
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    if(indexPath.section == 0) {
//        if(indexPath.row == 0) {
//            // title - presstop
//            return 44.0f;
//        } else if(indexPath.row == 1) {
//            // image
//            return 180.0f;
//        }
//    } else if(indexPath.section == 1) {
//        // bildebene
//        return [self heightForTextView:_imageText containingString:_imageText.text] + 15;
//    } else if(indexPath.section == 2) {
//        // tonebene
//        return [self heightForTextView:_soundText containingString:_soundText.text] + 15;
//    }
//    return 44.0f;
//}






//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return 2;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    if(section == 1) return [self.scene.images count];
//    return 2;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if(indexPath.section == 1) {
//        return 150.0f;
//    }
//    return 44.0f;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    UITableViewCell *cell;
//    
//    // Configure the cell...
//    if(indexPath.section == 0) {
//        
//        static NSString *CellIdentifier = @"SceneCell";
//        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
//        
//        if(indexPath.row == 0) {
//            cell.textLabel.text = @"add Photo from Library";
//        } else if(indexPath.row == 1) {
//            cell.textLabel.text = @"take Photo";
//        }
//    } else if(indexPath.section == 1) {
//        
//        static NSString *CellIdentifier = @"ImageCell";
//        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
//        
//        UIImageView *imageView = (UIImageView*)[cell viewWithTag:1302];
//        imageView.image = [[[self.scene.images allObjects] objectAtIndex:indexPath.row] getImage];
//        
//    }
//    
//    
//    return cell;
//}
//
//
//#pragma mark -
//#pragma mark UITableViewDelegate
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if(indexPath.section == 0) {
//        if(indexPath.row == 0) {
//            [self showPhotoPickerForType:UIImagePickerControllerSourceTypePhotoLibrary];
//        } else if(indexPath.row == 1) {
//            [self showPhotoPickerForType:UIImagePickerControllerSourceTypeCamera];
//        }
//    }
//}

@end
