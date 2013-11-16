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

@interface MJUSceneViewController ()
    
@end

@implementation MJUSceneViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.selectionView = [[[NSBundle mainBundle] loadNibNamed:@"TimePickerView" owner:self options:nil] objectAtIndex:0];
    [self loadContent];
}

- (void)loadContent
{
    if(self.scene.title) {
        self.titleCell.textLabel.text = self.scene.title;
    }
    if(self.scene.images.count > 0) {
        self.imageView.image = [((MJUSceneImage*)[self.scene.images anyObject]) getImage];
    }
    if(self.scene.imageText) {
        self.imageTextCell.textLabel.text = self.scene.imageText;
        [self.imageTextCell.textLabel setNumberOfLines:0];
        [self.imageTextCell.textLabel sizeToFit];
    }
    if(self.scene.soundText) {
        self.soundTextCell.textLabel.text = self.scene.soundText;
    }
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
            [[[MJUProjectsDataModel sharedDataModel] mainContext] save:nil];
            [self loadContent];
        };
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
    }
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
    [self.scene setImages:nil];
    [self.scene addImagesObject:sceneImage];
    [context save:nil];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    [self loadContent];
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

- (CGRect)sizeForLabel:(UILabel*)label
{
    CGSize maxSize = CGSizeMake(label.frame.size.width, MAXFLOAT);
    CGRect labelRect = [label.text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:label.font} context:nil];
    return labelRect;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 1) {
        if(indexPath.row == 0) {
            // iamgeview
            return 180.0f;
        } else if(indexPath.row == 1) {
            // image text
            CGRect size = [self sizeForLabel:self.imageTextCell.textLabel];
            return (size.size.height > 64.0f) ? size.size.height + 20 : 44.0f;
        }
    } else if(indexPath.section == 2) {
        if(indexPath.row == 0) {
            CGRect size = [self sizeForLabel:self.soundTextCell.textLabel];
            return (size.size.height > 64.0f) ? size.size.height + 20 : 44.0f;
        }
    }
    return 44.0f;
}


#pragma mark -
#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0 && indexPath.row == 1) {
        [self.view addSubview:self.selectionView];
        
    } else if(indexPath.section == 1 && indexPath.row == 0) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"select a Photo" delegate:self cancelButtonTitle:@"cancel" destructiveButtonTitle:nil otherButtonTitles:@"add Photo from Library", @"take Photo", nil];
        [actionSheet showInView:self.tableView];
    } else {
        [self performSegueWithIdentifier:@"TextInputSegue" sender:indexPath];
    }
    
}

@end
