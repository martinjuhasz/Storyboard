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





#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 1) return [self.scene.images count];
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 1) {
        return 150.0f;
    }
    return 44.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    // Configure the cell...
    if(indexPath.section == 0) {
        
        static NSString *CellIdentifier = @"SceneCell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        
        if(indexPath.row == 0) {
            cell.textLabel.text = @"add Photo from Library";
        } else if(indexPath.row == 1) {
            cell.textLabel.text = @"take Photo";
        }
    } else if(indexPath.section == 1) {
        
        static NSString *CellIdentifier = @"ImageCell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        
        UIImageView *imageView = (UIImageView*)[cell viewWithTag:1302];
        imageView.image = [[[self.scene.images allObjects] objectAtIndex:indexPath.row] getImage];
        
    }
    
    
    return cell;
}


#pragma mark -
#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0) {
        if(indexPath.row == 0) {
            [self showPhotoPickerForType:UIImagePickerControllerSourceTypePhotoLibrary];
        } else if(indexPath.row == 1) {
            [self showPhotoPickerForType:UIImagePickerControllerSourceTypeCamera];
        }
    }
}

@end
