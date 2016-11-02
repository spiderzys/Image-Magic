//
//  PhotoRequester.h
//  ImageEditor
//
//  Created by YANGSHENG ZOU on 2016-08-23.
//  Copyright © 2016 YANGSHENG ZOU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// this class will request photo from specified source
typedef NS_ENUM(NSInteger,photoSource){
    photoLibrary = 1,
    camera,
    instagram
};


@protocol PhotoRequestDelegate <NSObject>  // the delegate should know what to do after request
- (void)didFinishRequestPhoto:(UIImage*)photo;
@end

@interface PhotoRequester : NSObject <UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, weak) UIViewController<PhotoRequestDelegate>* delegate; // only view controller can be the delegate

+ (PhotoRequester*)sharedInstance; // singleton
- (void)requestPhotoViaSource:(enum photoSource)source;  // open interface for initializing a  request


@end
