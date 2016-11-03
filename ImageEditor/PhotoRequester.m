//
//  PhotoRequester.m
//  ImageEditor
//
//  Created by YANGSHENG ZOU on 2016-08-23.
//  Copyright © 2016 YANGSHENG ZOU. All rights reserved.
//

#import "PhotoRequester.h"
#import "TumblrImageViewController.h"

@implementation PhotoRequester{
    
}




- (void)requestPhotoViaSource:(enum photoSource)source{
    
    // request photo from specified source
    
    
    if (_delegate != nil){
        switch (source) {
            case photoLibrary:
                
                [self requestLocalPhotoViaSourceTyple:UIImagePickerControllerSourceTypePhotoLibrary];
                break;
            case camera:
                [self requestLocalPhotoViaSourceTyple:UIImagePickerControllerSourceTypeCamera];
                break;
            default:
                [self requestPhotoViaTumblr];
        }
        
    }
    
}


- (void)requestLocalPhotoViaSourceTyple:(UIImagePickerControllerSourceType)SourceType{
    
    if([UIImagePickerController isSourceTypeAvailable:SourceType]){
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        [picker setSourceType:SourceType];
        picker.allowsEditing = NO;
        [_delegate presentViewController:picker animated:YES completion:nil];
    }
    
    
}


- (void)requestPhotoViaTumblr{
    
    [_delegate presentViewController:[TumblrImageViewController sharedInstance] animated:YES completion:^{
        
    }];
    
    
}

#pragma TumblrImageViewControllerDelegate method

- (void)didFinishPickImageView:(UIImage *)image{
    [[TumblrImageViewController sharedInstance]dismissViewControllerAnimated:YES completion:^{
      [_delegate didFinishRequestPhoto:image];
    }];
    
}


#pragma UIImagePickerControllerDelegate method


- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(nonnull NSDictionary<NSString *,id> *)info{
    
    
    UIImage *image = (UIImage*)[info valueForKey:UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:^{
        [_delegate didFinishRequestPhoto:image];
    }];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}





#pragma Singleton
+(PhotoRequester*)sharedInstance{
    
    // sharedInstance is the only object for access
    static PhotoRequester *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[PhotoRequester alloc] init];
        
    });
    return sharedInstance;
}

+ (id)allocWithZone:(NSZone *)zone
{
    
    // alloc init method  override to avoid new object init
    static PhotoRequester *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [super allocWithZone:zone];
    });
    return sharedInstance;
}





@end
