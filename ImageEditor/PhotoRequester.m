//
//  PhotoRequester.m
//  ImageEditor
//
//  Created by YANGSHENG ZOU on 2016-08-23.
//  Copyright © 2016 YANGSHENG ZOU. All rights reserved.
//

#import "PhotoRequester.h"
#import "APICommunicator.h"
@implementation PhotoRequester{
    
}




- (void)requestPhotoViaSource:(enum photoSource)source{
    
    // request photo from specified source
    if (_delegate != nil){
            switch (source) {
            case photoLibrary:
                 [self requestLocalPhotoViaSourceTyple:UIImagePickerControllerSourceTypePhotoLibrary];
            case camera:
                 [self requestLocalPhotoViaSourceTyple:UIImagePickerControllerSourceTypeCamera];
            default:
                 [self requestPhotoViaInstagram];
        }
        
    }
    
}


- (void)requestLocalPhotoViaSourceTyple:(UIImagePickerControllerSourceType)SourceType{
    if([UIImagePickerController isSourceTypeAvailable:SourceType]){
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        [picker setSourceType:SourceType];
        picker.allowsEditing = false;
        [_delegate presentViewController:picker animated:true completion:nil];
    }
}


- (void)requestPhotoViaInstagram{
    
    
   
}


#pragma UIImagePickerControllerDelegate


- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(nonnull NSDictionary<NSString *,id> *)info{
   
    
    UIImage *image = (UIImage*)[info valueForKey:UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:^{
        [_delegate didFinishRequestPhoto:image];
    }];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
}



+(PhotoRequester*)sharedInstance{
   
    // sharedInstance is the only object for access
    static PhotoRequester *sharedInstance = nil;
    NSLog(@"%@",sharedInstance);
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
    NSLog(@"%@",sharedInstance);
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [super allocWithZone:zone];
    });
    return sharedInstance;
}

@end
