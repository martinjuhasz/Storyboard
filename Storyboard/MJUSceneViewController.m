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
#import "MJUTextInputViewController.h"
#import "MJUTimeSelectionView.h"
#import "UILabel+Additions.h"
#import "MJUTableHeaderView.h"
#import "MJUImagePickerController.h"
#import "MJUTextViewCell.h"



@interface MJUSceneViewController ()
    
@end

@implementation MJUSceneViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.selectionView = [[[NSBundle mainBundle] loadNibNamed:@"TimePickerView" owner:self options:nil] objectAtIndex:0];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    [self loadContent];
}

- (void)loadContent
{
    if(self.scene.title) {
        self.titleCell.textLabel.text = self.scene.title;
    }
    
    self.timeCell.textLabel.text = self.scene.timeAsText;
    
    if(self.scene.images.count > 0) {
        MJUSceneImage *sceneImage = [self.scene getSceneImage];
        if(sceneImage) {
            self.imageView.image = [sceneImage getImage];
        }
    } else {
        self.imageView.image = nil;
    }
    
    if(self.scene.imageText) {
        self.imageTextCell.contentLabel.text = self.scene.imageText;
    }
    
    if(self.scene.soundText) {
        self.soundTextCell.contentLabel.text = self.scene.soundText;
    }
    
    [self.tableView reloadData];
}

- (NSString*)getPropertyNameForIndexPath:(NSIndexPath*)indexPath
{
    NSString *property;
    if(indexPath.section == 0) {
        if(indexPath.row == 0) {
            property = @"title";
        }
    } else if(indexPath.section == 1) {
        if(indexPath.row == 1) {
            property = @"imageText";
        }
    } else if(indexPath.section == 2) {
        if(indexPath.row == 0) {
            property = @"soundText";
        }
    }
    return property;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"TextInputSegue"]) {
        
        if(![sender isKindOfClass:[NSIndexPath class]]) return;
        
        NSIndexPath *indexPath = (NSIndexPath*)sender;
        NSString *property = [self getPropertyNameForIndexPath:indexPath];
        
        MJUTextInputViewController *textViewController = (MJUTextInputViewController*)((UINavigationController*)[segue destinationViewController]).topViewController;
        textViewController.inputText = [self.scene valueForKey:property];
        textViewController.saveString = ^(NSString *saveString) {
            [self.scene setValue:saveString forKey:property];
            NSError *error;
            [[[MJUProjectsDataModel sharedDataModel] mainContext] save:&error];
            if(error) {
                NSLog(@"%@", [error localizedDescription]);
            }
            [self loadContent];
        };
    } else if ([[segue identifier] isEqualToString:@"TimerViewSegue"]) {
        MJUTimePickerViewController *pickerViewController = [segue destinationViewController];
        pickerViewController.delegate = self;
        pickerViewController.presetTime = [NSNumber numberWithInt:self.scene.time];
    }
}


#pragma mark -
#pragma mark Action Sheet

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0) {
        [self showPhotoPickerForType:UIImagePickerControllerSourceTypePhotoLibrary];
    } else if(buttonIndex == 1) {
        [self showPhotoPickerForType:UIImagePickerControllerSourceTypeCamera];
    } else if(buttonIndex == 2) {
        [self saveImage:nil];
    }
}

#pragma mark -
#pragma mark Photos

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
    if(!chosenImage) return;
    
    PECropViewController *controller = [[PECropViewController alloc] init];
    controller.delegate = self;
    controller.image = chosenImage;
    
    if(IS_IPAD) {
        controller.cropRect = CGRectMake(0.0f, 0.0f, 640.0f, 360.0f);
    } else {
        controller.cropRect = CGRectMake(0.0f, 0.0f, 320.0f, 160.0f);
    }
    
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
    
    [picker dismissViewControllerAnimated:YES completion:^{
        [self presentViewController:navigationController animated:YES completion:NULL];
    }];
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)cropViewController:(PECropViewController *)controller didFinishCroppingImage:(UIImage *)chosenImage
{
    [controller dismissViewControllerAnimated:YES completion:NULL];
    
    [self saveImage:chosenImage];
}

- (void)saveImage:(UIImage*)image
{
    NSManagedObjectContext *context = [[MJUProjectsDataModel sharedDataModel] mainContext];
    [self.scene setImages:nil];
    
    if(image) {
        MJUSceneImage *sceneImage = (MJUSceneImage *)[NSEntityDescription insertNewObjectForEntityForName:@"MJUSceneImage" inManagedObjectContext:context];
        [sceneImage addImage:image];
        [self.scene addImagesObject:sceneImage];
    }
    
    NSError *error;
    [context save:&error];
    if(error) {
        NSLog(@"%@", [error localizedDescription]);
    }
    
    [self loadContent];
}

- (void)cropViewControllerDidCancel:(PECropViewController *)controller
{
    [controller dismissViewControllerAnimated:YES completion:nil];
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
    
    MJUImagePickerController *picker = [[MJUImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = NO;
    picker.sourceType = type;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

#pragma mark -
#pragma mark UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 1) {
        if(indexPath.row == 0) {
            // imageview
            if(IS_IPAD) {
                if(UIDeviceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation)) {
                    return 218.0f;
                } else {
                    return 360.0f;
                }
            } else {
                return 180.0f;
            }
        } else if(indexPath.row == 1) {
            // image text
            [self.imageTextCell.contentView setNeedsLayout];
            [self.imageTextCell.contentView layoutIfNeeded];
            return [self.imageTextCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height + 1;
        }
    } else if(indexPath.section == 2) {
        if(indexPath.row == 0) {
            // sound text
            [self.soundTextCell.contentView setNeedsLayout];
            [self.soundTextCell.contentView layoutIfNeeded];
            return [self.soundTextCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height + 1;
        }
    }
    return 44.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    MJUTableHeaderView *aView = [[MJUTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, tableView.frame.size.width, 20.0f)];
    if(section == 1) {
        aView.titleLabel.text = NSLocalizedString(@"PICTURE", nil);
    } else if(section == 2) {
        aView.titleLabel.text =NSLocalizedString(@"SOUND", nil);
    } else {
        return nil;
    }
    return aView;
}


#pragma mark -
#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0 && indexPath.row == 1) {
        [self performSegueWithIdentifier:@"TimerViewSegue" sender:indexPath];
    } else if(indexPath.section == 1 && indexPath.row == 0) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"select a Photo", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"add Photo from Library", nil), NSLocalizedString(@"take Photo", nil), NSLocalizedString(@"delete Photo", nil), nil];
        [actionSheet showInView:self.tableView];
    } else {
        [self performSegueWithIdentifier:@"TextInputSegue" sender:indexPath];
    }
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark -
#pragma mark MJUTimePickerDelegate

- (void)didSelectTimeWithMinute:(NSUInteger)minute second:(NSUInteger)second
{
    NSManagedObjectContext *context = [[MJUProjectsDataModel sharedDataModel] mainContext];
    NSUInteger time = (minute * 60) + second;
    self.scene.time = (int32_t)time;
    NSError *error;
    [context save:&error];
    if(error) {
        NSLog(@"%@", [error localizedDescription]);
    }
    
    self.timeCell.textLabel.text = self.scene.timeAsText;
}

@end
